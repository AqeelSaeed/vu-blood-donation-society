import 'package:flutter/material.dart';
import 'constants.dart';

class Next extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback press1;
  final VoidCallback press2;

  Next(this.icon, this.press1, this.text, this.press2);

  @override
  Widget build(BuildContext context) {
    Size _height = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.0),
      child: TextButton(
        onLongPress: press2,
        onPressed: press1,
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              color: kPrimaryColor,
            ),
            SizedBox(width: _height.width * 0.04),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}