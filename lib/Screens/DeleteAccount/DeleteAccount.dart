import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plasma_donor/Components/ConnectivityStatus.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:plasma_donor/Screens/Welcome/welcome_screen.dart';

class DeleteAccount extends StatefulWidget {
  @override
  _DeleteAccountState createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _email;

  @override
  Widget build(BuildContext context) {
    Size _height = MediaQuery.of(context).size;
    return PopScope(
      canPop: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'Delete Account',
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
                      'Delete your account will:',
                      style: TextStyle(
                        fontFamily: 'Assistant',
                        fontSize: 20.0,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: _height.height * 0.03),
                    Wrap(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: _height.width * 0.15),
                          child: Column(
                            children: <Widget>[
                              technology(
                                  context, "Delete your account from PDRC"),
                              technology(context, "Delete your data"),
                              technology(context, "Delete your requests"),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: _height.height * 0.05),
                    Text(
                      'To delete your account confirm your email first',
                      style: TextStyle(
                        color: Color(0xff717C99),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: _height.height * 0.04,
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
                                  EmailValidator.validate(input.toString())
                                      ? null
                                      : "Please enter a valid email",
                              initialValue: _email,
                              keyboardType: TextInputType.visiblePassword,
                              cursorColor: kPrimaryColor,
                              onSaved: (input) => _email = input.toString(),
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.mail,
                                  color: kPrimaryColor,
                                ),
                                labelText: 'Email',
                                labelStyle: TextStyle(color: kPrimaryColor),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: kPrimaryColor),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: _height.height * 0.1,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimaryColor),
                              child: Text(
                                'Delete My Account',
                                style: TextStyle(color: kWhiteColor),
                              ),
                              onPressed: _updatePassword,
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
    );
  }

  Future<bool> onBackPressed() async {
    return Future.value(true);
  }

  Future<void> _updatePassword() async {
    final formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      try {
        User user = FirebaseAuth.instance.currentUser!;
        if (_email == user.email) {
          user.delete();
          Fluttertoast.showToast(
            msg: "Account deleted successfully",
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

  Widget technology(BuildContext context, String text) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.skip_next,
          color: kPrimaryColor,
          size: 14.0,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.01,
        ),
        Text(
          text,
          style: TextStyle(
            color: Color(0xff717C99),
          ),
        )
      ],
    );
  }
}
