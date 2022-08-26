// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:animated_gradient/animated_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:teacher_student_interaction/mainScreen.dart';
import 'package:teacher_student_interaction/registrationScreen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

var body;
String error='';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void _displaySuccessMotionToast() {
    MotionToast.success(
      title: const Text(
        'Login Successful',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      description: const Text(
        'You LoggedIn Successfully !',
        style: TextStyle(fontSize: 12),
      ),
      layoutOrientation: ToastOrientation.rtl,
      animationType: AnimationType.fromRight,
      dismissable: true,
    ).show(context);
  }
  void _displayErrorMotionToast() {
    MotionToast.error(
      title: const Text(
        'Error',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(error),
      animationType: AnimationType.fromLeft,
      position: MotionToastPosition.top,
      barrierColor: Colors.black.withOpacity(0.3),
      width: 300,
      height: 80,
      dismissable: true,
    ).show(context);
  }
  Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };

  Future<dynamic> postData(String email, String password) async {
    try {
      var response = await http.post(
          Uri.parse('https://tsi-backend.herokuapp.com/api/user/login'),
          headers: header,
          body: jsonEncode({"email": email, "password": password}));
      body = jsonDecode(response.body);
      // print(body);
      return (response.statusCode);
    } catch (e) {
      // print(e);
    }
  }

  String email = '';
  String password = '';
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradient(
        colors: [Color(0xFFe73c7e),Color(0xFF23a6d5),Color(0xFF23d5ab),Color(0xFFee7752)],
        child: SafeArea(
          child: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.,
              children: [
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Text(
                    'Please sign in to Continue',
                    style: TextStyle(
                      fontSize: 20,
                      // color: Colors.grey,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child:
                      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Material(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      elevation: 20,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.start,
                          onChanged: (value) {
                            email = value;
                          },
                          decoration: const InputDecoration(
                              hintText: 'Enter your Email',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(5),
                              hintStyle: TextStyle(),
                              icon: Icon(
                                Icons.email,
                              )),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Material(
                      elevation: 20,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          textAlign: TextAlign.start,
                          obscureText: true,
                          onChanged: (value) {
                            password = value;
                          },
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              //   hintStyle: TextStyle(color:Colors.black),
                              hintText: 'Enter your Password',
                              icon: Icon(Icons.lock)),
                          style: const TextStyle(
                              // color:Colors.white
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all<double>(20)),
                        onPressed: () async {
                          setState(() {
                            showSpinner = true;
                          });
                          try {
                            var response = await postData(email, password);
                            if (response == 201) {
                              final prefs = await SharedPreferences.getInstance();
                              final storage =  FlutterSecureStorage();
                              await storage.write(key: 'token', value: body['token']);
                              prefs.setString('email', email);
                              prefs.setString('name', body['name']);
                              prefs.setString('token', body['token']);
                              prefs.setString('UserId', body['_id']);
                              _displaySuccessMotionToast();
                              Timer(Duration(seconds: 2), () {Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MainScreen()));});

                            } else {
                              // print(response);
                              setState(() {
                                error=body['error'];
                              });
                              _displayErrorMotionToast();
                            }
                            setState(() {
                              showSpinner = false;
                            });
                          } catch (e) {
                            setState(() {
                              showSpinner = false;
                            });
                            // print(e);
                          }
                        },
                        child: Row(
                            children: const [Icon(Icons.forward), Text('Login')]),
                      ),
                    ),
                    Row(
                      children: [
                        const Text(
                          'Don\'t have an Account?',
                          style: TextStyle(fontSize: 15),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RegistrationScreen()));
                            },
                            child: const Text(
                              'Sign up!',
                              style: TextStyle(fontSize: 15,color:Colors.black54),
                            ))
                      ],
                    )
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
