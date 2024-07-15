import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plasma_donor/Components/ConnectivityStatus.dart';
import 'package:plasma_donor/Components/Next.dart';
import 'package:plasma_donor/Components/ProfileInfo.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:plasma_donor/Screens/Requests/requests_screen.dart';

class AcceptedRequestByUser extends StatefulWidget {
  @override
  _AcceptedRequestByUserState createState() => _AcceptedRequestByUserState();
}

class _AcceptedRequestByUserState extends State<AcceptedRequestByUser> {
  User user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Accepted Request',
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
      body: WillPopScope(
        child: ConnectivityStatus(
          child: Column(
            children: <Widget>[
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Requests')
                      .where('Accept By', isEqualTo: user.uid)
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
                                                  'Close',
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
                                                          .collection(
                                                              'Requests')
                                                          .doc(snapshot.data!
                                                              .docs[index].id)
                                                          .delete();
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'Completed Requests')
                                                          .doc()
                                                          .set({
                                                        'Completed By':
                                                            user.uid,
                                                        'Name': value['Name'],
                                                        'Phone Number': value[
                                                            'Phone Number'],
                                                        'About': value['About'],
                                                        'Blood Group': value[
                                                            'Blood Group'],
                                                        'location':
                                                            value['location'],
                                                      });
                                                      Navigator.pop(context);
                                                      Fluttertoast.showToast(
                                                        msg: "Thank You ❤",
                                                        gravity: ToastGravity.BOTTOM,
                                                      );
                                                    },
                                                    'Complete Request',
                                                    () {},
                                                  ),
                                                  Next(
                                                    Icons.delete,
                                                    () {
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'Requests')
                                                          .doc(snapshot.data!
                                                              .docs[index].id)
                                                          .update({
                                                        'Is Accepted': false,
                                                        'Accept By': '',
                                                      });
                                                      Navigator.pop(context);
                                                      Fluttertoast.showToast(
                                                        msg: "Request rejected successfully",
                                                        gravity: ToastGravity.BOTTOM,
                                                      );
                                                    },
                                                    'Reject Request',
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
        ),
        onWillPop: onBackPressed,
      ),
    );
  }

  Future<bool> onBackPressed() async{
    await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) {
        return RequestsScreen();
      },
    ), (route) => false);
    return Future.value(true);
  }
}
