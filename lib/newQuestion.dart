// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:dio/dio.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher_student_interaction/homeScreen.dart';

String? heading ;
String? description ;
int length = 0;
String? token;
bool showSpinner = false;
var categories = ['Hostel', 'Academic', 'Scholarships', 'Mess','Programming'];
String dropDownValue = 'Academic';

class NewQuestion extends StatefulWidget {
  const NewQuestion({Key? key}) : super(key: key);

  @override
  State<NewQuestion> createState() => _NewQuestionState();
}

class _NewQuestionState extends State<NewQuestion> {


  File? image=null  ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
  }

  void _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        );
    setState(
      () {
          image=File(pickedFile!.path);
        });
    Navigator.pop(context);
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    setState(
      () {
        File f = File(pickedFile!.path);
        image=f;
      },
    );
    Navigator.pop(context);
  }

  void _displaySuccessMotionToast() {
    MotionToast.success(
      title: const Text(
        'Congratulations',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      description: const Text(
        'Question posted successfully',
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
      barrierColor: Colors.black.withOpacity(0.3),
      width: 300,
      height: 80,
      dismissable: true,
    ).show(context);
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final tkn = prefs.getString('token');
    setState(() {
      token = tkn;
    });
    // print(token);
  }

  var body;
  Future<dynamic> postData(String? headi, String? desci, String category,File? image) async {
    var response;
    try {
      if(image!=null){
        Map<String, String> header = {'Authorization': 'Bearer $token'};
        String fileName = image.path.split('/').last;
        FormData formData = FormData.fromMap({
          "heading": headi,
          "description": desci,
          "category": category,
          "image": await MultipartFile.fromFile(image.path, filename: fileName),
        });
        response = await Dio()
            .post(url, data: formData, options: Options(headers: header));
        // return response.statusCode;
        // print(response);
        // print(response.statusCode);
        // print(body);
        return (response.statusCode);
      }
      else{
        Map<String, String> header = {'Authorization': 'Bearer $token'};
        FormData formData = FormData.fromMap({
          "heading": headi,
          "description": desci,
          "category": category,

        });
        response = await Dio()
            .post(url, data: formData, options: Options(headers: header));
        // return response.statusCode;
        print(response);
        print(response.statusCode);
        // print(body);
        return (response.statusCode);
      }
    } catch (e) {
      print(e);
      print(body);
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ask a new Question!'),
          centerTitle: true,
          // backgroundColor: const Color(0xFF193251),
        ),
        body: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Material(
                    elevation: 20,
                    borderRadius: BorderRadius.circular(5),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        heading = value;
                      },
                      decoration: const InputDecoration(
                          hintText: 'Title', border: InputBorder.none,
                          hintStyle: TextStyle(fontWeight: FontWeight.bold),

                          ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Material(
                    elevation: 20,
                    borderRadius: BorderRadius.circular(5),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        // style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                        // textAlign: TextAlign.center,
                        minLines: 3,
                        maxLines: 7,
                        onChanged: (value) {
                          description = value;
                        },
                        decoration: const InputDecoration(
                            hintText: 'Explain your problem', border: InputBorder.none
                            // hintStyle: TextStyle(color: Colors.white),

                            ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: DropdownButton(
                    onChanged: ((String? newValue) {
                      setState(() {
                        dropDownValue = newValue!;
                      });
                    }),
                    value: dropDownValue,
                    items: categories.map((String items) {
                      return DropdownMenuItem(value: items, child: Text(items));
                    }).toList(),
                    icon: const Icon(Icons.arrow_drop_down),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 175,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all<double>(20)),
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
                            size: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
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
                    child: image != null
                        ?  Container(
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
                                                builder: (BuildContext
                                                    dialogContext) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Delete Image?'),
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
                                                              image=null;
                                                              Navigator.of(
                                                                      dialogContext)
                                                                  .pop();
                                                            });
                                                          },
                                                          child:
                                                              const Text('Yes'))
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
                                          child: Image.file(image!,
                                              fit: BoxFit.fitWidth),
                                        ),
                                      )
                                    : const Text(
                                        'hello',
                                        style: TextStyle(fontSize: 40),
                                      ),
                          )
                        : null
                          )
                // : const Text(
                //     'hello',
                //     style: TextStyle(color: Colors.white, fontSize: 40),
                //   )
              ],
            )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          elevation: 20,
          onPressed: () async {
            if (heading != null && description != null) {
              showDialog<String>(
                  context: context,
                  builder: (BuildContext dialogContext) => AlertDialog(
                        title: const Text('Post Question'),
                        content: const Text(
                            'Are you sure you want to post this Question?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'No'),
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.of(dialogContext).pop();
                              setState(() {
                                showSpinner = true;
                              });
                              try {
                                var response;
                                if(image!=null) {
                                  response = await postData(
                                    heading, description, dropDownValue,image);
                                }
                                else{
                                  response = await postData(
                                      heading, description, dropDownValue,null);
                                }
                                if (response == 200) {
                                  image=null;
                                  _displaySuccessMotionToast();
                                  // print(body);// Navigator.pop(context);
                                } else {
                                  _displayErrorMotionToast();
                                  // print('error');
                                }
                                setState(() {
                                  showSpinner = false;
                                });
                              } catch (err) {
                                _displayErrorMotionToast();
                                setState(() {
                                  showSpinner = false;
                                });
                                // print(err);
                              }
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      ));
            }
            else{
              _displayErrorMotionToast();
            }
          },
          // backgroundColor: Colors.black,
          label: const Text('Post Question'),
        ),
      ),
    );
  }
}
