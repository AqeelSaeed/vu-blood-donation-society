import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plasma_donor/Components/constants.dart';

class AddPatientForm extends StatefulWidget {
  final String requestType;

  const AddPatientForm({super.key, required this.requestType});
  @override
  _AddPatientFormState createState() => _AddPatientFormState();
}

class _AddPatientFormState extends State<AddPatientForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;
  String? _bloodGroup;
  String? _name;
  String? _address;
  String? _gender;
  String? _mobileNo;
  String? _about;
  String? _hospitalName;
  String? _hospitalLocation;
  String? _case;
  List _bloodGroupItem = ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"];
  List _genderItem = ["Male", "Female", "Other"];
  CollectionReference _addData =
      FirebaseFirestore.instance.collection('Patients');

  @override
  Widget build(BuildContext context) {
    Size _height = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Add Patient',
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
        child: Container(
          width: double.infinity,
          height: _height.height,
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: [
                    SizedBox(height: _height.height * 0.05),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (input) {
                        if (input!.isEmpty) return 'Patient Name';
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
                        labelText: 'Patient Name',
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
                        if (input!.isEmpty) return 'Patient Case';
                        return null;
                      },
                      keyboardType: TextInputType.streetAddress,
                      cursorColor: kPrimaryColor,
                      onSaved: (input) => _case = input,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.wheelchair_pickup_rounded,
                          color: kPrimaryColor,
                        ),
                        labelText: 'Patient Case',
                        labelStyle: TextStyle(color: kPrimaryColor),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor),
                        ),
                      ),
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (input) {
                        if (input!.isEmpty) return 'Hospital Name';
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      cursorColor: kPrimaryColor,
                      onSaved: (input) => _hospitalName = input,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.location_city_rounded,
                          color: kPrimaryColor,
                        ),
                        labelText: 'Hospital Name',
                        labelStyle: TextStyle(color: kPrimaryColor),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor),
                        ),
                      ),
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (input) {
                        if (input!.isEmpty) return 'Hospital Location';
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      cursorColor: kPrimaryColor,
                      onSaved: (input) => _hospitalLocation = input,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.location_on_sharp,
                          color: kPrimaryColor,
                        ),
                        labelText: 'Hospital Location',
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
                              "Gender",
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextButton(
                    onPressed: () {
                      if (widget.requestType == "request-blood") {
                        generateBloodRequest();
                      } else {
                        _addPatient();
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      maximumSize: const Size(double.infinity, 50),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: kWhiteColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addPatient() async {
    final formState = _formKey.currentState;

    if (formState!.validate()) {
      formState.save();
      try {
        _addData.doc().set({
          'uid': user!.uid.toString(),
          'name': _name,
          'phoneNumber': _mobileNo,
          'about': _about,
          'bloodGroup': _bloodGroup,
          'gender': _gender,
          'location': _address,
          'case': _case,
          'hospitalName': _hospitalName,
          'hospitalLocation': _hospitalLocation,
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

  void generateBloodRequest() {
    // Add the blood request to Firestore
    final formState = _formKey.currentState;

    if (formState!.validate()) {
      formState.save();
      try {
        FirebaseFirestore.instance.collection('Requests').add({
          'patientId': user!.uid.toString(),
          'name': _name ?? 'Unknown',
          'bloodGroup': _bloodGroup,
          'phoneNumber': _mobileNo,
          'location': _address,
          'case': _case,
          'gender': _gender,
          'about': _about,
          'status': "Pending", // Default value
          'accept-by': '', // Default value
          'timestamp': FieldValue.serverTimestamp(),
        }).then((value) {
          Fluttertoast.showToast(msg: "Blood request generated successfully!");
          Navigator.pop(context);
        }).catchError((error) {
          Fluttertoast.showToast(msg: "Error generating request: $error");
        });
      } catch (e) {
        Fluttertoast.showToast(msg: "Error generating request: $e");
      }
    }
  }

  Future<bool> onBackPressed() {
    return Future.value(true);
  }
}
