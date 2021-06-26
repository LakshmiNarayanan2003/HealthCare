import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:health/src/config/route.dart';
import 'package:health/startpage.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var initializationSettingAndroid = AndroidInitializationSettings('ic_launcher');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {});
  var initializationSettings = InitializationSettings(initializationSettingAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
    onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('payload' + payload);
    }
    }
  );
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title: 'HealthCare',
    routes: Routes.getRoute(),
    onGenerateRoute: (settings) => Routes.onGenerateRoute(settings),
    debugShowCheckedModeBanner: false,
    home: StartScreen(),
  ));
}
