import 'dart:io';
import 'dart:typed_data';

import 'package:trybelocker/UniversalFunctions.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/viewmodel/home_view_model.dart';
import 'package:trybelocker/viewmodel/videoplayerviewmodel.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:provider/src/provider.dart';
import 'package:trybelocker/model/saveposttohistory/saveposttohistoryparams.dart';
import 'package:trybelocker/model/saveposttohistory/saveposttohistoryresponse.dart';

class VideoPlayerScreen extends StatefulWidget {
  String url;
  bool local;
  String post_id;
  VideoPlayerScreen(this.url, this.local, [this.post_id]);

  @override
  VideoPlayerState createState() => VideoPlayerState(url);
}

class VideoPlayerState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller;
  String url;
  var thumbnail = null;

  HomeViewModel _homeViewModel;
  VideoPlayerViewModel _videoPlayerViewModel;

  VideoPlayerState(this.url);

  @override
  void initState() {
    super.initState();
    _setListener();
    if (widget.local == true) {
      _controller = VideoPlayerController.file(File(url));
    } else {
      _controller = VideoPlayerController.network(url);
    }
    _controller
      ..setLooping(true)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    getThumbnailValue();
  }

  void getThumbnailValue() async {
    thumbnail = await getThumbnail(url);
  }

  @override
  Widget build(BuildContext context) {
    _homeViewModel = Provider.of<HomeViewModel>(context);
    _videoPlayerViewModel = Provider.of<VideoPlayerViewModel>(context);
    return MaterialApp(
      title: 'Trybelocker',
      home: Scaffold(
        backgroundColor:getColorFromHex(AppColors.black),
          body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: _controller.value.isInitialized
                    ? GestureDetector(
                        onTap: () {
                          _controller.value.isPlaying ? _pause() : _play();
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Stack(
                              children: [
                                // ThumbnailImage(
                                //   videoUrl: url,
                                //   width: MediaQuery.of(context).size.width,
                                //   height: 400,
                                //   fit: BoxFit.cover,
                                // ),
                                thumbnail == null
                                    ? FutureBuilder(
                                        future: getThumbnail(url),
                                        builder:
                                            (BuildContext context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            return Stack(
                                            children: <Widget>[
                                          snapshot!=null?snapshot.data!=null?
                                             Positioned.fill(
                                              child: Image.memory(
                                                snapshot.data,
                                                fit: BoxFit.cover,
                                              ),
                                            ):Positioned.fill(
                                                child: Image.network("https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80",fit: BoxFit.cover,
                                            )) : Positioned.fill(
                                                        child: Image.network(
                                                            "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80",fit: BoxFit.cover,))
                                              ],
                                          );
                                          } else {
                                            return Container();
                                          }
                                        })
                                    : Stack(
                                  children: [Positioned.fill(
                                    child: Image.memory(
                                      thumbnail,
                                      fit: BoxFit.cover,
                                    ),
                                  )],
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  color: getColorFromHex(AppColors.blur)
                                      .withOpacity(0.1),
                                )
                              ],
                            ),
                            AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: VideoPlayer(_controller))
                          ],
                        ),
                      )
                    : Stack(
                        children: <Widget>[
                          // getblurthumbnail(),
                          SpinKitCircle(
                            itemBuilder: (BuildContext context, int index) {
                              return DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                              );
                            },
                          )
                        ],
                      ),
              )
            ],
          ),
          Visibility(
              visible: widget.local,
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

  void _pause() {
    setState(() {
      _controller?.pause();
    });
  }

  void _play() {
    setState(() {
      _controller?.play();
    });
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose successfully=>=>=>=>");

    if(widget.post_id!=null&&widget.post_id.isNotEmpty){
      // if(_controller.value.duration.inSeconds>0)
      if(_controller.value.isPlaying)
      savevideotohistory();
    }

    _controller.dispose();
  }

  void _setListener() async {
    await Future.delayed(Duration(milliseconds: 500));
    _homeViewModel.controller.stream.listen((value) {
      print("pause=>=>=>=>");
      if(_controller!=null) {
        if (mounted) _pause();
      }
    });
  }

  getblurthumbnail() {
    return Stack(
      children: [
        // ThumbnailImage(
        //   videoUrl: url,
        //   width: MediaQuery.of(context).size.width,
        //   height: 400,
        //   fit: BoxFit.cover,
        // ),
        FutureBuilder(
            future: getThumbnail(url),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Positioned.fill(
                  child: Image.memory(
                    snapshot.data,
                    fit: BoxFit.cover,
                  ),
                );
              } else {
                return Container();
              }
            }),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: getColorFromHex(AppColors.blur).withOpacity(0.1),
        )
      ],
    );
  }

  Future<Uint8List> getThumbnail(String url) async {
    if (widget.local == true) {
      return await VideoThumbnail.thumbnailData(
        video: url,
        imageFormat: ImageFormat.PNG,
        maxWidth: 100,
        maxHeight: 100,
        // maxHeight: 500,
        // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        quality: 50,
      );
    } else {
      return await VideoThumbnail.thumbnailData(
        video: url,
        imageFormat: ImageFormat.PNG,
        maxWidth: 100,
        maxHeight: 100,
        // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        quality: 50,
      );
    }
  }

  void savevideotohistory() async {
    Saveposttohistoryparams request = Saveposttohistoryparams();
    request.uid = MemoryManagement.getuserId();
    request.postId = widget.post_id;

    var response = await _videoPlayerViewModel.savevideotohistory(request, context);
    Saveposttohistoryresponse getallvideosresponse = response;
  }

  void checkVideo(){
    // Implement your calls inside these conditions' bodies :
    if(_controller.value.position == Duration(seconds: 0, minutes: 0, hours: 0)) {
      print('video Started');
    }
    //
    // if(_controller.value.position == _controller.value.duration) {
    //   print('video Ended');
    // }

  }
}
