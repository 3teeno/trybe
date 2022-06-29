import 'dart:io';
import 'dart:typed_data';

import 'package:trybelocker/UniversalFunctions.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ImagePostScreen extends StatefulWidget {
  File url;

  ImagePostScreen(this.url);

  @override
  _ImagePostState createState() => _ImagePostState(url);
}

class _ImagePostState extends State<ImagePostScreen> {
  File url;

  _ImagePostState(this.url);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trybe Locker',
      home: Scaffold(
          body: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                      child: Image.file(url,fit: BoxFit.cover,)
                  )
                ],
              ),
              Visibility(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: EdgeInsets.only(left: 5, top: 10),
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(30)),
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ))
            ],
          )),
    );
  }
}
