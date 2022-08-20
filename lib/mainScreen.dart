// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:teacher_student_interaction/profileScreen.dart';
import 'package:teacher_student_interaction/searchScreen.dart';
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
