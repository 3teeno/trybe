import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trybelocker/UniversalFunctions.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:cast/cast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Casting extends StatefulWidget {
  CastingState createState() => CastingState();
}

class CastingState extends State<Casting> {
  // List<String> deviceList = [];
  Future<List<CastDevice>> _future;

  @override
  void initState() {
    super.initState();
    _startSearch();
  }

  void _startSearch() {
    _future = CastDiscoveryService().search();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CastDevice>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            color: Colors.black,
            home: Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                brightness: Brightness.dark,
                title: Text("Casting"),
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              body: Center(
                child: Text(
                  'Error: ${snapshot.error.toString()}',
                ),
              ),
            ),
          );
        } else if (!snapshot.hasData) {
          return MaterialApp(
            color: getColorFromHex(AppColors.black),
            home: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                brightness: Brightness.dark,
                title: Text("Casting"),
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              backgroundColor: getColorFromHex(AppColors.black),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      child: Center(
                    child: CircularProgressIndicator(),
                  ))
                ],
              ),
            ),
          );
        }

        if (snapshot.data.isEmpty) {
          return MaterialApp(
            color: Colors.black,
            home: Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                brightness: Brightness.dark,
                title: Text("Casting"),
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              body: Center(
                child: Text(
                  'No Device found',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          );
        }
        return MaterialApp(
          color: Colors.black,
          home: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              brightness: Brightness.dark,
              title: Text("Casting"),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: Column(
              children: snapshot.data.map((device) {
                return ListTile(
                  title: Text(device.name),
                  onTap: () {
                    // _connectToYourApp(context, device);
                    _connectAndPlayMedia(context, device);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Future<void> _connectToYourApp(
      BuildContext context, CastDevice object) async {
    final session = await CastSessionManager().startSession(object);

    session.stateStream.listen((state) {
      if (state == CastSessionState.connected) {
        final snackBar = SnackBar(content: Text('Connected'));
        Scaffold.of(context).showSnackBar(snackBar);

        _sendMessageToYourApp(session);
      }
    });

    session.messageStream.listen((message) {
      print('receive message: $message');
    });

    session.sendMessage(CastSession.kNamespaceReceiver, {
      'type': 'LAUNCH',
      'appId': 'Youtube', // set the appId of your app here
    });
  }

  Future<void> _connectAndPlayMedia(
      BuildContext context, CastDevice object) async {
    final session = await CastSessionManager().startSession(object);

    session.stateStream.listen((state) {
      if (state == CastSessionState.connected) {
        final snackBar = SnackBar(content: Text('Connected'));
        Scaffold.of(context).showSnackBar(snackBar);
      }
    });

    var index = 0;

    session.messageStream.listen((message) {
      index += 1;

      print('receive message: $message');

      if (index == 2) {
        Future.delayed(Duration(seconds: 5)).then((x) {
          _sendMessagePlayVideo(session);
        });
      }
    });

    session.sendMessage(CastSession.kNamespaceReceiver, {
      'type': 'LAUNCH',
      'appId': 'CC1AD845', // set the appId of your app here
    });
  }

  void _sendMessageToYourApp(CastSession session) {
    print('_sendMessageToYourApp');

    session.sendMessage('urn:x-cast:namespace-of-the-app', {
      'type': 'sample',
    });
  }

  void _sendMessagePlayVideo(CastSession session) {
    print('_sendMessagePlayVideo');

    var message = {
      // Here you can plug an URL to any mp4, webm, mp3 or jpg file with the proper contentType.
      'contentId':
          'http://commondatastorage.googleapis.com/gtv-videos-bucket/big_buck_bunny_1080p.mp4',
      'contentType': 'video/mp4',
      'streamType': 'BUFFERED',
      // or LIVE

      // Title and cover displayed while buffering
      'metadata': {
        'type': 0,
        'metadataType': 0,
        'title': "Big Buck Bunny",
        'images': [
          {
            'url':
                'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg'
          }
        ]
      }
    };

    session.sendMessage(CastSession.kNamespaceMedia, {
      'type': 'LOAD',
      'autoPlay': true,
      'currentTime': 0,
      'media': message,
    });
  }
}

//
