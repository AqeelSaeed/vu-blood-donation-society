import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plasma_donor/Components/ConnectivityStatus.dart';
import 'package:plasma_donor/Components/Next.dart';
import 'package:plasma_donor/Components/ProfileInfo.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:plasma_donor/Screens/Requests/components/AcceptedRequests.dart';
import 'package:plasma_donor/Screens/UserDashBoard/UserDashboard_Screen.dart';

import 'components/UserCompletedRequests.dart';

class RequestsScreen extends StatefulWidget {
  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  User user = FirebaseAuth.instance.currentUser!;

  handleClick(String value) {
    switch (value) {
      case 'Completed Requests':
        return Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => UserCompletedRequests()));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size _height = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Requests',
          style: TextStyle(color: kWhiteColor),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: kWhiteColor,
            ),
            onPressed: onBackPressed,
          ),
        ),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            iconColor: kWhiteColor,
            itemBuilder: (BuildContext context) {
              return {'Completed Requests'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 8.0,
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.black,
        tooltip: 'Accepted Requests',
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AcceptedRequestByUser()));
        },
        icon: Icon(Icons.local_hospital, color: Colors.white),
        label: Text('Accepted Requests', style: TextStyle(color: Colors.white)),
      ),
      body: ConnectivityStatus(
        child: Column(
          children: <Widget>[
            Image.asset(
              "assets/images/drop.png",
              height: _height.height * 0.4,
            ),
            Expanded(
              //fetching blood requests in list.
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Requests')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong ${snapshot.error}');
                  }
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return SizedBox(
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(kPrimaryColor),
                          ),
                        ),
                      );
                    case ConnectionState.none:
                      return Text('There is nothing');
                    default:
                      return List(snapshot);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> onBackPressed() async {
    await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) {
        return UserDashboardScreen();
      },
    ), (route) => false);
    return Future.value(true);
  }
}

class List extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot> _snapshot;

  List(this._snapshot);

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser!;
    return ListView(
      children: _snapshot.data!.docs
          .asMap()
          .map((index, value) => MapEntry(
                index,
                Next(
                  Icons.person,
                  () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('Requests')
                                .doc(_snapshot.data!.docs[index].id)
                                .snapshots(),
                            builder: (context, snapshot2) {
                              return ProfileReview(
                                () {
                                  if (snapshot2.data!['accept-by'] == '') {
                                    FirebaseFirestore.instance
                                        .collection('Requests')
                                        .doc(_snapshot.data!.docs[index].id)
                                        .update({
                                      'Is Accepted': true,
                                      'accept-by': user.uid,
                                    });
                                    Fluttertoast.showToast(
                                      msg: "Request accepted successfully",
                                      gravity: ToastGravity.BOTTOM,
                                    );
                                    Navigator.pop(context);
                                  } else {
                                    if (snapshot2.data!['accept-by'] ==
                                        user.uid) {
                                      Fluttertoast.showToast(
                                        msg: "You have already accepted",
                                        gravity: ToastGravity.BOTTOM,
                                      );
                                    } else {
                                      Fluttertoast.showToast(
                                        msg:
                                            "Already accepted by another donor",
                                        gravity: ToastGravity.BOTTOM,
                                      );
                                    }
                                    Navigator.pop(context);
                                  }
                                },
                                "${value['location']}",
                                "${value['about']}",
                                "${value['name']}",
                                "${value['phoneNumber']}",
                                "${value['bloodGroup']}",
                                'Accept Request',
                              );
                            },
                          );
                        });
                  },
                  '${value['name']}',
                  () {},
                ),
              ))
          .values
          .toList(),
    );
  }
}
