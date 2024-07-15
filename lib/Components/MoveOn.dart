import 'package:flutter/material.dart';
import 'constants.dart';

class MoveOn extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback press;

  MoveOn(this.icon, this.press, this.text);

  @override
  Widget build(BuildContext context) {
    Size _height = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.0),
      // ignore: deprecated_member_use
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: kPrimaryLightColor
        ),
        onPressed: press,
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
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.black38,
            ),
          ],
        ),
      ),
    );
  }
}
