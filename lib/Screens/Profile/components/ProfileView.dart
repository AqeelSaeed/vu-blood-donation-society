import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plasma_donor/Components/BorderView.dart';
import 'package:plasma_donor/Components/constants.dart';

class ProfileView extends StatefulWidget {
  String phoneNumber;
  String about;
  String bloodGroup;
  String gender;
  String location;


  ProfileView({
    required this.phoneNumber,
    required this.about,
    required this.bloodGroup,
    required this.gender,
    required this.location,
  });

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  User user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      //
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Profile')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                ),
              );
            case ConnectionState.none:
              return Text('There is nothing');
            default:
              return Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    BorderView(widget.phoneNumber, Icons.phone),
                    BorderView(
                      widget.location,
                      Icons.location_on,
                    ),
                    BorderView(widget.about, Icons.info),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: BorderView(widget.bloodGroup,
                              Icons.local_hospital),
                        ),
                        SizedBox(width: 10),
                        Flexible(
                          child: BorderView(
                              widget.gender, Icons.person),
                        ),
                      ],
                    ),
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}
