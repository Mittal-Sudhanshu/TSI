import 'dart:async';
import 'dart:convert';

import 'package:animated_gradient/animated_gradient.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:teacher_student_interaction/loginScreen.dart';
import 'package:teacher_student_interaction/mainScreen.dart';
String Email='';
String Password='';
String Name='';
int otp=0;
bool showSpinner=false;
String error='';
var body;
class OTP extends StatefulWidget {
  const OTP({Key? key}) : super(key: key);
  @override
  State<OTP> createState() => _OTPState();
  void getData(String email,String name,String password){
    Email=email;
    Password=password;
    Name=name;
  }
}

class _OTPState extends State<OTP> {

  Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };
  Future<dynamic> resendOTP(String name, String email, String password) async {
    try {
      var response = await http.post(
          Uri.parse('http://192.168.1.8:5000/api/user/'),
          headers: header,
          body:
          jsonEncode({"name": name, "email": email, "password": password}));

      // print(response.body);
      return (response.statusCode);
    } catch (e) {
      // print(e);
    }
  }
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

  Future<dynamic> checkOTP(int otp) async {
    try {
      var response = await http.post(
          Uri.parse('http://192.168.1.8:5000/api/user/validate/'),
          headers: header,
          body:
          jsonEncode({ "userOTP": otp}));
      body=jsonDecode(response.body);
      // print(response.body);
      return (response.statusCode);
    } catch (e) {
      // print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        body: AnimatedGradient(
          colors: [Color(0xFFe73c7e),Color(0xFF23a6d5),Color(0xFF23d5ab),Color(0xFFee7752)],
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'You\'re almost there!',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Enter OTP sent to your Mail!',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children:  [
                       Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 10),
                        child: Material(
                          elevation: 15,
                          child: TextField(
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            onChanged: (value){
                              otp=int.parse(value);
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter OTP',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(onPressed: ()async{
                              setState(() {
                                showSpinner=true;
                              });
                              try {
                                var response;

                                response = await resendOTP(Name, Email, Password);
                                if (response == 200) {
                                  // print(response);
                                } else {
                                  // print(response);
                                }
                                setState(() {
                                  showSpinner=false;
                                });
                              } catch (e) {
                                setState(() {
                                  showSpinner=false;
                                });
                                // print(e);
                              }
                            }, child: Text('Resend OTP')),
                            TextButton(onPressed: (){Navigator.pop(context);}, child: Text('Incorrect Email?')),
                          ],
                        )
                      )
                    ]),
                Center(child: ElevatedButton(onPressed: ()async{
                  try{
                    var response;
                    response=await checkOTP(otp);
                    if(response==201){
                      _displaySuccessMotionToast();
                      Timer(Duration(seconds: 3), () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen())); });
                    }
                    else{
                      setState(() {
                        error=body['error'];
                      });
                      _displayErrorMotionToast();
                    }
                  }catch(e){
                    // print(e);
                  }
                }, child: Text('Submit'),style:ButtonStyle(elevation: MaterialStateProperty.all(20)) ,))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
