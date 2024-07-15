import 'package:flutter/material.dart';
import 'package:plasma_donor/Screens/Signup//components/body.dart';
import 'package:plasma_donor/Screens/Welcome/welcome_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        child: Scaffold(
          body: Body(),
        ),
        onWillPop: onBackPressed,
      ),
    );
  }

  Future<bool> onBackPressed() async{
    await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) {
        return WelcomeScreen();
      },
    ), (route) => false);
    return Future.value(true);
  }
}
