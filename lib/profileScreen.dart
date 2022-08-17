import 'package:flutter/material.dart';
import 'registrationScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
String name=' ';
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
    });
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
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
              )
            ],
          )
        ],
      ),
    );
  }
}
