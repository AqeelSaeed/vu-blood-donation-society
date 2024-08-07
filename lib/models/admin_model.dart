/// User model class
class AdminModel {
  String? uid;
  String? phoneNumber;
  String? name;
  String? about;
  String? bloodGroup;
  String? gender;
  String? location;
  List<String>? searchIndex;
  String? userImage;

  /// Constructor
  AdminModel({
    this.uid,
    this.phoneNumber,
    this.name,
    this.about,
    this.bloodGroup,
    this.gender,
    this.location,
    this.searchIndex,
    this.userImage,
  });

  /// Encoder
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'phoneNumber': phoneNumber ?? '',
      'about': about ?? '',
      'name': name ?? '',
      'bloodGroup': bloodGroup ?? '',
      'gender': gender ?? '',
      'location': location ?? '',
      'searchIndex': searchIndex ?? [],
      'user-image': userImage ?? '',
    };
  }

  /// Decoder
  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      uid: json['uid'],
      phoneNumber: json['phoneNumber'],
      name: json['name'],
      about: json['about'],
      bloodGroup: json['bloodGroup'],
      gender: json['gender'],
      location: json['location'],
      searchIndex: json['searchIndex'].cast<String>(),
      userImage: json['user-image'],
    );
  }
}