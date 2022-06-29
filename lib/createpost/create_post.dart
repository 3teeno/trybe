import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trybelocker/UniversalFunctions.dart';
import 'package:trybelocker/createpost/photovideopostScreen.dart';
import 'package:trybelocker/createpost/writingpostscreen.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager/src/type.dart';
import 'package:image_picker/image_picker.dart';

class CreatePost extends StatefulWidget {
  static const String TAG = "/createpost";

  CreatePostState createState() => CreatePostState();
}

class CreatePostState extends State<CreatePost>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  int currenttab = 0;
  int currentPage = 0;
  var isphoto = false;
  int lastPage;
  List<Widget> mediadetailslist = [];
  List<bool> isSelected = [];
  List<AssetEntity> galleryselecteitems = [];
  List<AssetEntity> dataList = [];

  File _image, _video;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentPage = 0;
    mediadetailslist.clear();
    dataList.clear();
    _fetchNewMedia(isphoto);
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        currenttab = _tabController.index;
        if (_tabController.index == 0) {
          currentPage = 0;
          dataList.clear();
          mediadetailslist.clear();
          galleryselecteitems.clear();
          isphoto = false;
          _fetchNewMedia(isphoto);
        } else {
          currentPage = 0;
          dataList.clear();
          mediadetailslist.clear();
          galleryselecteitems.clear();
          isphoto = true;
          _fetchNewMedia(isphoto);
        }
        setState(() {
          isphoto;
          currenttab;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColorFromHex(AppColors.black),
      body: Stack(
        children: [
          Column(
            children: [
              Visibility(
                visible: isphoto ? true : false,
                child: InkWell(
                    onTap: () async {
                      var result = await PhotoManager.requestPermission();
                      if (result) {
                        _video = null;
                        getImage();
                      } else {
                        PhotoManager.openSetting();
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black12,
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Icon(
                          Icons.photo_camera_rounded,
                          size: 50,
                          color: getColorFromHex(AppColors.red),
                        ),
                      ),
                    )),
              ),
              Visibility(
                visible: isphoto ? false : true,
                child: Container(
                  alignment: Alignment.center,
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black12,
                  child: InkWell(
                    onTap: () async {
                      var result = await PhotoManager.requestPermission();
                      if (result) {
                        _image = null;
                        getVideo();
                      } else {
                        PhotoManager.openSetting();
                      }
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Icon(
                        Icons.videocam_rounded,
                        size: 50,
                        color: getColorFromHex(AppColors.red),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 4,
                color: Colors.black,
              ),
              new TabBar(
                controller: _tabController,
                tabs: [
                  _individualTab('Video', currenttab == 0),
                  _individualTab('Photo', currenttab == 1),
                ],
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white,
                indicatorColor: getColorFromHex(AppColors.red),
                indicatorSize: TabBarIndicatorSize.tab,
                labelPadding: EdgeInsets.all(0),
                indicatorPadding: EdgeInsets.all(0),
              ),
              Container(
                height: 4,
                color: Colors.black,
              ),
              InkWell(
                  onTap: ()  {
                    creativeJournal();
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 3),
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text(
                        'Creative Journal',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 17),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      // borderRadius: BorderRadius.circular(10)),
                    ),
                  )),
              Container(
                height: 4,
                color: Colors.black,
              ),
              Expanded(
                  child: Stack(
                children: <Widget>[
                  mediadetailslist.length > 0
                      ? NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scroll) {
                            _handleScrollEvent(scroll);
                            return;
                          },
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                  onTap: () {
                                    _image = null;
                                    _video = null;
                                    setState(() {
                                      if (galleryselecteitems
                                          .contains(dataList[index])) {
                                        galleryselecteitems
                                            .remove(dataList[index]);
                                      } else {
                                        if (galleryselecteitems.length <= 0)
                                          galleryselecteitems
                                              .add(dataList[index]);
                                        else
                                          displaytoast(
                                              "you can only select one video or photo",
                                              context);
                                      }
                                      mediadetailslist[index] = Material(
                                        child: Padding(
                                          padding: EdgeInsets.all(1.4),
                                          child: FutureBuilder(
                                            future: dataList[index]
                                                .thumbDataWithSize(300, 300),
                                            builder: (BuildContextcontext,
                                                snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.done) {
                                                return Stack(
                                                  children: <Widget>[
                                                    snapshot != null
                                                        ? snapshot.data != null
                                                            ? Positioned.fill(
                                                                child: Image
                                                                    .memory(
                                                                  snapshot.data,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              )
                                                            : Positioned.fill(
                                                                child: Image
                                                                    .network(
                                                                        "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80"))
                                                        : Positioned.fill(
                                                            child: Image.network(
                                                                "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80")),
                                                    Visibility(
                                                        visible:
                                                            galleryselecteitems
                                                                .contains(
                                                                    dataList[
                                                                        index]),
                                                        child: Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Container(
                                                            width: 40,
                                                            height: 40,
                                                            child: Icon(
                                                              Icons.check,
                                                              color:
                                                                  getColorFromHex(
                                                                      AppColors
                                                                          .black),
                                                              size: 20,
                                                            ),
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.4)),
                                                          ),
                                                        )),
                                                    if (dataList[index].type ==
                                                        AssetType.video)
                                                      Align(
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 5,
                                                                  bottom: 5),
                                                          child: Icon(
                                                            Icons.videocam,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    if (dataList[index].type ==
                                                        AssetType.video)
                                                      Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 5,
                                                                    top: 5),
                                                            child: Text(
                                                              timeinminutes(
                                                                  dataList[
                                                                          index]
                                                                      .videoDuration),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )),
                                                      ),
                                                  ],
                                                );
                                              }
                                              return Container();
                                            },
                                          ),
                                        ),
                                      );
                                    });
                                  },
                                  child: mediadetailslist[index]);
                            },
                            itemCount: mediadetailslist.length,
                          ))
                      : Container(
                          color: Colors.black,
                          child: Center(
                            child: Text(
                              "No Data Found",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ))
                ],
              ))
            ],
          ),
          Positioned(
              top: 0,
              right: 0,
              child: ElevatedButton(
                  child: Text("Next".toUpperCase(),
                      style: TextStyle(fontSize: 14)),
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(color: Colors.red)))),
                  onPressed: () => creativeJournal())),
        ],
      ),
    );
  }

  Widget _individualTab(String text, bool isChecked) {
    return Container(
      height: 50 + MediaQuery.of(context).padding.bottom,
      padding: EdgeInsets.all(0),
      width: double.infinity,
      decoration: BoxDecoration(
          color: isChecked == true
              ? getColorFromHex(AppColors.red)
              : Colors.black12,
          border: Border(
              right: BorderSide(
                  color: Colors.white, width: 1, style: BorderStyle.solid))),
      child: Tab(
        text: text,
      ),
    );
  }

  _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        _fetchNewMedia(isphoto);
      }
    }
  }

  _fetchNewMedia(bool isphoto) async {
    lastPage = currentPage;
    List<AssetPathEntity> albumslist;
    if (isphoto) {
      albumslist = await PhotoManager.getAssetPathList(type: RequestType.image);
    } else {
      albumslist = await PhotoManager.getAssetPathList(type: RequestType.video);
    }
    if (albumslist.isNotEmpty) {
      List<AssetEntity> media =
          await albumslist[0].getAssetListPaged(currentPage, 30);
      List<Widget> temp = [];
      for (var asset in media) {
        if (asset != null) {
          File file = await asset.file;
          bool fileExist = await file?.exists();
          if (file != null &&
              file.existsSync() == true &&
              fileExist != null &&
              fileExist == true) {
            dataList.add(asset);
            isSelected.add(galleryselecteitems.contains(asset));
            temp.add(Material(
              child: Padding(
                padding: EdgeInsets.all(1.5),
                child: FutureBuilder(
                  future: asset.thumbDataWithSize(300, 300),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Stack(
                        children: <Widget>[
                          Positioned.fill(
                              child: ClipRRect(
                            borderRadius: BorderRadius.circular(6.7),
                            child: Image.memory(
                              snapshot.data,
                              fit: BoxFit.cover,
                            ),
                          )),
                          Visibility(
                              visible: galleryselecteitems.contains(asset),
                              child: Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    margin: EdgeInsets.all(8.3),
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: getColorFromHex(AppColors.blur),
                                    ),
                                  ))),
                          if (asset.type == AssetType.video)
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: 5, bottom: 5),
                                child: Icon(
                                  Icons.videocam,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          if (asset.type == AssetType.video)
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                  padding: EdgeInsets.only(left: 5, top: 5),
                                  child: Text(
                                    timeinminutes(asset.videoDuration),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                        ],
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ));
          }
        }
      }
      setState(() {
        mediadetailslist.addAll(temp);
        currentPage++;
      });
    }
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      galleryselecteitems.clear();
      mediadetailslist.clear();
      currentPage = 0;
      _fetchNewMedia(isphoto);
      _image = File(pickedFile.path);
      print('_imagepath=> ${_image}');
    } else {
      print('No image selected.');
    }
    setState(() {});
  }

  Future getVideo() async {
    final pickedFile = await picker.getVideo(source: ImageSource.camera);

    if (pickedFile != null) {
      galleryselecteitems.clear();
      mediadetailslist.clear();
      currentPage = 0;
      _fetchNewMedia(isphoto);
      _video = File(pickedFile.path);
      print('_videopath=> ${_video}');
    } else {
      print('No video selected.');
    }
    setState(() {});
  }

  void creativeJournal() async {
    if (galleryselecteitems.length == 1) {
      var selectedfile = await galleryselecteitems[0].file;
      var type = await galleryselecteitems[0].type;
      if (type == AssetType.video)
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                PhotoVideoPostScreen(selectedfile, "video")));
      else if (type == AssetType.image)
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                PhotoVideoPostScreen(selectedfile, "image")));
    } else if (_image != null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              PhotoVideoPostScreen(_image, "image")));
    } else if (_video != null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              PhotoVideoPostScreen(_video, "video")));
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => WritingPostScreen()));
    }
  }
}
