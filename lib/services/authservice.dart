import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health/src/pages/home_page.dart';
import 'package:health/startpage.dart';

class AuthService {
  signout(BuildContext context) {
    FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return StartScreen();
      }));
    });
  }

  signIn(BuildContext context, AuthCredential authCredential) async {
    try {
      await FirebaseAuth.instance
          .signInWithCredential(authCredential)
          .then((value) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomePage();
        }));
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: "The OTP you have entered is incorrect.",
          backgroundColor: Colors.lightGreen);
    }
  }

  signInWithOTP(BuildContext context, smsCode, verId) {
    AuthCredential authCredential =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);

    signIn(context, authCredential);
  }
}
