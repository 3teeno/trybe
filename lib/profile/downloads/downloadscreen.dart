import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:trybelocker/UniversalFunctions.dart';
import 'package:trybelocker/profile/downloads/ImagePostScreen.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/video_player/videoplayer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';


class DownloadScreen extends StatefulWidget {
  DownloadScreenState createState() => DownloadScreenState();
}

class DownloadScreenState extends State<DownloadScreen> {
  Directory _photoDir;
  bool isLoaded=false;
  bool isDirExist=false;
  @override
  void initState() {
    super.initState();
    getPath();
  }
  void getPath() async {
    // print("path== ${await getTemporaryDirectory()}");
    _photoDir = Directory((await getTemporaryDirectory()).path+"/trybe/");
    isDirExist= await _photoDir.exists();
     setState((){
       isLoaded=true;
     });
  }
  @override
  Widget build(BuildContext context) {
      if(isLoaded==true){
         if(isDirExist==true){
          var imageList = _photoDir.listSync()
              .map((item) => item.path)
          // .where((item) => item.endsWith(".png"))
              .toList(growable: false);

          if (imageList.length > 0) {
            return
            Scaffold(
              appBar: AppBar(
                brightness: Brightness.dark,
                title: Text(
                  "Downloads",
                ),
                backgroundColor: getColorFromHex(AppColors.black),
              ),
              body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: getColorFromHex(AppColors.black),
                child: ListView.builder(
                    padding: EdgeInsets.only(left: 0, top: 15),
                    itemCount: imageList.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.only(left: 15, bottom: 15),
                        child: Row(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ImagePostScreen(
                                        File(imageList[index]))));
                              },
                              child: Visibility(
                                  visible: File(imageList[index])
                                      .path
                                      .split('.')
                                      .last
                                      .compareTo("mov") ==
                                      0
                                      ? false
                                      : true,
                                  child: new Container(
                                      width: 200,
                                      height: 100,
                                      child: Image.file(
                                        File(imageList[index]),
                                        fit: BoxFit.cover,
                                      ))),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => VideoPlayerScreen(
                                        File(imageList[index]).path, true)));
                              },
                              child: Visibility(
                                visible: File(imageList[index]).path.split('.').last.compareTo("mov") == 0? true : false,
                                child:File(imageList[index]).path.split('.').last.compareTo("mov") == 0? new Container(
                                  width: 200,
                                  height: 100,
                                  child: Stack(
                                    children: <Widget>[
                                      FutureBuilder(
                                          future:
                                          getThumbnail(File(imageList[index]).path),
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
                                          })
                                    ],
                                  ),
                                ) : Container(),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              File(imageList[index]).path.split('/').last,
                              // basename(File(imageList[index]).path),
                              style: TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            );
          } else {
            return  Scaffold(
              appBar: AppBar(
                brightness: Brightness.dark,
                title: Text(
                  "Downloads",
                ),
                backgroundColor: getColorFromHex(AppColors.black),
              ),
              body: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: getColorFromHex(AppColors.black),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 60.0),
                      child: Text(
                        "Sorry, No Downloads Found.",
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                    ),
                  )),
            );
          }
        }else{
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Downloads",
              ),
              brightness: Brightness.dark,
              backgroundColor: getColorFromHex(AppColors.black),
            ),
            body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: getColorFromHex(AppColors.black),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.only(bottom: 60.0),
                    child: Text(
                      "Sorry, No Downloads Found.",
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                )),
          );
        }
      }else{
        return Container();
      }
  }

  Future<Uint8List> getThumbnail(String url) async {
    print("urllink=>$url");
    return await VideoThumbnail.thumbnailData(
      video: url,
      imageFormat: ImageFormat.PNG,
      maxWidth: 300,
      maxHeight: 300,
      // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 90,
    );
  }


// }
}
