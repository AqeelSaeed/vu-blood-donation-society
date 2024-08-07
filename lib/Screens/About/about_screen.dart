import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:plasma_donor/Screens/AdminDashBoard/AdminDashboard_Screen.dart';
import 'package:plasma_donor/Screens/UserDashBoard/UserDashboard_Screen.dart';

// ignore: must_be_immutable
class AboutScreen extends KFDrawerContent {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    Size _height = MediaQuery.of(context).size;
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Change Password', style: TextStyle(color: kWhiteColor),),
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: kWhiteColor,),
              onPressed: widget.onMenuPressed,
            ),
          ),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
        ),
        body: Container(
          width: double.infinity,
          height: _height.height,
          child: Column(
            children: <Widget>[
              Image.asset(
                "assets/images/ak.jpg",
                height: _height.height * 0.4,
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Powered By',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Assistant',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'AK Network Expert',
                    style: TextStyle(
                      fontFamily: 'Libre_Baskerville',
                      fontSize: 30.0,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      onWillPop: onBackPressed,
    );
  }

  Future<bool> onBackPressed() {
    if (_userId == "FhfHklNx51e3wio9M2BSAdqYzv73") {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return AdminDashboardScreen();
        },
      ), (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return UserDashboardScreen();
        },
      ), (route) => false);
    }
    return Future.value(null);
  }
}
