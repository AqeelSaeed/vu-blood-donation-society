import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plasma_donor/Screens/AdminDashBoard/AdminDashboard_Screen.dart';
import 'package:plasma_donor/Screens/UserDashBoard/UserDashboard_Screen.dart';
import 'package:plasma_donor/providers/network_provider.dart';
import 'package:provider/provider.dart';
import 'Components/RegisterClassses.dart';
import 'Screens/Slider/getstarted_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  ClassBuilder.registerClasses();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? _user = FirebaseAuth.instance.currentUser;
  late Widget _firstWidget;

  @override
  void initState() {
    super.initState();
    if (_user != null) {
      _user!.uid == "FhfHklNx51e3wio9M2BSAdqYzv73"
          ? _firstWidget = AdminDashboardScreen()
          : _firstWidget = UserDashboardScreen();
    } else {
      _firstWidget = GetStartedScreen();
    }
  }

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
      ],
    );
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context)=> DataProvider())
        ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Plasma Donor',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
        ),
        home: _firstWidget,
      ),
    );
  }
}
