class UserModel {
  String? uid;
  String? name;
  String? email;
  String? gender;
  String? bloodGroup;
  String? location;
  String? phoneNumber;
  bool? isActive;
  bool? isRejected;
  bool? isVerified;
  String? userType;

  // Constructor
  UserModel({
    this.uid,
    this.name,
    this.email,
    this.gender,
    this.bloodGroup,
    this.location,
    this.phoneNumber,
    this.isActive,
    this.isRejected,
    this.isVerified,
    this.userType,
  });

  // Factory method to create a UserModel from Firestore data
  factory UserModel.fromFirestore(Map<String, dynamic> firestoreData) {
    return UserModel(
      uid: firestoreData['uid'],
      name: firestoreData['name'],
      email: firestoreData['email'],
      gender: firestoreData['gender'],
      bloodGroup: firestoreData['bloodGroup'],
      location: firestoreData['location'],
      phoneNumber: firestoreData['phoneNumber'],
      isActive: firestoreData['isActive'],
      isRejected: firestoreData['isRejected'],
      isVerified: firestoreData['isVerified'],
      userType: firestoreData['userType'],
    );
  }

  // Method to convert a UserModel instance to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'location': location,
      'phoneNumber': phoneNumber,
      'isActive': isActive,
      'isRejected': isRejected,
      'isVerified': isVerified,
      'userType': userType,
    };
  }
}
