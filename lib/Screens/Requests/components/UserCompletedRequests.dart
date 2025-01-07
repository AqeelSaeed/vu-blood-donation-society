import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plasma_donor/Components/Next.dart';
import 'package:plasma_donor/Components/ProfileInfo.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:plasma_donor/Screens/Requests/requests_screen.dart';

class UserCompletedRequests extends StatefulWidget {
  @override
  _UserCompletedRequestsState createState() => _UserCompletedRequestsState();
}

class _UserCompletedRequestsState extends State<UserCompletedRequests> {
  User user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
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
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Completed Requests')
                  .where('Completed By', isEqualTo: user.uid)
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
                                              "${value['about']}",
                                              "${value['name']}",
                                              "${value['phoneNumber']}",
                                              "${value['bloodGroup']}",
                                              'close',
                                            );
                                          });
                                    },
                                    '${value['name']}',
                                    () {},
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
        return RequestsScreen();
      },
    ), (route) => false);
    return Future.value(true);
  }
}
