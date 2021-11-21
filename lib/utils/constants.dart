import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Constants {
  //colors
  static const kPrimaryColor = Color(0xFFFFFFFF);
  static const kGreyColor = Color(0xFFEEEEEE);
  static const kBlackColor = Color(0xFF000000);
  static const kDarkGreyColor = Color(0xFF9E9E9E);
  static const kDarkBlueColor = Color(0xFF2196F3);
  static const kBorderColor = Color(0xFFEFEFEF);

  //text
  static const title = "Google Sign In";
  static const textIntro = "Taking care \n of ";
  static const textIntroDesc1 = "water";
  static const textIntroDesc2 = ", to \n take care of Earth!";
  static const textSignIn = "Sign In";
  static const textSignInGoogle = "Sign In With Google";
  static const textHome = "Home";

  //navigate
  static const welcomePage = '/';
  static const homeNavigate = '/home';
  static const profileNavigate = '/profile';
  static const friendsNavigate = '/friends';
  static const friendsAddNavigate = '/friends-add';

  static const statusBarColor = SystemUiOverlayStyle(
      statusBarColor: Constants.kPrimaryColor,
      statusBarIconBrightness: Brightness.dark);
}
