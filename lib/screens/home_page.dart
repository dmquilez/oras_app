import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
import 'package:oras_app/flip_card.dart';


class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class CustomDrawer {


  static int selectedDrawerIndex = 0;

  static final _drawerItems = [
    DrawerItem("Home", Icons.house),
    DrawerItem("Friends", Icons.people),
    DrawerItem("Profile", Icons.person),
  ];

  static _onTapDrawer(int itemPos, BuildContext context){
    Navigator.pop(context); // cerramos el drawer
    selectedDrawerIndex = itemPos;
    if(selectedDrawerIndex == 0){
      Navigator.pushNamedAndRemoveUntil(context, Constants.homeNavigate, (route) => false);
    }
    if(selectedDrawerIndex == 1){
      Navigator.pushNamedAndRemoveUntil(context, Constants.friendsNavigate, (route) => false);
    }
    if(selectedDrawerIndex == 2){
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

double global_consumption_0 = 0;
double global_consumption_1 = 0;
double global_consumption_2 = 0;
double global_consumption_3 = 0;
double global_consumption_4 = 0;
double global_consumption_5 = 0;
double global_consumption_6 = 0;

double global_consumption_0_HS = 0;
double global_consumption_1_HS = 0;
double global_consumption_2_HS = 0;
double global_consumption_3_HS = 0;
double global_consumption_4_HS = 0;
double global_consumption_5_HS = 0;
double global_consumption_6_HS = 0;

double global_consumption_0_KOF = 0;
double global_consumption_1_KOF = 0;
double global_consumption_2_KOF = 0;
double global_consumption_3_KOF = 0;
double global_consumption_4_KOF = 0;
double global_consumption_5_KOF = 0;
double global_consumption_6_KOF = 0;

int global_consumption_0_WM = 0;
int global_consumption_1_WM = 0;
int global_consumption_2_WM = 0;
int global_consumption_3_WM = 0;
int global_consumption_4_WM = 0;
int global_consumption_5_WM = 0;
int global_consumption_6_WM = 0;

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

      final _firebaseRef = _database.child("$userApartment/");

      _firebaseRef.child("Hydractiva_shower/").onValue.listen((event) {

        //print(event.snapshot.value[0]['Consumption']);

        final double consumption_monday = event.snapshot.value['consumption'][46];
        final double consumption_tuesday = event.snapshot.value['consumption'][47];
        final double consumption_wednesday = event.snapshot.value['consumption'][48];
        final double consumption_thursday = event.snapshot.value['consumption'][49];
        final double consumption_predict_friday = event.snapshot.value['consumption_predict'][0];
        final double consumption_predict_saturday = event.snapshot.value['consumption_predict'][1];
        final double consumption_predict_sunday = event.snapshot.value['consumption_predict'][2];



        //final String consumption = event.snapshot.value;
        setState(() {
          global_consumption_0_HS =  double.parse(consumption_monday.toStringAsFixed(2));
          global_consumption_1_HS =  double.parse(consumption_tuesday.toStringAsFixed(2));
          global_consumption_2_HS =  double.parse(consumption_wednesday.toStringAsFixed(2));
          global_consumption_3_HS =  double.parse(consumption_thursday.toStringAsFixed(2));
          global_consumption_4_HS =  double.parse(consumption_predict_friday.toStringAsFixed(2));
          global_consumption_5_HS =  double.parse(consumption_predict_saturday.toStringAsFixed(2));
          global_consumption_6_HS =  double.parse(consumption_predict_sunday.toStringAsFixed(2));
        });
      });

      _firebaseRef.child("Kitchen_optima_faucet/").onValue.listen((event) {

        //print(event.snapshot.value[0]['Consumption']);

        final double consumption_monday = event.snapshot.value['consumption'][46];
        final double consumption_tuesday = event.snapshot.value['consumption'][47];
        final double consumption_wednesday = event.snapshot.value['consumption'][48];
        final double consumption_thursday = event.snapshot.value['consumption'][49];
        final double consumption_predict_friday = event.snapshot.value['consumption_predict'][0];
        final double consumption_predict_saturday = event.snapshot.value['consumption_predict'][1];
        final double consumption_predict_sunday = event.snapshot.value['consumption_predict'][2];



        //final String consumption = event.snapshot.value;
        setState(() {
          global_consumption_0_KOF =  double.parse(consumption_monday.toStringAsFixed(2));
          global_consumption_1_KOF =  double.parse(consumption_tuesday.toStringAsFixed(2));
          global_consumption_2_KOF =  double.parse(consumption_wednesday.toStringAsFixed(2));
          global_consumption_3_KOF =  double.parse(consumption_thursday.toStringAsFixed(2));
          global_consumption_4_KOF =  double.parse(consumption_predict_friday.toStringAsFixed(2));
          global_consumption_5_KOF =  double.parse(consumption_predict_saturday.toStringAsFixed(2));
          global_consumption_6_KOF =  double.parse(consumption_predict_sunday.toStringAsFixed(2));
        });
      });

      _firebaseRef.child("Washing_machine/").onValue.listen((event) {

        //print(event.snapshot.value[0]['Consumption']);

        final double consumption_monday = event.snapshot.value['consumption'][46];
        final double consumption_tuesday = event.snapshot.value['consumption'][47];
        final double consumption_wednesday = event.snapshot.value['consumption'][48];
        final double consumption_thursday = event.snapshot.value['consumption'][49];
        final double consumption_predict_friday = event.snapshot.value['consumption_predict'][0];
        final double consumption_predict_saturday = event.snapshot.value['consumption_predict'][1];
        final double consumption_predict_sunday = event.snapshot.value['consumption_predict'][2];



        //final String consumption = event.snapshot.value;
        setState(() {
          global_consumption_0_WM =  int.parse(consumption_monday.toStringAsFixed(2));
          global_consumption_1_WM =  int.parse(consumption_tuesday.toStringAsFixed(2));
          global_consumption_2_WM =  int.parse(consumption_wednesday.toStringAsFixed(2));
          global_consumption_3_WM =  int.parse(consumption_thursday.toStringAsFixed(2));
          global_consumption_4_WM =  int.parse(consumption_predict_friday.toStringAsFixed(2));
          global_consumption_5_WM =  int.parse(consumption_predict_saturday.toStringAsFixed(2));
          global_consumption_6_WM =  int.parse(consumption_predict_sunday.toStringAsFixed(2));
        });

      }
      );

    }
    );


  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(scaffoldBackgroundColor: const Color(0xFF639CEA)),
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.bar_chart_rounded)),
                Tab(icon: FaIcon(FontAwesomeIcons.tint)),
                Tab(icon: Icon(Icons.power_outlined)),
                Tab(icon: Icon(Icons.euro)),

              ],
            ),
            systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.blue),
            title: const Text('Home'),
          ),
          drawer: CustomDrawer.getDrawer(context),
          body: TabBarView(
            children: [
              GridView.count(crossAxisCount: 1, scrollDirection: Axis.vertical,
                  shrinkWrap: true, children: [
                    FlipCard(
                      fill: Fill.fillBack, // Fill the back side of the card to make in the same size as the front.
                      direction: FlipDirection.HORIZONTAL, // default
                      front: Container(
                        child: Card(
                          margin: EdgeInsets.only(right: 15,left: 15, top: 15, bottom: 0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                          color:  Color(0xff252d49),
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child:
                                Image.asset(
                                  "assets/images/very_happy.gif",
                                ),
                              ),


                            ],
                          ),
                        ),
                      ),
                      back: Container(
                        child: Card(
                          margin: EdgeInsets.only(right: 15,left: 15, top: 15, bottom: 0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                          color:  Color(0xff252d49),
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child:
                                Text("Earthy will be angry if your water consumption is too high. Try to make Earthy happy and proud of you!",textAlign: TextAlign.center, style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25.0,
                                  fontWeight:  FontWeight.w300,
                                )
                                ),
                              ),




                            ],
                          ),
                        ),
                      ),
                    ),
                    BarChartSample1(50,45,72,35,46,32, 37,'Water Usage (min)','Household',Color(
                        0xff3be2ba),
                        Color(0xff0f4a3c),"min",75),
                  ]),

              GridView.count(crossAxisCount: 1, scrollDirection: Axis.vertical,
                  shrinkWrap: true, children: [
                    BarChartSample1(global_consumption_0_HS,global_consumption_1_HS,global_consumption_2_HS,global_consumption_3_HS,global_consumption_4_HS,global_consumption_5_HS, global_consumption_6_HS,'Water Consumption (L)','Shower',Color(
                        0xff66d3ff), Color(0xff0f668b),"L",75),
                    BarChartSample1(global_consumption_0_KOF,global_consumption_1_KOF,global_consumption_2_KOF,global_consumption_3_KOF,global_consumption_4_KOF,global_consumption_5_KOF, global_consumption_6_KOF,'Water Consumption (L)','Kitchen',Color(
                        0xffde6d59),
                        Color(0xff7f3e32), "L",150),
                    BarChartSample1(40,67,210,143,120,90, 180,'Water Consumption (L)','Washing Machine',Color(
                        0xffe7c45c),
                        Color(0xffb39847),"L",240),
                  ]),


              GridView.count(crossAxisCount: 1, scrollDirection: Axis.vertical,
                  shrinkWrap: true, children: [
                    BarChartSample1(52,65,73,27,34,63, 41,'Energy (kWh)','Shower',Color(
                        0xff66d3ff), Color(0xff0f668b),"kWh",75),
                    BarChartSample1(74,26,113,53,89,130, 15,'Energy (kWh)','Kitchen',Color(
                        0xffde6d59),
                        Color(0xff7f3e32),"kWh",150),
                    BarChartSample1(40,20,73,16,30,42, 55,'Energy (kWh)','Washing Machine',Color(
                        0xffe7c45c),
                        Color(0xffb39847),"kWh",80),
                  ]),


              GridView.count(crossAxisCount: 1, scrollDirection: Axis.vertical,
                  shrinkWrap: true, children: [
                    BarChartSample1(52,65,73,27,34,63, 41,'Budget (€)','Shower',Color(
                        0xff66d3ff), Color(0xff0f668b),"€",75),
                    BarChartSample1(74,26,113,53,89,130, 15,'Budget (€)','Kitchen',Color(
                        0xffde6d59),
                        Color(0xff7f3e32),"€",150),
                    BarChartSample1(40,20,73,16,30,42, 55,'Budget (€)','Washing Machine',Color(
                        0xffe7c45c),
                        Color(0xffb39847),"€",80),
                  ]),
            ],
          ),
        ),
      ),
    );

  }
}