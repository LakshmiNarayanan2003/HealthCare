import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Container linearProgress() {
  return Container(
//    padding: EdgeInsets.only(bottom: 10.0),
    child: LinearProgressIndicator(
//      backgroundColor: Colors.white,
      valueColor: AlwaysStoppedAnimation(Colors.blue),
    ),
  );
}
