import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:plasma_donor/Screens/AdminDashBoard/admin_dashboard_screen.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About Us',
          style: TextStyle(color: kWhiteColor),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              color: kWhiteColor,
            ),
            onPressed: widget.onMenuPressed,
          ),
        ),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      body: Center(
        child: Text(
          'Seyda Meerat Arshad',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
          ),
        ),
      ),
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
    return Future.value(true);
  }
}
