import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:teacher_student_interaction/otpInput.dart';
import 'package:teacher_student_interaction/homeScreen.dart';
import 'package:teacher_student_interaction/loginScreen.dart';
import 'package:teacher_student_interaction/mainScreen.dart';
import 'package:teacher_student_interaction/registrationScreen.dart';
import 'package:teacher_student_interaction/searchScreen.dart';
import 'package:teacher_student_interaction/splashScreen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:teacher_student_interaction/themeClass.dart';

bool permissionGranted=false;
bool cameraPermission=false;
void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  Future _getStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      setState(() {
        permissionGranted = true;
      });
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      setState(() {
        permissionGranted = false;
      });
    }
  }
  Future _getCameraPermission() async{
    if(await Permission.camera.request().isGranted){
      setState(() {
        cameraPermission=true;
      });
    }
    else if(await Permission.camera.request().isPermanentlyDenied){
      await openAppSettings();
    }else if(await Permission.camera.request().isDenied){
      setState(() {
        cameraPermission=false;
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getStoragePermission();
    _getCameraPermission();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: ThemeClass.lightTheme,
      darkTheme: ThemeClass.darkTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: 'splashScreen',
      routes: {
        'mainScreen': (context) => const MainScreen(),
        'registrationScreen': (context) => const RegistrationScreen(),
        'homeScreen': (context) => const HomeScreen(),
        'splashScreen': (context) => const SplashScreen(),
        'loginScreen': (context) => const LoginScreen(),
        'otpScreen':(context)=>const OTP(),
        'searchScreen': (context) => const SearchScreen()
      },
    );
  }
}
