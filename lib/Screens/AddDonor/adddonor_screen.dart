import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plasma_donor/Components/ConnectivityStatus.dart';
import 'package:plasma_donor/Components/Next.dart';
import 'package:plasma_donor/Components/ProfileInfo.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:plasma_donor/Screens/AddDonor/components/AddDonorForm.dart';
import 'package:plasma_donor/Screens/AdminDashBoard/AdminDashboard_Screen.dart';


class AddDonorScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<AddDonorScreen> {
  @override
  Widget build(BuildContext context) {
    Size _height = MediaQuery.of(context).size;
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Donor', style: TextStyle(color: kWhiteColor)),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: kWhiteColor,),
              onPressed: onBackPressed,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          elevation: 8.0,
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.black,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => AddDonorForm()));
          },
          icon: Icon(Icons.add, color: Colors.white),
          label: Text('Add Donor', style: TextStyle(color: Colors.white)),
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
                                                      .collection('Donors')
                                                      .doc(snapshot
                                                          .data!.docs[index].id)
                                                      .delete();
                                                  Fluttertoast.showToast(
                                                    msg: "Donor deleted successfully",
                                                    gravity: ToastGravity.BOTTOM,
                                                  );
                                                  Navigator.pop(context);
                                                },
                                                "${value['location']}",
                                                "${value['about']}",
                                                "${value['name']}",
                                                "${value['phoneNumber']}",
                                                "${value['bloodGroup']}",
                                                'Delete Request',
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
