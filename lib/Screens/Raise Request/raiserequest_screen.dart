import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plasma_donor/Components/ConnectivityStatus.dart';
import 'package:plasma_donor/Components/Next.dart';
import 'package:plasma_donor/Components/ProfileInfo.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:plasma_donor/Screens/AdminDashBoard/AdminDashboard_Screen.dart';
import 'package:plasma_donor/Screens/Raise%20Request/components/PendingRequests.dart';
import 'package:plasma_donor/Screens/Raise%20Request/components/CompletedRequests.dart';
import 'package:plasma_donor/Screens/Raise%20Request/components/RaiseRequestForm.dart';


class RaiseRequestScreen extends StatefulWidget {
  @override
  _RaiseRequestScreenState createState() => _RaiseRequestScreenState();
}

class _RaiseRequestScreenState extends State<RaiseRequestScreen> {
  handleClick(String value) {
    switch (value) {
      case 'Pending Requests':
        return Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => PendingRequests()));

      case 'Completed Requests':
        return Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => CompletedRequests()));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size _height = MediaQuery.of(context).size;
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.arrow_back_rounded),
              onPressed: onBackPressed,
            ),
          ),
          title: Text('Raise Request'),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {'Pending Requests', 'Completed Requests'}
                    .map((String choice) {
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
          tooltip: 'Raise Request',
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => RaiseRequestForm()));
          },
          icon: Icon(Icons.add, color: Colors.white),
          label: Text('Raise Request', style: TextStyle(color: Colors.white)),
        ),
        body: ConnectivityStatus(
          child: Column(
            children: <Widget>[
              SizedBox(height: _height.height * 0.03),
              Image.asset(
                "assets/images/blood.png",
                height: _height.height * 0.3,
              ),
              Expanded(
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
                                                    FirebaseFirestore.instance
                                                        .collection('Requests')
                                                        .doc(snapshot.data!
                                                            .docs[index].id)
                                                        .delete();
                                                    Fluttertoast.showToast(
                                                      msg: "Request deleted successfully",
                                                      gravity: ToastGravity.BOTTOM,
                                                    );
                                                    Navigator.pop(context);
                                                  },
                                                  "${value['location']}",
                                                  "${value['About']}",
                                                  "${value['Name']}",
                                                  "${value['Phone Number']}",
                                                  "${value['Blood Group']}",
                                                  'Delete Request',
                                                );
                                              });
                                        },
                                        '${value['Name']}',
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
        ),
      ),
      onWillPop: onBackPressed,
    );
  }

  Future<bool> onBackPressed() async{
    await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) {
        return AdminDashboardScreen();
      },
    ), (route) => false);
    return Future.value(true);
  }
}
