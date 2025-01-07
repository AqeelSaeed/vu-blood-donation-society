import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plasma_donor/Components/Next.dart';
import 'package:plasma_donor/Components/ProfileInfo.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:plasma_donor/Screens/Raise%20Request/raiserequest_screen.dart';

class CompletedRequests extends StatefulWidget {
  @override
  _CompletedRequestsState createState() => _CompletedRequestsState();
}

class _CompletedRequestsState extends State<CompletedRequests> {
  User user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    Size _height = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Completed Requests',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 23,
          ),
        ),
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: onBackPressed,
            icon: Icon(
              Icons.cancel,
              color: Colors.black26,
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: _height.height * 0.05),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Completed Requests')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong ${snapshot.error}');
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(kPrimaryColor),
                      ),
                    );
                  default:
                    return ListView(
                        children: snapshot.data!.docs
                            .asMap()
                            .map((index, value) => MapEntry(
                                  index,
                                  Next(
                                    Icons.person,
                                    () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ProfileReview(
                                              () {
                                                Navigator.pop(context);
                                              },
                                              "${value['location']}",
                                              "${value['About']}",
                                              "${value['Name']}",
                                              "${value['Phone Number']}",
                                              "${value['Blood Group']}",
                                              'close',
                                            );
                                          });
                                    },
                                    '${value['Name']}',
                                    () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: ((context) => More(
                                              Next(
                                                Icons.local_hospital,
                                                () {
                                                  FirebaseFirestore.instance
                                                      .collection('Profile')
                                                      .doc(
                                                          value['Completed By'])
                                                      .get()
                                                      .then((e) => showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return ProfileReview(
                                                              () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              "${e['location']}",
                                                              "${e['About']}",
                                                              "${e['Name']}",
                                                              "${e['Phone Number']}",
                                                              "${e['Blood Group']}",
                                                              'close',
                                                            );
                                                          }));
                                                },
                                                'Completed By',
                                                () {},
                                              ),
                                              Next(
                                                Icons.delete,
                                                () {
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                          'Completed Requests')
                                                      .doc(snapshot
                                                          .data!.docs[index].id)
                                                      .delete();
                                                  Navigator.pop(context);
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        "Request deleted successfully",
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                  );
                                                },
                                                'Delete',
                                                () {},
                                              ),
                                            )),
                                      );
                                    },
                                  ),
                                ))
                            .values
                            .toList());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> onBackPressed() async {
    await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) {
        return RaiseRequestScreen();
      },
    ), (route) => false);
    return Future.value(true);
  }
}
