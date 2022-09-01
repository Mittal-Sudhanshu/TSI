import 'package:flutter/material.dart';

String? heading ;
String? description ;
class DetailedSolution extends StatelessWidget {
  DetailedSolution({required this.sender,required this.solver,required this.head,required this.desc,required this.solution,required this.questionUrl,required this.imageUrl});
  final head;
  final questionUrl;
  final imageUrl;
  final desc;
  final sender;
  final solver;
  final solution;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: const Color(0xFF193251),
        appBar: AppBar(
          title: const Text('Detailed Solution'),
          centerTitle: true,
          // backgroundColor: const Color(0xFF193251),
        ),
        body: ListView(children: [
          Center(child: Text('Question',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,decoration: TextDecoration.underline),),),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8),
                child: CircleAvatar(
                  minRadius: 15,
                  child: Text(
                    sender[0],
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ),
              SizedBox(child: Text(sender)),
            ],
          ), Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(head,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(desc,style: TextStyle(fontSize: 15),),
                ),
              ],
            ),
          ),
          Padding(padding:const EdgeInsets.all(0),child: questionUrl!=''?SizedBox(height: 200,width: double.infinity,child: Image.network(questionUrl)):null,),
          Center(child: Text('Solution',style:TextStyle(fontSize: 20,decoration: TextDecoration.underline),),),

          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8),
                child: CircleAvatar(
                  minRadius: 15,
                  child: Text(
                    solver[0],
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ),
              SizedBox(child: Text(solver)),
            ],
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(solution,
                        style: const TextStyle(
                          // color: Colors.white,
                          fontSize: 17,
                        )),
                  ])),
          Padding(padding:const EdgeInsets.all(0),child: imageUrl!=''?SizedBox(height:200,width:double.infinity,child: Image.network(imageUrl)):null,),
        ]));
  }
}
