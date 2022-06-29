import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trybelocker/model/getallvideos/getallvideosparams.dart';
import 'package:trybelocker/model/search/search_post_response.dart';
import 'package:trybelocker/networkmodel/APIs.dart';
import 'package:trybelocker/post_screen.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/viewmodel/allvideos_view_model.dart';
import 'package:trybelocker/viewmodel/publicprofileviewmodel.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../UniversalFunctions.dart';
import 'package:provider/src/provider.dart';
import 'package:trybelocker/model/showhistorylist/showhistorylistparams.dart';
import 'package:trybelocker/model/showhistorylist/showhistorylistresponse.dart';

class History extends StatefulWidget {
  static const String TAG = "/uservideos";

  HistoryState createState() => HistoryState();
}

class HistoryState extends State<History> {
  // String sortbyselecttext = "Sort by";
  AllVideosViewModel _allVideosViewModel;
  int limit = 10;
  bool userallposts = false;
  bool isuserpostloading = false;
  List<Data> getallvideolist = [];
  int currentPage = 0;
  bool isDataLoaded = false;
  // String sortby="newest";

  @override
  void initState() {
    super.initState();
    new Future.delayed(const Duration(milliseconds: 300), () {
      isuserpostloading = false;
      currentPage = 1;
      userallposts = false;
      // _profileHomeViewModel.setLoading();
      if (isuserpostloading == false && userallposts == false) {
        setState(() {
          isuserpostloading = true;
        });
        showhistorylist(true, currentPage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _allVideosViewModel = Provider.of<AllVideosViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: getColorFromHex(AppColors.black),
        title: Text("History"),
      ),
      backgroundColor: getColorFromHex(AppColors.black),
      body: Stack(
        children: <Widget>[
          Visibility(
            visible: getallvideolist.length>0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container(
                //     margin: EdgeInsets.only(left: 20, top: 20),
                //     child: new Theme(
                //         data: Theme.of(context).copyWith(
                //           canvasColor: getColorFromHex(AppColors.black),
                //         ),
                //         child: DropdownButtonHideUnderline(
                //             child: ButtonTheme(
                //               alignedDropdown: true,
                //               child: DropdownButton<String>(
                //                 iconEnabledColor: Colors.white,
                //                 items: <String>[
                //                   'Sort by',
                //                   'Year',
                //                   'Oldest',
                //                   'Newest'
                //                 ].map((String value) {
                //                   return new DropdownMenuItem<String>(
                //                     value: value,
                //                     child: new Text(value),
                //                   );
                //                 }).toList(),
                //                 onChanged: (value) {
                //                   setState(() {
                //                     sortbyselecttext = value;
                //                     currentPage=0;
                //                     getallvideopost(true, currentPage);
                //                   });
                //                 },
                //                 value:sortbyselecttext,
                //                 style: new TextStyle(
                //                   color: Colors.white,
                //                 ),
                //               ),
                //             )))),
                Expanded(child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scroll) {
                      if (isuserpostloading == false &&
                          userallposts == false &&
                          scroll.metrics.pixels ==
                              scroll.metrics.maxScrollExtent) {
                        setState(() {
                          // isuserpostloading = true;
                          currentPage++;
                          showhistorylist(false, currentPage);
                        });
                      }
                      return;
                    },
                    child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 20),
                        itemCount: getallvideolist.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              DataPost datapost =
                              new DataPost();
                              datapost.id =
                                  getallvideolist[index].id;
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => PostScreen(datapost)));
                            },
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 200,
                                  height: 100,
                                  margin: EdgeInsets.fromLTRB(20, 10, 0, 10),
                                  child: FutureBuilder(
                                      future: getThumbnail(
                                          APIs.userpostvideosbaseurl +
                                              getallvideolist[index]
                                                  .postMediaUrl),
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
                                                  child: Image.network("https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80", fit: BoxFit.cover)
                                              ) : Positioned.fill(
                                                  child: Image.network(
                                                      "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80", fit: BoxFit.cover))
                                            ],
                                          );
                                        } else {
                                          return SpinKitCircle(
                                            itemBuilder:
                                                (BuildContext context,
                                                int index) {
                                              return DecoratedBox(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      }),
                                ),
                                new Container(
                                    height: 100,
                                    margin:
                                    EdgeInsets.only(left: 10, top: 10),
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          getallvideolist[index].postCaption,
                                          style:
                                          TextStyle(color: Colors.white),
                                        ),
                                        // Text(getuserpostlist[index].+" Likes")
                                      ],
                                    ))
                              ],
                            ),
                          );
                        })))
              ],
            ),
          ),
          getFullScreenProviderLoader(
              context: context, status: isuserpostloading),
          Visibility(
              visible:   isDataLoaded==true?getallvideolist.length<=0?true:false:false,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(child:Text("No Data Found",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),)),
              ))
        ],
      ),
    );
  }

  Future<Uint8List> getThumbnail(String url) async {
    return await VideoThumbnail.thumbnailData(
      video: url,
      imageFormat: ImageFormat.PNG,
      maxWidth: 500,
      maxHeight: 500,
      // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 90,
    );
  }

  getprofilepic(int index) {
    if (getallvideolist[index].userInfo.userImage != null &&
        getallvideolist[index].userInfo.userImage.isNotEmpty) {
      if (getallvideolist[index].userInfo.userImage.contains("https") ||
          getallvideolist[index].userInfo.userImage.contains("http")) {
        return NetworkImage(getallvideolist[index].userInfo.userImage);
      } else {
        return NetworkImage(APIs.userprofilebaseurl +
            getallvideolist[index].userInfo.userImage);
      }
    } else {
      return NetworkImage(
          "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80");
    }
  }

  void showhistorylist(bool isClear, int currentPage) async {
    _allVideosViewModel.setLoading();
    Showhistorylistparams request = Showhistorylistparams();
    request.uid = MemoryManagement.getuserId();
    request.page = currentPage.toString();
    request.limit = limit.toString();

    var response = await _allVideosViewModel.gethistorylist(request, context);
    Showhistorylistresponse getallvideosresponse = response;
    if (isClear == true) {
      getallvideolist.clear();
    }

    if (getallvideosresponse != null &&
        getallvideosresponse.postData.data != null &&
        getallvideosresponse.postData.data.length > 0) {
      if (getallvideosresponse.postData.data.length < limit) {
        userallposts = true;
        isuserpostloading = false;
      }
      if (getallvideosresponse != null) {
        if (getallvideosresponse.status != null &&
            getallvideosresponse.status.isNotEmpty) {
          if (getallvideosresponse.status.compareTo("success") == 0) {
            getallvideolist.addAll(getallvideosresponse.postData.data);
            print("listsize,${getallvideolist.length}");
            currentPage = 2;
            isDataLoaded = true;
            setState(() {});
          } else {}
        }
      }
      setState(() {
        isDataLoaded = true;
        isuserpostloading = false;
      });
    } else {
      isDataLoaded = true;
      userallposts = true;
      setState(() {
        isuserpostloading = false;
      });
    }
  }

  // getsortbytext() {
  //
  //   if(sortbyselecttext.compareTo("Sort by")==0||sortbyselecttext.compareTo("Newest")==0){
  //     return sortby = "newest";
  //   }else if(sortbyselecttext.compareTo("Oldest")==0){
  //     return sortby = "oldest";
  //   }else if(sortbyselecttext.compareTo("Year")==0){
  //     return sortby = "year";
  //   }
  //
  //
  // }
}
