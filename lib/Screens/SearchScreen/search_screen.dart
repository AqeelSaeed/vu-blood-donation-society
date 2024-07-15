import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plasma_donor/Components/ConnectivityStatus.dart';
import 'package:plasma_donor/Components/Next.dart';
import 'package:plasma_donor/Components/ProfileInfo.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:plasma_donor/Screens/AdminDashBoard/AdminDashboard_Screen.dart';
import 'package:plasma_donor/Screens/UserDashBoard/UserDashboard_Screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _userId = FirebaseAuth.instance.currentUser!.uid;
  late String _query;

  @override
  Widget build(BuildContext context) {
    Size _height = MediaQuery.of(context).size;
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Search Donor'),
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
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: (_query == null || _query.trim() == '')
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
      ),
      onWillPop: onBackPressed,
    );
  }

  Future<bool> onBackPressed() {
    if (_userId == "kspMRxCsY8ata5y018RSwtreovS2") {
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
    return Future.value(null);
  }
}

class List extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot> _snapshot;

  List(this._snapshot);

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: _snapshot.data!.docs
            .map((DocumentSnapshot doc) => Next(
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
                ))
            .toList());
  }
}