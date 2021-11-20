import 'package:oras_app/screens/home_page.dart';
import 'package:oras_app/screens/welcome_page.dart';
import 'package:oras_app/screens/profile_page.dart';
import 'package:flutter/material.dart';




class Navigate {
  static Map<String, Widget Function(BuildContext)> routes =   {
    '/' : (context) => WelcomePage(),
    '/home'  : (context) => HomePage(),
    '/profile'  : (context) => ProfilePage()
  };
}
