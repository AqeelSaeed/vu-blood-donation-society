

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plasma_donor/Components/constants.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late String _email;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AlertDialog _alertForgotPassword = AlertDialog(
    title: Text("Verify Email"),
    content: Text(
      'Password Change Link has been sent at your email address. Please check your email',
    ),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          return null;
        },
        child: Text('OK'),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    Size _height = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        width: double.infinity,
        height: _height.height,
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(height: _height.height * 0.05),
                Image.asset(
                  "assets/images/logo.png",
                  height: _height.height * 0.1,
                ),
                Text(
                  'Donate Plasma, Save Life',
                  style: TextStyle(
                    fontFamily: 'Assistant',
                    fontSize: 18.0,
                    letterSpacing: 2.0,
                    color: Color(0xFFB71C1C),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: _height.height * 0.2),
                Text(
                  'Enter your recovery email',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Color(0xFFB71C1C),
                  ),
                ),
                SizedBox(
                  height: _height.height * 0.02,
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: _height.width * 0.02,
                      right: _height.width * 0.02,
                    ),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (input) => EmailValidator.validate(input.toString())
                              ? null
                              : "Please enter a valid email",
                          onSaved: (input) => _email = input.toString(),
                          cursorColor: kPrimaryColor,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: kPrimaryColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: kPrimaryColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: kPrimaryColor),
                            ),
                            prefixIcon: Icon(
                              Icons.email,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                        SizedBox(height: _height.height * 0.03),
                        ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
                          child: Text('Send', style: TextStyle(color: kWhiteColor),),
                          onPressed: _forgotPassword,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _forgotPassword() async {
    final formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return _alertForgotPassword;
          },
        );
      } catch (e) {
        print('Failed with error code: ${e.toString()}');
      }
    }
  }
}
