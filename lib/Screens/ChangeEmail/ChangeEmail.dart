import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plasma_donor/Components/ConnectivityStatus.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:plasma_donor/Screens/Welcome/welcome_screen.dart';

class ChangeEmail extends StatefulWidget {
  @override
  _ChangeEmailState createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _email;
  String? _newEmail;

  @override
  Widget build(BuildContext context) {
    Size _height = MediaQuery.of(context).size;
    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'Change Email',
            style: TextStyle(color: kWhiteColor),
          ),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: kWhiteColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        body: ConnectivityStatus(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              width: double.infinity,
              height: _height.height,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: _height.height * 0.06),
                    Text(
                      'Change Your Email',
                      style: TextStyle(
                        fontFamily: 'Assistant',
                        fontSize: 20.0,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: _height.height * 0.07,
                    ),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: _height.width * 0.03),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (input) =>
                                  EmailValidator.validate(input!)
                                      ? null
                                      : "Please enter a valid email",
                              initialValue: _email,
                              keyboardType: TextInputType.visiblePassword,
                              cursorColor: kPrimaryColor,
                              onSaved: (input) => _email = input!,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.email,
                                  color: kPrimaryColor,
                                ),
                                labelText: 'Old Email',
                                labelStyle: TextStyle(color: kPrimaryColor),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: kPrimaryColor),
                                ),
                              ),
                            ),
                            SizedBox(height: _height.height * 0.03),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (input) =>
                                  EmailValidator.validate(input!)
                                      ? null
                                      : "Please enter a valid email",
                              initialValue: _newEmail,
                              keyboardType: TextInputType.visiblePassword,
                              cursorColor: kPrimaryColor,
                              onSaved: (input) => _newEmail = input!,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.email,
                                  color: kPrimaryColor,
                                ),
                                labelText: 'New Email',
                                labelStyle: TextStyle(color: kPrimaryColor),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: kPrimaryColor),
                                ),
                              ),
                            ),
                            SizedBox(height: _height.height * 0.1),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimaryColor),
                              child: Text(
                                'Change Email',
                                style: TextStyle(color: kWhiteColor),
                              ),
                              onPressed: _updateEmail,
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
        ),
      ),
      onWillPop: onBackPressed,
    );
  }

  Future<bool> onBackPressed() async {
    return Future.value(true);
  }

  Future<void> _updateEmail() async {
    final formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      try {
        User user = FirebaseAuth.instance.currentUser!;
        if (_email == user.email) {
          user.verifyBeforeUpdateEmail(_email!);
          Fluttertoast.showToast(
            msg: "Email Changed successfully",
            gravity: ToastGravity.BOTTOM,
          );
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) {
              return WelcomeScreen();
            },
          ), (route) => false);
        } else {
          Fluttertoast.showToast(
            msg: "Invalid Email",
            gravity: ToastGravity.BOTTOM,
          );
        }
      } catch (e) {}
    }
  }
}
