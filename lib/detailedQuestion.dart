import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:teacher_student_interaction/detailedSolution.dart';
import 'package:teacher_student_interaction/submitSolution.dart';
import 'cardStyle.dart';
import 'package:http/http.dart' as http;

class DetailedQuestion extends StatefulWidget {
  const DetailedQuestion({Key? key}) : super(key: key);

  @override
  State<DetailedQuestion> createState() => _DetailedQuestionState();
  void getHeadingDescription(String head, String desc, String id, String na,String imgUrl) {
    heading = head;
    description = desc;
    quesId = id;
    imageUrl=imgUrl;
    name = na;
  }
}

String heading = '';
String imageUrl='';
String name = '';
String description = '';
String quesId = '';
var names = [];
bool showSpinner=false;
String? token;
var _soljson = [];

class _DetailedQuestionState extends State<DetailedQuestion> {
  getToken() async {
    final storage = FlutterSecureStorage();
    String? tkn = await storage.read(key: 'token');
    setState(() {
      token = tkn;
    });
    // print(token);
    // print(quesId);
  }

  Future getQuestions() async {
    getToken().whenComplete(() async {
      setState(() {
        showSpinner=true;
      });
      final url = 'https://tsi-backend.herokuapp.com/api/solution/$quesId';
      // print(url);
      try {
        Map<String, String> header = {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        };
        final response = await http.get(Uri.parse(url), headers: header);
        final jsonData = jsonDecode(response.body) as List;
        var namee = [];
        jsonData.forEach((element) {
          Map obj = element;
          Map user = obj['sender'];
          String name = user['name'];
          namee.add(name);
        });
        // print(response.body);
        setState(() {
          _soljson = jsonData;
          showSpinner=false;
          names = namee;
        });
      } catch (err) {
        // print(err);
      }
    });
  }

  @override
  void initState() {
    _soljson=[];
    getQuestions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFF193251),
      appBar: AppBar(
        title: const Text('Detailed Question'),
        centerTitle: true,
        // backgroundColor: const Color(0xFF193251),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: ListView(children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                child: CircleAvatar(
                  minRadius: 15,
                  child: Text(
                    name[0],
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ),
              SizedBox(child: Text(name)),
            ],
          ),
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
                Text(description,
                    style: const TextStyle(
                      fontSize: 17,
                    )),
                Padding(padding: EdgeInsets.fromLTRB(0,5,0,0),child: imageUrl!=''?Center(child: SizedBox(height: 200,width: double.infinity,child: Image.network(imageUrl))):null,),
                TextButton(
                  onPressed: () {
                    const SubmitSolution().getQuesId(quesId);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SubmitSolution()));
                  },
                  child: const Text('Submit Solution!'),
                ),

                const Center(
                  child: Text(
                    'Solutions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _soljson.length,
                  itemBuilder: (BuildContext context, int index) {
                    final soln = _soljson[index];
                    return SolutionCard(
                      onPressedQ: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    DetailedSolution(
                                      head: heading,
                                      desc: description,
                                      sender: name,
                                      questionUrl: imageUrl,
                                      imageUrl: soln['image'],
                                      solver: names[index],
                                      solution: soln['solution'],
                                    )));
                      },
                      description: soln['solution'],
                      name: names[index],
                    );
                  },
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
