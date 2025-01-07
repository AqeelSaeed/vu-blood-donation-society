import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plasma_donor/Components/ConnectivityStatus.dart';
import 'package:plasma_donor/Components/Next.dart';
import 'package:plasma_donor/Components/ProfileInfo.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:plasma_donor/Screens/UserDashBoard/UserDashboard_Screen.dart';

import '../AdminDashBoard/admin_dashboard_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _userId = FirebaseAuth.instance.currentUser!.uid;
  String? _query;

  @override
  Widget build(BuildContext context) {
    Size _height = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Donor',
          style: TextStyle(color: kWhiteColor),
        ),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: kWhiteColor,
            ),
            onPressed: onBackPressed,
          ),
        ),
      ),
      body: ConnectivityStatus(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: <Widget>[
              SizedBox(height: _height.height * 0.03),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: TextField(
                  cursorColor: kPrimaryColor,
                  onChanged: (val) {
                    setState(() {
                      _query = val.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: kPrimaryColor,
                    ),
                    contentPadding: EdgeInsets.only(left: 25.0),
                    hintText: 'Search by Location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              // searching donors
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: (_query == null || _query.toString().trim() == '')
                      ? FirebaseFirestore.instance
                          .collection('Profile')
                          .snapshots()
                      : FirebaseFirestore.instance
                          .collection('Profile')
                          .where('searchIndex', arrayContains: _query)
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong ${snapshot.error}');
                    }
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                kPrimaryColor,
                              ),
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
      ),
    );
  }

  Future<bool> onBackPressed() {
    if (_userId == "FhfHklNx51e3wio9M2BSAdqYzv73") {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return AdminDashboardScreen();
        },
      ), (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return UserDashboardScreen();
        },
      ), (route) => false);
    }
    return Future.value(true);
  }
}

class List extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot> _snapshot;

  List(this._snapshot);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _snapshot.data!.docs.map((DocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
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
                  "${data['location'] ?? ''}",
                  "${data['about'] ?? ''}",
                  "${data['name'] ?? ''}",
                  "${data['phoneNumber'] ?? ''}",
                  "${data['bloodGroup'] ?? ''}",
                  'Close',
                );
              },
            );
          },
          '${data['name'] ?? ''}',
          () {},
        );
      }).toList(),
    );
  }
}
