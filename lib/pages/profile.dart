import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health/services/authservice.dart';
import 'package:health/src/pages/home_page.dart';
import 'package:health/startpage.dart';
import 'package:health/widgets/UserInfo.dart';
import 'package:health/widgets/progress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../startpage.dart';

class EditProfile extends StatefulWidget {
  final String currentUserId;

  const EditProfile({this.currentUserId});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File imageFileAvatar;
  String imgUrl;
  String username;
  String customBio;
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  bool isLoading = false;
  bool _displayNameValid = true;
  bool _bioValid = true;
  List nuts = [
    'Protein',
    'Calories',
    'Fats',
    'Carbs',
    'Cholesterol',
    'Calcium',
    'Sodium',
    'Iron',
    'Vit. A',
    'Vit. C'
  ];
  List units = ['g', 'g', 'g', 'g', 'mg', 'mg', 'mg', 'mg', 'mug', 'mg'];
  int protein = 0;
  int calories = 0;
  int fats = 0;
  int carbs = 0;
  int chol = 0;
  int calcium = 0;
  int sodium = 0;
  int iron = 0;
  int vita = 0;
  int vitc = 0;
  bool display = false;
  List defaults = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Future updateProfileData() async {
    setState(() {
      displayNameController.text.trim().length < 3 ||
              displayNameController.text.isEmpty
          ? _displayNameValid = false
          : _displayNameValid = true;
      bioController.text.trim().length > 80
          ? _bioValid = false
          : _bioValid = true;
    });
    if (_displayNameValid && _bioValid) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('username', displayNameController.text.toString());
      preferences.setString('bio', bioController.text.toString());
      // preferences.setString('username', account.displayName);
      Fluttertoast.showToast(
          msg: "Updated successfully.", backgroundColor: Colors.green);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return HomePage();
      }));
    }
  }

  Column buildDisplayName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            "Name :",
            style: GoogleFonts.ubuntu(
              color: Colors.blue,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 15, right: 15),
          child: TextFormField(
            maxLength: 20,
            controller: displayNameController,
            decoration: InputDecoration(
              hintText: "Enter your name",
              errorText: _displayNameValid ? null : "Display name too short.",
            ),
          ),
        ),
      ],
    );
  }

  logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('log_status');
    FirebaseAuth.instance.signOut();
    AuthService().signout(context);
    googleSignIn.signOut();
    await preferences.remove('verify');
  }

  Future getImage() async {
    File newImgFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (newImgFile != null) {
      setState(() {
        this.imageFileAvatar = newImgFile;
        isLoading = true;
      });
    }
    Directory appDocumentsDirectory =
        await getApplicationDocumentsDirectory(); // 1
    String path = appDocumentsDirectory.path; // 2

// Step 4: Copy the file to a application document directory.
    final fileName = Path.basename(newImgFile.path);
    final File localImage = await newImgFile.copy('$path/$fileName');
    uploadToSharedPref(localImage.path);
  }

  buildBioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            "Status :",
            style: GoogleFonts.ubuntu(
              color: Colors.blue,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: TextFormField(
            controller: bioController,
            maxLength: 80,
            decoration: InputDecoration(
              errorText: _bioValid ? null : "Description too long.",
              hintText: "Update status",
            ),
          ),
        ),
      ],
    );
  }

  editprofile() async {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Edit Profile",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.red,
            ),
            onPressed: () {
              handleLogout(context);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.done,
              size: 30.0,
              color: Colors.green,
            ),
            onPressed: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) {
              return HomePage();
            })),
          ),
        ],
      ),
      body: isLoading
          ? linearProgress()
          : ListView(
              children: <Widget>[
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Center(
                          child: Stack(
                            children: <Widget>[
                              (imageFileAvatar == null)
                                  ? (imgUrl
                                          .toString()
                                          .contains('com.rachinc.respic'))
                                      ? (imgUrl != "")
                                          ? Material(
                                              child: Image.file(
                                                File(imgUrl),
                                                width: 200.0,
                                                filterQuality:
                                                    FilterQuality.high,
                                                height: 200.0,
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(125.0)),
                                              clipBehavior: Clip.hardEdge,
                                              //Displaying new file/image.
                                            )
                                          : Icon(
                                              Icons.account_circle,
                                              size: 90.0,
                                              color: Colors.grey,
                                            )
                                      : Material(
                                          //Displaying existing file/image.
                                          child: CachedNetworkImage(
                                            placeholder: (context, url) =>
                                                Container(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.0,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                            Color>(
                                                        Colors.orangeAccent),
                                              ),
                                              width: 200.0,
                                              height: 200.0,
                                              padding: EdgeInsets.all(20.0),
                                            ),
                                            imageUrl: imgUrl,
                                            width: 200.0,
                                            height: 200.0,
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(125.0)),
                                          clipBehavior: Clip.hardEdge,
                                        )
                                  : Material(
                                      child: Image.file(
                                        imageFileAvatar,
                                        width: 200.0,
                                        height: 200.0,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(125.0)),
                                      clipBehavior: Clip.hardEdge,
                                      //Displaying new file/image.
                                    ),
                              IconButton(
                                icon: Icon(
                                  FontAwesome.camera,
                                  size: 50,
                                  color: Colors.transparent,
                                ),
                                onPressed: getImage,
                                padding: EdgeInsets.all(0.0),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.blue,
                                iconSize: 200.0,
                              ),
                            ],
                          ),
                        ),
                        width: double.infinity,
                        margin: EdgeInsets.all(20.0),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            buildDisplayName(),
                            buildBioField(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    username = preferences.get('username');
    imgUrl = preferences.get('imgUrl');
    customBio = preferences.get('bio');
    setState(() {
      username = preferences.get('username');
      imgUrl = preferences.get('imgUrl');
      UserInformation().imgUrl = imgUrl;
      UserInformation().username = username;
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
    getUser();
  }

  getData() async {
    SharedPreferences nutrition = await SharedPreferences.getInstance();
    protein = nutrition.getInt('protein');
    calories = nutrition.get('calories');
    fats = nutrition.getInt('fats');
    carbs = nutrition.getInt('carbs');
    chol = nutrition.getInt('chol');
    calcium = nutrition.getInt('calcium');
    sodium = nutrition.getInt('sodium');
    iron = nutrition.getInt('iron');
    vita = nutrition.getInt('vita');
    vitc = nutrition.getInt('vitc');
    setState(() {
      defaults = [
        protein,
        calories,
        fats,
        carbs,
        chol,
        calcium,
        sodium,
        iron,
        vita,
        vitc
      ];
    });
  }

  Future uploadToSharedPref(path) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      preferences.setString('imgUrl', path.toString());
    });

    setState(() {
      isLoading = false;
    });
    Fluttertoast.showToast(
        msg: "Updated successfully.", backgroundColor: Colors.green);
  }

  handleLogout(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              "Logout?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            children: <Widget>[
              Divider(height: 10, thickness: 1),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SimpleDialogOption(
                  onPressed: () async {
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    preferences.remove('premium');
                    preferences.remove('date');
                    //TODO: remove all nutritional data, date data
                    Navigator.pop(context);
                    logout();
                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SimpleDialogOption(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Edit Profile",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.red,
              ),
              onPressed: () {
                handleLogout(context);
              },
            ),
            IconButton(
                icon: Icon(
                  Icons.done,
                  size: 30.0,
                  color: Colors.green,
                ),
                onPressed: () {
                  updateProfileData();
                })
          ],
        ),
        body: isLoading
            ? linearProgress()
            : RefreshIndicator(
                onRefresh: () => editprofile(),
                child: ListView(
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Center(
                              child: Stack(
                                children: <Widget>[
                                  (imageFileAvatar == null)
                                      ? (imgUrl
                                              .toString()
                                              .contains('com.rachinc.respic'))
                                          ? (imgUrl != "")
                                              ? Material(
                                                  child: Image.file(
                                                    File(imgUrl),
                                                    width: 200.0,
                                                    filterQuality:
                                                        FilterQuality.high,
                                                    height: 200.0,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              125.0)),
                                                  clipBehavior: Clip.hardEdge,
                                                  //Displaying new file/image.
                                                )
                                              : Icon(
                                                  Icons.account_circle,
                                                  size: 90.0,
                                                  color: Colors.grey,
                                                )
                                          : Material(
                                              //Displaying existing file/image.
                                              child: CachedNetworkImage(
                                                placeholder: (context, url) =>
                                                    Container(
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2.0,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            Colors
                                                                .orangeAccent),
                                                  ),
                                                  width: 200.0,
                                                  height: 200.0,
                                                  padding: EdgeInsets.all(20.0),
                                                ),
                                                imageUrl: imgUrl,
                                                filterQuality:
                                                    FilterQuality.high,
                                                width: 200.0,
                                                height: 200.0,
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(125.0)),
                                              clipBehavior: Clip.hardEdge,
                                            )
                                      : Material(
                                          child: Image.file(
                                            imageFileAvatar,
                                            width: 200.0,
                                            height: 200.0,
                                            filterQuality: FilterQuality.high,
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(125.0)),
                                          clipBehavior: Clip.hardEdge,
                                          //Displaying new file/image.
                                        ),
                                  IconButton(
                                    icon: Icon(
                                      FontAwesome.camera,
                                      size: 50,
                                      color: Colors.transparent,
                                    ),
                                    onPressed: getImage,
                                    padding: EdgeInsets.all(0.0),
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.blue,
                                    iconSize: 200.0,
                                  ),
                                ],
                              ),
                            ),
                            width: double.infinity,
                            margin: EdgeInsets.all(20.0),
                          ),
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              children: <Widget>[
                                buildDisplayName(),
                                buildBioField(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
  }
}