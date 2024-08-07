import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:connectivity/connectivity.dart';
import 'package:plasma_donor/Components/ConnectivityStatus.dart';
import 'package:plasma_donor/Components/DashboardCard.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:plasma_donor/Screens/Donors/donor_screen.dart';
import 'package:plasma_donor/Screens/Profile/components/EditProfile.dart';
import 'package:plasma_donor/Screens/Profile/profile_screen.dart';
import 'package:plasma_donor/Screens/Requests/requests_screen.dart';

// ignore: must_be_immutable
class UserHomeScreen extends KFDrawerContent {
  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  User user = FirebaseAuth.instance.currentUser!;
  CollectionReference _addData =
      FirebaseFirestore.instance.collection('Profile');

  @override
  void initState() {
    super.initState();
    _checkInternetConnectivity();
    _addData.doc(user.uid).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document are exist on the database');
      } else {
        // infoDialog();
        _addData.doc(user.uid).set({
          'name': user.displayName,
          'phoneNumber': '',
          'about': '',
          'bloodGroup': '',
          'gender': '',
          'location': '',
          'user-image': 'https://cdn-icons-png.flaticon.com/512/149/149071.png',
          'searchIndex': <String>[],
        });
      }
    });
    return null;
  }

  Widget build(BuildContext context) {
    Size _height = MediaQuery.of(context).size;
    log('userName: ${user.displayName}');
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.menu_rounded,
                color: kPrimaryColor,
              ),
              onPressed: widget.onMenuPressed,
            ),
          ),
          backgroundColor: Colors.white,
          title: Image.asset(
            'assets/images/logo.png',
            height: 35.0,
          ),
          centerTitle: true,
        ),
        body: ConnectivityStatus(
          child: Column(
            children: <Widget>[
              Image.asset(
                "assets/images/new4.png",
                height: _height.height * 0.3,
              ),
              Text(
                "MAKE SOMEONE HAPPY TODAY",
                style: TextStyle(
                  fontFamily: 'Libre_Baskerville',
                  fontSize: 30.0,
                  color: kPrimaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: _height.height * 0.05),
              Expanded(
                child: HorizontalCard(
                  Icons.local_hospital,
                  () {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                      builder: (context) {
                        return DonorsScreen();
                      },
                    ), (route) => false);
                  },
                  'Donors',
                ),
              ),
              Expanded(
                child: HorizontalCard(
                  Icons.notifications,
                  () {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                      builder: (context) {
                        return RequestsScreen();
                      },
                    ), (route) => false);
                  },
                  'Requests',
                ),
              ),
            ],
          ),
        ),
      ),
      onWillPop: onBackPressed,
    );
  }

  Future<bool> onBackPressed() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Do you want to exit?"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Yes"),
          )
        ],
      ),
    );
    return Future.value(true);
  }

  _checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      _addData.doc(user.uid).update({
        'isActive': true,
      });
      print('done mobile');
    } else if (connectivityResult == ConnectivityResult.wifi) {
      _addData.doc(user.uid).update({
        'isActive': true,
      });
      print('done wifi');
    } else if (connectivityResult == ConnectivityResult.none) {
      _addData.doc(user.uid).update({
        'isActive': false,
      });
      print('done none');
    }
  }

  infoDialog(){
    showDialog(context: context, builder: (context){
      return Dialog(
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: kWhiteColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Please complete your profile first.'),
              OutlinedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileForm()));
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: kPrimaryColor
                  ),
                  child: Text('Ok', style: TextStyle(color: kWhiteColor),))
            ],
          ),
        ),
      );
    });
  }
}
