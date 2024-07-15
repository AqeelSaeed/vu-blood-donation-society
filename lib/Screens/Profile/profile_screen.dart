import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:plasma_donor/Components/ConnectivityStatus.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:plasma_donor/Screens/AdminDashBoard/AdminDashboard_Screen.dart';
import 'package:plasma_donor/Screens/Profile/components/EditProfile.dart';
import 'dart:io';
import 'package:plasma_donor/Screens/Profile/components/NameBottomSheet.dart';
import 'package:plasma_donor/Screens/Profile/components/ProfileView.dart';
import 'package:plasma_donor/Screens/UserDashBoard/UserDashboard_Screen.dart';

// ignore: must_be_immutable
class ProfileScreen extends KFDrawerContent {
  ProfileScreen({
    Key? key,
  });

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User user = FirebaseAuth.instance.currentUser!;
  late XFile _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    Size _height = MediaQuery.of(context).size;
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: widget.onMenuPressed,
            ),
          ),
          title: Text('Profile'),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
        ),
        floatingActionButton: FloatingActionButton.extended(
          elevation: 8.0,
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.black,
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => EditProfileForm()));
          },
          icon: Icon(Icons.edit, color: Colors.white),
          label: Text('Edit', style: TextStyle(color: Colors.white)),
        ),
        body: ConnectivityStatus(
          child: Column(
            children: <Widget>[
              SizedBox(height: _height.height * 0.02),
              Container(
                height: _height.height * 0.3,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Stack(
                        fit: StackFit.loose,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 140.0,
                                height: 140.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: _imageFile == null ? DecorationImage(
                                    image: AssetImage(
                                            'assets/images/_blankProfile.jpg',
                                          ),
                                    fit: BoxFit.cover,
                                  ) : DecorationImage(image: FileImage(
                                    File(_imageFile.path),
                                  )),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 90.0, right: 100.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundColor: kPrimaryColor,
                                  radius: 25.0,
                                  child: GestureDetector(
                                    child: Icon(
                                      Icons.camera_alt,
                                    ),
                                    onTap: () {
                                      showModalBottomSheet(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          context: context,
                                          builder: ((builder) =>
                                              bottomSheet()));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: _height.height * 0.02,
                    ),
                    TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            context: context,
                            builder: ((context) => SingleChildScrollView(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: NameBottomSheet(),
                                  ),
                                )));
                      },
                      child: Text(
                        user.displayName ?? '',
                        style: TextStyle(color: Colors.black, fontSize: 30),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: _height.height * 0.03,
              ),
              ProfileView(),
            ],
          ),
        ),
      ),
      onWillPop: onBackPressed,
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 20.0,
      ),
      child: Column(
        children: <Widget>[
          Text(
            'Choose Profile Photo',
            style: TextStyle(
              fontSize: 25.0,
              color: kPrimaryColor,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // ignore: deprecated_member_use
              IconButton(onPressed: (){
                takePhoto(ImageSource.camera);
              }, icon: Column(
                children: [
                  Icon(
                    Icons.camera_alt,
                    color: kPrimaryColor,
                  ),
                  Text('Camera')
                ],
              ),
              ),
              // ignore: deprecated_member_use
              IconButton(onPressed: (){
                takePhoto(ImageSource.gallery);
              }, icon: Column(
                children: [
                  Icon(
                    Icons.image,
                    color: kPrimaryColor,
                  ),
                  Text('Photos')
                ],
              ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile!;
    });
  }

  Future<bool> onBackPressed() {
    if (user.uid == "kspMRxCsY8ata5y018RSwtreovS2") {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return AdminDashboardScreen();
        },
      ), (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return UserDashboardScreen();
        },
      ), (route) => false);
    }
    return Future.value(true);
  }
}
