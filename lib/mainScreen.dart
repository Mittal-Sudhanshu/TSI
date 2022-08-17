// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacher_student_interaction/loginScreen.dart';
import 'package:teacher_student_interaction/profileScreen.dart';
import 'package:teacher_student_interaction/searchScreen.dart';
import 'otpInput.dart';
import 'homeScreen.dart';

var tabs = [const HomeScreen(), const SearchScreen(), const ProfileScreen()];

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFF193251),
      drawer: Drawer(
          // backgroundColor: const Color(0xFF193251),
          child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(children: [
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
                }),
          ],
        ),
      )),
      appBar: AppBar(
        centerTitle: true,
        // backgroundColor: const Color(0xFF193251),
        title: const Text('Questions'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
        ],
        // unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        // selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      body: tabs[_selectedIndex],
    );
  }
}
