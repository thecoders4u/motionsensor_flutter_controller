import 'package:admin/constants.dart';
import 'package:admin/controllers/MenuController.dart';
import 'package:admin/homeparent.dart';
import 'package:admin/monitorparent.dart';
import 'package:admin/register.dart';
import 'package:admin/screens/dashbord/dashboard_screen.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:admin/settingsparent.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:admin/snack.dart';
import 'package:admin/register.dart';
import 'login.dart';
import 'splashy.dart';

void main() {
  runApp(MyApp());
}
class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EasySplashScreen(
          durationInSeconds: 3,
          logo: Image.asset('assets/images/logo.png'),
          title: Text(
            "G4SCam",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          showLoader: true,
          loadingText: Text("Loading"),
          navigator: RegisterScreen(),),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.black),
        canvasColor: secondaryColor,
      ),

    );
  }
}
