// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:animated_gradient/animated_gradient.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:motion_toast/motion_toast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:teacher_student_interaction/otpInput.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  void _displaySuccessMotionToast() {
    MotionToast.success(
      title: const Text(
        'OTP',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      description: const Text(
        'OTP sent successfully !',
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
      dismissable: false,
    ).show(context);
  }
  Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };

  Future<dynamic> postData(String name, String email, String password) async {
    try {
      var response = await http.post(
          Uri.parse('http://192.168.1.8:5000/api/user/'),
          headers: header,
          body:
              jsonEncode({"name": name, "email": email, "password": password}));
      if(response.statusCode!=200){
        body=jsonDecode(response.body);
      }
      return (response.statusCode);
    } catch (e) {
      // print(e);
    }
  }

  String email = '';
  String password = '';
  String name = '';
  List<String> mail=[];
  var body;
  bool showSpinner = false;
  String error='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      body: AnimatedGradient(
        colors: const [Color(0xFFe73c7e),Color(0xFF23a6d5),Color(0xFF23d5ab),Color(0xFFee7752)],
        child: SafeArea(
          child: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Hello!',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Welcome Aboard',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Ask Your Doubts by Signing up!',
                      style: TextStyle(fontSize: 20,),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Material(
                        elevation: 20,
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            keyboardType: TextInputType.name,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              name = value;
                            },
                            // style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                //   hintStyle: TextStyle(color:Colors.black),
                                hintText: 'Enter your Name',
                                icon: Icon(Icons.person)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Material(
                        elevation: 20,
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              email = value;
                            },
                            // style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                //   hintStyle: TextStyle(color:Colors.black),
                                hintText: 'Enter your Email',
                                icon: Icon(Icons.email)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Material(
                        elevation: 20,
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            textAlign: TextAlign.center,
                            obscureText: true,
                            onChanged: (value) {
                              password = value;
                            },
                            // style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                //   hintStyle: TextStyle(color:Colors.black),
                                hintText: 'Enter your Password',
                                icon: Icon(Icons.lock)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24.0,
                      ),
                      Column(children: [
                        ElevatedButton(
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.all<double>(20)),
                            onPressed: () async {
                              mail=email.split('@');
                              setState(() {
                                if (name.isNotEmpty ||
                                    email.isNotEmpty ||
                                    password.isNotEmpty) {
                                  showSpinner = true;
                                }
                              });
                              try {
                                var response;
                                if(mail[1]=='iiitranchi.ac.in') {
                                  response = await postData(name, email, password);
                                  if (response == 200) {
                                    // print(response);

                                    _displaySuccessMotionToast();

                                    Timer(const Duration(seconds: 3),(){const OTP().getData(email,name,password);Navigator.pushNamed(context, 'otpScreen');});
                                  } else if(response==400) {
                                    setState(() {
                                      error=body['error'];
                                    });
                                    _displayErrorMotionToast();
                                    // print(response);
                                  }else{
                                    // print('internal server error');
                                  }
                                  setState(() {
                                    showSpinner = false;
                                  });
                                }
                                else{
                                  setState(() {
                                    error='Signup with college id only';
                                    showSpinner = false;
                                  });
                                  _displayErrorMotionToast();
                                }
                              } catch (e) {
                                // print(e);
                              }
                            },
                            child: SizedBox(
                              width: 100,
                              child: Row(
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.password),
                                  ),
                                  Text('Get OTP'),
                                ],
                              ),
                            ))
                      ]),
                      Row(
                        children: <Widget>[
                          const Text('Already have an account?'),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Sign in!',style: TextStyle(color: Colors.black54),))
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
