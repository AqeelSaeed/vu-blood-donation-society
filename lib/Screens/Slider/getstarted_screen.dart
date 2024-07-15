import 'package:flutter/material.dart';
import 'package:plasma_donor/Screens/Slider/components/body.dart';

class GetStartedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // set it to false
      body: Body(),
    );
  }
}
