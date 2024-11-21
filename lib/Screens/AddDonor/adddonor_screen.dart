import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plasma_donor/Components/ConnectivityStatus.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:plasma_donor/Screens/AddDonor/components/AddDonorForm.dart';

class AddDonorScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<AddDonorScreen> {
  String keyword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Donor', style: TextStyle(color: kWhiteColor)),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        leading: Builder(
          builder: (context) => IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: kWhiteColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
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
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                cursorColor: kPrimaryColor,
                onChanged: (val) {
                  setState(() {
                    keyword = val;
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
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('Donors').snapshots(),
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

                          // Check if the location contains the search keyword
                          if (value['location']
                              .toString()
                              .toLowerCase()
                              .contains(keyword.toLowerCase())) {
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        value['name'] ?? 'Unknown',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'Blood Group: ${value['bloodGroup'] ?? 'Unknown'}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
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
                                              text: 'Location: ',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 15,
                                              ),
                                            ),
                                            TextSpan(
                                              text: value['location'] ??
                                                  'Unknown',
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
                                  IconButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('Donors')
                                          .doc(value
                                              .id) // Accessing document ID directly
                                          .delete();
                                      Fluttertoast.showToast(
                                        msg: "Donor deleted successfully",
                                        gravity: ToastGravity.BOTTOM,
                                      );
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            // Return an empty container to avoid showing a "No Donor Found" message for every item that doesn't match.
                            return SizedBox.shrink();
                          }
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
}
