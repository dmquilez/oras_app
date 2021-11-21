import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oras_app/screens/friends_page.dart';
import 'package:oras_app/services/firebase_service.dart';
import 'package:oras_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oras_app/screens/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_search/firestore_search.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';


class DataModel {
  final String? name;
  final String? email;
  final String? picture;

  DataModel({this.name, this.email, this.picture});

  //Create a method to convert QuerySnapshot from Cloud Firestore to a list of objects of this DataModel
  //This function in essential to the working of FirestoreSearchScaffold

  List<DataModel> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap =
      snapshot.data() as Map<String, dynamic>;

      return DataModel(
          name: dataMap['name'],
          email: dataMap['email'],
          picture: dataMap['picture']);
    }).toList();
  }
}


class FriendsAddPage extends StatefulWidget {
  FriendsAddPage({Key? key}) : super(key: key);

  @override
  _FriendsAddPageState createState() => _FriendsAddPageState();
}

class _FriendsAddPageState extends State<FriendsAddPage> {
  User? user = FirebaseAuth.instance.currentUser;


  @override
  void initState() {
    super.initState();
  }

  Future<bool> _onWillPop() async {
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return FriendsPage();
        },
      ),
    );
    return true;
  }

  Future<bool> addFriendRequest(email) async {

    bool _invitationSent = false;
    CollectionReference friends = FirebaseFirestore.instance.collection('friends');
    final friendRequestID = Uuid().v4();

   await friends
        .doc(friendRequestID)
        .set({
     'id': friendRequestID,
     'from': FirebaseAuth.instance.currentUser!.email,
      'to': email,
      'accepted': false})
        .then((_) => _invitationSent = true)
        .catchError((error) => print("Failed to add user: $error"));

    return _invitationSent;
  }

  Future sendFriendRequest(email) async{

    if(email == FirebaseAuth.instance.currentUser!.email){
      return false;
    }

    CollectionReference friends = FirebaseFirestore.instance.collection('friends');

    var a = await friends
        .where("from", isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .where("to", isEqualTo: email)
        .where("accepted", isNotEqualTo: true)
        .get();

    if(a.size > 0){
      return false;
    }else{
      return await addFriendRequest(email);
    }

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: FirestoreSearchScaffold(
          firestoreCollectionName: 'users',
          searchBy: 'email',
          scaffoldBody: const Center(child: Text('Use the top searchbar to find your friends!')),
          dataListFromSnapshot: DataModel().dataListFromSnapshot,
          builder: (context, snapshot) {

            if (snapshot.hasData) {
              final List<DataModel>? dataList = snapshot.data;

              return
                ListView.builder(
                    itemCount: dataList?.length ?? 0,
                    itemBuilder: (context, index) {
                      final DataModel data = dataList![index];

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: SizedBox(
                                    height: 100.0,
                                    width: 100.0, // fixed width and height
                                    child: Image.network("${data.picture}")
                                ),
                                title: Text('${data.name}'),
                                subtitle: Text('${data.email}'),
                                onTap: () async {
                                  if(await sendFriendRequest('${data.email}')){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Friend request sent')),
                                    );
                                  }else{
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Impossible to send a friend request to that person")),
                                    );
                                  }
                                },
                              )
                          )
                        ],
                      );
                    });
            }


            if (snapshot.connectionState == ConnectionState.done) {
              if (!snapshot.hasData){
                return const Center(child: Text('No Results Returned'),);
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        )
        ),
      );

  }

}
