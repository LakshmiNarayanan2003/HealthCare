import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SkinPage extends StatefulWidget {
  @override
  _SkinPageState createState() => _SkinPageState();
}

class _SkinPageState extends State<SkinPage> {

  File _image;
  List _recognitions = [];
  bool _busy;
  bool loaded = false;
  final picker = ImagePicker();

  loadTfModel() async {
    Tflite.close();
    String res = await Tflite.loadModel(
        model: "assets/models/sc_model.tflite",
        labels: "assets/models/sc_labels.txt",
        numThreads: 1
    );
    setState(() {
      _busy = false;
    });
    print('----------------res');
    print(res);

  }

  detectObject(File image) async {
    var recognitions = await Tflite.runModelOnImage(
        path: image.path, // required
        imageMean: 127.5,
        imageStd: 127.5,
        threshold: 0.4, // defaults to 0.1
        asynch: true // defaults to true
    );
    FileImage(image)
        .resolve(ImageConfiguration())
        .addListener((ImageStreamListener((ImageInfo info, bool _) {
    })));
    setState(() {
      _recognitions = recognitions;
    });
    print('--------------rekog');
    print(_recognitions);
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        setState(() {
          loaded = true;
        });
      } else {}
    });
    detectObject(_image);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadTfModel();
  }

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
          "Skin cancer Prediction",
          style: GoogleFonts.merriweather(
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment : MainAxisAlignment.center,
          crossAxisAlignment:CrossAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.all(25),
                child: GestureDetector(
                  onTap: () {
                    getImageFromGallery();
                  },
                  child: SizedBox(
                    height: 300,
                    width: 300,
                    child: loaded ? Image.file(_image) : Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.add, size: 30,),
                            SizedBox(height: 20,),
                            Text('Upload Image')
                          ],
                        ),
                      elevation: 20,
                    ),
                  ),
                )
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Container(
                height: 50.0,
                width: 220.0,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0.0, 20.0),
                      blurRadius: 30.0,
                      color: Colors.black12,
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25.0),
                    topLeft: Radius.circular(25.0),
                    bottomRight: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                  //   borderRadius:
                  //       BorderRadius.circular(25.0),
                ),
                child: GestureDetector(
                  onTap: () {
                    print('lol');
                    getImageFromGallery();
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 70.0,
                        width: 170.0,
                        margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0.0),
                        child: Padding(
                          padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10.0),
                          child: Text(
                            'Predict',
                            style: GoogleFonts.nunito(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25.0),
                            topLeft: Radius.circular(25.0),
                            bottomRight: Radius.circular(200.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Icon(FontAwesome.picture_o),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    _recognitions.isEmpty ? 'Choose a file' : _recognitions[0]['label'],
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                color: _recognitions.isEmpty ? Colors.blueGrey : _recognitions[0] == 'Normal' ? Colors.green : Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}
