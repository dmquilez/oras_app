import 'package:firebase_auth/firebase_auth.dart';
import 'package:oras_app/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oras_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

import '../FadeAnimation.dart';



class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/oras-logo-blue.png'),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter
              )
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 400),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.all(23),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Center(
                      child:  RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: Constants.textIntro,
                                style: TextStyle(
                                  color: Constants.kBlackColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30.0,
                                )),
                            TextSpan(
                                text: Constants.textIntroDesc1,
                                style: TextStyle(
                                    color: Constants.kDarkBlueColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.0)),
                            TextSpan(
                                text: Constants.textIntroDesc2,
                                style: TextStyle(
                                    color: Constants.kBlackColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.0)),
                          ]))
                  ),
                ),
                GoogleSignIn(),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class GoogleSignIn extends StatefulWidget {
  GoogleSignIn({Key? key}) : super(key: key);

  @override
  _GoogleSignInState createState() => _GoogleSignInState();
}

class _GoogleSignInState extends State<GoogleSignIn> {
  bool isLoading = false;

  userCheck(googleID) async{

    bool exists = false;

    // Create a CollectionReference called users that references the firestore collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return users
          .doc(googleID)
          .set({'name': FirebaseAuth.instance.currentUser!.displayName,
                'email': FirebaseAuth.instance.currentUser!.email,
                'picture': FirebaseAuth.instance.currentUser!.photoURL,
                'apartment': 0})
          .then((_) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }
      await addUser();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  !isLoading? Padding(
      padding: EdgeInsets.only(top: 20),
      child: MaterialButton(
        onPressed: () async {
          setState(() {
            isLoading = true;
          });
          FirebaseService service = new FirebaseService();
          try {
            await service.signInwithGoogle();
            await userCheck(FirebaseAuth.instance.currentUser!.uid);
            Navigator.pushNamedAndRemoveUntil(context, Constants.homeNavigate, (route) => false);
          } catch(e){
            if(e is FirebaseAuthException){
              showMessage(e.message!);
            }
          }
          setState(() {
            isLoading = false;
          });
        },
        child: Text('SIGN IN WITH GOOGLE',
          style: TextStyle(
            fontSize: 15,
            fontFamily: 'SFUIDisplay',
            fontWeight: FontWeight.bold,
          ),
        ),
        color: Color(0xff2482fa),
        elevation: 0,
        minWidth: 400,
        height: 50,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
      ),
    ) : CircularProgressIndicator();
  }

  void showMessage(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}




