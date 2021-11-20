import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'navigation/navigate.dart';
import 'utils/constants.dart';
import 'package:flutter/services.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });

}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.title,
      builder: (context, child) {
        return Scaffold(
          body: child,
        );
      },
      initialRoute: '/',
      routes: Navigate.routes,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
