import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:plasma_donor/Components/MoveOn.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:plasma_donor/Screens/AdminDashBoard/admin_dashboard_screen.dart';
import 'package:plasma_donor/Screens/ChangeEmail/ChangeEmail.dart';
import 'package:plasma_donor/Screens/ChangePassword/ChangePassword.dart';
import 'package:plasma_donor/Screens/DeleteAccount/DeleteAccount.dart';
import 'package:plasma_donor/Screens/UserDashBoard/UserDashboard_Screen.dart';

// ignore: must_be_immutable
class SettingScreen extends KFDrawerContent {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String _userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    Size _height = MediaQuery.of(context).size;
    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.menu_outlined,
                color: kWhiteColor,
              ),
              onPressed: widget.onMenuPressed,
            ),
          ),
          centerTitle: true,
          title: Text(
            'Account Setting',
            style: TextStyle(color: kWhiteColor),
          ),
        ),
        body: Container(
          width: double.infinity,
          height: _height.height,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: _height.height * 0.01),
                MoveOn(
                  Icons.lock_outline,
                  () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChangePasswordScreen(),
                      ),
                    );
                  },
                  'Change Password',
                ),
                MoveOn(Icons.email_outlined, () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChangeEmail(),
                    ),
                  );
                }, 'Change Email'),
                MoveOn(Icons.delete_outline, () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DeleteAccount(),
                    ),
                  );
                }, 'Delete Account'),
              ],
            ),
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
