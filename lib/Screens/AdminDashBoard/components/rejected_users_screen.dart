import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Components/constants.dart';
import '../../../Components/custom_row_widget.dart';

class RejectedUsersScreen extends StatefulWidget {
  const RejectedUsersScreen({super.key});

  @override
  State<RejectedUsersScreen> createState() => _RejectedUsersScreenState();
}

class _RejectedUsersScreenState extends State<RejectedUsersScreen> {
  final CollectionReference itemsCollection =
      FirebaseFirestore.instance.collection('Profile');
  @override
  Widget build(BuildContext context) {
    log('currentUser: ${FirebaseAuth.instance.currentUser!.uid.toString()}');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: kWhiteColor),
        ),
        title: Text('Rejected Users', style: TextStyle(color: kWhiteColor)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Stream from Firestore: Query for rejected users only
        stream:
            itemsCollection.where('isRejected', isEqualTo: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return Center(
                child: Text('Something went wrong: ${snapshot.error}'));
          }
          // Show loading indicator while waiting for data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // Once data is ready, display it in a ListView
          final data = snapshot.requireData;

          if (data.docs.isEmpty) {
            return Center(child: Text('No Rejected Users found'));
          }
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ListView.builder(
              itemCount: data.size,
              itemBuilder: (context, index) {
                var item = data.docs[index];
                log('data: $item');
                return Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 2),
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['name'],
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15)),
                          Text(item['email'],
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15)),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'User Type: ',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 15),
                                ),
                                TextSpan(
                                  text: item['userType'],
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      OutlinedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return Dialog(
                                child: Container(
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.5,
                                  decoration: BoxDecoration(
                                    color: kWhiteColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Stack(
                                    children: [
                                      Column(
                                        children: [
                                          const SizedBox(height: 10),
                                          Text('User Info',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25,
                                                  color: Colors.black)),
                                          const Spacer(),
                                          CustomRow(
                                              item: item['name'],
                                              title: 'Name'),
                                          CustomRow(
                                              item: item['email'],
                                              title: 'Email'),
                                          CustomRow(
                                              item: item['userType'],
                                              title: 'User Type'),
                                          CustomRow(
                                              item: item['gender'],
                                              title: 'Gender'),
                                          CustomRow(
                                              item: item['bloodGroup'],
                                              title: 'Blood Group'),
                                          CustomRow(
                                              item: item['phoneNumber'],
                                              title: 'Phone'),
                                          CustomRow(
                                              item: item['location'],
                                              title: 'Location'),
                                          const Spacer(),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: OutlinedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              style: OutlinedButton.styleFrom(
                                                padding: EdgeInsets.zero,
                                                backgroundColor: kPrimaryColor,
                                                minimumSize:
                                                    const Size(100, 40),
                                                shape: StadiumBorder(),
                                              ),
                                              child: Text(
                                                'Close',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: kWhiteColor),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: Icon(
                                            Icons.close_rounded,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: kPrimaryColor,
                          minimumSize: const Size(80, 40),
                          maximumSize: const Size(80, 40),
                          shape: StadiumBorder(),
                        ),
                        child: Text('View',
                            style: TextStyle(fontSize: 15, color: kWhiteColor)),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
