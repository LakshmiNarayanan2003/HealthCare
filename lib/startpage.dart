// Start page, detects silently whether the user has signed in for not. If not, he's re-directed to the sign in page.
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:health/authentication/signredirect.dart';
import 'package:health/widgets/UserInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:local_auth/local_auth.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool _hasFingerPrintSupport = false;
  List<BiometricType> _availableBuimetricType = List<BiometricType>();

  bool isAuth;

  Future<void> _getBiometricsSupport() async {
    bool hasFingerPrintSupport = false;
    try {
      hasFingerPrintSupport = await _localAuthentication.canCheckBiometrics;
    } catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _hasFingerPrintSupport = hasFingerPrintSupport;
    });
  }

  Future<void> _getAvailableSupport() async {
    // 7. this method fetches all the available biometric supports of the device
    List<BiometricType> availableBuimetricType = List<BiometricType>();
    try {
      availableBuimetricType =
      await _localAuthentication.getAvailableBiometrics();
    } catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _availableBuimetricType = availableBuimetricType;
    });
  }

  Future<void> _authenticateMe() async {
    print('-----------------imma trying');
    // 8. this method opens a dialog for fingerprint authentication.
    //    we do not need to create a dialog nut it popsup from device natively.
    bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Authenticate for Testing", // message for dialog
        useErrorDialogs: true,// show error in dialog
        stickyAuth: true,// native process
      );
    } catch (e) {
      print(e);
    }
    if (!mounted) return;
    if (authenticated) {
      checkLogin();
    }
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    checkInternet();
    _authenticateMe();
  }

  checkInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: 'Not connected to Internet.',
          backgroundColor: Colors.black,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG);
    }
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
  }

  handleSignIn(GoogleSignInAccount account) async {
    if (account != null) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('username', account.displayName);
      preferences.setString('imgUrl', account.photoUrl);

      setState(() {
        UserInformation().username = preferences.get('username');
        UserInformation().imgUrl = preferences.get('imgUrl');
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  login() {
    googleSignIn.signIn();
  }

  callback() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return SignInPage();
    }));
  }

  startTimer() async {
    var duration = Duration(
        seconds:
            1); // After 1 seconds, it is re-directed to the sign-in screen if the user is not authenticated, else it takes him into the app.
    return Timer(duration, callback);
  }

  buildUnAuthScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
              Theme.of(context).primaryColor.withOpacity(0.8),
              Theme.of(context).accentColor,
            ])),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  top: 225, bottom: 225, left: 35, right: 35),
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.satisfy(
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlue.shade400,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Health',
                        style: GoogleFonts.satisfy(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                    TextSpan(
                        text: 'Care',
                        style: GoogleFonts.satisfy(
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700)),
                  ],
                ),
              ),
            ),
            GestureDetector(
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
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Shimmer.fromColors(
              baseColor: Colors.lightBlue,
              highlightColor: Colors.lightBlue.shade400,
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.satisfy(
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlue.shade400,
                    fontSize: 50,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Health',
                        style: GoogleFonts.satisfy(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                    TextSpan(
                        text: 'Care',
                        style: GoogleFonts.satisfy(
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
