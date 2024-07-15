import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plasma_donor/Components/ConnectivityStatus.dart';
import 'package:plasma_donor/Components/Next.dart';
import 'package:plasma_donor/Components/ProfileInfo.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:plasma_donor/Screens/AdminDashBoard/AdminDashboard_Screen.dart';

class ActiveUsers extends StatefulWidget {
  @override
  _ActiveUsersState createState() => _ActiveUsersState();
}

class _ActiveUsersState extends State<ActiveUsers> {
  @override
  Widget build(BuildContext context) {
    Size _height = MediaQuery.of(context).size;
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.arrow_back_rounded),
              onPressed: (){},
            ),
          ),
          title: Text('Active Users'),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
        ),
        body: ConnectivityStatus(
          child:
          Column(
            children: <Widget>[
              SizedBox(height: _height.height * 0.03),
              Image.asset(
                "assets/images/users.png",
                height: _height.height * 0.3,
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Profile')
                      .where('isActive', isEqualTo: true)
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
                        return ListView(
                            children: snapshot.data!.docs
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
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      onWillPop: (){
        return Future.value(true);
      },
    );
  }
  Future<bool> onBackPressed() async {
    await Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => AdminDashboardScreen(),
      ),
          (route) => false,
    );
    return Future.value(true);
  }

}
