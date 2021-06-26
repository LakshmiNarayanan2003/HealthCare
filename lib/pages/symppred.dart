import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SympPred extends StatefulWidget {
  @override
  _SympPredState createState() => _SympPredState();
}

class _SympPredState extends State<SympPred> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "TB Prediction",
          style: GoogleFonts.merriweather(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
