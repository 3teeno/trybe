import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trybelocker/chat/ChatScreen.dart';
import 'package:trybelocker/get_collection_post.dart';
import 'package:trybelocker/getplaylistpost.dart';
import 'package:trybelocker/group_chat.dart';
import 'package:trybelocker/model/followunfollow/followunfollowparams.dart';
import 'package:trybelocker/model/followunfollow/followunfollowresponse.dart';
import 'package:trybelocker/model/getallposts/getallpostresponse.dart';
import 'package:trybelocker/model/getallvideos/getallvideosparams.dart';
import 'package:trybelocker/model/getplaylist/getplaylistparams.dart';
import 'package:trybelocker/model/getplaylist/getplaylistresponse.dart';
import 'package:trybelocker/model/getuserpost/getuserpostparams.dart';
import 'package:trybelocker/model/getuserpost/getuserpostresponse.dart';
import 'package:trybelocker/model/notificationoff/notificationoff_params.dart';
import 'package:trybelocker/model/notificationoff/notificationoff_response.dart';
import 'package:trybelocker/model/search/search_post_response.dart';
import 'package:trybelocker/model/search/search_response.dart';
import 'package:trybelocker/networkmodel/APIs.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/video_player/videoplayer.dart';
import 'package:trybelocker/viewmodel/home_view_model.dart';
import 'package:trybelocker/viewmodel/publicprofileviewmodel.dart';
import '../UniversalFunctions.dart';
import 'package:provider/src/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import '../post_screen.dart';
import 'package:firebase_database/firebase_database.dart';

class PublicProfileScreen extends StatefulWidget {
  static const String TAG = "/publicprofile";

  DataUser userdata;

  PublicProfileScreen([this.userdata]);

  @override
  PublicProfileState createState() => PublicProfileState(userdata);
}

class PublicProfileState extends State<PublicProfileScreen>
    with SingleTickerProviderStateMixin {
  int currenttab = 0;
  int currentPage = 0;
  TabController _tabController;
  bool isnotificationvisible = true;
  var selecttext = "Sort by";
  String sortbyselecttext = "Sort by";
  String trybelistselecttext = "Sort by";
  DataUser userdata;
  PublicProfileViewModel _profileViewModel;
  int limit = 10;
  int isFollowed = -1;

  PublicProfileState(this.userdata);

  List<Datas> getuserpostlist = [];
  bool userallposts = false;
  bool isuserpostloading = false;
  List<DataPost> getallvideolist = [];
  List<DataPost> getallimageslist = [];
  bool isDataLoaded = false;
  List<PlaylistData> playlistdatalist = [];

  var reference;

  DataSnapshot dataSnapshot;

  bool istrybegoupprivate = false;

  String sortby = "newest";
  String trybelistsortby = "newest";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 6);

    if (currenttab == 0) {
      new Future.delayed(const Duration(milliseconds: 300), () {
        isuserpostloading = false;
        currentPage = 1;
        userallposts = false;
        // _profileHomeViewModel.setLoading();
        if (isuserpostloading == false && userallposts == false) {
          setState(() {
            isuserpostloading = true;
          });
          getuserposts(true, currentPage);
        }
      });
    }

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        currenttab = _tabController.index;
        if (_tabController.index == 0) {
          currentPage = 0;
          isuserpostloading = false;
          currentPage = 1;
          userallposts = false;
          // _profileHomeViewModel.setLoading();
          if (isuserpostloading == false && userallposts == false) {
            setState(() {
              isuserpostloading = true;
              isDataLoaded = false;
            });
            getuserposts(true, currentPage);
          }
        } else if (_tabController.index == 1) {
          currentPage = 1;
          new Future.delayed(const Duration(milliseconds: 50), () {
            isuserpostloading = false;
            currentPage = 1;
            userallposts = false;
            // _profileHomeViewModel.setLoading();
            if (isuserpostloading == false && userallposts == false) {
              setState(() {
                isuserpostloading = true;
                isDataLoaded = false;
              });
              getallvideopost(true, currentPage);
            }
          });
        } else if (_tabController.index == 2) {
          currentPage = 1;
          new Future.delayed(const Duration(milliseconds: 50), () {
            isuserpostloading = false;
            currentPage = 1;
            userallposts = false;
            // _profileHomeViewModel.setLoading();
            if (isuserpostloading == false && userallposts == false) {
              setState(() {
                isuserpostloading = true;
                isDataLoaded = false;
              });
              getCollectionList();
            }
          });
        } else if (_tabController.index == 4) {
          try {
            reference =
                FirebaseDatabase.instance.reference().child("groups").child(
                    widget.userdata.id.toString());
            getgroupname();
          } catch (e) {
            print(e.toString());
          }
        } else if (_tabController.index == 3) {
          try {
            currentPage = 1;
            new Future.delayed(const Duration(milliseconds: 50), () {
              isuserpostloading = false;
              currentPage = 1;
              userallposts = false;
              // _profileHomeViewModel.setLoading();
              if (isuserpostloading == false && userallposts == false) {
                setState(() {
                  isuserpostloading = true;
                  isDataLoaded = false;
                });
                getallimagespost(true, currentPage);
              }
            });
          } catch (e) {
            print(e.toString());
          }
        }
      }
    });
  }

  void getCollectionList() async {
    _profileViewModel.setLoading();
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _profileViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Getplaylistparams request =
      new Getplaylistparams(uid: MemoryManagement.getuserId(),
          other_uid: widget.userdata.id.toString(),
          sort_by: gettrybelistsortbytext());
      var response = await _profileViewModel.getplaylist(request, context);
      Getplaylistresponse getplaylistresponse = response;
      if (getplaylistresponse.status.compareTo("success") == 0) {
        setState(() {
          playlistdatalist.clear();
          if (getplaylistresponse.playlistData != null &&
              getplaylistresponse.playlistData.length > 0) {
            playlistdatalist.addAll(getplaylistresponse.playlistData);
            isDataLoaded = true;
            isuserpostloading = false;
          } else {
            isDataLoaded = true;
            isuserpostloading = false;
          }
        });
      } else {
        setState(() {
          isDataLoaded = true;
          isuserpostloading = false;
        });
      }
    }
  }

  void getallimagespost(bool isClear, int currentPage) async {
    _profileViewModel.setLoading();
    if (isClear == true) {
      setState(() {
        isuserpostloading = true;
      });
    }
    Getallvideosparams request = Getallvideosparams();
    request.uid = MemoryManagement.getuserId();
    request.postType = "1";
    request.page = currentPage.toString();
    request.sort_by = getsortbytext();
    request.other_uid = widget.userdata.id.toString();
    request.limit = limit.toString();

    var response = await _profileViewModel.getallimages(request, context);

    setState(() {
      isuserpostloading = false;
      Search_post_response getallvideosresponse = response;
      if (isClear == true) {
        getallimageslist.clear();
      }
      if (getallvideosresponse != null &&
          getallvideosresponse.postData.data != null &&
          getallvideosresponse.postData.data.length > 0) {
        if (getallvideosresponse.postData.data.length < limit) {
          userallposts = true;
          isuserpostloading = false;
          isDataLoaded = true;
        }
        if (getallvideosresponse != null) {
          if (getallvideosresponse.status != null &&
              getallvideosresponse.status.isNotEmpty) {
            if (getallvideosresponse.status.compareTo("success") == 0) {
              getallimageslist.addAll(getallvideosresponse.postData.data);
              currentPage = 2;
              isDataLoaded = true;
            } else {}
          }
        }
        isDataLoaded = true;
        isuserpostloading = false;
      } else {
        isDataLoaded = true;
        userallposts = true;
        isuserpostloading = false;
      }
    });
  }

  void getallvideopost(bool isClear, int currentPage) async {
    _profileViewModel.setLoading();
    if (isClear == true) {
      setState(() {
        isuserpostloading = true;
      });
    }
    Getallvideosparams request = Getallvideosparams();
    request.uid = MemoryManagement.getuserId();
    request.postType = "2";
    request.page = currentPage.toString();
    request.sort_by = getsortbytext();
    request.other_uid = widget.userdata.id.toString();
    request.limit = limit.toString();

    var response = await _profileViewModel.getallvideos(request, context);
    setState(() {
      isuserpostloading = false;
      Search_post_response getallvideosresponse = response;
      if (isClear == true) {
        getallvideolist.clear();
      }
      if (getallvideosresponse != null &&
          getallvideosresponse.postData.data != null &&
          getallvideosresponse.postData.data.length > 0) {
        if (getallvideosresponse.postData.data.length < limit) {
          userallposts = true;
          isuserpostloading = false;
          isDataLoaded = true;
        }
        if (getallvideosresponse != null) {
          if (getallvideosresponse.status != null &&
              getallvideosresponse.status.isNotEmpty) {
            if (getallvideosresponse.status.compareTo("success") == 0) {
              getallvideolist.addAll(getallvideosresponse.postData.data);
              currentPage = 2;
              isDataLoaded = true;
            } else {}
          }
        }
        isDataLoaded = true;
        isuserpostloading = false;
      } else {
        isDataLoaded = true;
        userallposts = true;
        isuserpostloading = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _profileViewModel = Provider.of<PublicProfileViewModel>(context);
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor: getColorFromHex(AppColors.red),
          title: Text(
            userdata != null
                ? userdata != null
                ? userdata.username != null
                ? userdata.username.isNotEmpty
                ? userdata.username
                : ""
                : ""
                : ""
                : "",
          ),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: [
              _individualTab('HOME', currenttab == 0),
              _individualTab('VIDEOS', currenttab == 1),
              _individualTab('TRYBELISTS', currenttab == 2),
              _individualTab('IMAGES', currenttab == 3),
              _individualTab('TRYBE', currenttab == 4),
              _individualTab('ABOUT', currenttab == 5),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: getColorFromHex(AppColors.lightredcolor),
            indicatorColor: getColorFromHex(AppColors.red),
            indicatorSize: TabBarIndicatorSize.tab,
            labelPadding: EdgeInsets.only(left: 10, right: 10),
            indicatorPadding: EdgeInsets.all(0),
          ),
        ),
        backgroundColor: getColorFromHex(AppColors.black),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: 140,
                  child: getCachedNetworkImage(
                      url: userdata != null
                          ? userdata.cover_photo != null
                          ? userdata.cover_photo
                          .toString()
                          .trim()
                          .length >
                          0
                          ? getCoverPhoto(userdata.cover_photo)
                          : "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80"
                          : "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80"
                          : "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80",
                      fit: BoxFit.cover)),
              Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: 100,
                  color: Colors.black,
                  child: Row(
                    children: <Widget>[
                      new Container(
                        width: 70,
                        height: 70,
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.cover, image: getprofilepic())),
                      ),
                      new Container(
                        // width: 70,
                        // height: 70,
                        margin: EdgeInsets.only(left: 10, top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userdata != null
                                  ? userdata != null
                                  ? userdata.username != null
                                  ? userdata.username.isNotEmpty
                                  ? userdata.username
                                  : ""
                                  : ""
                                  : ""
                                  : "",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Visibility(
                                    visible: userdata != null
                                        ? userdata != null
                                        ? userdata.id != null
                                        ? (MemoryManagement.getuserId()
                                        .compareTo(userdata
                                        .id
                                        .toString()) ==
                                        0)
                                        ? false
                                        : true
                                        : false
                                        : false
                                        : false,
                                    child: getfollowunfollow())
                                ,


                                // Visibility(
                                //     visible: userdata != null
                                //         ? userdata != null
                                //         ? userdata.id != null
                                //         ? (MemoryManagement.getuserId()
                                //         .compareTo(userdata
                                //         .id
                                //         .toString()) ==
                                //         0)
                                //         ? false
                                //         : true
                                //         : false
                                //         : false
                                //         : false,
                                //     child: InkWell(
                                //       onTap: () {
                                //         var updatedvalue = keyvalue;
                                //         if (updatedvalue.compareTo("1") == 0) {
                                //           setState(() {
                                //             followtext = "Unfollow";
                                //             isFollow = true;
                                //           });
                                //         } else {
                                //           setState(() {
                                //             followtext = "Follow";
                                //             isFollow = false;
                                //           });
                                //         }
                                //         followunfollowapi(keyvalue);
                                //       },
                                //       child: Container(
                                //         padding: EdgeInsets.only(
                                //             left: 10,
                                //             right: 10,
                                //             top: 5,
                                //             bottom: 5),
                                //         decoration: BoxDecoration(
                                //             border: Border.all(
                                //                 color: Colors.white)),
                                //         child: Text(followtext,
                                //             style:
                                //             TextStyle(color: Colors.white)),
                                //       ),
                                //     )),
                                SizedBox(
                                  width: 10,
                                ),
                                Visibility(
                                    visible: (userdata?.id != null &&
                                        MemoryManagement.getuserId() != userdata
                                            .id
                                            .toString() && isFollowed != -1),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatScreen(
                                                        widget.userdata)));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 5,
                                            bottom: 5),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.white)),
                                        child: Text("Message",
                                            style:
                                            TextStyle(color: Colors.white)),
                                      ),
                                    ))
                              ],
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      Visibility(
                          visible: userdata != null
                              ? userdata != null
                              ? userdata.id != null
                              ? (MemoryManagement.getuserId().compareTo(
                              userdata.id.toString()) ==
                              0)
                              ? false
                              : true
                              : false
                              : false
                              : false,
                          child: isnotificationvisible == false
                              ? IconButton(
                            icon: Icon(Icons.notifications),
                            color: Colors.white,
                            onPressed: () {
                              getnotificationvalue(isnotificationvisible);
                              setState(() {
                                isnotificationvisible = true;
                              });
                            },
                          )
                              : IconButton(
                            icon: Icon(Icons.notifications_off_outlined),
                            color: Colors.white,
                            onPressed: () {
                              getnotificationvalue(isnotificationvisible);
                              setState(() {
                                isnotificationvisible = false;
                              });
                            },
                          ))
                    ],
                  )),
              Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height - 300,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child:
                  TabBarView(controller: _tabController, children: <Widget>[
                    RefreshIndicator(
                        onRefresh: () async {
                          isuserpostloading = false;
                          currentPage = 1;
                          userallposts = false;
                          // _profileHomeViewModel.setLoading();
                          if (isuserpostloading == false &&
                              userallposts == false) {
                            setState(() {
                              isuserpostloading = true;
                            });
                            return getuserposts(true, currentPage);
                          }
                        },
                        child: Stack(
                          children: <Widget>[
                            // Stack(
                            //   children: [
                            Visibility(
                              // visible: isuserpostloading == false
                              //     ? true
                              //     : false,
                                visible: isDataLoaded == true
                                    ? getuserpostlist.length > 0
                                    ? true
                                    : false
                                    : false,
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Flexible(
                                        flex: 1,
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: 0, top: 15),
                                          color: getColorFromHex(
                                              AppColors.black),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: 15, bottom: 10),
                                                child: Text(
                                                  "Uploads",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontStyle:
                                                      FontStyle.italic),
                                                ),
                                              ),
                                              NotificationListener<
                                                  ScrollNotification>(
                                                  onNotification:
                                                      (ScrollNotification
                                                  scroll) {
                                                    if (isuserpostloading ==
                                                        false &&
                                                        userallposts ==
                                                            false &&
                                                        scroll.metrics
                                                            .pixels ==
                                                            scroll.metrics
                                                                .maxScrollExtent) {
                                                      setState(() {
                                                        // isuserpostloading = true;
                                                        currentPage++;
                                                        getuserposts(false,
                                                            currentPage);
                                                      });
                                                    }
                                                    return;
                                                  },
                                                  child: Expanded(
                                                    child: ListView.builder(
                                                        padding:
                                                        EdgeInsets.only(
                                                            bottom: 20),
                                                        itemCount:
                                                        getuserpostlist
                                                            .length,
                                                        shrinkWrap: true,
                                                        scrollDirection:
                                                        Axis.vertical,
                                                        itemBuilder:
                                                            (BuildContext
                                                        context,
                                                            int index) {
                                                          return Column(
                                                            children: <
                                                                Widget>[
                                                              Row(
                                                                children: <
                                                                    Widget>[
                                                                  Visibility(
                                                                      visible: getuserpostlist[index]
                                                                          .postType ==
                                                                          1
                                                                          ? false
                                                                          : true,
                                                                      child:
                                                                      Container(
                                                                        width:
                                                                        200,
                                                                        height:
                                                                        100,
                                                                        margin: EdgeInsets
                                                                            .fromLTRB(
                                                                            20,
                                                                            10,
                                                                            0,
                                                                            10),
                                                                        child:
                                                                        Stack(
                                                                          children: <
                                                                              Widget>[
                                                                            FutureBuilder(
                                                                                future: getThumbnail(
                                                                                    APIs
                                                                                        .userpostvideosbaseurl +
                                                                                        getuserpostlist[index]
                                                                                            .postMediaUrl),
                                                                                builder: (
                                                                                    BuildContext context,
                                                                                    snapshot) {
                                                                                  if (snapshot
                                                                                      .connectionState ==
                                                                                      ConnectionState
                                                                                          .done) {
                                                                                    return Positioned
                                                                                        .fill(
                                                                                      child: Image
                                                                                          .memory(
                                                                                        snapshot
                                                                                            .data,
                                                                                        fit: BoxFit
                                                                                            .cover,
                                                                                      ),
                                                                                    );
                                                                                  } else {
                                                                                    return SpinKitCircle(
                                                                                      itemBuilder: (
                                                                                          BuildContext context,
                                                                                          int index) {
                                                                                        return DecoratedBox(
                                                                                          decoration: BoxDecoration(
                                                                                            color: Colors
                                                                                                .white,
                                                                                          ),
                                                                                        );
                                                                                      },
                                                                                    );
                                                                                  }
                                                                                })
                                                                          ],
                                                                        ),
                                                                      )),
                                                                  Visibility(
                                                                      visible: getuserpostlist[index]
                                                                          .postType ==
                                                                          1
                                                                          ? true
                                                                          : false,
                                                                      child: Container(
                                                                          margin: EdgeInsets
                                                                              .fromLTRB(
                                                                              20,
                                                                              10,
                                                                              0,
                                                                              10),
                                                                          width: 200,
                                                                          height: 100,
                                                                          child: getCachedNetworkImage(
                                                                              url: APIs
                                                                                  .userpostimagesbaseurl +
                                                                                  getuserpostlist[index]
                                                                                      .postMediaUrl,
                                                                              fit: BoxFit
                                                                                  .cover))),
                                                                  new Container(
                                                                      height:
                                                                      100,
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                          left:
                                                                          10,
                                                                          top:
                                                                          10),
                                                                      child:
                                                                      Column(
                                                                        children: <
                                                                            Widget>[
                                                                          Text(
                                                                            getuserpostlist[index]
                                                                                .postCaption !=
                                                                                null
                                                                                ? getuserpostlist[index]
                                                                                .postCaption
                                                                                : "",
                                                                            style: TextStyle(
                                                                                color: Colors
                                                                                    .white),
                                                                          ),
                                                                          // Text(getuserpostlist[index].+" Likes")
                                                                        ],
                                                                      ))
                                                                ],
                                                              )
                                                            ],
                                                          );
                                                        }),
                                                  )),
                                            ],
                                          ),
                                        )),
                                  ],
                                )),
                            getFullScreenProviderLoaderWithOutbackground(
                                status: isuserpostloading, context: context),
                            //   ],
                            // ),
                            Visibility(
                              visible: isDataLoaded == true
                                  ? getuserpostlist.length <= 0
                                  ? true
                                  : false
                                  : false,
                              child: Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height,
                                  color: getColorFromHex(AppColors.black),
                                  child: Center(
                                    child: Text(
                                      "No Data Found",
                                      style: TextStyle(
                                          fontSize: 18.0, color: Colors.white),
                                    ),
                                  )),
                            )
                          ],
                        )),
                    Stack(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 5, top: 5),
                                child: new Theme(
                                    data: Theme.of(context).copyWith(
                                      canvasColor:
                                      getColorFromHex(AppColors.black),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                        child: ButtonTheme(
                                          alignedDropdown: true,
                                          child: DropdownButton<String>(
                                            icon: Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded),
                                            iconEnabledColor: Colors.white,
                                            items: <String>[
                                              'Sort by',
                                              // 'Year',
                                              'Newest',
                                              'Oldest'
                                            ].map((String value) {
                                              return new DropdownMenuItem<
                                                  String>(
                                                value: value,
                                                child: new Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                sortbyselecttext = value;
                                                currentPage = 0;
                                                getallvideopost(
                                                    true, currentPage);
                                              });
                                            },
                                            value: sortbyselecttext,
                                            style: new TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        )))),
                            Expanded(
                              child: NotificationListener<ScrollNotification>(
                                  onNotification: (ScrollNotification scroll) {
                                    if (isuserpostloading == false &&
                                        userallposts == false &&
                                        scroll.metrics.pixels ==
                                            scroll.metrics.maxScrollExtent) {
                                      setState(() {
                                        // isuserpostloading = true;
                                        currentPage++;
                                        getallvideopost(false, currentPage);
                                      });
                                    }
                                    return;
                                  },
                                  child: ListView.builder(
                                      padding: EdgeInsets.only(bottom: 20),
                                      itemCount: getallvideolist.length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PostScreen(
                                                            getallvideolist[
                                                            index])));
                                          },
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                width: 200,
                                                height: 100,
                                                margin: EdgeInsets.fromLTRB(
                                                    20, 10, 0, 10),
                                                child: FutureBuilder(
                                                    future: getThumbnail(APIs
                                                        .userpostvideosbaseurl +
                                                        getallvideolist[index]
                                                            .postMediaUrl),
                                                    builder:
                                                        (BuildContext context,
                                                        snapshot) {
                                                      if (snapshot
                                                          .connectionState ==
                                                          ConnectionState
                                                              .done) {
                                                        return Stack(
                                                          children: <Widget>[
                                                            Positioned.fill(
                                                              child:
                                                              Image.memory(
                                                                snapshot.data,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            )
                                                          ],
                                                        );
                                                      } else {
                                                        return SpinKitCircle(
                                                          itemBuilder:
                                                              (BuildContext
                                                          context,
                                                              int index) {
                                                            return DecoratedBox(
                                                              decoration:
                                                              BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      }
                                                    }),
                                              ),
                                              new Container(
                                                  height: 100,
                                                  margin: EdgeInsets.only(
                                                      left: 10, top: 10),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Text(
                                                        getallvideolist[index]
                                                            .postCaption,
                                                        maxLines: 4,
                                                        overflow:
                                                        TextOverflow.clip,
                                                        style: TextStyle(
                                                            color:
                                                            Colors.white),
                                                      ),
                                                      // Text(getuserpostlist[index].+" Likes")
                                                    ],
                                                  ))
                                            ],
                                          ),
                                        );
                                      })),
                            ),
                          ],
                        ),
                        getFullScreenProviderLoader(
                            status: isuserpostloading, context: context),
                        Visibility(
                            visible: isDataLoaded == true
                                ? getallvideolist.length <= 0
                                ? true
                                : false
                                : false,
                            child: Container(
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .height,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              child: Center(
                                  child: Text(
                                    "No Data Found",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  )),
                            ))
                      ],
                    ),
                    Stack(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                                visible: playlistdatalist.length > 0,
                                child: Container(
                                    margin: EdgeInsets.only(left: 5, top: 5),
                                    child: new Theme(
                                        data: Theme.of(context).copyWith(
                                          canvasColor:
                                          getColorFromHex(AppColors.black),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                            child: ButtonTheme(
                                              alignedDropdown: true,
                                              child: DropdownButton<String>(
                                                icon: Icon(Icons
                                                    .keyboard_arrow_down_rounded),
                                                iconEnabledColor: Colors.white,
                                                items: <String>[
                                                  'Sort by',
                                                  // 'Year',
                                                  'Newest',
                                                  'Oldest'
                                                ].map((String value) {
                                                  return new DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: new Text(value),
                                                  );
                                                }).toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    trybelistselecttext = value;
                                                    getCollectionList();
                                                  });
                                                },
                                                value: trybelistselecttext,
                                                style: new TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ))))),
                            Visibility(
                                visible: playlistdatalist.length > 0,
                                child: Expanded(
                                  child: ListView.builder(
                                      itemCount: playlistdatalist.length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.of(context,
                                                rootNavigator: true)
                                                .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    GetPlaylistPost(
                                                        playlistdatalist[
                                                        index]
                                                            .id)));
                                          },
                                          child: Row(
                                            children: <Widget>[
                                              SizedBox(
                                                width: 15,
                                              ),
                                              getImage(playlistdatalist[index]),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Container(
                                                height: 100,
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width -
                                                    270,
                                                margin: EdgeInsets.only(
                                                  right: 20,
                                                ),
                                                child: Text(
                                                  playlistdatalist[index]
                                                      .playlistName !=
                                                      null
                                                      ? playlistdatalist[index]
                                                      .playlistName
                                                      : "",
                                                  overflow: TextOverflow.clip,
                                                  maxLines: 4,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }),
                                )),
                          ],
                        ),
                        Visibility(
                          visible: isDataLoaded == true
                              ? playlistdatalist.length <= 0
                              ? true
                              : false
                              : false,
                          child: Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .height,
                              color: getColorFromHex(AppColors.black),
                              child: Center(
                                child: Text(
                                  "No Data Found",
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.white),
                                ),
                              )),
                        ),
                        getFullScreenProviderLoader(
                            status: isuserpostloading, context: context),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: 5, top: 5),
                            child: new Theme(
                                data: Theme.of(context).copyWith(
                                  canvasColor: getColorFromHex(AppColors.black),
                                ),
                                child: DropdownButtonHideUnderline(
                                    child: ButtonTheme(
                                      alignedDropdown: true,
                                      child: DropdownButton<String>(
                                        icon:
                                        Icon(Icons.keyboard_arrow_down_rounded),
                                        iconEnabledColor: Colors.white,
                                        items: <String>[
                                          'Sort by',
                                          // 'Year',
                                          'Newest',
                                          'Oldest'
                                        ].map((String value) {
                                          return new DropdownMenuItem<String>(
                                            value: value,
                                            child: new Text(value),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selecttext = value;
                                          });
                                        },
                                        value: selecttext,
                                        style: new TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )))),
                        Expanded(
                          child: GridView.builder(
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                              physics: BouncingScrollPhysics(),
                              itemCount: getallimageslist.length,
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              itemBuilder: (BuildContextcontext, int index) {
                                return GestureDetector(
                                    onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PostScreen(
                                                  getallimageslist[
                                                  index])));
                                },
                                child: Card(
                                margin: EdgeInsets.symmetric(
                                vertical: 1, horizontal: 1),
                                shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                Radius.circular(8),
                                )),

                                child:
                                Container(
                                margin:EdgeInsets.all(2),
                                width: 100,
                                height: 100,
                                child: getCachedNetworkImage(url: APIs.userpostimagesbaseurl+getallimageslist[index].postMediaUrl,
                                fit: BoxFit
                                .
                                fill
                                )
                                )
                                ,
                                ));
                              }),
                        ),
                      ],
                    ),
                    Stack(
                      children: <Widget>[
                        istrybegoupprivate == false ? reference != null
                            ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Text("TrybeGroups", style: TextStyle(
                                  color: Colors.white, fontSize: 20),),
                            ),

                            Container(
                                margin: EdgeInsets.only(
                                    left: 25, top: 10, bottom: 20),
                                child: FirebaseAnimatedList(
                                  padding: EdgeInsets.all(0),
                                  shrinkWrap: true,
                                  query: reference ?? "",
                                  reverse: true,
                                  sort: (a, b) => b.key.compareTo(a.key),
                                  //comparing timestamp of messages to check which one would appear first
                                  itemBuilder: (_, DataSnapshot messageSnapshot,
                                      Animation<double> animation, int index) {
                                    print("index= $index");
                                    print("index= ${messageSnapshot.value}");
                                    return GestureDetector(
                                      onTap: () {
                                        String groupname = messageSnapshot
                                            .value['groupname'] != null
                                            ? messageSnapshot.value['groupname']
                                            : "";
                                        String admin = messageSnapshot
                                            .value['admin'] != null
                                            ? messageSnapshot.value['admin']
                                            : "";
                                        String keys = messageSnapshot.key;
                                        // Navigator.of(context,rootNavigator: true).
                                        // push(MaterialPageRoute(builder: (context) => GroupChat(groupname,admin,keys)));
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 10),
                                        child: Text(
                                          messageSnapshot.value['groupname'] !=
                                              null ? messageSnapshot
                                              .value['groupname'] : "",
                                          style: TextStyle(color: Colors.white,
                                              fontSize: 18),),
                                      ),
                                    );
                                  },
                                )

                            )
                          ],
                        )
                            : Container(
                          child: Center(child: Text("No Data Found",
                            style: TextStyle(color: Colors.white, fontSize: 20
                                , fontWeight: FontWeight.bold),),),
                        ) : Container(
                          child: Center(
                            child: Text("No Data Found", style: TextStyle(
                                color: Colors.white, fontSize: 20
                                , fontWeight: FontWeight.bold),),),
                        )
                      ],
                    ),
                    userdata.about != null
                        ? userdata.about.isNotEmpty
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin:
                            EdgeInsets.only(left: 10, top: 10),
                            child: Text(
                              "About",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        seperationline(1),
                        Container(
                            margin:
                            EdgeInsets.only(left: 10, top: 10),
                            child: Text(
                              userdata.about != null
                                  ? userdata.about
                                  : "",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        seperationline(1),
                        Container(
                            margin:
                            EdgeInsets.only(left: 10, top: 10),
                            child: Text(
                              userdata.createdAt != null
                                  ? "Joined " +
                                  formatDateString(
                                      userdata.createdAt,
                                      "dd-MMM-yyyy")
                                  : "",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14),
                            )),
                      ],
                    )
                        : Container(
                      child: Center(
                        child: Text(
                          "No Data Found",
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                        : Container(
                      child: Center(
                        child: Text(
                          "No Data Found",
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                    // Visibility(
                    //     visible:  userdata.about!=null?userdata.about.isNotEmpty?true:false:false,
                    //     child: ),
                  ]))
            ],
          ),
        ));
  }

  Widget getImage(PlaylistData playlistData) {
    if (playlistData.postType != null &&
        playlistData.postMediaUrl != null &&
        playlistData.postMediaUrl
            .trim()
            .length > 0) {
      if (playlistData.postType == 2) {
        return Container(
          width: 200,
          height: 100,
          margin: EdgeInsets.all(2),
          child: FutureBuilder(
              future: getThumbnail(playlistData.postMediaUrl),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Stack(
                    children: <Widget>[
                      snapshot != null
                          ? snapshot.data != null
                          ? Positioned.fill(
                        child: Image.memory(
                          snapshot.data,
                          fit: BoxFit.cover,
                        ),
                      )
                          : Positioned.fill(
                          child: Image.network(
                              "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80",
                              fit: BoxFit.cover))
                          : Positioned.fill(
                          child: Image.network(
                              "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80",
                              fit: BoxFit.cover))
                    ],
                  );
                } else {
                  return SpinKitCircle(
                    itemBuilder: (BuildContext context, int index) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                      );
                    },
                  );
                }
              }),
        );
      } else {
        return Container(
          width: 200,
          height: 100,
          margin: EdgeInsets.all(2),
          child: getCachedNetworkImage(
              url: playlistData.postMediaUrl, fit: BoxFit.cover),
        );
      }
    } else {
      return new Container(
        width: 200,
        height: 100,
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            image: new DecorationImage(
                fit: BoxFit.cover,
                image: new NetworkImage(
                    "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80"))),
      );
    }
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

  getprofilepic() {
    if (userdata != null &&
        userdata != null &&
        userdata.userImage != null &&
        userdata.userImage.isNotEmpty) {
      if (userdata.userImage.contains("https") ||
          userdata.userImage.contains("http")) {
        return NetworkImage(userdata.userImage);
      } else {
        return NetworkImage(APIs.userprofilebaseurl + userdata.userImage);
      }
    } else {
      return NetworkImage(
          "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80");
    }
  }

  Widget _individualTab(String text, bool isChecked) {
    return Tab(
      text: text,
    );
  }

  void followunfollowapi(String key) async {
    Followunfollowparams request = Followunfollowparams();
    request.userid = MemoryManagement.getuserId();
    request.followerId = userdata.id.toString();
    request.key = key;

    var response = await _profileViewModel.followunfollow(request, context);
    Followunfollowresponse followunfollowresponse = response;
    if (followunfollowresponse != null) {
      if (followunfollowresponse.status.compareTo("success") == 0) {
        if (key.compareTo("1") == 0) {
          setState(() {
            // keyvalue = "2";
            // followtext = "Unfollow";
            // isFollow = true;
            isFollowed = 2;
          });
        } else if (key.compareTo("2") == 0) {
          setState(() {
            // keyvalue = "1";
            // followtext = "Follow";
            // isFollow = false;
            isFollowed = 0;
          });
        }
      } else {
        displaytoast(followunfollowresponse.message, context);
      }
    }
  }

  void getuserposts(bool isClear, int currentPage) async {
    _profileViewModel.setLoading();
    Getuserpostparams request = Getuserpostparams();
    request.uid = MemoryManagement.getuserId();
    request.other_uid = widget.userdata.id.toString();
    request.page = currentPage.toString();
    request.limit = limit.toString();

    var response = await _profileViewModel.getuserposts(request, context);
    Getuserpostresponse getuserpostresponse = response;
    if (isClear == true) {
      getuserpostlist.clear();
    }

    if (getuserpostresponse != null) {
      if (getuserpostresponse.checkPrivateData != null) {
        if (getuserpostresponse.checkPrivateData.isGroupPrivate.compareTo(
            "0") == 0) {
          setState(() {
            istrybegoupprivate = false;
            print("istrybegroup=>,${istrybegoupprivate}");
            print("istrybegroup=>,${getuserpostresponse.checkPrivateData
                .isGroupPrivate}");
          });
        }

        else {
          setState(() {
            istrybegoupprivate = true;
            print("istrybegroup=>,${istrybegoupprivate}");
            print("istrybegroup=>,${getuserpostresponse.checkPrivateData
                .isGroupPrivate}");
          });
        }
      } else {
        istrybegoupprivate = false;
      }
    }

    if (getuserpostresponse != null &&
        getuserpostresponse.postData != null &&
        getuserpostresponse.postData.isfollowed != null) {
      // print("istrybegroup=>,${getuserpostresponse.checkPrivateData.isGroupPrivate}");
      setState(() {
        isFollowed = getuserpostresponse.postData.isfollowed;
        // if (isFollow == true) {
        //   keyvalue = "2";
        //   followtext = "UnFollow";
        // } else {
        //   keyvalue = "1";
        //   followtext = "Follow";
        // }

        print(
            "isnotification=>${getuserpostresponse.postData
                .isNotificationOff}");

        isnotificationvisible =
        getuserpostresponse.postData.isNotificationOff == true
            ? false
            : true;
      });
    }

    if (getuserpostresponse != null &&
        getuserpostresponse.postData.data != null &&
        getuserpostresponse.postData.data.length > 0) {
      if (getuserpostresponse.postData.data.length < limit) {
        userallposts = true;
        isuserpostloading = false;
      }
      if (getuserpostresponse != null) {
        if (getuserpostresponse.status != null &&
            getuserpostresponse.status.isNotEmpty) {
          if (getuserpostresponse.status.compareTo("success") == 0) {
            getuserpostlist.addAll(getuserpostresponse.postData.data);
            print("listsize,${getuserpostlist.length}");
            currentPage = 2;
            setState(() {});
          } else {}
        }
      }
      setState(() {
        isuserpostloading = false;
        isDataLoaded = true;
      });
    } else {
      print("listsize,${getuserpostlist.length}");
      userallposts = true;
      setState(() {
        isuserpostloading = false;
        isDataLoaded = true;
      });
    }
  }

  void getnotificationvalue(bool isnotificationvisible) async {
    _profileViewModel.setLoading();
    NotificationoffParams request = NotificationoffParams();
    request.uid = MemoryManagement.getuserId();
    request.otherUid = widget.userdata.id.toString();
    request.notificationValue = isnotificationvisible == false ? "1" : "0";

    var response = await _profileViewModel.notificationoffapi(request, context);
    NotificationoffResponse notificationoffResponse = response;
    if (notificationoffResponse != null &&
        notificationoffResponse.status != null &&
        notificationoffResponse.status.compareTo("success") == 0) {
      // setState(() {
      // isnotificationvisible
      // });
    }
  }

  getCoverPhoto(String coverphoto) {
    if (coverphoto.contains("https") || coverphoto.contains("http")) {
      return coverphoto;
    } else {
      return APIs.user_cover_photo + coverphoto;
    }
  }

  getthumbnail(String url) async {
    return Image.memory(await VideoThumbnail.thumbnailData(
      video: url,
      imageFormat: ImageFormat.PNG,
      maxWidth: 128,
      // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 25,
    ));
  }

  getfollowunfollow() {
    if (isFollowed == 0) {
      return InkWell(
        onTap: () {
          // setState(() {
          //
          // });
          followunfollowapi("1");
        },
        child: Container(
          padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 5,
              bottom: 5),
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.white)),
          child: Text("Follow",
              style:
              TextStyle(color: Colors.white)),
        ),
      );
    } else if (isFollowed == 1) {
      return InkWell(
        onTap: () {
          // var updatedvalue = keyvalue;
          // if (updatedvalue.compareTo("1") == 0) {
          //   setState(() {
          //     followtext = "Unfollow";
          //     isFollow = true;
          //   });
          // } else {
          //   setState(() {
          //     followtext = "Follow";
          //     isFollow = false;
          //   });
          // }
          followunfollowapi("2");
        },
        child: Container(
          padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 5,
              bottom: 5),
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.white)),
          child: Text("UnFollow",
              style:
              TextStyle(color: Colors.white)),
        ),
      );
    } else if (isFollowed == 2) {
      return InkWell(
        onTap: () {
          // var updatedvalue = keyvalue;
          // if (updatedvalue.compareTo("1") == 0) {
          //   setState(() {
          //     followtext = "Unfollow";
          //     isFollow = true;
          //   });
          // } else {
          //   setState(() {
          //     followtext = "Follow";
          //     isFollow = false;
          //   });
          // }
          // followunfollowapi(keyvalue);
        },
        child: Container(
          padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 5,
              bottom: 5),
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.white)),
          child: Text("Request Sent",
              style:
              TextStyle(color: Colors.white)),
        ),
      );
    }
    else {
      return Container();
    }
  }

  void getgroupname() async {
    dataSnapshot = await reference.orderByKey().once();
    dataSnapshot.key;
    print("length== ${dataSnapshot}");
    setState(() {

    });
  }


  getsortbytext() {
    if (sortbyselecttext.compareTo("Sort by") == 0 ||
        sortbyselecttext.compareTo("Newest") == 0) {
      return sortby = "newest";
    } else if (sortbyselecttext.compareTo("Oldest") == 0) {
      return sortby = "oldest";
    } /*else if(sortbyselecttext.compareTo("Year")==0){
      return sortby = "year";
    }*/


  }


  gettrybelistsortbytext() {
    if (trybelistselecttext.compareTo("Sort by") == 0 ||
        trybelistselecttext.compareTo("Newest") == 0) {
      return trybelistsortby = "newest";
    } else if (trybelistselecttext.compareTo("Oldest") == 0) {
      return trybelistsortby = "oldest";
    } /*else if(trybelistselecttext.compareTo("Year")==0){
      return trybelistsortby = "year";
    }*/


  }
}
