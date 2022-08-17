import 'package:flutter/material.dart';

String heading = '';
String description = '';

class DetailedSolution extends StatefulWidget {
  const DetailedSolution({Key? key}) : super(key: key);

  @override
  State<DetailedSolution> createState() => _DetailedSolutionState();
}

class _DetailedSolutionState extends State<DetailedSolution> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: const Color(0xFF193251),
        appBar: AppBar(
          title: const Text('Detailed Question'),
          centerTitle: true,
          // backgroundColor: const Color(0xFF193251),
        ),
        body: ListView(children: [
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
                          // color: Colors.white,
                          fontSize: 17,
                        )),
                  ]))
        ]));
  }
}
