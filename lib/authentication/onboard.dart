import 'package:animated_onboarding/animated_onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class onboard extends StatefulWidget {
  @override
  _onboardState createState() => _onboardState();
}

class _onboardState extends State<onboard> {
  bool isDone = false;
  bool show = false;

  @override
  void initState() {
    check();
    super.initState();
  }

  check() async {
    SharedPreferences onboard_chk = await SharedPreferences.getInstance();
    if (onboard_chk.getString('check') == 'completed') {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      setState(() {
        show = true;
      });
    }
  }

  final _pages = [
    OnboardingPage(
        child: Container(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0, bottom: 25),
                    child: CircleAvatar(
                      backgroundImage: AssetImage(
                        'assets/images/imgHome.jpg',
                      ),
                      radius: 100,
                    ),
                  ),
                  // Image.asset(
                  //   'assets/images/imgHome.jpg',
                  // ),

                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.merriweather(
                            color: Colors.green.shade700, fontSize: 15),
                        children: <TextSpan>[
                          TextSpan(
                              text:
                                  'Get the world of recipes under your hand with ResPic. Over 700,000+ recipes to cook with a teaspoon full of machine learning and tons of love. We have simplified each and every step in providing you with the perfect recipe within the given time.',
                              style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // CarouselSlider(
              //   options: CarouselOptions(
              //     height: 50,
              //     enlargeCenterPage: true,
              //     autoPlay: true,
              //     pauseAutoPlayOnTouch: true,
              //     autoPlayCurve: Curves.fastOutSlowIn,
              //     enableInfiniteScroll: true,
              //     autoPlayAnimationDuration: Duration(milliseconds: 800),
              //     viewportFraction: 0.8,
              //   ),
              //   items: [
              //     Card(child: Text('Popcorn')),
              //     Card(child: Text('Masala Dosa')),
              //     Card(child: Text('high nutrient food')),
              //     Card(child: Text('cheese recipes'))
              //   ],
              // ),
            ],
          ),
        ),
        color: Colors.white),
    OnboardingPage(
      color: Colors.green[500],
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: 560,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Customized Search",
                  style: GoogleFonts.merriweather(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2.0, bottom: 20),
                child: Container(
                  child: Image.asset(
                    "assets/images/search.jpg",
                    height: 200,
                    width: 200,
                  ),
                ),
              ),
              // Image.asset(
              //   'assets/images/imgHome.jpg',
              // ),

              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.merriweather(
                        color: Colors.green.shade700, fontSize: 15),
                    children: <TextSpan>[
                      TextSpan(
                          text:
                              'With more than 1000+ combinations, find the exact recipe you need from the type of dish till the cuisine type. Get the recipe world under your hand.',
                          style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    OnboardingPage(
      color: Colors.green[400],
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: 560,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 25),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Res',
                        style: GoogleFonts.satisfy(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: 'Pic',
                        style: GoogleFonts.satisfy(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                      TextSpan(
                          text: '\n\t\t\t\t\t\t\t  EYES',
                          style: GoogleFonts.alef(
                              fontWeight: FontWeight.w700,
                              color: Colors.blue,
                              fontSize: 10)),
                      TextSpan(
                          text: '\t beta',
                          style: GoogleFonts.alef(
                              fontWeight: FontWeight.w700,
                              color: Colors.grey,
                              fontSize: 10)),
                    ],
                  ),
                ),

                // ),Text(
                //   "ResPic for Pets",
                //   style: GoogleFonts.merriweather(
                //       fontWeight: FontWeight.bold,
                //       color: Colors.deepOrange,
                //       fontSize: 18),
                // ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0.0, bottom: 10),
                child: Container(
                  height: 250,
                  width: 250,
                  child: Image.asset(
                    "assets/images/ml.jpg",
                    fit: BoxFit.fitWidth,
                    // width: 500,
                  ),
                ),
              ),
              // Image.asset(
              //   'assets/images/imgHome.jpg',
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    heroTag: "obd",
                    elevation: 20,
                    onPressed: () {},
                    child: Shimmer.fromColors(
                      baseColor: Colors.black,
                      highlightColor: Colors.white,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  FloatingActionButton(
                    heroTag: "stt",
                    elevation: 20,
                    onPressed: () {},
                    child: Shimmer.fromColors(
                      baseColor: Colors.black,
                      highlightColor: Colors.white,
                      child: Icon(
                        FontAwesome.image,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.merriweather(
                        color: Colors.green.shade700, fontSize: 15),
                    children: <TextSpan>[
                      TextSpan(
                          text:
                              "Confused in identifying the ingredient? Perplexed what's before your eyes? With the help of ResPic take a snap and find the ingredient!",
                          style: TextStyle(color: Colors.black)),
                      TextSpan(
                        text: "\n\nNOTE : ",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            " This feature is a beta release, i.e., we're still working on the magic!",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    OnboardingPage(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 25),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Res',
                    style: GoogleFonts.satisfy(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: 'Pic',
                    style: GoogleFonts.satisfy(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                  TextSpan(
                      text: '\n\t\t\t\t\t  FOR PETS',
                      style: GoogleFonts.alef(
                          fontWeight: FontWeight.w700,
                          color: Colors.orange,
                          fontSize: 10)),
                ],
              ),
            ),
            // ),Text(
            //   "ResPic for Pets",
            //   style: GoogleFonts.merriweather(
            //       fontWeight: FontWeight.bold,
            //       color: Colors.deepOrange,
            //       fontSize: 18),
            // ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 35.0, bottom: 45),
              child: Center(
                  child: Icon(
                Icons.pets_sharp,
                size: 100,
                color: Colors.orange,
              ))),
          // Image.asset(
          //   'assets/images/imgHome.jpg',
          // ),
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: "Introducing",
                  // 'Personalized search is a customization of recipe results created by a filter that takes into account potentially relevant information such as whenever is user is going on a diet, he wants to choose the custom cuisine, he wants a particular recipe from a particular cuisine.. Explore them today!',
                  style: GoogleFonts.merriweather(
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                    text: " Res",
                    // 'Personalized search is a customization of recipe results created by a filter that takes into account potentially relevant information such as whenever is user is going on a diet, he wants to choose the custom cuisine, he wants a particular recipe from a particular cuisine.. Explore them today!',
                    style: GoogleFonts.merriweather(
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold)),
                TextSpan(
                    text: "Pic ",
                    // 'Personalized search is a customization of recipe results created by a filter that takes into account potentially relevant information such as whenever is user is going on a diet, he wants to choose the custom cuisine, he wants a particular recipe from a particular cuisine.. Explore them today!',
                    style: GoogleFonts.merriweather(
                        color: Colors.green.shade700,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold)),
                TextSpan(
                  text: " for Pets",
                  // 'Personalized search is a customization of recipe results created by a filter that takes into account potentially relevant information such as whenever is user is going on a diet, he wants to choose the custom cuisine, he wants a particular recipe from a particular cuisine.. Explore them today!',
                  style: GoogleFonts.merriweather(
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25, top: 40),
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.openSans(
                    color: Colors.green.shade700, fontSize: 15),
                children: <TextSpan>[
                  TextSpan(
                      text:
                          "Don't bore your pets with same food everyday, with",
                      // 'Personalized search is a customization of recipe results created by a filter that takes into account potentially relevant information such as whenever is user is going on a diet, he wants to choose the custom cuisine, he wants a particular recipe from a particular cuisine.. Explore them today!',
                      style: TextStyle(color: Colors.black)),
                  TextSpan(
                      text: " Res",
                      // 'Personalized search is a customization of recipe results created by a filter that takes into account potentially relevant information such as whenever is user is going on a diet, he wants to choose the custom cuisine, he wants a particular recipe from a particular cuisine.. Explore them today!',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: "Pic ",
                      // 'Personalized search is a customization of recipe results created by a filter that takes into account potentially relevant information such as whenever is user is going on a diet, he wants to choose the custom cuisine, he wants a particular recipe from a particular cuisine.. Explore them today!',
                      style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          "find delicious, easy to cook recipes for your pet.",
                      // 'Personalized search is a customization of recipe results created by a filter that takes into account potentially relevant information such as whenever is user is going on a diet, he wants to choose the custom cuisine, he wants a particular recipe from a particular cuisine.. Explore them today!',
                      style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    OnboardingPage(
      color: Colors.red[300],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Find your match with food",
              style: GoogleFonts.merriweather(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 25),
            child: SizedBox(
              height: 250,
              child: Image.asset(
                "assets/images/match.jpg",
              ),
            ),
          ),
          // Image.asset(
          //   'assets/images/imgHome.jpg',
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 20, right: 20),
          //   child: Text(
          //     "Are you a student looking for recipes which can be cooked under 10 minutes? Enthusiastic about food? Want to explore more recipes? Made with love, just for you! We all love food, with ResPic, you can find the food that matches you by swiping left or right.",
          //     style: GoogleFonts.merriweather(
          //       fontWeight: FontWeight.w600,
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.merriweather(
                    color: Colors.green.shade700, fontSize: 15),
                children: <TextSpan>[
                  TextSpan(
                      text:
                          "Want to explore more recipes? We all love food, with ResPic, you can find the food that matches you by swiping left or right.",
                      // 'Personalized search is a customization of recipe results created by a filter that takes into account potentially relevant information such as whenever is user is going on a diet, he wants to choose the custom cuisine, he wants a particular recipe from a particular cuisine.. Explore them today!',
                      style: TextStyle(fontSize: 13, color: Colors.black)),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    // OnboardingPage(
    //   color: Colors.white,
    //   child: Container(
    //     height: 500,
    //     margin: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
    //     decoration: BoxDecoration(
    //         color: Colors.white,
    //         // color: Colors.lightBlue
    //
    //         borderRadius: BorderRadius.circular(12.0),
    //         boxShadow: [
    //           BoxShadow(
    //             color: Colors.cyan[100],
    //             spreadRadius: 5,
    //             blurRadius: 7,
    //             offset: Offset(0, 10),
    //           ),
    //         ]),
    //     child: SingleChildScrollView(
    //       child: Container(
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: <Widget>[
    //             Padding(
    //               padding: const EdgeInsets.all(8.0),
    //               child: Text(
    //                 "Nutritional Facts",
    //                 style: GoogleFonts.merriweather(
    //                     fontWeight: FontWeight.bold,
    //                     color: Colors.lightGreen,
    //                     fontSize: 18),
    //               ),
    //             ),
    //             Padding(
    //               padding: const EdgeInsets.only(top: 25.0, bottom: 45),
    //               child: SizedBox(
    //                 height: 100,
    //                 child: Image.asset(
    //                   "assets/images/facts.jpg",
    //                 ),
    //               ),
    //             ),
    //             // Image.asset(
    //             //   'assets/images/imgHome.jpg',
    //             // ),
    //             Padding(
    //               padding: const EdgeInsets.only(left: 20, right: 20),
    //               child: Text(
    //                 " “When diet is wrong, medicine is of no use. When diet is correct, medicine is of no need.”",
    //                 style:
    //                     GoogleFonts.merriweather(fontWeight: FontWeight.bold),
    //               ),
    //             ),
    //             Padding(
    //               padding: const EdgeInsets.only(left: 20, right: 20, top: 100),
    //               child: RichText(
    //                 text: TextSpan(
    //                   style: GoogleFonts.merriweather(
    //                       color: Colors.green.shade700, fontSize: 15),
    //                   children: <TextSpan>[
    //                     TextSpan(
    //                         text:
    //                             "Always know about what you consume,what you eat. Providing you with every detail by which the recipe is made up of.",
    //                         // 'Personalized search is a customization of recipe results created by a filter that takes into account potentially relevant information such as whenever is user is going on a diet, he wants to choose the custom cuisine, he wants a particular recipe from a particular cuisine.. Explore them today!',
    //                         style: TextStyle(color: Colors.black)),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // ),
    OnboardingPage(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Nutritional status for you and your Pet",
              style: GoogleFonts.merriweather(
                  fontWeight: FontWeight.bold,
                  color: Colors.lightGreen,
                  fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 0.0,
              bottom: 45,
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 45.0),
                  child: SizedBox(
                    height: 270,
                    child: Image.asset(
                      "assets/images/nutrition.jpg",
                    ),
                  ),
                ),
                SizedBox(width: 35),
                SizedBox(
                  height: 270,
                  child: Image.asset(
                    "assets/images/nutrition1.jpg",
                  ),
                ),
              ],
            ),
          ),
          // Image.asset(
          //   'assets/images/imgHome.jpg',
          // ),
          // Padding(
          //   padding:
          //   const EdgeInsets.only(left: 20, right: 20),
          //   child: Text(
          //     "For you and for your pet.",
          //     style: GoogleFonts.merriweather(),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 20, right: 20),
          //   child: Text(
          //     "“To eat is a necessity, but to eat intelligently is an art.”",
          //     style: GoogleFonts.merriweather(fontWeight: FontWeight.w700),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.merriweather(
                    color: Colors.green.shade700, fontSize: 15),
                children: <TextSpan>[
                  TextSpan(
                      text:
                          "Always know about what you consume, what you eat. Providing you with every detail by which the recipe is made up of.",
                      // 'Personalized search is a customization of recipe results created by a filter that takes into account potentially relevant information such as whenever is user is going on a diet, he wants to choose the custom cuisine, he wants a particular recipe from a particular cuisine.. Explore them today!',
                      style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return show == false
        ? Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          )
        : AnimatedOnboarding(
            pages: _pages,
            pageController: PageController(),
            topLeftChild: RichText(
              text: TextSpan(
                style: GoogleFonts.satisfy(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                    fontSize: 22),
                children: <TextSpan>[
                  TextSpan(
                      text: 'Res',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  TextSpan(
                      text: 'Pic',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700)),
                ],
              ),
            ),
            topRightChild: GestureDetector(
              onTap: () async {

                SharedPreferences onboard_chk =
                    await SharedPreferences.getInstance();
                onboard_chk.setString('check', 'completed');
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    spreadRadius: 0.1,
                    blurRadius: 18,
                    offset: Offset(-1, 12),
                  ),
                ]),
                child: Text(
                  'SKIP',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                      fontSize: 14,
                      letterSpacing: 1,
                      shadows: [Shadow(color: Colors.blue.withOpacity(0.5))]),
                ),
              ),
            ),
            onFinishedButtonTap: () async {

              SharedPreferences onboard_chk =
                  await SharedPreferences.getInstance();
              onboard_chk.setString('check', 'completed');
              Navigator.pushReplacementNamed(context, '/login');
            });
  }
}
