import 'package:flutter/material.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:plasma_donor/Screens/Welcome/welcome_screen.dart';

class AlreadyAccount extends StatelessWidget {
  const AlreadyAccount();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Already have an Account?',
          style: TextStyle(color: kPrimaryColor),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (context) {
                return WelcomeScreen();
              },
            ), (route) => false);
          },
          child: Text(
            'Login',
            style: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
