import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:plasma_donor/Components/ConnectivityStatus.dart';
import 'package:plasma_donor/Components/constants.dart';
import 'package:plasma_donor/Screens/AdminDashBoard/admin_dashboard_screen.dart';
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
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    Size _height = MediaQuery.of(context).size;
    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.menu,
                color: kWhiteColor,
              ),
              onPressed: widget.onMenuPressed,
            ),
          ),
          title: Text(
            'Profile',
            style: TextStyle(color: kWhiteColor),
          ),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
        ),
        floatingActionButton: FloatingActionButton.extended(
          elevation: 8.0,
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.black,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => EditProfileForm()));
          },
          icon: Icon(Icons.edit, color: Colors.white),
          label: Text('Edit', style: TextStyle(color: Colors.white)),
        ),
        body: ConnectivityStatus(
          // fetching user data from firebase with stream builder
          // fetching data from firebase
          child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Profile')
                  .doc(user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: kPrimaryColor,
                      strokeCap: StrokeCap.round,
                    ),
                  );
                }
                final data = snapshot.data!.data() as Map<String, dynamic>?;
                return Column(
                  children: <Widget>[
                    // SizedBox(height: _height.height * 0.02),
                    Container(
                      // height: _height.height * 0.3,
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
                                    _imageFile == null
                                        ? Container(
                                            width: 140.0,
                                            height: 140.0,
                                            decoration: data!['user-image'] !=
                                                    null
                                                ? BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          snapshot.data![
                                                              'user-image']),
                                                      fit: BoxFit.cover,
                                                    ))
                                                : BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            'assets/images/_blankProfile.jpg'),
                                                        fit: BoxFit.cover)),
                                          )
                                        : Container(
                                            width: 140.0,
                                            height: 140.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: FileImage(
                                                    File(_imageFile!.path
                                                        .toString()),
                                                  ),
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 90.0, right: 100.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      CircleAvatar(
                                        backgroundColor: kPrimaryColor,
                                        radius: 25.0,
                                        child: GestureDetector(
                                          child: Icon(
                                            Icons.camera_alt,
                                            color: kWhiteColor,
                                          ),
                                          onTap: () {
                                            showModalBottomSheet(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
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
                          // SizedBox(
                          //   height: _height.height * 0.02,
                          // ),
                          Text(
                            snapshot.data!['name'] ?? '',
                            style: TextStyle(color: Colors.black, fontSize: 30),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: _height.height * 0.03,
                    ),
                    ProfileView(
                      phoneNumber: snapshot.data!['phoneNumber'],
                      about: snapshot.data!['about'],
                      bloodGroup: snapshot.data!['bloodGroup'],
                      gender: snapshot.data!['gender'],
                      location: snapshot.data!['location'],
                    ),
                  ],
                );
              }),
        ),
      ),
      onWillPop: onBackPressed,
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 120.0,
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // ignore: deprecated_member_use
              IconButton(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                style: IconButton.styleFrom(
                    backgroundColor: kPrimaryColor.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                icon: Column(
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
              IconButton(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                style: IconButton.styleFrom(
                    backgroundColor: kPrimaryColor.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                icon: Column(
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
    //pick image from gallery or camera and then upload to firebase.

    var imageName = DateTime.now().millisecondsSinceEpoch.toString();
    final storageRef =
        FirebaseStorage.instance.ref('user-images/$imageName.jpg');
    CollectionReference addImage =
        FirebaseFirestore.instance.collection('Profile');

    final pickedFile = await _picker.pickImage(
      source: source,
    );

    setState(() {
      _imageFile = File(pickedFile!.path.toString());
      storageRef.putFile(File(_imageFile!.path.toString())).then((value) async {
        log('firebaseMessage: ${value.toString()}');
        var imageUrl = await storageRef.getDownloadURL();
        log('imageUrl: ${imageUrl.toString()}');
        user.updateProfile(photoURL: imageUrl);
        addImage.doc(user.uid).update({
          'user-image': imageUrl,
        });
        _imageFile = null;
        Fluttertoast.showToast(msg: 'Image Uploaded Successfully');
      });
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
