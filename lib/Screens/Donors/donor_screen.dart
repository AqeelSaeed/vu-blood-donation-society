import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plasma_donor/Components/ConnectivityStatus.dart';
import 'package:plasma_donor/Components/Next.dart';
import 'package:plasma_donor/Components/ProfileInfo.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:plasma_donor/Screens/UserDashBoard/UserDashboard_Screen.dart';

class DonorsScreen extends StatefulWidget {
  @override
  _DonorsScreenState createState() => _DonorsScreenState();
}

class _DonorsScreenState extends State<DonorsScreen> {
  @override
  Widget build(BuildContext context) {
    Size _height = MediaQuery.of(context).size;
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Donors'),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.arrow_back_rounded),
              onPressed: onBackPressed,
            ),
          ),
        ),
        body: ConnectivityStatus(
          child: Column(
            children: <Widget>[
              Image.asset(
                "assets/images/blood2.png",
                height: _height.height * 0.3,
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Donors')
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
                        return ListView(
                          children: snapshot.data!.docs
                              .map(
                                (DocumentSnapshot doc) => Next(
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
                                            "${doc['About']}",
                                            "${doc['Name']}",
                                            "${doc['Phone Number']}",
                                            "${doc['Blood Group']}",
                                            'Close',
                                          );
                                        });
                                  },
                                  '${doc['Name']}',
                                  () {},
                                ),
                              )
                              .toList(),
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      onWillPop: onBackPressed,
    );
  }

  Future<bool> onBackPressed() async{
    await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) {
        return UserDashboardScreen();
      },
    ), (route) => false);
    return Future.value(true);
  }
}
