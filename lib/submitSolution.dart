// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? heading;
String? solution ;
List<File> image = [];
String? token;
bool showSpinner = false;
String? userId;
String questionId = '';
var body;

class SubmitSolution extends StatefulWidget {
  void getQuesId(String qid) {
    questionId = qid;
  }

  const SubmitSolution({Key? key}) : super(key: key);

  @override
  State<SubmitSolution> createState() => _SubmitSolutionState();
}

class _SubmitSolutionState extends State<SubmitSolution> {
  getTokenId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      userId = prefs.getString('UserId');
    });
  }

  void _displaySuccessMotionToast() {
    MotionToast.success(
      title: const Text(
        'Congratulations',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      description: const Text(
        'Solution posted successfully',
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
      description: const Text('Some Error Occurred'),
      animationType: AnimationType.fromLeft,
      position: MotionToastPosition.top,
      dismissable: true,
    ).show(context);
  }

  postSolution(String? soltion) async {

      try {
        // print(soltion);
        // print(questionId);
        const url = 'http://192.168.1.8:5000/api/solution';
        Map<String, String> header = {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        };
        final response = await http.post(Uri.parse(url),
            headers: header,
            body: jsonEncode({"solution": soltion, "questionId": questionId}));
        body = jsonDecode(response.body);
        // print(response.statusCode);
        return (response.statusCode);
      } catch (err) {
        // print(err);
      }
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
  void initState() {
    // TODO: implement initState
  getTokenId();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Solution!'),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Material(
                  elevation: 20,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  // color: Colors.black,
                  child: TextField(
                      keyboardType: TextInputType.text,
                      // style: TextStyle(color: Colors.white),
                      minLines: 3,
                      textAlign: TextAlign.center,
                      maxLines: 7,
                      onChanged: (value) {
                        solution = value;
                      },
                      decoration: const InputDecoration(
                          hintText: 'Solution', border: InputBorder.none
                          // hintStyle: TextStyle(color: Colors.white),

                          )),
                ),
              ),
              // const SizedBox(height: 10,),
              SizedBox(
                width: 175,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(20),
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return SizedBox(
                              height: 100,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
                                        style: TextStyle(fontSize: 15),
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                          onPressed: () async {
                                            _openGallery(context);
                                          },
                                          icon: const Icon(
                                              FontAwesomeIcons.folder,
                                              size: 25)),
                                      const Text(
                                        'Open Gallery',
                                        style: TextStyle(fontSize: 15),
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
                                        setState(() {
                                          showDialog<String>(
                                            context: context,
                                            // false = user must tap button, true = tap outside dialog
                                            builder:
                                                (BuildContext dialogContext) {
                                              return AlertDialog(
                                                title:
                                                    const Text('Delete Image?'),
                                                content: const Text(
                                                    'Are you sure you want to delete the image?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('No'),
                                                    onPressed: () {
                                                      Navigator.of(
                                                              dialogContext)
                                                          .pop(); // Dismiss alert dialog
                                                    },
                                                  ),
                                                  TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          image.removeAt(index);
                                                          Navigator.of(
                                                                  dialogContext)
                                                              .pop();
                                                        });
                                                      },
                                                      child: const Text('Yes'))
                                                ],
                                              );
                                            },
                                          );
                                        });
                                      },
                                      style: ButtonStyle(
                                          elevation:
                                              MaterialStateProperty.all(20),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.transparent)),
                                      child: Image.file(image[index],
                                          fit: BoxFit.fitWidth),
                                    ),
                                  )
                                : const Text(
                                    'hello',
                                    style: TextStyle(fontSize: 40),
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
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 20,
        onPressed: () async {
          if(solution!=null) {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: const Text('Post Solution'),
                      content: const Text(
                          'Are you sure you want to post the Solution?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'No'),
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            setState(() {
                              showSpinner = true;
                            });
                            try {
                               var response =await postSolution(solution);
                              if (response == 200) {
                                _displaySuccessMotionToast();
                              } else {
                                _displayErrorMotionToast();
                                // print(response);
                              }
                              setState(() {
                                showSpinner = false;
                              });
                            } catch (err) {
                              _displayErrorMotionToast();
                              setState(() {
                                showSpinner = false;
                              });
                            }
                            image = [];
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    ));
          }
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
