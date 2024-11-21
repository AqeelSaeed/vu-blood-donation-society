import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:plasma_donor/Components/ConnectivityStatus.dart';
import 'package:plasma_donor/Components/DashboardCard.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:plasma_donor/Screens/ActiveUsers/activeusers_screen.dart';
import 'package:plasma_donor/Screens/AddDonor/adddonor_screen.dart';
import 'package:plasma_donor/Screens/AdminDashBoard/components/rejected_users_screen.dart';
import 'package:plasma_donor/Screens/NewUsers/w/new_users_list_screen.dart';
import 'package:plasma_donor/Screens/Raise%20Request/raiserequest_screen.dart';
import 'package:plasma_donor/Screens/SearchScreen/search_screen.dart';
import 'package:plasma_donor/patient/add_patient_screen.dart';

// ignore: must_be_immutable
class AdminHomeScreen extends KFDrawerContent {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size _height = MediaQuery.of(context).size;
    return PopScope(
      canPop: true,
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
              // Image.asset(
              //   "assets/images/new4.png",
              //   height: _height.height * 0.3,
              // ),
              SizedBox(height: _height.height * 0.05),
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
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
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
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
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
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: VerticalCard(
                          Icons.person_add_alt_sharp,
                          () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return AddDonorScreen();
                              },
                            ));
                          },
                          'Donors',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: VerticalCard(
                          Icons.wheelchair_pickup_rounded,
                          () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return AddPatientScreen();
                              },
                            ));
                          },
                          'Patients',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: VerticalCard(
                          Icons.add,
                          () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        NewUsersListScreen()));
                          },
                          'New Users',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: VerticalCard(
                          Icons.close,
                          () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RejectedUsersScreen()));
                          },
                          'Rejected Users',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
