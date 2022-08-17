import 'dart:async';
import 'dart:convert';

import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_api/http_api.dart' as https;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher_student_interaction/detailedQuestion.dart';
import 'package:teacher_student_interaction/newQuestion.dart';
import 'cardStyle.dart';
import 'package:http/http.dart' as http;

// var a = ['homeScreen', 'searchScreen', ''];
String head = '';
String? token;
String desc = '';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    getToken();
    fetchQues();
    super.initState();
  }

  final url = 'http://192.168.1.8:5000/api/question';
  var _quesJson = [];

  getToken() async{
    final storage = FlutterSecureStorage();
    String? tkn=await storage.read(key: 'token');
    setState(() {
      token = tkn;
    });
    // print(token);
  }

  fetchQues() async {
    getToken().whenComplete(() async {
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
        print(response.body);
        setState(() {
          _quesJson = jsonData;
        });
      } catch (err) {
        print(err);
      }});
  }

  @override
  Widget build(BuildContext context) {
    // fetchQues();
    return Scaffold(
      // backgroundColor: const Color(0xFF193251),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        // physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _quesJson.length,
        itemBuilder: (BuildContext context, int index) {
          final ques = _quesJson[index];
          return CardStyle(
            onPressedQ: () {
              const DetailedQuestion().getHeadingDescription(
                  ques['heading'], ques['description'],ques['_id']);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DetailedQuestion()));
            },
            heading: ques['heading'],
            description: ques['description'],
          );
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
    );
  }
}
