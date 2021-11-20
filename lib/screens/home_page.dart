import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oras_app/main.dart';
import 'package:oras_app/services/firebase_service.dart';
import 'package:oras_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:oras_app/charts/bar_chart_sample1.dart';
import 'package:oras_app/charts/bar_chart_sample2.dart';
import 'package:oras_app/charts/bar_chart_sample3.dart';
import 'package:oras_app/charts/bar_chart_sample4.dart';
import 'package:oras_app/charts/bar_chart_sample5.dart';
import 'package:oras_app/charts/line_chart_sample1.dart';
import 'package:oras_app/charts/line_chart_sample10.dart';
import 'package:oras_app/charts/line_chart_sample2.dart';
import 'package:oras_app/charts/line_chart_sample3.dart';
import 'package:oras_app/charts/line_chart_sample4.dart';
import 'package:oras_app/charts/line_chart_sample5.dart';
import 'package:oras_app/charts/line_chart_sample6.dart';
import 'package:oras_app/charts/line_chart_sample7.dart';
import 'package:oras_app/charts/line_chart_sample8.dart';
import 'package:oras_app/charts/line_chart_sample9.dart';
import 'package:oras_app/charts/pie_chart_sample1.dart';
import 'package:oras_app/charts/pie_chart_sample2.dart';
import 'package:oras_app/charts/pie_chart_sample3.dart';
import 'package:oras_app/charts/scatter_chart_sample1.dart';
import 'package:oras_app/charts/scatter_chart_sample2.dart';


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
double global_consumption = 5;

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
    _activateListeners(0);
  }

  void _activateListeners(userApartment){

    Future.delayed(Duration(milliseconds: 100), () {

    _database.child("houses/0/apartments/$userApartment/").onValue.listen((event) {
      final data = Map<String, dynamic>.from(event.snapshot.value);
      final String consumption = data['Dishwasher']['measurements'][0]['Consumption'];

      //final String consumption = event.snapshot.value;
      setState(() {
        global_consumption =  double.parse(consumption);
      });
    });
  }
    );}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.blue),
          title: Text("Home"),
        ),
        drawer: CustomDrawer.getDrawer(context),
        body: GridView.count(crossAxisCount: 1, scrollDirection: Axis.vertical,
                    shrinkWrap: true,children: [BarChartSample1(global_consumption,2,3,4,5,6,7)]));

  }
}