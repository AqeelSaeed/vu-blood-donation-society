import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:plasma_donor/Screens/Raise%20Request/raiserequest_screen.dart';

class RaiseRequestForm extends StatefulWidget {
  @override
  _RaiseRequestFormState createState() => _RaiseRequestFormState();
}

class _RaiseRequestFormState extends State<RaiseRequestForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  User user = FirebaseAuth.instance.currentUser!;
  late String _bloodGroup;
  late String _name;
  late String _address;
  late String _gender;
  late String _mobileNo;
  late String _about;
  List _bloodGroupItem = ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"];
  List _genderItem = ["Male", "Female", "other"];
  CollectionReference _addData =
      FirebaseFirestore.instance.collection('Requests');

  @override
  Widget build(BuildContext context) {
    Size _height = MediaQuery.of(context).size;
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Raise Request',
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
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: _height.height * 0.05),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (input) {
                        if (input.toString().isEmpty) return 'Enter Name';
                        return null;
                      },
                      keyboardType: TextInputType.name,
                      cursorColor: kPrimaryColor,
                      onSaved: (input) => _name = input.toString(),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.person,
                          color: kPrimaryColor,
                        ),
                        labelText: 'Full Name',
                        labelStyle: TextStyle(color: kPrimaryColor),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor),
                        ),
                      ),
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (input) {
                        if (input.toString().isEmpty) return 'Enter Phone Number';
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      cursorColor: kPrimaryColor,
                      onSaved: (input) => _mobileNo = input.toString(),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.phone,
                          color: kPrimaryColor,
                        ),
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(color: kPrimaryColor),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor),
                        ),
                      ),
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (input) {
                        if (input.toString().isEmpty) return 'Enter Location';
                        return null;
                      },
                      keyboardType: TextInputType.streetAddress,
                      cursorColor: kPrimaryColor,
                      onSaved: (input) => _address = input.toString(),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.location_on,
                          color: kPrimaryColor,
                        ),
                        labelText: 'Location',
                        labelStyle: TextStyle(color: kPrimaryColor),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor),
                        ),
                      ),
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (input) {
                        if (input.toString().isEmpty) return 'Enter About';
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      cursorColor: kPrimaryColor,
                      onSaved: (input) => _about = input.toString(),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.info_outline_rounded,
                          color: kPrimaryColor,
                        ),
                        labelText: 'About',
                        labelStyle: TextStyle(color: kPrimaryColor),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.local_hospital_outlined,
                          color: kPrimaryColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                          child: DropdownButton(
                            hint: Text(
                              "Select Blood Group",
                              style: TextStyle(color: kPrimaryColor),
                            ),
                            value: _bloodGroup,
                            onChanged: (input) {
                              setState(() {
                                _bloodGroup = input.toString();
                              });
                            },
                            items: _bloodGroupItem.map((input) {
                              return DropdownMenuItem(
                                value: input,
                                child: Text(input),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.assignment_ind,
                          color: kPrimaryColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: DropdownButton(
                            hint: Text(
                              "Select Your Gender",
                              style: TextStyle(color: kPrimaryColor),
                            ),
                            value: _gender,
                            onChanged: (input) {
                              setState(() {
                                _gender = input.toString();
                              });
                            },
                            items: _genderItem.map((input) {
                              return DropdownMenuItem(
                                value: input,
                                child: Text(input),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: _height.height * 0.05),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
                      onPressed: _raiseRequest,
                      child: Text('Raise Request'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      onWillPop: onBackPressed,
    );
  }

  Future<void> _raiseRequest() async {
    final formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      try {
        _addData.doc().set({
          'Name': _name,
          'Phone Number': _mobileNo,
          'About': _about,
          'Accept By': '',
          'Blood Group': _bloodGroup,
          'Gender': _gender,
          'location': _address,
        });
        Fluttertoast.showToast(
          msg: "Raised request successfully",
          gravity: ToastGravity.BOTTOM,
        );
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context) {
            return RaiseRequestScreen();
          },
        ), (route) => false);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<bool> onBackPressed() async{
    await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) {
        return RaiseRequestScreen();
      },
    ), (route) => false);
    return Future.value(true);
  }
}
