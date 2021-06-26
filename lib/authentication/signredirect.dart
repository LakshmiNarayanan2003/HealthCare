import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:health/services/authservice.dart';
import 'package:health/src/pages/home_page.dart';
import 'package:health/startpage.dart';

//Google authentication &
//Mobile authentication
String phisoCode;

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  callback() {
    setState(() {
      isLoading = false;
    });
  }

  startTimer() async {
    var duration = Duration(
        seconds:
            2); // After 2 seconds, it is re-directed to the sign-in screen if the user is not authenticated, else it takes him into the app.
    return Timer(duration, callback);
  }

  final formKey = new GlobalKey<FormState>();
  String phoneNo, verificationId;
  String smsCode;
  bool codeSent = false;
  bool isAuth = false;
  bool _visible = true;
  String isoCCode;
  bool isLoading = true;

  @override
  void initState() {
    startTimer();
    super.initState();
    checkLogin();
  }

  checkLogin() async {
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      handleSignIn(account);
      onError:
      (err) {};
    });
    googleSignIn
        .signInSilently(suppressErrors: false) //signing in automatically
        .then((account) {
      handleSignIn(account);
    }).catchError((err) {});

    FirebaseAuth.instance.authStateChanges().listen((acc) {
      if (acc != null) {
        setState(() {
          isAuth = true;
        });
      } else {
        googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
          handleSignIn(account);
          onError:
          (err) {};
        });
        googleSignIn
            .signInSilently(suppressErrors: false) //signing in automatically
            .then((account) {
          handleSignIn(account);
        }).catchError((err) {});
      }
    });
  }

  handleSignIn(GoogleSignInAccount account) async {
    if (account != null) {
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      phoneNo = internationalizedPhoneNumber;
      phisoCode = isoCode;
    });
  }

  @override
  buildUnauthScreen() {
    return Scaffold(
      appBar: _visible == false
          ? AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return SignInPage();
                    }));
                  }),
            )
          : null,
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: _visible
                  ? const EdgeInsets.only(
                      top: 150, bottom: 0, left: 35, right: 35)
                  : const EdgeInsets.only(
                      top: 150, bottom: 0, left: 35, right: 35),
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.satisfy(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                      fontSize: 36),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Health',
                        style: GoogleFonts.satisfy(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                    TextSpan(
                        text: 'Care',
                        style: GoogleFonts.satisfy(
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue.shade400)),
                  ],
                ),
              ),
            ),
            Text(
              "Always close to you",
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade800.withOpacity(0.8),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8),
            ),
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: SvgPicture.asset(
                'assets/img/splash.svg',
                height: 250,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: isLoading == true
                  ? CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    )
                  : GestureDetector(
                      onTap: login,
                      child: Container(
                        width: 260.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/images/google_signin_button.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
            ),
            isLoading == true
                ? CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 55,
                      width: 256,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue.shade400,
                          textStyle: TextStyle(
                            color: Colors.white,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Wrap(
                            children: <Widget>[
                              Icon(
                                Icons.fingerprint,
                                color: Colors.white,
                                size: 30,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5.0, left: 25.0),
                                child: Text(
                                  "Sign in with Fingerprint",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                        onPressed: () {
                          // TODO Fingerprint signin
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  login() async {
    await googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
    AuthService().signout(context);
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? HomePage() : buildUnauthScreen();
  }
}
