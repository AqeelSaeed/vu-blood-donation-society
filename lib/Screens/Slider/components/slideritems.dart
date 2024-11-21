import 'package:flutter/material.dart';
import 'package:plasma_donor/Components/constants.dart';

List<Widget> items = [
  FirstItem(),
  SecondItem(),
  ThirdItem(),
];

class FirstItem extends StatelessWidget {
  const FirstItem();

  @override
  Widget build(BuildContext context) {
    Size _height = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: _height.height * 0.01,
        ),
        Image.asset(
          "assets/images/drop.png",
          height: _height.height * 0.1,
        ),
        Text(
          'Donate Plasma, Save Life',
          style: TextStyle(
            fontFamily: 'Libre_Baskerville',
            fontSize: _height.height * 0.02,
            letterSpacing: 2.0,
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: _height.height * 0.01,
        ),
        Text(
          'This App will provide user-friendly interface to interact with the system to finding the required plasma. Moreover, you can request plasma donation help or ask someone to help.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Assistant',
            fontSize: _height.height * 0.02,
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class SecondItem extends StatelessWidget {
  const SecondItem();

  @override
  Widget build(BuildContext context) {
    Size _height = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: _height.height * 0.01,
        ),
        Image.asset(
          "assets/images/location.gif",
          height: _height.height * 0.1,
        ),
        Text(
          'Location',
          style: TextStyle(
            fontFamily: 'Libre_Baskerville',
            fontSize: _height.height * 0.02,
            letterSpacing: 2.0,
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: _height.height * 0.01,
        ),
        Text(
          'This App will able to find a donor from the map with any group of Plasma You can request from the app to take any plasma with the same blood group at any time and find donor location easily.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Assistant',
            fontSize: _height.height * 0.01,
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class ThirdItem extends StatelessWidget {
  const ThirdItem();

  @override
  Widget build(BuildContext context) {
    Size _height = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: _height.height * 0.01,
        ),
        Image.asset(
          "assets/images/security.gif",
          height: _height.height * 0.1,
        ),
        Text(
          'Security',
          style: TextStyle(
            fontFamily: 'Libre_Baskerville',
            fontSize: _height.height * 0.02,
            letterSpacing: 2.0,
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: _height.height * 0.01,
        ),
        Text(
          'This App will able to find a donor from the map with any group of Plasma You can request from the app to take any plasma with the same blood group at any time and find donor location easily.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Assistant',
            fontSize: _height.height * 0.01,
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
