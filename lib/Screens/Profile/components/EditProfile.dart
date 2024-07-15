import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:plasma_donor/Screens/Profile/profile_screen.dart';


class EditProfileForm extends StatefulWidget {
  @override
  _EditProfileFormState createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  User user = FirebaseAuth.instance.currentUser!;
  late String _bloodGroup;
  late String _address;
  late String _gender;
  late String _mobileNo;
  late String _about;
  List _bloodGroupItem = ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"];
  List _genderItem = ["Male", "Female", "other"];
  CollectionReference _addData =
      FirebaseFirestore.instance.collection('Profile');

  @override
  Widget build(BuildContext context) {
    Size _height = MediaQuery.of(context).size;
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Update Profile',
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
          actions: [
            TextButton(
              onPressed: () {
                _updateProfile();
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

  Future<void> _updateProfile() async {
    final formState = _formKey.currentState;

    if (formState!.validate()) {
      formState.save();
      try {
        List<String> splitList = _address.split(" ");
        List<String> indexList = [];
        for (int i = 0; i < splitList.length; i++) {
          for (int j = 0; j < splitList[i].length + i; j++) {
            indexList.add(splitList[i].substring(0, j).toLowerCase());
          }
        }
        _addData.doc(user.uid).update({
          'Phone Number': _mobileNo,
          'About': _about,
          'Blood Group': _bloodGroup,
          'Gender': _gender,
          'location': _address,
          'searchIndex': indexList,
        });
        Fluttertoast.showToast(
          msg: "Profile Updated",
          gravity: ToastGravity.BOTTOM,
        );
        Navigator.pop(context);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<bool> onBackPressed() async{
    await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) {
        return ProfileScreen();
      },
    ), (route) => false);
    return Future.value(true);
  }
}
