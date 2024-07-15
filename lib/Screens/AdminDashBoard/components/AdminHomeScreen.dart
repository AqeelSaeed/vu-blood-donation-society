import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:plasma_donor/Components/ConnectivityStatus.dart';
import 'package:plasma_donor/Components/DashboardCard.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:plasma_donor/Screens/ActiveUsers/activeusers_screen.dart';
import 'package:plasma_donor/Screens/AddDonor/adddonor_screen.dart';
import 'package:plasma_donor/Screens/Raise%20Request/raiserequest_screen.dart';
import 'package:plasma_donor/Screens/SearchScreen/search_screen.dart';

// ignore: must_be_immutable
class AdminHomeScreen extends KFDrawerContent {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size _height = MediaQuery.of(context).size;
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu_rounded, color: kPrimaryColor),
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
              SizedBox(height: _height.height * 0.03),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: VerticalCard(
                        Icons.person,
                        () {
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(
                            builder: (context) {
                              return ActiveUsers();
                            },
                          ), (route) => false);
                        },
                        'Active Users',
                      ),
                    ),
                    Expanded(
                      child: VerticalCard(
                        Icons.local_hospital_outlined,
                        () {
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(
                            builder: (context) {
                              return RaiseRequestScreen();
                            },
                          ), (route) => false);
                        },
                        'Raise Request',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: VerticalCard(
                        Icons.add,
                        () {
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(
                            builder: (context) {
                              return AddDonorScreen();
                            },
                          ), (route) => false);
                        },
                        'Add Donor',
                      ),
                    ),
                    Expanded(
                      child: VerticalCard(
                        Icons.search,
                        () {
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(
                            builder: (context) {
                              return SearchScreen();
                            },
                          ), (route) => false);
                        },
                        'Search Donor',
                      ),
                    ),
                  ],
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
          // ignore: deprecated_member_use
          OutlinedButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("No"),
          ),
          // ignore: deprecated_member_use
          OutlinedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Yes"),
          )
        ],
      ),
    );
    return Future.value(true);

  }
}
