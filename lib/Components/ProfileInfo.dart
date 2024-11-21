import 'package:flutter/material.dart';
import 'BorderView.dart';
import 'constants.dart';

class Constants {
  Constants._();

  static const double padding = 20;
  static const double avatarRadius = 50;
}

class ProfileReview extends StatelessWidget {
  final String name, about, button, mobile, location, blood;
  final VoidCallback press;

  ProfileReview(
    this.press,
    this.location,
    this.about,
    this.name,
    this.mobile,
    this.blood,
    this.button,
  );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius,
              right: Constants.padding,
              bottom: Constants.padding,
            ),
            margin: EdgeInsets.only(top: Constants.avatarRadius),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(Constants.padding),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(0, 10),
                    blurRadius: 10,
                  ),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  name,
                  style: TextStyle(fontSize: 30),
                ),
                Text(
                  about,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  blood,
                  style: TextStyle(
                    fontSize: 25,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                BorderView(
                  mobile,
                  Icons.phone,
                ),
                BorderView(
                  location,
                  Icons.location_on,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: press,
                    child: Text(
                      button,
                      style: TextStyle(fontSize: 18, color: kPrimaryColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: Constants.padding,
            right: Constants.padding,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: Constants.avatarRadius,
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(Constants.avatarRadius),
                ),
                child: Image.asset(
                  'assets/images/logofull.jpg',
                  width: 70,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class More extends StatelessWidget {
  final Widget _widget1, _widget2;

  More(this._widget1, this._widget2);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
        ),
        padding: EdgeInsets.all(5),
        child: Column(
          children: <Widget>[
            _widget1,
            _widget2,
          ],
        ),
      ),
    );
  }
}
