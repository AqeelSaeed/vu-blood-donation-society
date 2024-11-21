import 'package:flutter/material.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:plasma_donor/Screens/Slider/components/slideritems.dart';
import 'package:plasma_donor/continue_as.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State {
  @override
  Widget build(BuildContext context) {
    Size _height = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: _height.height * 0.05),
          Image.asset(
            "assets/images/logo.png",
            height: _height.height * 0.1,
          ),
          Text(
            'Welcome',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Assistant',
              fontSize: 35.0,
              letterSpacing: 2.5,
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Plasma Donor",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Libre_Baskerville',
              fontSize: 30.0,
              color: kPrimaryColor,
            ),
          ),
          Text(
            'Recipient Connector ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Assistant',
              fontSize: 18.0,
              letterSpacing: 2.0,
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: _height.height * 0.2),
          SizedBox(
            height: 300,
            child: PageView.builder(
              itemCount: 3,
              controller: PageController(
                viewportFraction: 0.9,
              ),
              allowImplicitScrolling: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, itemIndex) {
                return Container(
                  height: _height.height * 0.37,
                  child: items[itemIndex],
                );
              },
              onPageChanged: (index) {
                // Handle any page change logic here, if needed
              },
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              padding: EdgeInsets.symmetric(horizontal: 60, vertical: 16),
              textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            child: Text(
              'Get Started',
              style: TextStyle(color: kWhiteColor),
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SelectUserScreen()),
                  (route) => false);
              //
            },
          ),
        ],
      ),
    );
  }
}
