import 'dart:developer';

import 'package:flutter/material.dart';

import 'Screens/Welcome/welcome_screen.dart';
import 'main.dart';

class SelectUserScreen extends StatefulWidget {
  const SelectUserScreen({super.key});

  @override
  State<SelectUserScreen> createState() => _SelectUserScreenState();
}

class _SelectUserScreenState extends State<SelectUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/drop.png'),
                    Text(
                      'Continue As',
                      style: TextStyle(fontSize: 32, color: Colors.black),
                    ),
                  ],
                )),
            Expanded(
              child: Container(
                width: double.infinity,
                // color: Colors.amber,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                        onPressed: () {
                          saveUserType('Donor'); //
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(
                            builder: (context) {
                              return WelcomeScreen();
                            },
                          ), (route) => false);
                        },
                        style: OutlinedButton.styleFrom(
                            fixedSize: Size.square(100),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/users.png',
                              height: 50,
                            ),
                            Text(
                              'Donor',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        )),
                    OutlinedButton(
                        onPressed: () {
                          saveUserType('Patient');
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(
                            builder: (context) {
                              return WelcomeScreen();
                            },
                          ), (route) => false);
                        },
                        style: OutlinedButton.styleFrom(
                            fixedSize: Size.square(100),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/patient_log.png',
                              height: 50,
                            ),
                            Text(
                              'Patient',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        )),
                    OutlinedButton(
                        onPressed: () {
                          saveUserType('');
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(
                            builder: (context) {
                              return WelcomeScreen();
                            },
                          ), (route) => false);
                        },
                        style: OutlinedButton.styleFrom(
                            fixedSize: Size.square(100),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/patient_log.png',
                              height: 50,
                            ),
                            Text(
                              'Admin',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void saveUserType(String userType) {
    prefs.setString('type', userType);
    log('selectedUserType: ${prefs.getString('type')} okay done.');
  }
}
