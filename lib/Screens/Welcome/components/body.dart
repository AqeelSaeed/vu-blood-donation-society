import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plasma_donor/Components/ConnectivityStatus.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:plasma_donor/Components/or_divider.dart';
import 'package:plasma_donor/Components/social_icon.dart';
import 'package:plasma_donor/Screens/AdminDashBoard/AdminDashboard_Screen.dart';
import 'package:plasma_donor/Screens/Forgotpassword/forgotpassword_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plasma_donor/Screens/UserDashBoard/UserDashboard_Screen.dart';
import 'package:plasma_donor/Screens/Welcome/components/Create_an_Account.dart';


class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool _isHidden = true;
  late String _email;
  late String _password;
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
                                  if (input.toString().isEmpty) return 'Enter Password';
                                  return null;
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onSaved: (input) => _password = input.toString(),
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
                                child: Text('Login', style: TextStyle(
                                  color: kWhiteColor
                                ),),
                                onPressed: () async {
                                  final progress = ProgressHUD.of(context);
                                  final formState = _formKey.currentState;
                                  if (formState!.validate()) {
                                    formState.save();
                                    progress!.show();
                                    try {
                                      final user = await FirebaseAuth.instance
                                          .signInWithEmailAndPassword(
                                              email: _email,
                                              password: _password);
                                      if (user != null) {
                                        if (_email ==
                                            "aqeelsaeed15@gmail.com") {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AdminDashboardScreen(),
                                            ),
                                          );
                                        } else {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UserDashboardScreen(),
                                            ),
                                          );
                                        }
                                        Fluttertoast.showToast(
                                          msg: "Login successfully",
                                          gravity: ToastGravity.BOTTOM,
                                        );
                                        progress.dismiss();
                                      }
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
                      OrDivider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SocialIcon(
                            iconSrc: "assets/icons/facebook.svg",
                            press: () {},
                          ),
                          SocialIcon(
                            iconSrc: "assets/icons/twitter.svg",
                            press: () {},
                          ),
                          SocialIcon(
                            iconSrc: "assets/icons/google-plus.svg",
                            press: () {},
                          ),
                        ],
                      ),
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
}
