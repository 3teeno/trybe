import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trybelocker/Recentpostuserlist.dart';
import 'package:trybelocker/casting.dart';
import 'package:trybelocker/comments.dart';
import 'package:trybelocker/model/getallposts/getallpostresponse.dart';
import 'package:trybelocker/model/getallposts/getallpostsparams.dart';
import 'package:trybelocker/model/likepost/likepostparams.dart';
import 'package:trybelocker/model/likepost/likepostresponse.dart';
import 'package:trybelocker/model/recentuserlist/getrecentuserlistparams.dart';
import 'package:trybelocker/model/recentuserlist/getrecentuserlistresponse.dart';
import 'package:trybelocker/model/reportpost/reportpost_params.dart';
import 'package:trybelocker/model/reportpost/reportpost_response.dart';
import 'package:trybelocker/networkmodel/APIs.dart';
import 'package:trybelocker/notifications.dart';
import 'package:trybelocker/publicprofile/publicprofilescreen.dart';
import 'package:trybelocker/recentuserpostlist.dart';
import 'package:trybelocker/search.dart';
import 'package:trybelocker/service/MyService.dart';
import 'package:trybelocker/settings/settings.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/video_player/videoplayer.dart';
import 'package:trybelocker/viewmodel/home_view_model.dart';
import 'package:provider/src/provider.dart';
import 'package:trybelocker/viewmodel/news_view_model.dart';
import 'UniversalFunctions.dart';
import 'package:share/share.dart';

import 'model/createplaylist/createplaylistparams.dart';
import 'model/createplaylist/createplaylistresponse.dart';
import 'model/favouritecollectios/collection_list_params.dart';
import 'model/favouritecollectios/collection_list_response.dart';
import 'model/favouritecollectios/create_collection_params.dart';
import 'model/favouritecollectios/create_collectionresponse.dart';
import 'model/getplaylist/getplaylistparams.dart';
import 'model/getplaylist/getplaylistresponse.dart';
import 'model/savecollectionpost/save_post_collection_params.dart';
import 'model/savecollectionpost/savepostcollectionresponse.dart';
import 'package:trybelocker/service/service_locator.dart';

import 'model/savecollectionpost/unsave_collection_post_response.dart';
import 'model/savetrybelist/savetrybelistparams.dart';
import 'model/savetrybelist/savetrybelistresponse.dart';
import 'model/search/search_response.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';

class NewsFeed extends StatefulWidget {
  ScrollController controller;
  HomeViewModel homeViewModel;
  NewsFeed({Key key, this.controller, this.homeViewModel}) : super(key: key);

  NewsFeedState createState() => NewsFeedState();
}

class NewsFeedState extends State<NewsFeed> {
  NewsViewModel _newsViewModel;
  // HomeViewModel _homeViewModel;
  int currentPage = 1;
  int limit = 10;
  List<Data> getallpostlist = [];
  List<DataUsers> getrecentuserlist = [];
  bool isnearpostLoading = false;
  List<CollectionData> collectiondatalist = [];
  List<PlaylistData> playlistdata = [];
  bool allnearPost = false;
  DataUser user;
  bool isDataLoaded = false;
  InterstitialAd myInterstitial;
  BannerAd myBanner;

  bool isadloaded = false;
  var controller = ScrollController();

  @override
  void initState() {
    super.initState();
    new Future.delayed(const Duration(milliseconds: 300), () {
      getNewsFeed();
    });
  }

  void getNewsFeed() {
    // initalizeInterstial();
    // myInterstitial.load();
    // initialzeBanners();
    // myBanner.load();

    isDataLoaded = false;
    isnearpostLoading = false;
    currentPage = 1;
    allnearPost = false;
    _newsViewModel.setLoading();
    if (isnearpostLoading == false && allnearPost == false) {
      setState(() {
        isnearpostLoading = true;
      });
      getrecentuser();
      getallPosts(true, currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    _newsViewModel = Provider.of<NewsViewModel>(context);
    // _homeViewModel = Provider.of<HomeViewModel>(context);

    var newsFeed = NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scroll) {
          if (isnearpostLoading == false &&
              allnearPost == false &&
              scroll.metrics.pixels == scroll.metrics.maxScrollExtent) {
            setState(() {
              // _newsViewModel.setLoading();
              isnearpostLoading = true;
              currentPage++;
              getallPosts(false, currentPage);
            });
          }
          return;
        },
        child: Expanded(
          child: ListView.builder(
              padding: EdgeInsets.only(bottom: 20),
              itemCount: getallpostlist.length,
              shrinkWrap: true,
              controller: controller,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                if (getallpostlist[index].isAdd) {
                    var myBanner = BannerAd(
                      adUnitId: 'ca-app-pub-7410464693885383/1095703406',
                      size: AdSize(
                          width: MediaQuery.of(context).size.width.toInt(),
                          height: 350),
                      request: AdRequest(),
                      listener: new BannerAdListener(
                        // Called when an ad is successfully received.
                        onAdLoaded: (Ad ad) {
                          setState(() {
                            isadloaded = true;
                          });
                        },
                        // Called when an ad request failed.
                        onAdFailedToLoad: (Ad ad, LoadAdError error) {
                          // Dispose the ad here to free resources.
                          setState(() {
                            isadloaded = false;
                          });
                          // ad.dispose();
                          print('Ad failed to load: $error');
                        },
                        // Called when an ad opens an overlay that covers the screen.
                        onAdOpened: (Ad ad) => print('Ad opened.'),
                        // Called when an ad removes an overlay that covers the screen.
                        onAdClosed: (Ad ad) => print('Ad closed.'),
                        // Called when an impression occurs on the ad.
                        onAdImpression: (Ad ad) => print('Ad impression.'),
                      ),
                    );
                    myBanner.load();
                    return Column(
                      children: <Widget>[
                        Container(
                          child: AdWidget(
                            ad: myBanner,
                          ),
                          width: myBanner.size.width.toDouble(),
                          height: myBanner.size.height.toDouble(),
                        ),
                        seperationline(2)
                      ],
                    );
                  
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                  margin: EdgeInsets.only(left: 7),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          widget.homeViewModel.controller
                                              .add(true);
                                          navigateToNextScreen(
                                              context,
                                              true,
                                              PublicProfileScreen(
                                                  getallpostlist[index]
                                                      .userInfo));
                                        },
                                        child: new Container(
                                          width: 30,
                                          height: 30,
                                          margin: EdgeInsets.all(2),
                                          child: ClipOval(
                                            child: getProfileImage(
                                                getallpostlist[index]
                                                            .userInfo
                                                            .userImage !=
                                                        null
                                                    ? getallpostlist[index]
                                                        .userInfo
                                                        .userImage
                                                    : ""),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        getallpostlist[index]
                                                    .userInfo
                                                    .username !=
                                                null
                                            ? getallpostlist[index]
                                                    .userInfo
                                                    .username
                                                    .isNotEmpty
                                                ? getallpostlist[index]
                                                    .userInfo
                                                    .username
                                                : ""
                                            : "",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white),
                                      ),
                                      new Spacer(),
                                      new InkWell(
                                        onTap: () {
                                          setState(() {
                                            print("indexnumber=>,${index}");
                                            bool value = getallpostlist[index]
                                                        .isSelected !=
                                                    null
                                                ? getallpostlist[index]
                                                    .isSelected
                                                : false;

                                            for (int k = 0;
                                                k < getallpostlist.length;
                                                k++) {
                                              if (k == (index)) {
                                                if (value == true) {
                                                  getallpostlist[k]
                                                      .setMenuData(false);
                                                } else {
                                                  getallpostlist[k]
                                                      .setMenuData(true);
                                                }
                                              } else {
                                                getallpostlist[k]
                                                    .setMenuData(false);
                                              }
                                            }
                                          });
                                        },
                                        child: Icon(
                                          Icons.more_vert,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Visibility(
                                  visible: getallpostlist[index].postType == 1
                                      ? false
                                      : true,
                                  child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 400,
                                      margin: EdgeInsets.only(top: 10),
                                      child: VideoPlayerScreen(
                                        APIs.userpostvideosbaseurl +
                                            getallpostlist[index].postMediaUrl,
                                        false,
                                        getallpostlist[index].id.toString(),
                                      ))),
                              Visibility(
                                  visible: getallpostlist[index].postType == 1
                                      ? true
                                      : false,
                                  child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 400,
                                      child: Stack(
                                        children: [
                                          getCachedNetworkImage(
                                              url: APIs.userpostimagesbaseurl +
                                                  getallpostlist[index]
                                                      .postMediaUrl,
                                              fit: BoxFit.cover),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 400,
                                            color:
                                                Colors.white.withOpacity(0.4),
                                          ),
                                          getCachedNetworkImage(
                                              url: APIs.userpostimagesbaseurl +
                                                  getallpostlist[index]
                                                      .postMediaUrl,
                                              fit: BoxFit.contain)
                                        ],
                                      ))),
                              Container(
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, top: 10),
                                  child: Row(
                                    children: <Widget>[
                                      Visibility(
                                          visible: getallpostlist[index]
                                                      .isliked !=
                                                  null
                                              ? getallpostlist[index].isliked ==
                                                      true
                                                  ? false
                                                  : true
                                              : true,
                                          child: Container(
                                              // margin: EdgeInsets.only(bottom: 0, right: 10),
                                              child: Row(
                                            children: <Widget>[
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: InkWell(
                                                    onTap: () {
                                                      postlike(getallpostlist[
                                                          index]);
                                                    },
                                                    child: Icon(
                                                      Icons.favorite_border,
                                                      color: Colors.white,
                                                      size: 26,
                                                    )),
                                              ),
                                              SizedBox(
                                                width: 2,
                                              ),
                                              Text(
                                                getallpostlist[index]
                                                        .likes
                                                        .toString() +
                                                    " likes",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ))),
                                      // Spacer(),
                                      Visibility(
                                          visible: getallpostlist[index]
                                                      .isliked !=
                                                  null
                                              ? getallpostlist[index].isliked ==
                                                      true
                                                  ? true
                                                  : false
                                              : false,
                                          child: Row(
                                            children: <Widget>[
                                              InkWell(
                                                  onTap: () {
                                                    postdislike(
                                                        getallpostlist[index]);
                                                  },
                                                  child: Icon(
                                                    Icons.favorite,
                                                    color: getColorFromHex(
                                                        AppColors.red),
                                                    size: 26,
                                                  )),
                                              SizedBox(
                                                width: 2,
                                              ),
                                              Text(
                                                getallpostlist[index]
                                                        .likes
                                                        .toString() +
                                                    " likes",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          )),
                                      Spacer(),
                                      Row(
                                        children: <Widget>[
                                          GestureDetector(
                                              child: Icon(
                                                Icons.message,
                                                color: Colors.white,
                                              ),
                                              onTap: () {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .push(MaterialPageRoute(
                                                        builder: (context) =>
                                                            CommentScreen(
                                                                getallpostlist[
                                                                        index]
                                                                    .id)))
                                                    .then((value) =>
                                                        getallpostlist[index]
                                                            .comment = value);
                                                // navigateToNextScreen(context,
                                                //     true, CommentScreen(getallpostlist[index].id));
                                              }),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                              getallpostlist[index]
                                                  .comment
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.white))
                                        ],
                                      )
                                    ],
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.only(
                                          left: 20 /*,bottom: 20*/),
                                      width: MediaQuery.of(context).size.width -
                                          64,
                                      child: Text(
                                        getallpostlist[index].postCaption !=
                                                null
                                            ? getallpostlist[index]
                                                        .postCaption
                                                        .trim()
                                                        .length >
                                                    0
                                                ? getallpostlist[index]
                                                    .postCaption
                                                : ""
                                            : "",
                                        // maxLines: 3,
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            fontStyle: FontStyle.italic),
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              seperationline(2),
                            ],
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Visibility(
                              visible: getallpostlist[index].isSelected != null
                                  ? getallpostlist[index].isSelected
                                  : false,
                              // visible: false,
                              child: Container(
                                color: getColorFromHex(AppColors.black),
                                margin: EdgeInsets.only(top: 60, right: 5),
                                height: 200,
                                width: 200,
                                child: Column(
                                  children: <Widget>[
                                    Stack(
                                      children: <Widget>[
                                        Visibility(
                                            visible:
                                                getallpostlist[index].isSaved ==
                                                        false
                                                    ? true
                                                    : false,
                                            child: GestureDetector(
                                              onTap: () {
                                                for (int k = 0;
                                                    k < getallpostlist.length;
                                                    k++) {
                                                  getallpostlist[k]
                                                      .setMenuData(false);
                                                }
                                                getCollectionList(
                                                    getallpostlist[index].id,
                                                    index);
                                              },
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Container(
                                                  width: 200,
                                                  padding: EdgeInsets.all(10),
                                                  child: Text(
                                                    'Save to Favorites Folder',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontSize: 14,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            )),
                                        Visibility(
                                            visible:
                                                getallpostlist[index].isSaved ==
                                                        false
                                                    ? false
                                                    : true,
                                            child: GestureDetector(
                                              onTap: () {
                                                for (int k = 0;
                                                    k < getallpostlist.length;
                                                    k++) {
                                                  getallpostlist[k]
                                                      .setMenuData(false);
                                                }
                                                unsavefromcollection(
                                                    getallpostlist[index].id,
                                                    getallpostlist[index]
                                                        .collectionId,
                                                    index);
                                              },
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Container(
                                                  width: 200,
                                                  padding: EdgeInsets.all(10),
                                                  child: Text(
                                                    'Unsave from Favorites Folder',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontSize: 14,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ))
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          for (int k = 0;
                                              k < getallpostlist.length;
                                              k++) {
                                            getallpostlist[k]
                                                .setMenuData(false);
                                          }
                                        });
                                        MyService service =
                                            locator<MyService>();
                                        if (getallpostlist[index].postType ==
                                            1) {
                                          service.startdownload(
                                              APIs.userpostimagesbaseurl +
                                                  getallpostlist[index]
                                                      .postMediaUrl,
                                              getallpostlist[index]
                                                  .postType
                                                  .toString());
                                        } else {
                                          service.startdownload(
                                              APIs.userpostvideosbaseurl +
                                                  getallpostlist[index]
                                                      .postMediaUrl,
                                              getallpostlist[index]
                                                  .postType
                                                  .toString());
                                        }
                                      },
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          width: 200,
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            'Download',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        for (int k = 0;
                                            k < getallpostlist.length;
                                            k++) {
                                          getallpostlist[k].setMenuData(false);
                                        }
                                        if (getallpostlist[index]
                                                    .postMediaUrl !=
                                                null &&
                                            getallpostlist[index]
                                                    .postMediaUrl
                                                    .trim()
                                                    .length >
                                                0) {
                                          Share.share(
                                              APIs.userpostimagesbaseurl +
                                                  getallpostlist[index]
                                                      .postMediaUrl);
                                        }
                                      },
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          width: 200,
                                          child: Text(
                                            'Share',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () {
                                          for (int k = 0;
                                              k < getallpostlist.length;
                                              k++) {
                                            getallpostlist[k]
                                                .setMenuData(false);
                                          }
                                          postreport(getallpostlist[index]);
                                        },
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            width: 200,
                                            child: Text(
                                              'Report',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 14,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )),
                                    Visibility(
                                        visible: getallpostlist[index]
                                                    .isPlaylistSaved ==
                                                false
                                            ? true
                                            : false,
                                        child: GestureDetector(
                                          onTap: () {
                                            for (int k = 0;
                                                k < getallpostlist.length;
                                                k++) {
                                              getallpostlist[k]
                                                  .setMenuData(false);
                                            }
                                            getTrybeList(
                                                getallpostlist[index].id,
                                                index);
                                          },
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Container(
                                              width: 200,
                                              padding: EdgeInsets.all(10),
                                              child: Text(
                                                'Save to TrybeList Folder',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 14,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        )),
                                    Visibility(
                                        visible: getallpostlist[index]
                                                    .isPlaylistSaved ==
                                                false
                                            ? false
                                            : true,
                                        child: GestureDetector(
                                          onTap: () {
                                            for (int k = 0;
                                                k < getallpostlist.length;
                                                k++) {
                                              getallpostlist[k]
                                                  .setMenuData(false);
                                            }
                                            unsavefromplaylist(
                                                getallpostlist[index].id,
                                                getallpostlist[index]
                                                    .playlistId,
                                                index);
                                          },
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Container(
                                              width: 200,
                                              padding: EdgeInsets.all(10),
                                              child: Text(
                                                'Unsave from TrybeList Folder',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 14,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  );
                }
              }),
        ));

    var storyList = ListView.builder(
        itemCount: getrecentuserlist.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              // bool value = getrecentuserlist[index].isuserselected != null ? getrecentuserlist[index].isuserselected
              //     : false;
              // print("check_called $value");
              // for (int k = 0;
              // k < getrecentuserlist.length;
              // k++) {
              //   if (k == index) {
              //     if (value == true) {
              //       getrecentuserlist[k]
              //           .setselecteduser(false);
              //     } else {
              //       getrecentuserlist[k]
              //           .setselecteduser(true);
              //       print(
              //           "check_called value= $value");
              //     }
              //   } else {
              //     getrecentuserlist[k]
              //         .setselecteduser(false);
              //   }
              // }
              // DataUser datausers = new DataUser();
              // datausers.id = getrecentuserlist[index].id;
              // datausers.username = getrecentuserlist[index].username;
              // datausers.userImage = getrecentuserlist[index].userImage;
              // datausers.email = getrecentuserlist[index].email;
              // datausers.phoneNumber = getrecentuserlist[index].phoneNumber;
              // datausers.fullName = getrecentuserlist[index].fullName;
              // datausers.birthDate = getrecentuserlist[index].birthDate;
              // datausers.loginType = getrecentuserlist[index].loginType;
              // datausers.socialId = getrecentuserlist[index].socialId;
              // datausers.about = getrecentuserlist[index].about;
              //
              // navigateToNextScreen(
              //     context, true, PublicProfileScreen(datausers));
              widget.homeViewModel.controller.add(true);
              Navigator.of(context, rootNavigator: true)
                  .push(MaterialPageRoute(
                      builder: (context) =>
                          RecentUserPostList(getrecentuserlist, index)))
                  .then((value) {
                getNewsFeed();
              });
            },
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Stack(
                children: [
                  Column(
                    children: <Widget>[
                      // SizedBox(height: ,10),
                      new Container(
                        width: 60,
                        height: 60,
                        margin: EdgeInsets.all(2),
                        child: ClipOval(
                          child: getProfileImage(
                              getrecentuserlist[index].userImage != null
                                  ? getrecentuserlist[index].userImage
                                  : ""),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        getrecentuserlist[index].username,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      )
                    ],
                  ),
                  // Visibility(
                  //     visible: getrecentuserlist[index].isuserselected != null
                  //         ?  getrecentuserlist[index].isuserselected
                  //         : false,
                  //     child: Container(
                  //         height: 90,
                  //         width: 70,
                  //         decoration: BoxDecoration(
                  //             shape: BoxShape.rectangle,
                  //             color: Colors.white.withOpacity(0.5))))
                ],
              ),
            ),
          );
        });

    return Scaffold(
        backgroundColor: getColorFromHex(AppColors.black),
        appBar: ScrollAppBar(
          controller: controller,
          brightness: Brightness.dark,
          backgroundColor: getColorFromHex(AppColors.black),
          automaticallyImplyLeading: false,
          title: InkWell(
              onTap: () {
                displaybottomsheet(context, widget.homeViewModel);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Image.asset(
                        "assets/white_logo.png",
                        height: 120,
                        width: 120,
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  Image.asset(
                    "assets/dropdown.png",
                    height: 15,
                    width: 15,
                    color: Colors.white,
                  )
                ],
              )),
          actions: <Widget>[
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                // navigateToNextScreen(context, true, Drag());
                widget.homeViewModel.controller.add(true);
                navigateToNextScreen(context, true, Casting());
              },
              child: Image.asset(
                "assets/streaming.png",
                height: 25,
                width: 25,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
                onTap: () {
                  widget.homeViewModel.controller.add(true);
                  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                      statusBarColor: Colors.black,
                      systemNavigationBarColor:
                          getColorFromHex(AppColors.black),
                      statusBarIconBrightness: Brightness.light,
                      systemNavigationBarIconBrightness: Brightness.light));
                  navigateToNextScreen(context, true, NotificationScreen());
                },
                child: Image.asset(
                  "assets/notification.png",
                  height: 25,
                  width: 25,
                  color: Colors.white,
                )),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
                onTap: () {
                  widget.homeViewModel.controller.add(true);
                  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                      statusBarColor: Colors.black,
                      systemNavigationBarColor:
                          getColorFromHex(AppColors.black),
                      statusBarIconBrightness: Brightness.light,
                      systemNavigationBarIconBrightness: Brightness.light));
                  navigateToNextScreen(context, true, SearchScreen());
                },
                child: Image.asset(
                  "assets/search.png",
                  height: 25,
                  width: 25,
                  color: Colors.white,
                )),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
                onTap: () {
                  widget.homeViewModel.controller.add(true);
                  if (!(MemoryManagement.getlogintype().compareTo("4") == 0)) {
                    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                        statusBarColor: Colors.black,
                        systemNavigationBarColor:
                            getColorFromHex(AppColors.black),
                        statusBarIconBrightness: Brightness.light,
                        systemNavigationBarIconBrightness: Brightness.light));
                    navigateToNextScreen(context, true, SettingsScreen());
                  } else {
                    displaytoast(
                        "You don't have access to open settings", context);
                  }
                },
                child: Icon(
                  Icons.settings_applications_outlined,
                  color: Colors.white,
                  size: 32,
                )),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        body: Snap(
          controller: controller.appBar,
          child: Stack(
            children: <Widget>[
              RefreshIndicator(
                onRefresh: () async {
                  // initialzeBanners();
                  // myBanner.load();
                  // isnearpostLoading = false;
                  // currentPage = 1;
                  // allnearPost = false;
                  // _newsViewModel.setLoading();
                  // if (isnearpostLoading == false && allnearPost == false) {
                  //   isnearpostLoading = true;
                  //   getrecentuser();
                  //   return getallPosts(true, currentPage);
                  // }
                  return getNewsFeed();
                },
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      seperationline(2),
                      Visibility(
                          visible: getrecentuserlist != null
                              ? getrecentuserlist.length > 0
                                  ? true
                                  : false
                              : false,
                          child: Container(
                              margin: EdgeInsets.only(top: 5),
                              width: MediaQuery.of(context).size.width,
                              height: 91,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width -
                                          70,
                                      child: storyList),
                                  GestureDetector(
                                      onTap: () {
                                        widget.homeViewModel.controller
                                            .add(true);
                                        navigateToNextScreen(context, true,
                                            RecentPostUserList());
                                      },
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          height: 90,
                                          width: 70,
                                          color:
                                              getColorFromHex(AppColors.black),
                                          child: Center(
                                            child: Text('All',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20)),
                                          ),
                                        ),
                                      ))
                                ],
                              ))),
                      Visibility(
                        visible: getrecentuserlist != null
                            ? getrecentuserlist.length > 0
                                ? true
                                : false
                            : false,
                        child: seperationline(2),
                      ),
                      isDataLoaded == true
                          ? getallpostlist.length > 0
                              ? /*Expanded(child: Container(
                        margin:EdgeInsets.only(top: 10),
                        child:*/
                              newsFeed
                              // ))
                              : SingleChildScrollView(
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.height -
                                              200,
                                      child: Center(
                                        child: Text(
                                          "No Data Found",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )))
                          : Container(),
                      // seperationline(),
                    ],
                  ),
                ),
              ),
              getFullScreenProviderLoader(
                  status: _newsViewModel.getLoading(), context: context)
            ],
          ),
        ));
  }

  void showFavouriteList(
      List<CollectionData> collectiondatalist, int postid, int index) {
    CollectionData data = collectiondatalist[0];
    showModalBottomSheet(
        context: context,
        builder: (context) {
          // ignore: missing_return
          return StatefulBuilder(builder: (context, setState) {
            return Stack(
              children: <Widget>[
                new Container(
                  height: 350.0,
                  color: Colors.black,
                  //so you don't have to change MaterialApp canvasColor
                  child: new Container(
                      height: 350.0,
                      padding: EdgeInsets.only(
                          left: 20, top: 20, bottom: 0, right: 20),
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(20),
                              topRight: const Radius.circular(20))),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Select favourite Folder",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: getColorFromHex(AppColors.red),
                                      fontSize: 14),
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    _newsViewModel.showCollectionLoaded();
                                  });
                                  bool gotInternetConnection =
                                      await hasInternetConnection(
                                    context: context,
                                    mounted: mounted,
                                    canShowAlert: true,
                                    onFail: () {
                                      _newsViewModel.hideCollectionLoaded();
                                    },
                                    onSuccess: () {},
                                  );
                                  if (gotInternetConnection) {
                                    Save_post_collection_params params =
                                        new Save_post_collection_params(
                                            key: "1",
                                            collectionId: data.id.toString(),
                                            postId: postid.toString());
                                    var response = await _newsViewModel
                                        .savepostcollection(params, context);
                                    Savepostcollectionresponse
                                        savecollectioresponse = response;
                                    setState(() {
                                      _newsViewModel.hideCollectionLoaded();
                                    });
                                    if (savecollectioresponse != null &&
                                        savecollectioresponse.status
                                                .compareTo("success") ==
                                            0) {
                                      updateSavedCollection(
                                          true, index, data.id);
                                      displaytoast(
                                          savecollectioresponse.message,
                                          context);
                                      Navigator.pop(context);
                                    } else if (savecollectioresponse != null) {
                                      displaytoast(
                                          savecollectioresponse.message,
                                          context);
                                    }
                                  }
                                },
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "Save",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              showCreateFoler(postid, index);
                            },
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 25,
                                ),
                                Image.asset(
                                  "assets/addwhite.png",
                                  height: 25,
                                  width: 25,
                                  color: getColorFromHex(AppColors.black),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'New Favorites Folder',
                                  style: TextStyle(
                                      color: getColorFromHex(AppColors.black),
                                      fontSize: 16),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                              child: ListView.builder(
                                  padding: EdgeInsets.only(top: 0, bottom: 10),
                                  itemCount: collectiondatalist.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return RadioListTile(
                                      value: collectiondatalist[index],
                                      title: Text(collectiondatalist[index]
                                                  .collectionName !=
                                              null
                                          ? collectiondatalist[index]
                                              .collectionName
                                          : ""),
                                      groupValue: data,
                                      onChanged:
                                          (CollectionData collectiondata) {
                                        setState(() {
                                          data = collectiondata;
                                        });
                                      },
                                    );
                                  })),
                        ],
                      )),
                ),
                Container(
                  child: getFullScreenProviderLoaders(
                      status: _newsViewModel.getCollectionLoaded(),
                      context: context),
                ),
              ],
            );
          });
        });
  }

  void showCreateFoler(int postid, int index) {
    TextEditingController foldername = new TextEditingController();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              insetPadding: EdgeInsets.all(20),
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 55,
                          ),
                          Expanded(
                            child: Container(
                              child: Text(
                                'Create Folder',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18.3),
                              ),
                            ),
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              })
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Form(
                            // key: _creditsformKey,
                            child: TextFormField(
                              // controller: creditsController,
                              maxLines: 1,
                              minLines: 1,
                              controller: foldername,
                              keyboardType: TextInputType.text,
                              autofocus: false,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "Gilroy-SemiBold",
                                  color: Color.fromRGBO(60, 72, 88, 1),
                                  fontSize: 16.7),
                              onFieldSubmitted: (trem) async {
                                if (foldername != null &&
                                    foldername.text.trim().length > 0) {
                                  Navigator.pop(context);
                                  createFolderApi(
                                      foldername, context, postid, index);
                                } else {
                                  displaytoast("Folder name required", context);
                                }
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  hintText: "Enter name",
                                  contentPadding:
                                      EdgeInsets.fromLTRB(5.0, 0, 0.0, 0.0),
                                  hintStyle: TextStyle(
                                      fontFamily: "Gilroy-Regular",
                                      fontSize: 13.3)),
                            ),
                          )),
                        ],
                      ),
                      InkWell(
                        onTap: () async {
                          if (foldername != null &&
                              foldername.text.trim().length > 0) {
                            Navigator.pop(context);
                            createFolderApi(foldername, context, postid, index);
                          } else {
                            displaytoast("Folder name required", context);
                          }
                        },
                        child: Container(
                            height: 40,
                            width: 120,
                            margin: EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                                color: getColorFromHex('#A10000')),
                            child: Center(
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                      )
                    ],
                  ),
                  Container(
                    child: getDialogLoader(
                        status: _newsViewModel.getLoading(), context: context),
                  ),
                ],
              ),
            );
          });
        });
  }

  void createFolderApi(TextEditingController foldername, BuildContext context,
      int postid, int index) async {
    _newsViewModel.setLoading();
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _newsViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Create_collection_params params = new Create_collection_params(
          userid: MemoryManagement.getuserId(),
          collectionName: foldername.text.trim());
      var response = await _newsViewModel.createcollection(params, context);
      Create_collectionresponse collectionresponse = response;
      if (collectionresponse.status.compareTo("success") == 0) {
        if (collectionresponse.collectionData != null &&
            collectionresponse.collectionData.length > 0) {
          showFavouriteList(collectionresponse.collectionData, postid, index);
        }
      }
    }
  }

  Widget getFullScreenProviderLoaders({
    @required bool status,
    @required BuildContext context,
  }) {
    return status
        ? getAppThemedLoaders(
            context: context,
          )
        : new Container(
            height: 350,
          );
  }

  Widget getAppThemedLoaders({
    @required BuildContext context,
    Color bgColor,
    Color color,
    double strokeWidth,
  }) {
    return new Container(
      color: bgColor ?? const Color.fromRGBO(1, 1, 1, 0.6),
      width: getScreenSize(context: context).width,
      height: 350,
      child: getChildLoader(
        color: color ?? AppColors.kPrimaryBlue,
        strokeWidth: strokeWidth,
      ),
    );
  }

  void getCollectionList(int postid, int index) async {
    _newsViewModel.setLoading();
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _newsViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Collection_list_params request =
          new Collection_list_params(userid: MemoryManagement.getuserId());
      var response = await _newsViewModel.getallcollections(request, context);
      Collection_list_response collectionresponse = response;
      if (collectionresponse.status.compareTo("success") == 0) {
        setState(() {
          collectiondatalist.clear();
          if (collectionresponse.collectionData != null &&
              collectionresponse.collectionData.length > 0) {
            collectiondatalist.addAll(collectionresponse.collectionData);
            showFavouriteList(collectiondatalist, postid, index);
          } else {
            displaytoast("Please create folder in favourite section", context);
          }
        });
      } else {
        displaytoast("Please create folder in favourite section", context);
      }
    }
  }

  void getallPosts(bool isClear, int currentPage) async {
    Getallpostsparams request = Getallpostsparams();
    request.userid = MemoryManagement.getuserId();
    request.page = currentPage.toString();
    request.limit = limit.toString();

    var response = await _newsViewModel.getAllPosts(request, context);
    Getallpostresponse getallpostsresponse = response;
    if (isClear == true) {
      getallpostlist.clear();
    }
    isDataLoaded = true;
    if (getallpostsresponse != null &&
        getallpostsresponse.postData.data != null &&
        getallpostsresponse.postData.data.length > 0) {
      if (getallpostsresponse.postData.data.length < limit) {
        allnearPost = true;
        isnearpostLoading = false;
      }
      if (getallpostsresponse != null) {
        if (getallpostsresponse.status != null &&
            getallpostsresponse.status.isNotEmpty) {
          if (getallpostsresponse.status.compareTo("success") == 0) {
            user = getallpostsresponse.userData;
            getallpostlist.addAll(getallpostsresponse.postData.data);

            currentPage = 2;
            setState(() {});
          } else {}
        }
      }
      setState(() {
        isnearpostLoading = false;
      });
    } else {
      allnearPost = true;
      setState(() {
        isnearpostLoading = false;
      });
    }
  }

  getprofilepic(int index) {
    if (getallpostlist[index].userInfo.userImage != null &&
        getallpostlist[index - 1].userInfo.userImage.isNotEmpty) {
      if (getallpostlist[index].userInfo.userImage.contains("https") ||
          getallpostlist[index - 1].userInfo.userImage.contains("http")) {
        return NetworkImage(getallpostlist[index].userInfo.userImage);
      } else {
        return NetworkImage(APIs.userprofilebaseurl +
            getallpostlist[index - 1].userInfo.userImage);
      }
    } else {
      return NetworkImage(
          "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80");
    }
  }

  void postlike(Data getallpostlist) async {
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {},
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Likepostparams request = Likepostparams();
      request.uid = MemoryManagement.getuserId();
      request.key = "1";
      request.postId = getallpostlist.id.toString();

      var response = await _newsViewModel.likepost(request, context);

      Likepostresponse likepostresponse = response;
      if (likepostresponse != null) {
        if (likepostresponse.status != null &&
            likepostresponse.status.isNotEmpty) {
          if (likepostresponse.status.compareTo("success") == 0) {
            setState(() {
              getallpostlist.isliked = true;
              getallpostlist.likes = getallpostlist.likes + 1;
            });
          } else {
            setState(() {
              if (getallpostlist.isliked == true) {
                getallpostlist.isliked = true;
              } else {
                getallpostlist.isliked = false;
              }
            });
          }
        }
      }
    }
  }

  void postdislike(Data getallpostlist) async {
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {},
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Likepostparams request = Likepostparams();
      request.uid = MemoryManagement.getuserId();
      request.key = "2";
      request.postId = getallpostlist.id.toString();

      var response = await _newsViewModel.dislikepost(request, context);

      Likepostresponse likepostresponse = response;
      if (likepostresponse != null) {
        if (likepostresponse.status != null &&
            likepostresponse.status.isNotEmpty) {
          if (likepostresponse.status.compareTo("success") == 0) {
            setState(() {
              getallpostlist.isliked = false;
              getallpostlist.likes = getallpostlist.likes - 1;
            });
          } else {
            setState(() {
              if (getallpostlist.isliked == true) {
                getallpostlist.isliked = true;
              } else {
                getallpostlist.isliked = false;
              }
            });
          }
        }
      }
    }
  }

  void postreport(Data getallpostlist) async {
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {},
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Reportpost_params request = Reportpost_params();
      request.userid = MemoryManagement.getuserId();
      request.postId = getallpostlist.id.toString();

      var response = await _newsViewModel.reportpost(request, context);

      Reportpost_response reportpost_response = response;
      if (reportpost_response != null) {
        if (reportpost_response.status != null &&
            reportpost_response.status.isNotEmpty) {
          if (reportpost_response.status.compareTo("success") == 0) {
            displaytoast(reportpost_response.message, context);
          } else {
            displaytoast(reportpost_response.message, context);
          }
        }
      }
    }
  }

  void getrecentuser() async {
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {},
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Getrecentuserlistparams request = Getrecentuserlistparams();
      request.uid = MemoryManagement.getuserId();
      request.limit = "20";
      request.page = "1";
      request.sort_by = "newest";
      request.key = "1";

      var response = await _newsViewModel.getrecentuserlist(request, context);

      Getrecentuserlistresponse getrecentuserlistresponse = response;
      if (getrecentuserlistresponse != null) {
        if (getrecentuserlistresponse.status != null &&
            getrecentuserlistresponse.status.isNotEmpty) {
          if (getrecentuserlistresponse.status.compareTo("success") == 0) {
            if (getrecentuserlistresponse.postData != null &&
                getrecentuserlistresponse.postData.userData != null) {
              if (getrecentuserlistresponse.postData.userData.data != null &&
                  getrecentuserlistresponse.postData.userData.data.length > 0) {
                getrecentuserlist.clear();
                getrecentuserlist
                    .addAll(getrecentuserlistresponse.postData.userData.data);
              }
            } else {}
          }
        }
      }
    }
  }

  void unsavefromcollection(int id, int collectionId, int index) async {
    _newsViewModel.setLoading();
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _newsViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Save_post_collection_params params = new Save_post_collection_params(
          key: "2",
          collectionId: collectionId.toString(),
          postId: id.toString());
      var response = await _newsViewModel.unsavepostcollection(params, context);
      Unsave_collection_post_response unsave_collection_post_response =
          response;
      if (unsave_collection_post_response.status.compareTo("success") == 0) {
        setState(() {
          collectiondatalist.clear();
          if (unsave_collection_post_response != null &&
              unsave_collection_post_response.message.length > 0) {
            displaytoast(unsave_collection_post_response.message, context);
            updateSavedCollection(false, index, 0);
          } else {
            displaytoast("Something went wrong", context);
          }
        });
      } else {
        displaytoast("Something went wrong", context);
      }
    }
  }

  void updateSavedCollection(bool status, int index, int collectionId) {
    setState(() {
      if (getallpostlist[index] != null) {
        if (status == true) {
          getallpostlist[index - 1].collectionId = collectionId;
        } else {
          getallpostlist[index - 1].collectionId = 0;
        }
        getallpostlist[index - 1].isSaved = status;
      }
    });
  }

  getProfileImage(String userImage) {
    if (userImage != null && userImage.isNotEmpty) {
      if (userImage.contains("https") || userImage.contains("http")) {
        return getCachedNetworkImage(url: userImage, fit: BoxFit.cover);
      } else {
        return getCachedNetworkImage(
            url: APIs.userprofilebaseurl + userImage, fit: BoxFit.cover);
      }
    } else {
      return getCachedNetworkImage(
          url:
              "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80",
          fit: BoxFit.cover);
    }
  }

  void getTrybeList(int postid, int index) async {
    _newsViewModel.setLoading();
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _newsViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Getplaylistparams request = new Getplaylistparams(
          uid: MemoryManagement.getuserId(),
          other_uid: MemoryManagement.getuserId());
      var response = await _newsViewModel.getplaylist(request, context);
      Getplaylistresponse getplaylistresponse = response;
      if (getplaylistresponse.status.compareTo("success") == 0) {
        setState(() {
          playlistdata.clear();
          if (getplaylistresponse.playlistData != null &&
              getplaylistresponse.playlistData.length > 0) {
            playlistdata.addAll(getplaylistresponse.playlistData);
            showPlayListFolders(playlistdata, postid, index);
          } else {
            displaytoast("No playlist found.Please create a playlist", context);
            showTrybeListFolder(postid, index);
          }
        });
      } else {
        displaytoast("Error occurred while getting the playlist", context);
      }
    }
  }

  void showPlayListFolders(
      List<PlaylistData> playlistdata, int postid, int index) {
    PlaylistData trybelistdata;
    if (playlistdata != null && playlistdata.length > 0) {
      trybelistdata = playlistdata[0];
    }

    showModalBottomSheet(
        context: context,
        builder: (context) {
          // ignore: missing_return
          return StatefulBuilder(builder: (context, setState) {
            return Stack(
              children: <Widget>[
                new Container(
                  height: 350.0,
                  color: Colors.black,
                  child: new Container(
                      height: 350.0,
                      padding: EdgeInsets.only(
                          left: 20, top: 20, bottom: 0, right: 20),
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(20),
                              topRight: const Radius.circular(20))),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Select TrybeList Folder",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: getColorFromHex(AppColors.red),
                                      fontSize: 14),
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    _newsViewModel.showCollectionLoaded();
                                  });
                                  bool gotInternetConnection =
                                      await hasInternetConnection(
                                    context: context,
                                    mounted: mounted,
                                    canShowAlert: true,
                                    onFail: () {
                                      _newsViewModel.hideCollectionLoaded();
                                    },
                                    onSuccess: () {},
                                  );
                                  if (gotInternetConnection) {
                                    Savetrybelistparams request =
                                        new Savetrybelistparams(
                                            key: "1",
                                            playlistId:
                                                trybelistdata.id.toString(),
                                            postId: postid.toString());
                                    var response = await _newsViewModel
                                        .savepostplaylist(request, context);
                                    Savetrybelistresponse
                                        savetrybelistresponse = response;
                                    setState(() {
                                      _newsViewModel.hideCollectionLoaded();
                                    });
                                    if (savetrybelistresponse.status
                                            .compareTo("success") ==
                                        0) {
                                      if (savetrybelistresponse.message !=
                                              null &&
                                          savetrybelistresponse.message
                                                  .trim()
                                                  .length >
                                              0) {
                                        displaytoast(
                                            savetrybelistresponse.message,
                                            context);
                                        updateUnsavedTrybeList(
                                            true, index, trybelistdata.id);
                                        Navigator.pop(context);
                                      } else {
                                        displaytoast(
                                            "Post saved successfully", context);
                                        updateUnsavedTrybeList(
                                            true, index, trybelistdata.id);
                                        Navigator.pop(context);
                                      }
                                    } else {
                                      displaytoast(
                                          "Error occurred while getting the playlist",
                                          context);
                                    }
                                  }
                                },
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "Save",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              showTrybeListFolder(postid, index);
                            },
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 25,
                                ),
                                Image.asset(
                                  "assets/addwhite.png",
                                  height: 25,
                                  width: 25,
                                  color: getColorFromHex(AppColors.black),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'New TryebList Folder',
                                  style: TextStyle(
                                      color: getColorFromHex(AppColors.black),
                                      fontSize: 16),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          playlistdata.length > 0
                              ? Expanded(
                                  child: ListView.builder(
                                      padding:
                                          EdgeInsets.only(top: 0, bottom: 10),
                                      itemCount: playlistdata.length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return RadioListTile(
                                            value: playlistdata[index],
                                            title: Text(playlistdata[index]
                                                        .playlistName !=
                                                    null
                                                ? playlistdata[index]
                                                    .playlistName
                                                : ""),
                                            groupValue: trybelistdata,
                                            onChanged: (PlaylistData data) {
                                              setState(() {
                                                trybelistdata = data;
                                              });
                                            });
                                      }))
                              : Container(),
                        ],
                      )),
                ),
                Container(
                  child: getFullScreenProviderLoaders(
                      status: _newsViewModel.getCollectionLoaded(),
                      context: context),
                ),
              ],
            );
          });
        });
  }

  void showTrybeListFolder(int postid, int index) {
    TextEditingController foldername = new TextEditingController();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              insetPadding: EdgeInsets.all(20),
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Create TryebeList Folder',
                        style: TextStyle(fontSize: 18.3),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Form(
                            // key: _creditsformKey,
                            child: TextFormField(
                              // controller: creditsController,
                              maxLines: 1,
                              minLines: 1,
                              controller: foldername,
                              keyboardType: TextInputType.text,
                              autofocus: false,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "Gilroy-SemiBold",
                                  color: Color.fromRGBO(60, 72, 88, 1),
                                  fontSize: 16.7),
                              onFieldSubmitted: (trem) async {
                                if (foldername != null &&
                                    foldername.text.trim().length > 0) {
                                  Navigator.pop(context);
                                  createFolderApi(
                                      foldername, context, postid, index);
                                } else {
                                  displaytoast("Folder name required", context);
                                }
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  hintText: "Enter name",
                                  contentPadding:
                                      EdgeInsets.fromLTRB(5.0, 0, 0.0, 0.0),
                                  hintStyle: TextStyle(
                                      fontFamily: "Gilroy-Regular",
                                      fontSize: 13.3)),
                            ),
                          )),
                        ],
                      ),
                      InkWell(
                        onTap: () async {
                          if (foldername != null &&
                              foldername.text.trim().length > 0) {
                            Navigator.pop(context);
                            createTrybeListApi(
                                foldername, context, postid, index);
                          } else {
                            displaytoast("Folder name required", context);
                          }
                        },
                        child: Container(
                            height: 40,
                            width: 120,
                            margin: EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                                color: getColorFromHex('#A10000')),
                            child: Center(
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                      )
                    ],
                  ),
                  Container(
                    child: getDialogLoader(
                        status: _newsViewModel.getLoading(), context: context),
                  ),
                ],
              ),
            );
          });
        });
  }

  void createTrybeListApi(TextEditingController foldername,
      BuildContext context, int postid, int index) async {
    _newsViewModel.setLoading();
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _newsViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Createplaylistparams params = new Createplaylistparams(
          uid: MemoryManagement.getuserId(),
          playlistName: foldername.text.trim());
      var response = await _newsViewModel.createplaylist(params, context);
      Createplaylistresponse createplaylistresponse = response;
      if (createplaylistresponse != null &&
          createplaylistresponse.status.compareTo("success") == 0) {
        if (createplaylistresponse.playlistData != null &&
            createplaylistresponse.playlistData.length > 0) {
          playlistdata.clear();
          playlistdata.addAll(createplaylistresponse.playlistData);
          showPlayListFolders(
              createplaylistresponse.playlistData, postid, index);
        }
        displaytoast(createplaylistresponse.message, context);
      } else if (createplaylistresponse != null &&
          createplaylistresponse.message != null &&
          createplaylistresponse.message.trim().length > 0) {
        displaytoast(createplaylistresponse.message, context);
      }
    }
  }

  void unsavefromplaylist(int postid, int playlistId, int index) async {
    _newsViewModel.setLoading();
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _newsViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Savetrybelistparams request = new Savetrybelistparams(
          key: "2",
          playlistId: playlistId.toString(),
          postId: postid.toString());
      var response = await _newsViewModel.savepostplaylist(request, context);
      Savetrybelistresponse savetrybelistresponse = response;
      if (savetrybelistresponse.status.compareTo("success") == 0) {
        if (savetrybelistresponse.message != null &&
            savetrybelistresponse.message.trim().length > 0) {
          displaytoast(savetrybelistresponse.message, context);
          updateUnsavedTrybeList(false, index, 0);
        } else {
          displaytoast("Post unsaved successfully", context);
          updateUnsavedTrybeList(false, index, 0);
        }
      } else {
        displaytoast("Error occurred while getting the playlist", context);
      }
    }
  }

  void updateUnsavedTrybeList(bool status, int index, int playlistid) {
    setState(() {
      if (getallpostlist[index] != null) {
        if (status == true) {
          getallpostlist[index - 1].playlistId = playlistid;
        } else {
          getallpostlist[index - 1].playlistId = 0;
        }
        getallpostlist[index - 1].isPlaylistSaved = status;
      }
    });
  }

//  void initalizeInterstial() {
  //  final AdListener listener = AdListener(
  // Called when an ad is successfully received.
  //  onAdLoaded: (Ad ad) {
  //   print("adloaded=> Ad loaded.");
  //  myInterstitial.show();
  //  },
  // Called when an ad request failed.
  //  onAdFailedToLoad: (Ad ad, LoadAdError error) {
  //   ad.dispose();
  //   print('adloaded=> Ad failed to load: $error');
  // },
  // Called when an ad opens an overlay that covers the screen.
  //  onAdOpened: (Ad ad) => print('adloaded=> Ad opened.'),
  // Called when an ad removes an overlay that covers the screen.
  //   onAdClosed: (Ad ad) {
  //   ad.dispose();
  //   print('adloaded=> Ad closed.');
  //  },
  // Called when an ad is in the process of leaving the application.
  //   onApplicationExit: (Ad ad) => print('Left application.'),
  //);

  // myInterstitial = InterstitialAd(
  //  adUnitId: 'ca-app-pub-3940256099942544/8691691433',
  //  request: AdRequest(),
  //  listener: listener,
  //  );
  //}
  void initialzeBanners() {
    final BannerAdListener listener = BannerAdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) {
        setState(() {
          isadloaded = true;
        });
      },
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        // Dispose the ad here to free resources.
        setState(() {
          isadloaded = false;
        });
        ad.dispose();
        print('Ad failed to load: $error');
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => print('Ad opened.'),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) => print('Ad closed.'),
      // Called when an impression occurs on the ad.
      onAdImpression: (Ad ad) => print('Ad impression.'),
    );

    AdSize adSize =
        AdSize(width: MediaQuery.of(context).size.width.toInt(), height: 350);
    myBanner = BannerAd(
      adUnitId: 'ca-app-pub-7410464693885383/1095703406',
      size: adSize,
      request: AdRequest(),
      listener: listener,
    );
  }
}
