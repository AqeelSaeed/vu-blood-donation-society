import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plasma_donor/Components/ConnectivityStatus.dart';
import 'package:plasma_donor/Components/ProfileInfo.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:plasma_donor/Screens/AdminDashBoard/admin_dashboard_screen.dart';

import '../../Components/Next.dart';

class ActiveUsers extends StatefulWidget {
  @override
  _ActiveUsersState createState() => _ActiveUsersState();
}

class _ActiveUsersState extends State<ActiveUsers> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: kWhiteColor,
              ),
              onPressed: () {
                onBackPressed();
              },
            ),
          ),
          title: Text(
            'Active Users',
            style: TextStyle(color: kWhiteColor),
          ),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
        ),
        body: ConnectivityStatus(
          child: Column(
            children: [
              Expanded(
                // Fetching active and verified donors
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Profile')
                      .where('isActive', isEqualTo: true)
                      .where('isVerified', isEqualTo: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                          child:
                              Text('Something went wrong: ${snapshot.error}'));
                    }
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(kPrimaryColor),
                          ),
                        );
                      case ConnectionState.none:
                        return Center(child: Text('There is nothing'));
                      default:
                        // Check if the data list is empty
                        if (snapshot.data?.docs.isEmpty ?? true) {
                          return Center(
                              child:
                                  Text('No active and verified users found'));
                        }

                        // Use ListView.builder for displaying the data
                        return ListView.builder(
                          itemCount: snapshot.data?.docs.length ?? 0,
                          itemBuilder: (context, index) {
                            var doc = snapshot.data!.docs[index];
                            return Next(
                              Icons.person,
                              () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ProfileReview(
                                      () {
                                        Navigator.pop(context);
                                      },
                                      "${doc['location']}",
                                      "${doc['about']}",
                                      "${doc['name']}",
                                      "${doc['phoneNumber']}",
                                      "${doc['bloodGroup']}",
                                      'Close',
                                    );
                                  },
                                );
                              },
                              '${doc['name']}',
                              () {},
                            );
                          },
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      canPop: false,
      onPopInvoked: (value) {
        log('onPopInvoked: $value');
        onBackPressed();
      },
    );
  }

  onBackPressed() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => AdminDashboardScreen(),
      ),
      (route) => false,
    );
  }
}
