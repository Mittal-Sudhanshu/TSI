import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:teacher_student_interaction/cardStyle.dart';
import 'package:teacher_student_interaction/detailedQuestion.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
String name=' ';
String? token;
bool showSpinner=false;
String url='https://tsi-backend.herokuapp.com/api/question/yourquestion';
var _quesJson=[];
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStringValue();
  }
  getStringValue()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    setState(() {
      name=prefs.getString('name')!;
      token=prefs.getString('token');
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(title: const Text('Your Profile'),centerTitle: true,),
      // backgroundColor: const Color(0xFF193251),
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                color: Colors.grey,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              minRadius: 30,
                              child: Text(
                                name[0],
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                            SizedBox(child: Text(name)),
                          ],
                        ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ButtonStyle(

                      elevation: MaterialStateProperty.all(20)),
                    onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>const MyQuestions() ));
                    }, child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                  Text('My Questions'),Icon(Icons.arrow_right)
                ],)),
              )
            ],
          )
        ],
      ),
    );
  }
}
class MyQuestions extends StatefulWidget {
  const MyQuestions({Key? key}) : super(key: key);

  @override
  State<MyQuestions> createState() => _MyQuestionsState();
}
var names=[];

class _MyQuestionsState extends State<MyQuestions> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStringValue();
    fetchQues();
  }
  getStringValue()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    setState(() {
      token=prefs.getString('token');
    });
  }
  fetchQues() async {
    setState(() {
      showSpinner=true;
    });
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
      final jsonData = jsonDecode(response.body) as List;
      var namee = [];
      jsonData.forEach((element) {
        Map obj = element;
        Map user = obj['user'];
        String name = user['name'];
        namee.add(name);
      });

      // print(response.body);
      setState(() {
        showSpinner=false;
        _quesJson = jsonData;
        _quesJson=List.from(_quesJson.reversed);
        names=namee;
      });
    } catch (err) {
      setState(() {
        showSpinner=false;

      });
      // print(err);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Questions'),
      ),
      body:ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: ListView.builder( scrollDirection: Axis.vertical,
            // physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _quesJson.length,
            itemBuilder: (BuildContext context, int index) {
              final ques = _quesJson[index];
              return CardStyle(
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
                name: names[index],
              );
            },),
      ),
    );
  }
}
