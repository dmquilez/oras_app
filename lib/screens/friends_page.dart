import 'package:firebase_auth/firebase_auth.dart';
import 'package:oras_app/services/firebase_service.dart';
import 'package:oras_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oras_app/screens/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid_util.dart';
import 'package:uuid/uuid.dart';

class FriendsPage extends StatefulWidget {
  FriendsPage({Key? key}) : super(key: key);

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(text: "Ranking"),
                Tab(text: "Friends"),
                Tab(text: "Requests",),
              ],

            ),
            title: Text("Friends"),centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () async {
                  Navigator.pushReplacementNamed(
                      context, Constants.friendsAddNavigate);
                },
              )
            ],
          ),
          drawer: CustomDrawer.getDrawer(context),
          body: TabBarView(
            children: [

              Icon(Icons.wheelchair_pickup),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("friends")
                    .where("to", isEqualTo: FirebaseAuth.instance.currentUser!.email)
                    .where("accepted", isEqualTo: true).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView(
                      children: snapshot.data!.docs.map((DocumentSnapshot doc) {
                        return Card(
                          child: ListTile(
                            title: Text(doc["from"]),
                            trailing: Icon(Icons.person),
                            onTap: () async {

                              await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: new Text('Delete friend'),
                                  content: new Text('Are you sure?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: new Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                      {
                                        FirebaseFirestore.instance
                                            .collection('friends')
                                            .doc(doc["id"])
                                            .delete().then((result){
                                          Navigator.of(context).pop(true);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Friend deleted')),
                                          );
                                        }).catchError((onError){
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Error deleting friend')),
                                          );
                                        })},
                                      child: new Text('Yes'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("friends")
                    .where("to", isEqualTo: FirebaseAuth.instance.currentUser!.email)
                    .where("accepted", isEqualTo: false).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView(
                      children: snapshot.data!.docs.map((DocumentSnapshot doc) {
                        return Card(
                          child: ListTile(
                            title: Text(doc["from"]),
                            trailing: Icon(Icons.person_add),
                            onTap: () async {

                              await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: new Text('Add a new friend'),
                                  content: new Text('This person will see some data about your consumption records at the ranking. Do you want to add this person as a friend?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: new Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                      {
                                        FirebaseFirestore.instance
                                            .collection('friends')
                                            .doc(doc["id"])
                                            .update({
                                          "accepted":true
                                        }).then((result){
                                          final String friendRequestID = Uuid().v4();
                                          FirebaseFirestore.instance
                                              .collection('friends')
                                              .doc(friendRequestID)
                                              .set({
                                            "id": friendRequestID,
                                            "from": FirebaseAuth.instance.currentUser!.email,
                                            "to": doc["from"],
                                            "accepted": true
                                          });
                                          Navigator.of(context).pop(true);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Friend request accepted')),
                                          );
                                        }).catchError((onError){
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Error accepting friend request')),
                                          );
                                        })},
                                      child: new Text('Yes'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );Scaffold(
      appBar: AppBar(
        title: Text("Friends"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () async {
              Navigator.pushReplacementNamed(
                  context, Constants.friendsAddNavigate);
            },
          )
        ],
      ),
      drawer: CustomDrawer.getDrawer(context),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("friends")
            .where("to", isEqualTo: FirebaseAuth.instance.currentUser!.email)
            .where("accepted", isEqualTo: false).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot doc) {
                return Card(
                  child: ListTile(
                    title: Text(doc["from"]),
                    trailing: Icon(Icons.person_add),
                    onTap: () async {

                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: new Text('Add a new friend'),
                          content: new Text('This person will see some data about your consumption records at the ranking. Do you want to add this person as a friend?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: new Text('No'),
                            ),
                            TextButton(
                              onPressed: () =>
                              {
                                FirebaseFirestore.instance
                                    .collection('friends')
                                    .doc(doc["id"])
                                    .update({
                                  "accepted":true
                                }).then((result){
                                  Navigator.of(context).pop(true);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Friend request accepted')),
                                  );
                                }).catchError((onError){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Error accepting friend request')),
                                  );
                                })},
                              child: new Text('Yes'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}