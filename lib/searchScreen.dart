import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:teacher_student_interaction/cardStyle.dart';
import 'package:teacher_student_interaction/detailedQuestion.dart';

String? searchText;
var _jsonData = [];
bool showSpinner = false;
String? token;
var names=[];
String? error;

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  void _displayErrorMotionToast() {
    MotionToast.error(
      title: const Text(
        'Error',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(error!),
      animationType: AnimationType.fromLeft,
      position: MotionToastPosition.top,
      dismissable: true,
    ).show(context);
  }

  getSearchResults() async {
    setState(() {
      showSpinner = true;
    });
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
      String url = 'https://tsi-backend.herokuapp.com/api/question?search=$searchText';
      try {
        final response = await http.get(Uri.parse(url), headers: headers);
        final jsonData = jsonDecode(response.body) as List;
        var namee=[];
        jsonData.forEach((element) {
          Map obj = element;
          Map user = obj['user'];
          String name = user['name'];
          namee.add(name);
        });
        setState(() {
          showSpinner = false;
          _jsonData = jsonData;
          names=namee;
        });
        // print(response.body);
        return response.statusCode;
      } catch (err) {
        print(err);
      }
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
    // print(token);
  }

  @override
  void initState() {
    getToken();
    _jsonData=[];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(title: const Text('Search your Query here'),
        centerTitle: true,),
        // backgroundColor: const Color(0xFF193251),
        body: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Material(
                    elevation: 20,
                    borderRadius: BorderRadius.circular(5),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                          // color:Colors.white
                          ),
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        searchText = value;
                      },
                      decoration: const InputDecoration(
                          hintText: 'Search', border: InputBorder.none),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                      style: ButtonStyle(elevation: MaterialStateProperty.all(20)),
                      onPressed: () {
                        //implement search on backend
                        if (searchText != null) {
                          getSearchResults().whenComplete((){
                            if(_jsonData.isEmpty) {
                              setState(() {
                                error = 'No results matching your query exists';
                              });
                              _displayErrorMotionToast();
                            }
                          });

                        } else {
                          setState(() {
                            error = 'Search Field Can\'t be empty';
                          });
                          _displayErrorMotionToast();
                        }

                        // Navigator.pushNamed(context, 'homeScreen');
                      },
                      child: SizedBox(
                        width: 75,
                        child: Row(
                          children: const [
                            Icon(Icons.search),
                            Text('Search'),
                          ],
                        ),
                      )),
                ),

              ],
            ),
            ListView.builder(
                itemCount: _jsonData.length,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  final ques = _jsonData[index];

                  return CardStyle(
                      onPressedQ: () {
                        const DetailedQuestion().getHeadingDescription(
                            ques['heading'], ques['description'], ques['_id'],names[index],ques['image']);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const DetailedQuestion()));
                      },
                      heading: ques['heading'],
                      description: ques['description'],
                  name: names[index],);
                }),
          ],
        ),
      ),
    );
  }
}
