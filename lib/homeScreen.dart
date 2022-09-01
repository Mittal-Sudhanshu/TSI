// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher_student_interaction/detailedQuestion.dart';
import 'package:teacher_student_interaction/loginScreen.dart';
import 'package:teacher_student_interaction/newQuestion.dart';
import 'cardStyle.dart';
import 'package:http/http.dart' as http;

// var a = ['homeScreen', 'searchScreen', ''];
String head = '';
String? token;
bool showSpinner=false;
var names=[];
String e='';
String desc = '';
String url = 'https://tsi-backend.herokuapp.com/api/question';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    _quesJson=[];
    e='';
    getToken();
    fetchQues();
    super.initState();
  }


  var _quesJson = [];

  getToken() async{
    const storage = FlutterSecureStorage();
    String? tkn=await storage.read(key: 'token');
    setState(() {
      token = tkn;
    });
    // print(token);
  }

  fetchQues() async {
    setState(() {
      showSpinner=true;
    });
    getToken().whenComplete(() async{
      try {
        Map<String, String> header = {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        };
        // var dio;
        // dio.interceptors.add(DioCacheManager(CacheConfig(baseUrl: "http://www.google.com")).interceptor);
        final response = await http.get(Uri.parse(url), headers: header);
        // final resp=dio.post(url,he)
        var namee = [];
        final jsonData = jsonDecode(response.body) as List;
        jsonData.forEach((element) {
          Map obj = element;
          Map user = obj['user'];
          String name = user['name'];
          namee.add(name);
        });
        // print(response.body);
        setState(() {
          showSpinner = false;
          _quesJson = jsonData;
          if(_quesJson.isEmpty){
            e='No question exits currently';
          }
          names = namee;
          _quesJson = List.from(_quesJson.reversed);
          names = List.from(names.reversed);
        });
      } catch (err) {
        setState(() {
          if(this.mounted)
            showSpinner = false;
        });
        // print(err);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // fetchQues();
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        drawer: Drawer(
          // backgroundColor: const Color(0xFF193251),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(children: [
                    ListTile(
                      leading: const Icon(Icons.all_inclusive),
                      title: const Text(' All '),
                      onTap: (){
                        setState(() {
                          url='https://tsi-backend.herokuapp.com/api/question';
                          fetchQues();
                        });

                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.home_filled,
                        // color: Colors.white,
                      ),
                      title: const Text(
                        ' Hostel ',
                        // style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        setState(() {
                          url='https://tsi-backend.herokuapp.com/api/question/Hostel';
                          fetchQues();
                        });
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.book_outlined,
                        // color: Colors.white,
                      ),
                      title: const Text(
                        ' Academic ',
                        // style: TextStyle(color: Colors.white)
                      ),
                      onTap: () {

                        setState(() {
                          url='https://tsi-backend.herokuapp.com/api/question/Academic';
                          fetchQues();
                        });
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.school,
                        // color: Colors.white,
                      ),
                      title: const Text(' Scholarships ', style: TextStyle()),
                      onTap: () {
                        setState(() {
                          url='https://tsi-backend.herokuapp.com/api/question/Scholarshpis';
                          fetchQues();
                        });
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.food_bank,
                        // color: Colors.white,
                      ),
                      title: const Text(' Mess ', style: TextStyle()),
                      onTap: () {
                        setState(() {
                          url='https://tsi-backend.herokuapp.com/api/question/Mess';
                          fetchQues();
                        });
                        Navigator.pop(context);
                      },
                    ),ListTile(
                      leading: const Icon(
                        Icons.code,
                        // color: Colors.white,
                      ),
                      title: const Text(' Programming ', style: TextStyle()),
                      onTap: () {
                        setState(() {
                          url='https://tsi-backend.herokuapp.com/api/question/Programming';
                          fetchQues();
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ]),
                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                      // color: Colors.white,
                    ),
                    title: const Text('LogOut', style: TextStyle()),
                    onTap: () async {
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Logout'),
                            content: const Text('Are You Sure You Want to Logout?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'No'),
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  final prefs =
                                  await SharedPreferences.getInstance();
                                  const storage = FlutterSecureStorage();
                                  prefs.remove('email');
                                  storage.deleteAll();
                                  prefs.remove('name');
                                  prefs.remove('token');
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return const LoginScreen();
                                          }));
                                },
                                child: const Text('Yes'),
                              ),
                            ],
                          ));
                    },
                  ),
                ],
              ),
            )),
        appBar: AppBar(
          centerTitle: true,
          // backgroundColor: const Color(0xFF193251),
          title: const Text('Questions'),
        ),
        // backgroundColor: const Color(0xFF193251),
        body: ListView.builder(
          scrollDirection: Axis.vertical,
          // physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _quesJson.isNotEmpty?_quesJson.length:1,
          itemBuilder: (BuildContext context, int index) {
            var ques;
            if(_quesJson.isNotEmpty) {
              ques = _quesJson[index];
            }
            return _quesJson.isNotEmpty?CardStyle(
              onPressedQ: () {
                const DetailedQuestion().getHeadingDescription(
                    ques['heading'], ques['description'],ques['_id'],names[index],ques['image']);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DetailedQuestion()));
              },
              heading: ques['heading'],
              description: ques['description'],
              category: ques['category'],
              name:names[index]
            ): Center(child: Text(e,style: const TextStyle(fontSize: 20),),);
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const NewQuestion()));
          },
          // backgroundColor: Colors.black,
          icon: const Icon(
            Icons.add,
            // color: Colors.white,
          ),
          label: const Text('Add Question'),
        ),
      ),
    );
  }
}
