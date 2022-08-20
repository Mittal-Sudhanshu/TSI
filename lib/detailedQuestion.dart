import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:teacher_student_interaction/detailedSolution.dart';
import 'package:teacher_student_interaction/submitSolution.dart';
import 'cardStyle.dart';
import 'package:http/http.dart' as http;


class DetailedQuestion extends StatefulWidget {
  const DetailedQuestion({Key? key}) : super(key: key);

  @override
  State<DetailedQuestion> createState() => _DetailedQuestionState();
  void getHeadingDescription(String head, String desc,String id) {
    heading = head;
    description = desc;
    quesId=id;
  }
}

String  heading = '';
String description = '';
String quesId='';
String? token;
var _soljson=[];
class _DetailedQuestionState extends State<DetailedQuestion> {
  getToken() async{
    final storage = FlutterSecureStorage();
    String? tkn=await storage.read(key: 'token');
    setState(() {
      token = tkn;
    });
    // print(token);
  }
  Future getQuestions()async{
    getToken().whenComplete(()async{
      final url='http://192.168.1.8:5000/api/solution/$quesId';
      try{
        Map<String, String> header = {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        };
        final response=await http.get(Uri.parse(url),headers: header);
        final jsonData=jsonDecode(response.body) as List;
        // print(response.body);
        setState(() {
          _soljson=jsonData;
        });
      }catch(err){
        // print(err);
      }
    });
  }
  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    getToken();
    getQuestions();
    return Scaffold(
      // backgroundColor: const Color(0xFF193251),
      appBar: AppBar(
        title: const Text('Detailed Question'),
        centerTitle: true,
        // backgroundColor: const Color(0xFF193251),
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                heading,
                style: const TextStyle(
                    // color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                description,
                style: const TextStyle( fontSize: 17,
                )),
              TextButton(
                onPressed: () {
                  const SubmitSolution().getQuesId(quesId);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const SubmitSolution()));
                },
                child: const Text('Submit Solution!'),
              ),
              const Center(
                child: Text('Solutions',
                style: TextStyle(fontSize: 20,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,),),
              ),
              ListView.builder(
                scrollDirection: Axis.vertical,
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: _soljson.length,
                itemBuilder: (BuildContext context, int index) {
                  final soln=_soljson[index];
                  return CardStyle(onPressedQ: (){
                    const DetailedSolution().getSolution(soln['solution']);
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>DetailedSolution()));
                  },heading:null ,description: soln['solution'],);
                },
              )
            ],
          ),
        ),
      ]),
    );
  }
}
