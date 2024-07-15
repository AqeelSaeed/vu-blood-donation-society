import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:plasma_donor/Components/RegisterClassses.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:plasma_donor/Screens/About/about_screen.dart';
import 'package:plasma_donor/Screens/AdminDashBoard/components/AdminHomeScreen.dart';
import 'package:plasma_donor/Screens/Profile/profile_screen.dart';
import 'package:plasma_donor/Screens/Setting/setting_screen.dart';
import 'package:plasma_donor/Screens/Welcome/welcome_screen.dart';

import 'components/UserHomeScreen.dart';

class UserDashboardScreen extends StatefulWidget {
  UserDashboardScreen({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _UserDashboardScreenState createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  User user = FirebaseAuth.instance.currentUser!;
  late KFDrawerController _drawerController;

  @override
  void initState() {
    super.initState();
    _drawerController = KFDrawerController(
      initialPage: ClassBuilder.fromString('UserHomeScreen'),
      items: [
        KFDrawerItem.initWithPage(
          text:
              Text('Home', style: TextStyle(color: Colors.white, fontSize: 18)),
          icon: Icon(Icons.home, color: Colors.white),
          page: user.uid == "kspMRxCsY8ata5y018RSwtreovS2"
              ? AdminHomeScreen()
              : UserHomeScreen(),
        ),
        KFDrawerItem.initWithPage(
          text: Text('Profile',
              style: TextStyle(color: Colors.white, fontSize: 18)),
          icon: Icon(Icons.person, color: Colors.white),
          page: ProfileScreen(),
        ),
        KFDrawerItem.initWithPage(
          text: Text('Setting',
              style: TextStyle(color: Colors.white, fontSize: 18)),
          icon: Icon(Icons.settings, color: Colors.white),
          page: SettingScreen(),
        ),
        KFDrawerItem.initWithPage(
          text: Text('About',
              style: TextStyle(color: Colors.white, fontSize: 18)),
          icon: Icon(Icons.info_outline_rounded, color: Colors.white),
          page: AboutScreen(),
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: KFDrawer(
        controller: _drawerController,
        header: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            width: MediaQuery.of(context).size.width * 0.8,
            child: Padding(
              padding: EdgeInsets.only(right: 50.0),
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage:
                        ExactAssetImage('assets/images/_blankProfile.jpg'),
                  ),
                  SizedBox(height: 5),
                  Text(
                    user.displayName.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    'User',
                    style: TextStyle(color: Colors.white54, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
        footer: KFDrawerItem(
          text: Text(
            'Logout',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 18,
            ),
          ),
          icon: Icon(Icons.logout, color: Colors.white54),
          onPressed: () async {
            FirebaseAuth.instance.signOut().then((_) {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (context) {
                  return WelcomeScreen();
                },
              ), (route) => false);
              Fluttertoast.showToast(
                msg: "logout successfully",
                gravity: ToastGravity.BOTTOM,
              );
            });
          },
        ),
        decoration: BoxDecoration(
          color: kPrimaryColor,
        ),
      ),
    );
  }
}