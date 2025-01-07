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
import 'package:plasma_donor/Screens/Requests/requests_screen.dart';
import 'package:plasma_donor/patient/patient_requests_screen.dart';

import '../../../patient/add_patient_form.dart';

// ignore: must_be_immutable
class UserHomeScreen extends KFDrawerContent {
  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  User user = FirebaseAuth.instance.currentUser!;
  CollectionReference _addData =
      FirebaseFirestore.instance.collection('Profile');
  bool isLoading = false;
  String userType = '';

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

    return Scaffold(
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
        child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Profile') // Replace with your collection name
                .doc(user.uid) // Fetch the document for the current user
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              // Error handling
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              // Show loading while waiting for data
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              // Fetch the data from the snapshot
              var data = snapshot.data;

              // Check if the user's account is verified
              if (data != null && data.exists) {
                userType =
                    data['userType']; // Get the userType (Donor or Patient)
                if ((data.data() as Map<String, dynamic>)
                        .containsKey('isRejected') &&
                    data['isRejected'] == true) {
                  return Center(
                    child: Column(
                      children: [
                        Text(
                          "Your account has been rejected.",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: kPrimaryColor,
                                minimumSize: const Size(80, 40),
                                maximumSize: const Size(80, 40),
                                shape: StadiumBorder()),
                            child: isLoading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: kWhiteColor,
                                      strokeCap: StrokeCap.round,
                                      strokeWidth: 4,
                                    ),
                                  )
                                : Text('Reject',
                                    style: TextStyle(
                                        fontSize: 15, color: kWhiteColor)))
                      ],
                    ),
                  );
                } else if (data['isVerified'] == false) {
                  return Center(
                    child: Text(
                      "Your account activation request has been sent to admin for approval.",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
              }
              return Column(
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
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return DonorsScreen();
                          },
                        ));
                      },
                      'Donors',
                    ),
                  ),
                  Expanded(
                    child: HorizontalCard(
                      Icons.notifications,
                      () {
                        if (userType == "Patient") {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return PatientRequestsScreen(
                                role: userType,
                                userId: user.uid,
                              );
                              // return AddPatientForm(
                              //     requestType: 'request-blood');
                            },
                          ));
                        } else {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return RequestsScreen();
                            },
                          ));
                        }
                      },
                      'Requests',
                    ),
                  ),
                ],
              );
            }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return AddPatientForm(requestType: 'request-blood');
            },
          ));
        },
        backgroundColor: kPrimaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        label: Row(
          children: [
            Text('Request Blood',
                style: TextStyle(
                    color: kWhiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(width: 10),
            Icon(Icons.bloodtype_rounded, color: kWhiteColor, size: 24)
          ],
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

  infoDialog() {
    showDialog(
        context: context,
        builder: (context) {
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
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfileForm()));
                      },
                      style: OutlinedButton.styleFrom(
                          backgroundColor: kPrimaryColor),
                      child: Text(
                        'Ok',
                        style: TextStyle(color: kWhiteColor),
                      ))
                ],
              ),
            ),
          );
        });
  }
}
