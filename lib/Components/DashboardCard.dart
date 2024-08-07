import 'package:flutter/material.dart';
import 'constants.dart';

class VerticalCard extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback press;

  VerticalCard(this.icon, this.press, this.text);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 8,
        shadowColor: Colors.black,
        child: Container(
          height: 150.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 50.0,
                color: kPrimaryColor,
              ),
              SizedBox(height: 10),
              Text(
                text,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HorizontalCard extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback press;

  HorizontalCard(this.icon, this.press, this.text);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: press,
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 8,
        shadowColor: Colors.black,
        child: Container(
          height: 150,
          width: 350,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 50.0,
                color: kPrimaryColor,
              ),
              SizedBox(height: 10),
              Text(
                text,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
