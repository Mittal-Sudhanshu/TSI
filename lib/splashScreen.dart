import 'dart:async';


import 'package:flutter/material.dart';
import 'package:animated_gradient/animated_gradient.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:circular_image/circular_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher_student_interaction/loginScreen.dart';
import 'package:teacher_student_interaction/mainScreen.dart';

String? finalEmail;
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEmail();
    // Timer(Duration(seconds: 3),_navigateToHome);
  }

  _navigateToHome() async {
    getEmail().whenComplete(() async {
      if (finalEmail == null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainScreen()));
      }
    });
  }

  Future getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final obtainedEmail = prefs.get('email');
    setState(() {
      finalEmail = obtainedEmail as String?;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: Colors.white,
      splash: AnimatedGradient(
        colors: const [Color(0xFFe73c7e),Color(0xFF23a6d5),Color(0xFF23d5ab),Color(0xFFee7752)],

        // primaryColors: [Color(0xFFee7752),Color(0xFF23a6d5)],
        // secondaryColors: [Color(0xFFe73c7e),Color(0xFF23d5ab)],
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,

            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(

                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(child: CircularImage(radius: 150, source: 'images/lo.png',),),
                      const SizedBox(
                        height: 20,
                      ),
                      const Center(
                        child: Text(
                          'Indian Institute of Information Technology,Ranchi',
                          style: TextStyle(color: Colors.white, fontSize: 17,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 250,)
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text('Made with ❤️ by Sudhanshu Mittal'),
              )
            ],
          ),
        ),
      ),
      nextScreen: finalEmail==null?const LoginScreen():const MainScreen(),
      splashIconSize: 1000,


      duration: 5000,
    );
  }
}
//
