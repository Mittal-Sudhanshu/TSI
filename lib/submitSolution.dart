// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher_student_interaction/loginScreen.dart';

String? heading;
String solution='';
List<File> image = [];
String? token;
String? userId;
String questionId='';
var body;
class SubmitSolution extends StatefulWidget {
  void getQuesId(String qid){
    questionId=qid;
  }
  const SubmitSolution({Key? key}) : super(key: key);

  @override
  State<SubmitSolution> createState() => _SubmitSolutionState();
}

class _SubmitSolutionState extends State<SubmitSolution> {
  getTokenId()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    setState(() {
      token=prefs.getString('token');
      userId=prefs.getString('UserId');
    });
  }
  postSolution(String soltion)async{
    getTokenId().whenComplete(()async{
      try{
        // print(soltion);
        print(questionId);
        final url='http://192.168.1.8:5000/api/solution';
        Map<String, String> header = {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        };
        final response= await http.post(Uri.parse(url),headers: header,body: jsonEncode(
            {"solution": soltion, "questionId":questionId}));
        body=jsonDecode(response.body);
        return (response.body);
      }
      catch(err){
        // print(err);
      }
    });
  }
  void _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().pickMultiImage(
        // source: ImageSource.gallery,
        );
    setState(
      () {
        for (int i = 0; i < pickedFile!.length; i++) {
          image.add(File(pickedFile[i].path));
        }
      },
    );

    Navigator.pop(context);
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    setState(
      () {
        File f = File(pickedFile!.path);
        image.add(f);
      },
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Solution!'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Material(
              elevation: 20,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              child:  TextField(
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Heading',
                    border: InputBorder.none,
                    // border: InputBorder.none,
                    contentPadding:
                         EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  )),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
           Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Material(
              elevation: 20,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              // color: Colors.black,
              child: TextField(
                  keyboardType: TextInputType.text,
                  // style: TextStyle(color: Colors.white),
                  minLines: 3,
                  textAlign: TextAlign.center,
                  maxLines: 7,
                  onChanged: (value){
                    solution=value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Solution',
                    border: InputBorder.none
                    // hintStyle: TextStyle(color: Colors.white),

                  )),
            ),
          ),
          // const SizedBox(height: 10,),
          SizedBox(
            width: 175,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
              child: ElevatedButton(
                style: ButtonStyle(elevation: MaterialStateProperty.all(20),),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        _openCamera(context);
                                      },
                                      icon: const Icon(
                                        FontAwesomeIcons.camera,
                                        // color: Colors.white,
                                        size: 25,
                                      )),
                                  const Text(
                                    'Open Camera',
                                    style: TextStyle(
                                     fontSize: 15),
                                  )
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        _openGallery(context);
                                      },
                                      icon: const Icon(FontAwesomeIcons.folder,
                                           size: 25)),
                                  const Text(
                                    'Open Gallery',
                                    style: TextStyle(
                                        fontSize: 15),
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      FontAwesomeIcons.camera,
                      // color: Colors.white,
                      size: 25,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Text('Add Image'),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 200,
            width: 400,
            child: image != []
                ? ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: image.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        alignment: Alignment.center,
                        // width: double.maxFinite,
                        height: 200,
                        child: image != []
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  onLongPress: () {
                                    setState((){
                                      showDialog<String>(
                                        context: context,
                                        // false = user must tap button, true = tap outside dialog
                                        builder: (BuildContext dialogContext) {
                                          return AlertDialog(
                                            title: const Text('Delete Image?'),
                                            content: const Text('Are you sure you want to delete the image?'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text('No'),
                                                onPressed: () {
                                                  Navigator.of(dialogContext)
                                                      .pop(); // Dismiss alert dialog
                                                },
                                              ),
                                              TextButton(onPressed: (){
                                                setState(() {

                                                  image.removeAt(index);
                                                  Navigator.of(dialogContext).pop();
                                                });
                                              }, child: const Text('Yes'))
                                            ],
                                          );
                                        },
                                      );
                                      AlertDialog(
                                        title:
                                            const Text('AlertDialog Title'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: const <Widget>[
                                              Text(
                                                  'This is a demo alert dialog.'),
                                              Text(
                                                  'Would you like to approve of this message?'),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Approve'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                                  },
                                  style: ButtonStyle(
                                    elevation: MaterialStateProperty.all(20),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.transparent)),
                                  child: Image.file(image[index],
                                      fit: BoxFit.fitWidth),
                                ),
                              )
                            : const Text(
                                'hello',
                                style: TextStyle(
                                     fontSize: 40),
                              ),
                      );
                    },
                  )
                : const Text(
                    '',
                    // style: TextStyle(color: Colors.white),
                  ),
          )
          //
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 20,
        onPressed: () async{
          try{
            var response=postSolution(solution);
            if(response==200){

            }
            else{
              // print(response);
            }
          }catch(err){
            // print(err);
          }
          image = [];
          // Navigator.pop(context);
        },
        label: const Text(
          'Post Solution',
          // style: TextStyle(color: Colors.white),
        ),
        // backgroundColor: Colors.black,
      ),
    );
  }
}
