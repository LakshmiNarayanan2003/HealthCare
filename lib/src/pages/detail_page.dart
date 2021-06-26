import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health/src/model/dactor_model.dart';
import 'package:health/src/theme/extention.dart';
import 'package:health/src/theme/light_color.dart';
import 'package:health/src/theme/text_styles.dart';
import 'package:health/src/theme/theme.dart';
import 'package:health/src/widgets/rating_start.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';

class DetailPage extends StatefulWidget {
  DetailPage({Key key, this.model}) : super(key: key);
  final DoctorModel model;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DoctorModel model;
  String username = '';
  String imgUrl = '';
  String msg = '';
  final authctrl = TextEditingController();
  String times = '';
  List appnts = [];
  Razorpay _razorpay;
  bool success = false;
  DateTime date;

  @override
  void initState() {
    model = widget.model;
    super.initState();
    getName();
    getCloudData();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  getName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    username = preferences.getString('username');
    imgUrl = preferences.getString('imgUrl');
    times = preferences.getString('times');
    if (times == null) {
      setState(() {
        times = '0';
      });
    }
  }

  getCloudData() async {
    appnts.clear();
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection(model.name);
    QuerySnapshot querySnapshot = await _collectionRef.get();
    final allData = querySnapshot.docs.map((e) => e.data()).toList();
    for (int i = 0; i < allData.length; i++) {
      if (allData[i]["name"] == username) {
        appnts.add(allData[i]);
      }
    }
    print(appnts);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout(int cost, String name) async {
    var options = {
      'key': '{RAZORPAY_API_KEY}',
      'amount': cost,
      'name': name,
      'description': 'Doctor Fees',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId, toastLength: Toast.LENGTH_SHORT);
    setState(() {
      success = true;
    });
    final ref = FirebaseFirestore.instance
        .collection(model.name)
        .doc('$username-$times')
        .set({
      'cost': '500',
      'doc_id': '$username-$times',
      'img': imgUrl,
      'msg': msg,
      'name': username,
      'status': 'waiting',
      'time': date.toString()
    }).then((value) async {
      int t = num.parse(times);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('times', (t + 1).toString());
      getCloudData();
      Fluttertoast.showToast(
          msg: 'Successfully sent request',
          backgroundColor: Colors.green,
          textColor: Colors.green);
      setState(() {
        success = false;
      });
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName,
        toastLength: Toast.LENGTH_SHORT);
  }

  Widget _appbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        BackButton(color: Theme.of(context).primaryColor),
        IconButton(
            icon: Icon(
              model.isfavourite ? Icons.favorite : Icons.favorite_border,
              color: model.isfavourite ? Colors.red : LightColor.grey,
            ),
            onPressed: () {
              setState(() {
                model.isfavourite = !model.isfavourite;
              });
            })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = TextStyles.title.copyWith(fontSize: 25).bold;
    if (AppTheme.fullWidth(context) < 393) {
      titleStyle = TextStyles.title.copyWith(fontSize: 23).bold;
    }
    return Scaffold(
      backgroundColor: LightColor.extraLightBlue,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            Image.asset(model.image),
            DraggableScrollableSheet(
              maxChildSize: .8,
              initialChildSize: .6,
              minChildSize: .6,
              builder: (context, scrollController) {
                return Container(
                  height: AppTheme.fullHeight(context) * .5,
                  padding: EdgeInsets.only(
                      left: 19,
                      right: 19,
                      top: 16), //symmetric(horizontal: 19, vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(model.name,
                                  style: GoogleFonts.marmelad(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.check_circle,
                                  size: 20,
                                  color: Theme.of(context).primaryColor),
                              Spacer(),
                            ],
                          ),
                          subtitle: Text(
                            model.type,
                            style: TextStyles.bodySm.subTitleColor.bold,
                          ),
                        ),
                        Divider(
                          thickness: .3,
                          color: LightColor.grey,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RatingStar(
                              rating: model.rating,
                            )
                          ],
                        ),
                        Divider(
                          thickness: .3,
                          color: LightColor.grey,
                        ),
                        Text("About", style: titleStyle).vP16,
                        Text(
                          model.description,
                          style: TextStyles.body.subTitleColor,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        TextField(
                          controller: authctrl,
                          decoration: InputDecoration(
                            suffixIcon: Transform.rotate(
                              angle: 3.92,
                              child: IconButton(
                                icon: Icon(
                                  Icons.add_circle,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  authctrl.clear();
                                },
                              ),
                            ),
                            border: OutlineInputBorder(),
                            labelText: 'Enter your message',
                            labelStyle: TextStyle(color: Colors.blueGrey),
                            fillColor: Colors.blueGrey,
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                          onSubmitted: (tag) {
                            print('--------------tag');
                            print(tag);
                            setState(() {
                              msg = tag;
                            });
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              FloatingActionButton(
                                heroTag: "lol",
                                child: Icon(Icons.call),
                                onPressed: () async {
                                  const url = 'tel:9444160512';
                                  if (await canLaunch(url)) {
                                    launch(url);
                                  }
                                },
                                backgroundColor: Colors.blueGrey,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              FloatingActionButton(
                                heroTag: "ogg",
                                child: Icon(Icons.message),
                                onPressed: () async {
                                  print('lol');
                                  const url =
                                      'sms:+919444160512?body=Hello%20Doctor';
                                  if (await canLaunch(url)) {
                                    launch(url);
                                  }
                                },
                                backgroundColor: Colors.blueGrey,
                                focusColor: Colors.blueGrey,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              FlatButton(
                                color: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onPressed: () async {
                                  await DatePicker.showDateTimePicker(context,
                                      showTitleActions: true,
                                      minTime: DateTime(2020, 5, 5, 20, 50),
                                      maxTime: DateTime(2021, 6, 30, 05, 09),
                                      onConfirm: (time) async {
                                    print('confirm $time');
                                    setState(() {
                                      date = time;
                                    });
                                    await scheduleAlarm(date,
                                        'Medical checkup on ${date.toString()} with ${model.name}');
                                  });
                                  await openCheckout(5000, model.name);
                                  if (msg == '' || success == false) {
                                  } else {
                                    await getName();
                                  }
                                },
                                child: Text(
                                  "Make an appointment",
                                  style: TextStyles.titleNormal.white,
                                ).p(10),
                              ),
                            ],
                          ).vP16,
                        ),
                        Padding(
                          padding: EdgeInsets.all(2),
                          child: SizedBox(
                            height: 100,
                            child: ListView.builder(
                              itemCount: appnts.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, int) {
                                return Card(
                                  shadowColor: Colors.tealAccent,
                                  elevation: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: appnts[int]
                                                          ["status"] ==
                                                      'waiting'
                                                  ? Colors.yellow
                                                  : Colors.green,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'Status: \n${appnts[int]["status"]}',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: SizedBox(
                                            width: 100,
                                            child: Text(
                                              appnts[int]["msg"],
                                              softWrap: true,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          '₹ ${appnts[int]["cost"]}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            _appbar(),
          ],
        ),
      ),
    );
  }

  void scheduleAlarm(
      DateTime scheduledNotificationDateTime, String alarmInfo) async {
    print('doing alaram-----------');
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      'Channel for Alarm notification',
      icon: 'ic_launcher',
      sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('ic_launcher'),
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);

    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin
        .schedule(0, 'Office', alarmInfo, scheduledNotificationDateTime,
            platformChannelSpecifics)
        .then((value) => print('----------------------value'));
  }
}
