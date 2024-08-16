import 'package:flutter/material.dart';
import 'components/body.dart';

class WelcomeScreen extends StatefulWidget {

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Body(),
      ),
      onWillPop: onBackPressed,
    );
  }

  Future<bool> onBackPressed() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Do you want to exit?"),
        actions: <Widget>[
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("No")),
          TextButton(
              onPressed: () => Navigator.pop(context, true), child: Text("Yes"))
        ],
      ),
    );
    return Future.value(true);
  }
}
