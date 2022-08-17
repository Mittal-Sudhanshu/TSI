import 'package:flutter/material.dart';
String searchText='';
class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFF193251),
      body: Column(
        
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
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
                decoration: const InputDecoration(hintText: 'Search',border: InputBorder.none),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(style: ButtonStyle(elevation: MaterialStateProperty.all(20)),onPressed: ()  {
              //implement search on backend
              // Navigator.pushNamed(context, 'homeScreen');
            }, child: SizedBox(
              width: 75,
              child: Row(
                children: const [
                  Icon(Icons.search),
                  Text('Search'),
                ],
              ),
            )),
          )
        ],
      ),
    );
  }
}
