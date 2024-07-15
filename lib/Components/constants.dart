import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFFc62828);
const kPrimaryLightColor = Color(0xF7e3745);

const kTextFormFieldDecoration = InputDecoration(
  labelText: 'Email',
  labelStyle: TextStyle(color: kPrimaryColor),
  border: OutlineInputBorder(
    borderSide: BorderSide(color: kPrimaryColor),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kPrimaryColor),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kPrimaryColor),
  ),
  prefixIcon: Icon(
    Icons.email,
    color: kPrimaryColor,
  ),
);
