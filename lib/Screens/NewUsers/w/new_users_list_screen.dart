import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plasma_donor/Components/constants.dart';

import '../../../Components/custom_row_widget.dart';
import '../../../models/user_model.dart';

class NewUsersListScreen extends StatefulWidget {
  const NewUsersListScreen({super.key});

  @override
  State<NewUsersListScreen> createState() => _NewUsersListScreenState();
}

class _NewUsersListScreenState extends State<NewUsersListScreen> {
  final CollectionReference itemsCollection =
      FirebaseFirestore.instance.collection('Profile');
  bool isLoading = false;
  bool isVerifying = false;
  List<UserModel> users = [];

  @override
  void initState() {
    super.initState();
    // Fetch data on initialization
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      isLoading = true;
    });
    try {
      // Modify the query to filter users who are neither verified nor rejected
      QuerySnapshot snapshot = await itemsCollection
          .where('isVerified', isEqualTo: false)
          // .where('isRejected', isEqualTo: false)
          .get();

      setState(() {
        // Map the data to UserModel and store it in the users list
        users = snapshot.docs
            .map((doc) =>
                UserModel.fromFirestore(doc.data() as Map<String, dynamic>))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      log('Error loading users: $e');
    }
  }

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
            child: Icon(Icons.arrow_back, color: kWhiteColor)),
        title: Text('New Users', style: TextStyle(color: kWhiteColor)),
      ),
      body: users.isEmpty
          ? Center(child: Text('No user requests found.'))
          : Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  var user = users[index];
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
                            spreadRadius: 2)
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.name ?? 'Unknown',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15)),
                            Text(user.email ?? 'Unknown',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15)),
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: 'User Type: ',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 15)),
                                TextSpan(
                                    text: user.userType ?? 'Unknown',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black))
                              ]),
                            ),
                          ],
                        ),
                        OutlinedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                log('loading2: $isLoading');
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return Dialog(
                                      child: Container(
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.5,
                                        decoration: BoxDecoration(
                                          color: kWhiteColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Stack(
                                          children: [
                                            Column(
                                              children: [
                                                const SizedBox(height: 10),
                                                Text('User Info',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 25,
                                                        color: Colors.black)),
                                                const Spacer(),
                                                CustomRow(
                                                    item: user.name,
                                                    title: 'Name'),
                                                CustomRow(
                                                    item: user.email,
                                                    title: 'Email'),
                                                CustomRow(
                                                    item: user.userType,
                                                    title: 'User Type'),
                                                CustomRow(
                                                    item: user.gender,
                                                    title: 'Gender'),
                                                CustomRow(
                                                    item: user.bloodGroup,
                                                    title: 'Blood Group'),
                                                CustomRow(
                                                    item: user.phoneNumber,
                                                    title: 'Phone'),
                                                CustomRow(
                                                    item: user.location,
                                                    title: 'Location'),
                                                const Spacer(),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      18.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      OutlinedButton(
                                                        onPressed: () async {
                                                          setState(() {
                                                            isVerifying = true;
                                                          });
                                                          await updateVerificationStatus(
                                                                  true,
                                                                  user.uid ??
                                                                      '')
                                                              .whenComplete(() {
                                                            _loadUsers();
                                                            Navigator.pop(
                                                                context);
                                                          });
                                                          setState(() {
                                                            isVerifying = false;
                                                          });
                                                        },
                                                        style: OutlinedButton
                                                            .styleFrom(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          backgroundColor:
                                                              kPrimaryColor,
                                                          minimumSize:
                                                              const Size(
                                                                  80, 40),
                                                          maximumSize:
                                                              const Size(
                                                                  80, 40),
                                                          shape:
                                                              StadiumBorder(),
                                                        ),
                                                        child: isVerifying
                                                            ? SizedBox(
                                                                height: 20,
                                                                width: 20,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color:
                                                                      kWhiteColor,
                                                                  strokeCap:
                                                                      StrokeCap
                                                                          .round,
                                                                  strokeWidth:
                                                                      4,
                                                                ),
                                                              )
                                                            : Text(
                                                                'Approve',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color:
                                                                        kWhiteColor),
                                                              ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      OutlinedButton(
                                                        onPressed: () async {
                                                          setState(() {
                                                            isLoading = true;
                                                          });
                                                          await updateRejectionStatus(
                                                                  true,
                                                                  user.uid ??
                                                                      '')
                                                              .whenComplete(() {
                                                            _loadUsers();
                                                            Navigator.pop(
                                                                context);
                                                          });
                                                          setState(() {
                                                            isLoading = false;
                                                          });
                                                        },
                                                        style: OutlinedButton
                                                            .styleFrom(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          backgroundColor:
                                                              kPrimaryColor,
                                                          minimumSize:
                                                              const Size(
                                                                  80, 40),
                                                          maximumSize:
                                                              const Size(
                                                                  80, 40),
                                                          shape:
                                                              StadiumBorder(),
                                                        ),
                                                        child: isLoading
                                                            ? SizedBox(
                                                                height: 20,
                                                                width: 20,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color:
                                                                      kWhiteColor,
                                                                  strokeCap:
                                                                      StrokeCap
                                                                          .round,
                                                                  strokeWidth:
                                                                      4,
                                                                ),
                                                              )
                                                            : Text(
                                                                'Reject',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color:
                                                                        kWhiteColor),
                                                              ),
                                                      ),
                                                    ],
                                                  ),
                                                )
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
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
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
                              style:
                                  TextStyle(fontSize: 15, color: kWhiteColor)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }

  Future<void> updateRejectionStatus(bool isRejected, String uid) async {
    try {
      await FirebaseFirestore.instance
          .collection('Profile') // Your Firestore collection name
          .doc(uid)
          .update({'isRejected': isRejected}).whenComplete(() {});
      print('isRejected updated to $isRejected');
    } catch (e) {
      print('Error updating isVerified: $e');
    }
  }

  Future<void> updateVerificationStatus(bool isVerified, String uid) async {
    try {
      await FirebaseFirestore.instance
          .collection('Profile') // Your Firestore collection name
          .doc(uid)
          .update({'isVerified': isVerified}).whenComplete(() {});
      print('isVerified updated to $isVerified');
    } catch (e) {
      print('Error updating isVerified: $e');
    }
  }
}
