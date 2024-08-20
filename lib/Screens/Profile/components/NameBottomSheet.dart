import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:provider/provider.dart';

import '../../../providers/network_provider.dart';


class NameBottomSheet extends StatefulWidget {
  @override
  _NameBottomSheetState createState() => _NameBottomSheetState();
}

class _NameBottomSheetState extends State<NameBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _name;
  User user = FirebaseAuth.instance.currentUser!;
  CollectionReference _addData =
      FirebaseFirestore.instance.collection('Profile');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: TextFormField(
              autofocus: true,
              keyboardType: TextInputType.name,
              cursorColor: kPrimaryColor,
              onSaved: (input) => _name = input.toString(),
              decoration: InputDecoration(
                icon: Icon(
                  Icons.person,
                  color: kPrimaryColor,
                ),
                labelText: 'Name',
                labelStyle: TextStyle(color: kPrimaryColor),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: kPrimaryColor),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: kPrimaryColor),
                ),
              ),
              TextButton(
                onPressed: _updateName,
                child: Text(
                  "Save",
                  style: TextStyle(color: kPrimaryColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _updateName() async {
    // updating user name
    final formState = _formKey.currentState;

    if (formState!.validate()) {
      formState.save();
      try {
        _addData.doc(user.uid).update({
          'name': _name,
        });
        user.updateProfile(
          displayName: _name,
        );
        Provider.of<DataProvider>(context, listen: false).fetchAdminProfile();
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: "Name updated successfully",
          gravity: ToastGravity.BOTTOM,
        );
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
