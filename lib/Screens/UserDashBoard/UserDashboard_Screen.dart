import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:plasma_donor/Components/RegisterClassses.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:plasma_donor/Screens/About/about_screen.dart';
import 'package:plasma_donor/Screens/AdminDashBoard/components/admin_home_screen.dart';
import 'package:plasma_donor/Screens/Profile/profile_screen.dart';
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
              child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Profile')
                      .doc(user.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      final data =
                          snapshot.data!.data() as Map<String, dynamic>?;
                      return Column(
                        children: <Widget>[
                          data!['user-image'] != null
                              ? CircleAvatar(
                                  radius: 50.0,
                                  backgroundImage: NetworkImage(
                                      data['user-image'].toString()),
                                )
                              : CircleAvatar(
                                  radius: 50.0,
                                  backgroundImage: ExactAssetImage(
                                      'assets/images/_blankProfile.jpg'),
                                ),
                          SizedBox(height: 5),
                          Text(
                            data['name'] ?? '',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          Text(
                            data['userType'] ?? 'User',
                            style:
                                TextStyle(color: Colors.white54, fontSize: 18),
                          ),
                        ],
                      );
                    }
                    return const CircularProgressIndicator();
                  }),
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
          onPressed: () {
            logoutUser(context);
          },
        ),
        decoration: BoxDecoration(
          color: kPrimaryColor,
        ),
      ),
    );
  }

  // Logout user and update isActive to false
  Future<void> logoutUser(BuildContext context) async {
    try {
      // Get the current user's UID
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // Update the 'isActive' field to false for the current user in Firestore
      await FirebaseFirestore.instance
          .collection('Profile') // Your Firestore collection name
          .doc(uid)
          .update({'isActive': true});

      // Now, sign out the user
      await FirebaseAuth.instance.signOut().then((_) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context) {
            return WelcomeScreen(); // Navigate to WelcomeScreen
          },
        ), (route) => false);

        // Show a toast message
        Fluttertoast.showToast(
          msg: "Logged out successfully",
          gravity: ToastGravity.BOTTOM,
        );
      });
    } catch (e) {
      print('Error during logout: $e');
      Fluttertoast.showToast(
        msg: "Error logging out",
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}
