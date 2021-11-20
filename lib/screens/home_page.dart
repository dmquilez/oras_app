import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:oras_app/services/firebase_service.dart';
import 'package:oras_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  @override
  void initState() {
    super.initState();
  }
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.blue),
          title: Text("Home"),
        ),
        drawer: CustomDrawer.getDrawer(context),
        body:  GridView.count(crossAxisCount: 1, children: [BarChartSample1(), BarChartSample2(), BarChartSample3(), BarChartSample4(), BarChartSample5(),
          PieChartSample1(), PieChartSample2(), PieChartSample3(),
          ScatterChartSample1(), ScatterChartSample2(),
          LineChartSample1(), LineChartSample2(), LineChartSample3(), LineChartSample4(), LineChartSample5(), LineChartSample6(), LineChartSample7(), LineChartSample8(), LineChartSample9(), LineChartSample10(),
          Image.asset(
          "assets/images/earth_without_bg.gif",
        )]),);
  }
}