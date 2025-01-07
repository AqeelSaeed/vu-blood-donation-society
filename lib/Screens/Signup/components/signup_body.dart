import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plasma_donor/Components/ConnectivityStatus.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:plasma_donor/Components/dropdown_component.dart';
import 'package:plasma_donor/Screens/Signup/components/Already_have_an_Account.dart';
import 'package:plasma_donor/Screens/Welcome/welcome_screen.dart';

class SignupBody extends StatefulWidget {
  @override
  _SignupBodyState createState() => _SignupBodyState();
}

class _SignupBodyState extends State<SignupBody> {
  late bool _isHidden = true;
  late String _name;
  late String _email;
  late String _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? dropDownValue;
  CollectionReference _addData =
      FirebaseFirestore.instance.collection('Profile');

  // String? _validatePassword(String? input) {
  //   _password = input ?? '';
  //   Pattern pattern =
  //       r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';

  //   RegExp regex = new RegExp(pattern.toString());
  //   print(input);
  //   if (input.toString().isEmpty) {
  //     return 'Please enter password';
  //   } else {
  //     if (!regex.hasMatch(input.toString()))
  //       return 'Please enter valid password (Example: abc*123ABC)';
  //     else
  //       return null;
  //   }
  // }

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
                        'Donate Plasma, Save Life',
                        style: TextStyle(
                          fontFamily: 'Libre_Baskerville',
                          fontSize: 20.0,
                          color: kPrimaryColor,
                        ),
                      ),
                      SizedBox(
                        height: _height.height * 0.25,
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
                                keyboardType: TextInputType.name,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (input) {
                                  if (input.toString().isEmpty)
                                    return 'Please enter your name';
                                  return null;
                                },
                                onSaved: (input) => _name = input.toString(),
                                cursorColor: kPrimaryColor,
                                decoration: kTextFormFieldDecoration.copyWith(
                                  labelText: 'Full Name',
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: kPrimaryColor,
                                  ),
                                ),
                              ),
                              SizedBox(height: _height.height * 0.01),
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (input) =>
                                    EmailValidator.validate(input.toString())
                                        ? null
                                        : "Please enter a valid email",
                                onSaved: (input) => _email = input.toString(),
                                cursorColor: kPrimaryColor,
                                decoration: kTextFormFieldDecoration,
                              ),
                              SizedBox(height: _height.height * 0.01),
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                // validator: _validatePassword,
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
                              SizedBox(height: _height.height * 0.01),
                              DropdownComponent(
                                  items: ['Donor', 'Patient'],
                                  value: dropDownValue,
                                  hint: 'Continue As',
                                  labelBuilder: (lable) => lable,
                                  onChanged: (value) {
                                    setState(() {
                                      dropDownValue = value;
                                    });
                                  }),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: kPrimaryColor),
                                child: Text(
                                  'Register',
                                  style: TextStyle(color: kWhiteColor),
                                ),
                                onPressed: () async {
                                  final progress = ProgressHUD.of(context);
                                  final formState = _formKey.currentState;
                                  if (formState!.validate()) {
                                    formState.save();
                                    progress!.show();
                                    try {
                                      registerUser();
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
                      AlreadyAccount(),
                      // OrDivider(),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: <Widget>[
                      //     SocialIcon(
                      //       iconSrc: "assets/icons/facebook.svg",
                      //       press: () {},
                      //     ),
                      //     SocialIcon(
                      //       iconSrc: "assets/icons/twitter.svg",
                      //       press: () {},
                      //     ),
                      //     SocialIcon(
                      //       iconSrc: "assets/icons/google-plus.svg",
                      //       press: () {},
                      //     ),
                      //   ],
                      // ),
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

  void registerUser() async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: _email, password: _password);
    User user = FirebaseAuth.instance.currentUser!;
    _addData.doc(user.uid).set({
      'uid': user.uid,
      'name': _name,
      'email': _email,
      'phoneNumber': '',
      'about': '',
      'bloodGroup': '',
      'gender': '',
      'location': '',
      'isVerified': false,
      'userType': dropDownValue,
    });
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => WelcomeScreen(),
        ),
        (route) => false);
    Fluttertoast.showToast(
      msg: "Registered successfully",
      gravity: ToastGravity.BOTTOM,
    );
  }
}
