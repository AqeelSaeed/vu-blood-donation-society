import 'package:plasma_donor/Screens/About/about_screen.dart';
import 'package:plasma_donor/Screens/AddDonor/adddonor_screen.dart';
import 'package:plasma_donor/Screens/AdminDashBoard/components/AdminHomeScreen.dart';
import 'package:plasma_donor/Screens/Profile/profile_screen.dart';
import 'package:plasma_donor/Screens/Setting/setting_screen.dart';
import 'package:plasma_donor/Screens/UserDashBoard/components/UserHomeScreen.dart';

typedef T Constructor<T>();

final Map<String, Constructor<Object>> _constructors =
    <String, Constructor<Object>>{};

void register<T>(Constructor<T> constructor) {
  _constructors[T.toString()] = constructor as Constructor<Object>;
}

class ClassBuilder {
  static void registerClasses() {
    register<ProfileScreen>(() => ProfileScreen());
    register<AdminHomeScreen>(() => AdminHomeScreen());
    register<UserHomeScreen>(() => UserHomeScreen());
    register<AddDonorScreen>(() => AddDonorScreen());
    register<SettingScreen>(() => SettingScreen());
    register<AboutScreen>(() => AboutScreen());
  }

  static dynamic fromString(String type) {
    return _constructors[type]!();
  }
}
