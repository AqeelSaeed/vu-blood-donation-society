import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plasma_donor/Components/ConnectivityStatus.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:plasma_donor/Screens/AdminDashBoard/admin_dashboard_screen.dart';
import 'package:plasma_donor/Screens/Forgotpassword/forgotpassword_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plasma_donor/Screens/UserDashBoard/UserDashboard_Screen.dart';
import 'package:plasma_donor/Screens/Welcome/components/Create_an_Account.dart';

import '../../../main.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool _isHidden = true;
  late String _email;
  late String _password;
  String userType = prefs.getString('type').toString();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _toggleVisibility() {
    setState(
      () {
        _isHidden = !_isHidden;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size _height = MediaQuery.of(context).size;
    log('message: $userType');
    return ConnectivityStatus(
      child: ProgressHUD(
        child: Builder(
          builder: (context) => GestureDetector(
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
                      SizedBox(height: _height.height * 0.03),
                      Image.asset(
                        "assets/images/logo.png",
                        height: _height.height * 0.1,
                      ),
                      Text(
                        "Plasma Donor",
                        style: TextStyle(
                          fontFamily: 'Libre_Baskerville',
                          fontSize: 30.0,
                          color: kPrimaryColor,
                        ),
                      ),
                      Text(
                        'Recipient Connector ',
                        style: TextStyle(
                          fontFamily: 'Assistant',
                          fontSize: 18.0,
                          letterSpacing: 2.0,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        userType,
                        style: TextStyle(
                          fontFamily: 'Assistant',
                          fontSize: 18.0,
                          letterSpacing: 2.0,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: _height.height * 0.25),
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
                                onSaved: (input) => _email = input.toString(),
                                cursorColor: kPrimaryColor,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (input) =>
                                    EmailValidator.validate(input.toString())
                                        ? null
                                        : "Please enter a valid email",
                                decoration: kTextFormFieldDecoration.copyWith(
                                  labelText: 'Email',
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: kPrimaryColor,
                                  ),
                                ),
                              ),
                              SizedBox(height: _height.height * 0.01),
                              TextFormField(
                                validator: (input) {
                                  if (input.toString().isEmpty)
                                    return 'Enter Password';
                                  return null;
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onSaved: (input) =>
                                    _password = input.toString(),
                                cursorColor: kPrimaryColor,
                                obscureText: _isHidden,
                                decoration: kTextFormFieldDecoration.copyWith(
                                  labelText: 'Password',
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: kPrimaryColor,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: _toggleVisibility,
                                    icon: _isHidden
                                        ? Icon(
                                            Icons.visibility_off,
                                            color: kPrimaryColor,
                                          )
                                        : Icon(
                                            Icons.visibility,
                                            color: kPrimaryColor,
                                          ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ForgotPasswordScreen();
                                        },
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: kPrimaryColor),
                                child: Text(
                                  'Login',
                                  style: TextStyle(color: kWhiteColor),
                                ),
                                onPressed: () async {
                                  final progress = ProgressHUD.of(context);
                                  final formState = _formKey.currentState;
                                  if (formState!.validate()) {
                                    formState.save();
                                    progress!.show();
                                    try {
                                      loginUser();
                                      progress.dismiss();
                                    } on FirebaseAuthException catch (error) {
                                      Fluttertoast.showToast(
                                        msg: "${error.message}",
                                        gravity: ToastGravity.BOTTOM,
                                      );
                                    }
                                  }
                                  progress!.dismiss();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      CreateAnAccount(),
                      SizedBox(height: _height.height * 0.02),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  loginUser() async {
    try {
      // Authenticate user with Firebase
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);

      final user = userCredential.user;

      if (user != null) {
        // Fetch user data from Firestore

        await FirebaseFirestore.instance
            .collection('Profile')
            .doc(user.uid)
            .update({'isActive': true});
        final userDoc = await FirebaseFirestore.instance
            .collection('Profile')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final isVerified = userDoc.data()?['isVerified'] ?? false;

          // Check for admin email
          if (_email == "aqeelsaeed15@gmail.com") {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => AdminDashboardScreen(),
              ),
            );
          } else if (isVerified) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => UserDashboardScreen(),
              ),
            );

            Fluttertoast.showToast(
              msg: "Login successfully",
              gravity: ToastGravity.BOTTOM,
            );
          } else {
            // User is not verified
            Fluttertoast.showToast(
              msg: "Your account is not verified by the admin.",
              gravity: ToastGravity.BOTTOM,
            );
          }
        } else {
          // User document doesn't exist
          Fluttertoast.showToast(
            msg: "Account not found. Please contact support.",
            gravity: ToastGravity.BOTTOM,
          );
        }
      }
    } on FirebaseAuthException catch (error) {
      // Handle login error
      Fluttertoast.showToast(
        msg: "${error.message}",
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}
