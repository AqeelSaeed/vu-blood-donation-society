import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plasma_donor/Components/ConnectivityStatus.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:plasma_donor/Screens/Setting/setting_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String? _oldPassword;
  String? _newPassword;
  String? _confirmPassword;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _validatePassword(String? input) {
    _newPassword = input ?? '';
    Pattern pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = new RegExp(pattern.toString());
    print(input);
    if (input.toString().isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(input.toString()))
        return 'Please enter valid password (Example: abc*123ABC)';
      else
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size _height = MediaQuery.of(context).size;
    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Change Password', style: TextStyle(color: kWhiteColor),),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: kWhiteColor,),
              onPressed: (){
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
                      'Secure Your Account',
                      style: TextStyle(
                        fontFamily: 'Assistant',
                        fontSize: 20.0,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: _height.height * 0.04,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (input) {
                              if (input.toString().isEmpty)
                                return 'Please enter old password';
                              return null;
                            },
                            initialValue: _oldPassword,
                            keyboardType: TextInputType.visiblePassword,
                            cursorColor: kPrimaryColor,
                            onSaved: (input) => _oldPassword = input.toString(),
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.lock_outline,
                                color: kPrimaryColor,
                              ),
                              labelText: 'Old Password',
                              labelStyle: TextStyle(color: kPrimaryColor),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: kPrimaryColor),
                              ),
                            ),
                          ),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: _validatePassword,
                            initialValue: _newPassword,
                            keyboardType: TextInputType.visiblePassword,
                            cursorColor: kPrimaryColor,
                            onSaved: (input) => _newPassword = input.toString(),
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.lock_outline,
                                color: kPrimaryColor,
                              ),
                              labelText: 'New Password',
                              labelStyle: TextStyle(color: kPrimaryColor),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: kPrimaryColor),
                              ),
                            ),
                          ),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (input) {
                              if (input.toString().isEmpty)
                                return 'Please confirm new password';
                              if (input != _newPassword)
                                return 'Password do not match';
                              return null;
                            },
                            initialValue: _confirmPassword,
                            keyboardType: TextInputType.visiblePassword,
                            cursorColor: kPrimaryColor,
                            onSaved: (input) => _confirmPassword = input.toString(),
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.lock_outline,
                                color: kPrimaryColor,
                              ),
                              labelText: 'Confirm Password',
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
                            child: Text('Change Password', style: TextStyle(color: kWhiteColor),),
                            onPressed: _updatePassword,
                          ),
                        ],
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

  Future<bool> onBackPressed() async{
    return Future.value(true);
  }

  Future<void> _updatePassword() async {
    final formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      try {
        User user = FirebaseAuth.instance.currentUser!;
        user.updatePassword(_confirmPassword!);
        Fluttertoast.showToast(
          msg: "Raised request successfully",
          gravity: ToastGravity.BOTTOM,
        );
      } catch (e) {}
    }
  }
}
