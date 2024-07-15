import 'package:flutter/material.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:plasma_donor/Screens/Signup/signup_screen.dart';

class CreateAnAccount extends StatelessWidget {
  const CreateAnAccount();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Don’t have an Account?',
          style: TextStyle(color: kPrimaryColor),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (context) {
                return SignUpScreen();
              },
            ), (route) => false);
          },
          child: Text(
            'Register',
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
