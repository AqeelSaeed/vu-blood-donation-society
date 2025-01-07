import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plasma_donor/Components/ConnectivityStatus.dart';
import 'package:plasma_donor/Components/constants.dart';
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
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
            builder: (context) => IconButton(
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: kWhiteColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                })),
        title: Text('Blood Requests', style: TextStyle(color: kWhiteColor)),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            iconColor: kWhiteColor,
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
          Navigator.push(
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
            SizedBox(height: _height.height * 0.01),
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
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var value = snapshot.data!.docs[index];
                          // var documentId = snapshot.data!.docs;
                          return Container(
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 2),
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                )
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      value['name'] ?? 'Unknown',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Required Blood Group: ',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 15,
                                            ),
                                          ),
                                          TextSpan(
                                            text: value['bloodGroup'] ??
                                                'Unknown',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Phone: ',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 15,
                                            ),
                                          ),
                                          TextSpan(
                                            text: value['phoneNumber'] ??
                                                'Unknown',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Case: ',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 15,
                                            ),
                                          ),
                                          TextSpan(
                                            text: value['case'] ?? 'Unknown',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Hospital: ',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 15,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                value['location'] ?? 'Unknown',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                PopupMenuButton(
                                  onSelected: (option) async {
                                    switch (option) {
                                      case '/accepted':
                                        await updateRequestStatus(
                                            value.id, 'accepted');
                                        break;
                                      case '/rejected':
                                        await updateRequestStatus(
                                            value.id, 'rejected');
                                        break;
                                      case '/delete':
                                        // Delete the request document
                                        await FirebaseFirestore.instance
                                            .collection('Requests')
                                            .doc(value.id)
                                            .delete();
                                        Fluttertoast.showToast(
                                          msg: "Request deleted successfully",
                                          gravity: ToastGravity.BOTTOM,
                                        );
                                        break;
                                      default:
                                        Fluttertoast.showToast(
                                          msg: "Invalid action",
                                          gravity: ToastGravity.BOTTOM,
                                        );
                                    }
                                  },
                                  itemBuilder: (BuildContext bc) {
                                    return const [
                                      PopupMenuItem(
                                        child: Text("Accept"),
                                        value: '/accepted',
                                      ),
                                      PopupMenuItem(
                                        child: Text("Reject"),
                                        value: '/rejected',
                                      ),
                                      PopupMenuItem(
                                        child: Text("Delete"),
                                        value: '/delete',
                                      )
                                    ];
                                  },
                                )
                              ],
                            ),
                          );
                        },
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateRequestStatus(String requestId, String newStatus) async {
    try {
      log('patientId: $requestId');
      // Update the request status in Firestore
      await FirebaseFirestore.instance
          .collection('Requests')
          .doc(requestId) // Specify the document ID
          .update({'status': newStatus});

      // Show success message to the user
      Fluttertoast.showToast(
        msg: "Request status updated to $newStatus",
        gravity: ToastGravity.BOTTOM,
      );
    } catch (error) {
      // Handle errors and show feedback to the user
      log('result: $error');
      Fluttertoast.showToast(
        msg: "Failed to update request status: $error",
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Future<bool> onBackPressed() {
    Navigator.pop(context);
    return Future.value(true);
  }
}
