import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:plasma_donor/Components/RegisterClassses.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:plasma_donor/Screens/About/about_screen.dart';
import 'package:plasma_donor/Screens/AdminDashBoard/components/admin_home_screen.dart';
import 'package:plasma_donor/Screens/Profile/profile_screen.dart';
import 'package:plasma_donor/Screens/Setting/setting_screen.dart';
import 'package:plasma_donor/Screens/UserDashBoard/components/UserHomeScreen.dart';
import 'package:plasma_donor/Screens/Welcome/welcome_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  final String? title;
  AdminDashboardScreen({Key? key, this.title}) : super(key: key);

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  User user = FirebaseAuth.instance.currentUser!;
  late KFDrawerController _drawerController;

  @override
  void initState() {
    super.initState();
    _drawerController = KFDrawerController(
      initialPage: ClassBuilder.fromString('AdminHomeScreen'),
      items: [
        KFDrawerItem.initWithPage(
          text:
              Text('Home', style: TextStyle(color: Colors.white, fontSize: 18)),
          icon: Icon(Icons.home, color: Colors.white),
          page: user.uid == "FhfHklNx51e3wio9M2BSAdqYzv73"
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
                    user.displayName ?? "",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    'Admin',
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
