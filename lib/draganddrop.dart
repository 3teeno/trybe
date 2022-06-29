import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trybelocker/itemscene.dart';

class Drag extends StatefulWidget{
  DragScreenState createState() => DragScreenState();
}

class DragScreenState extends State<Drag>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    home: Scaffold(
    body: Center(
    child: Container(
    alignment: Alignment.center,
    child: ItemsScene(),
    decoration: BoxDecoration(
    border: Border.all(
    color: Colors.blueAccent,
    ),
    ),
    ),
    ),
    ),
    );
  }

}