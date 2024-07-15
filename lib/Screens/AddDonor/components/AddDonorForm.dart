import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:plasma_donor/Screens/AddDonor/adddonor_screen.dart';


class AddDonorForm extends StatefulWidget {
  @override
  _AddDonorFormState createState() => _AddDonorFormState();
}

class _AddDonorFormState extends State<AddDonorForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;
  String? _bloodGroup;
  String? _name;
  String? _address;
  String? _gender;
  String? _mobileNo;
  String? _about;
  List _bloodGroupItem = ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"];
  List _genderItem = ["Male", "Female", "other"];
  CollectionReference _addData =
      FirebaseFirestore.instance.collection('Donors');

  @override
  Widget build(BuildContext context) {
    Size _height = MediaQuery.of(context).size;
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Add Donor',
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
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  _addDonor();
                },
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              )
            ],
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                height: _height.height,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: _height.height * 0.05),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (input) {
                          if (input!.isEmpty) return 'Enter Name';
                          return null;
                        },
                        keyboardType: TextInputType.name,
                        cursorColor: kPrimaryColor,
                        onSaved: (input) => _name = input,
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
                          if (input!.isEmpty) return 'Enter Phone Number';
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                        cursorColor: kPrimaryColor,
                        onSaved: (input) => _mobileNo = input,
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
                          if (input!.isEmpty) return 'Enter Location';
                          return null;
                        },
                        keyboardType: TextInputType.streetAddress,
                        cursorColor: kPrimaryColor,
                        onSaved: (input) => _address = input,
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
                          if (input!.isEmpty) return 'Enter About';
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        cursorColor: kPrimaryColor,
                        onSaved: (input) => _about = input,
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
                            padding:
                                const EdgeInsets.only(left: 10.0, top: 10.0),
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        onWillPop: onBackPressed);
  }

  Future<void> _addDonor() async {
    final formState = _formKey.currentState;

    if (formState!.validate()) {
      formState.save();
      try {
        _addData.doc().set({
          'Name': _name,
          'Phone Number': _mobileNo,
          'About': _about,
          'Blood Group': _bloodGroup,
          'Gender': _gender,
          'location': _address,
        });
        Fluttertoast.showToast(
          msg: "Donor added successfully",
          gravity: ToastGravity.BOTTOM,
        );
        Navigator.pop(context);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<bool> onBackPressed() {
    return Future.value(true);
  }
}
