import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plasma_donor/models/admin_model.dart';

class DataProvider extends ChangeNotifier{
  AdminModel model = AdminModel();
  late String userName;
  bool isDataLoading = false;
  String userImage = '';

  void fetchAdminProfile(){
    isDataLoading = true;
    notifyListeners();
    CollectionReference getAllData = FirebaseFirestore.instance.collection('Profile');
    User user = FirebaseAuth.instance.currentUser!;

    getAllData.doc(user.uid).get().then((snapshot){
      log('snapshot: ${snapshot.data()}');
      if(snapshot.exists){
        model = AdminModel.fromJson(snapshot.data() as Map<String, dynamic>);
        userName = model.name ?? '';
      }

      isDataLoading = false;
      notifyListeners();
    });
  }

  void uploadImage(File imageFile){
    var imageName = DateTime.now().millisecondsSinceEpoch.toString();
    User user = FirebaseAuth.instance.currentUser!;
    CollectionReference addImage =
    FirebaseFirestore.instance.collection('Profile');
    var storageRef = FirebaseStorage.instance.ref("user-images/$imageName.jpg");
    storageRef.putFile(imageFile).then((file) async{
      var imageUrl = await storageRef.getDownloadURL();
      log('imageUrl: ${imageUrl.toString()}');
      user.updateProfile(photoURL: imageUrl);
      addImage.doc(user.uid).update({
        'user-image': imageUrl,
      });
      userImage = imageUrl;
      notifyListeners();
      Fluttertoast.showToast(
        msg: "Image Uploaded",
        gravity: ToastGravity.BOTTOM,
      );
    });
  }


}