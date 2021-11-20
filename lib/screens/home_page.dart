import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oras_app/main.dart';
import 'package:oras_app/services/firebase_service.dart';
import 'package:oras_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';


class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class CustomDrawer {


  static int selectedDrawerIndex = 0;

  static final _drawerItems = [
    DrawerItem("Home", Icons.house),
    DrawerItem("Profile", Icons.person),
  ];

  static _onTapDrawer(int itemPos, BuildContext context){
    Navigator.pop(context); // cerramos el drawer
    selectedDrawerIndex = itemPos;
    if(selectedDrawerIndex == 0){
      Navigator.pushNamedAndRemoveUntil(context, Constants.homeNavigate, (route) => false);
    }
    if(selectedDrawerIndex == 1){
      Navigator.pushNamedAndRemoveUntil(context, Constants.profileNavigate, (route) => false);
    }
  }

  static Widget getDrawer(BuildContext context) {
    List<Widget> drawerOptions = [];
    // armamos los items del menu
    for (var i = 0; i < _drawerItems.length; i++) {
      var d = _drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(d.title),
        selected: i == selectedDrawerIndex,
        onTap: () => _onTapDrawer(i, context),
      ));
    }



    // menu lateral
    return Drawer(
      child: Column(
        children: <Widget>[

          UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(_HomePageState().user!.photoURL!),
                radius: 20,
              ),accountName: Text(_HomePageState().user!.displayName!), accountEmail: Text(_HomePageState().user!.email!)),
          Column(children: drawerOptions)
        ],
      ),
    );
  }
}


class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  final _database = FirebaseDatabase.instance.reference();
  final _firestoreDoc = FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid);
  String _diplaytText = "Loading...";

  @override
  void initState() {
    super.initState();
  }

  void _activateListeners(userApartment){


    _database.child("houses/0/apartments/$userApartment/").onValue.listen((event) {
      final data = Map<String, dynamic>.from(event.snapshot.value);
      final String consumption = data['Dishwasher']['measurements'][0]['Consumption'];
      //final String consumption = event.snapshot.value;
      setState(() {
        _diplaytText = consumption;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.blue),
        title: Text("Home"),
      ),
      drawer: CustomDrawer.getDrawer(context),
      body:  Column(
      mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
    Container(
    width: 150,
    height: 150,
    ),
    SizedBox(height: 24.0),
      StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user!.uid).get().asStream(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          _activateListeners(snapshot.data!["apartment"]);
          return Text(_diplaytText);
        },

      ),
    SizedBox(height: 48.0),
    ],
    ));
  }
}
