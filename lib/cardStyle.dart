import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';

import 'homeScreen.dart';
class CardStyle extends StatelessWidget {
  CardStyle({required this.onPressedQ,required this.heading,required this.description});
  final onPressedQ;
  final heading;
  final description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(20),
          padding:
          MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(0)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                // side: BorderSide(color:Colors.blueGrey.shade900)
              )),
        ),
        onPressed: onPressedQ,
        child: Card(
          // color: Color(0xFF193251),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))
          ),
          borderOnForeground: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                //heading container
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    head = heading,
                    maxLines: 2,
                    softWrap: true,
                    style: const TextStyle(
                      letterSpacing: 0,
                      wordSpacing: 0,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      // color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Text(
                  desc = description,
                  maxLines: 4,
                  style: const TextStyle(
                    fontSize: 15,
                    // color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}