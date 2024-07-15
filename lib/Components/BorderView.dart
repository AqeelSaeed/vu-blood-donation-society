import 'package:flutter/material.dart';

import 'constants.dart';

class BorderView extends StatelessWidget {
  final String text;
  final IconData icon;

  BorderView(this.text, this.icon);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 7),
      child: TextFormField(
        readOnly: true,
        initialValue: text,
        style: TextStyle(fontSize: 20),
        decoration: InputDecoration(
          border:
              OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor)),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor)),
          prefixIcon: Icon(
            icon,
            color: kPrimaryColor,
          ),
        ),
      ),
    );
  }
}
