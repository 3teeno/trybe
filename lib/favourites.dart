import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/src/provider.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';
import 'package:trybelocker/model/saveViewByStatus/view_by_status_params.dart';
import 'package:trybelocker/model/saveViewByStatus/view_by_status_response.dart';
import 'package:trybelocker/model/search/search_post_response.dart';
import 'package:trybelocker/notifications.dart';
import 'package:trybelocker/post_screen.dart';
import 'package:trybelocker/search.dart';
import 'package:trybelocker/settings/settings.dart';
import 'package:trybelocker/silverappbardelegate.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/viewmodel/favourites_view_model.dart';
import 'package:trybelocker/viewmodel/home_view_model.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'UniversalFunctions.dart';
import 'get_collection_post.dart';
import 'model/favouritecollectios/collection_list_params.dart';
import 'model/favouritecollectios/collection_list_response.dart';
import 'model/favouritecollectios/create_collection_params.dart';
import 'model/favouritecollectios/create_collectionresponse.dart';
import 'model/savecollectionpost/collection_post_reponse.dart';
import 'model/savecollectionpost/get_post_collection_params.dart';
import 'networkmodel/APIs.dart';

class Favourites extends StatefulWidget {
  HomeViewModel homeViewModel;

  Favourites({Key key, this.homeViewModel}) : super(key: key);

  FavouritesState createState() => FavouritesState();
}

class FavouritesState extends State<Favourites> {
  FavouritesViewModel _favouritesViewModel;
  List<CollectionData> collectiondatalist = [];
  String sortbyselecttext = "Sort by";
  String viewbyselecttext = "View by";
  TextEditingController foldername = TextEditingController();
  var displaycollection = TextEditingController();
  int collectionid;
  int currentpage = 1;
  int limit = 15;
  List<DataCollection> datacollection = [];
  bool isCollectionLoading = false;
  bool allCollectionLoaded = false;
  bool isDataLoaded = false;
  var controller = ScrollController();

  String sortby = "newest";

  @override
  void initState() {
    super.initState();
  }

  getCollections() {
    isDataLoaded = false;
    getCollectionList();
  }


  void saveViewBy(String viewBy) async {
    _favouritesViewModel.setLoading();
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _favouritesViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      ViewByStatusParams request = new ViewByStatusParams();
      request.viewBy =viewBy;
      request.userId = MemoryManagement.getuserId();
      var response = await _favouritesViewModel.saveViewByStatus(request, context);
      ViewByStatusResponse collectionresponse = response;
      if (collectionresponse.status.compareTo("success") == 0) {
        setState(() {
          isDataLoaded = true;
        });

      } else {
        setState(() {
          isDataLoaded = true;
        });
      }
    }
  }
  void getCollectionList() async {
    _favouritesViewModel.setLoading();
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _favouritesViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Collection_list_params request =
          new Collection_list_params(userid: MemoryManagement.getuserId());
      var response =
          await _favouritesViewModel.getallcollections(request, context);
      Collection_list_response collectionresponse = response;
      if (collectionresponse.status.compareTo("success") == 0) {
        setState(() {
          collectiondatalist.clear();
          if (collectionresponse.collectionData != null &&
              collectionresponse.collectionData.length > 0) {
            collectiondatalist.addAll(collectionresponse.collectionData);
            for (var data in collectiondatalist) {
              if (data.collectionName != null &&
                  data.collectionName.compareTo("Creative Journal") == 0) {
                collectionid = data.id;
                collectiondatalist.remove(data);
                break;
              }
            }
            if (collectionid != null && collectionid > 0) {
              getCollectionpost(true);
            } else {
              isDataLoaded = true;
            }
          } else {
            isDataLoaded = true;
          }
        });
      } else {
        setState(() {
          isDataLoaded = true;
        });
      }
    }
  }

  getCollectionpost(bool isClear) async {
    print("collectionid=>$collectionid");
    _favouritesViewModel.setLoading();
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _favouritesViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Get_post_collection_params params = Get_post_collection_params(
          uid: MemoryManagement.getuserId(),
          collectionId: collectionid.toString(),
          page: currentpage.toString(),
          sort_by: getsortbytext(),
          limit: limit.toString());
      var response =
          await _favouritesViewModel.getPostCollection(params, context);
      Collection_post_reponse collection_post_reponse = response;
      if (isClear == true) {
        datacollection.clear();
      }
      if (collection_post_reponse.status.compareTo("success") == 0) {
        if (collection_post_reponse.collectionData != null &&
            collection_post_reponse.collectionData.data != null &&
            collection_post_reponse.collectionData.data.length > 0) {
          if (collection_post_reponse.collectionData.data.length < limit) {
            setState(() {
              isCollectionLoading = false;
              allCollectionLoaded = true;
              isDataLoaded = true;
            });
            datacollection.addAll(collection_post_reponse.collectionData.data);
            print("ViewByStatus${datacollection[0].postData.viewBy}");
            if(datacollection[0].postData.viewBy.isEmpty) {
              print("ViewByStatus3${datacollection[0].postData.viewBy}");
            }
            else{
              viewbyselecttext = datacollection[0].postData.viewBy;
              print("ViewByStatus2${datacollection[0].postData.viewBy}");
            }
          } else {
            setState(() {
              isCollectionLoading = false;
              allCollectionLoaded = false;
              isDataLoaded = true;
            });
            datacollection.addAll(collection_post_reponse.collectionData.data);
          }
        } else {
          if (datacollection.length < 0) {
            displaytoast("No data found", context);
          }
          setState(() {
            isCollectionLoading = false;
            allCollectionLoaded = false;
            isDataLoaded = true;
          });
        }
      } else {
        if (datacollection.length < 0) {
          displaytoast("No data found", context);
        }
        setState(() {
          isCollectionLoading = false;
          allCollectionLoaded = false;
          isDataLoaded = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _favouritesViewModel = Provider.of<FavouritesViewModel>(context);
    print("isdataloaded== $isDataLoaded");
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
                // widget.homeViewModel.controller.add(true);
                //navigateToNextScreen(context, true, Casting());
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
                  // widget.homeViewModel.controller.add(true);
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
                  // widget.homeViewModel.controller.add(true);
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
                  // widget.homeViewModel.controller.add(true);
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
              CustomScrollView(
                controller: controller,
                shrinkWrap: true,
                slivers: [
                  SliverFixedExtentList(
                      delegate: SliverChildListDelegate([
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              seperationline(2),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "FAVORITES",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 15),
                                child: Text(
                                  "Favorites Folder",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              InkWell(
                                onTap: () {
                                  showCreateFoler();
                                },
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Image.asset(
                                      "assets/addwhite.png",
                                      height: 25,
                                      width: 25,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'New Favorites Folder',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 0, top: 15),
                                height: 170,
                                width: MediaQuery.of(context).size.width,
                                child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            mainAxisExtent: 200,
                                            childAspectRatio: 1 / 2,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10),
                                    itemCount: collectiondatalist.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      GetCollectionPost(
                                                          collectiondatalist[
                                                                  index]
                                                              .id)));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Row(
                                            children: <Widget>[
                                              getImage(
                                                  collectiondatalist[index]),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Container(
                                                width: 60,
                                                child: Text(
                                                  collectiondatalist[index]
                                                      .collectionName,
                                                  textAlign: TextAlign.left,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              seperationline(1),
                            ])
                      ]),
                      itemExtent: 320.0),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: SliverAppBarDelegate(
                      minHeight: 30,
                      maxHeight: 30,
                      child: Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width,
                        color: getColorFromHex(AppColors.black),
                        child: Row(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                  margin: EdgeInsets.only(left: 0, top: 0),
                                  child: new Theme(
                                      data: Theme.of(context).copyWith(
                                        canvasColor:
                                            getColorFromHex(AppColors.black),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                          child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButton<String>(
                                          iconEnabledColor: Colors.white,
                                          items: <String>[
                                            'View by',
                                            'Preview',
                                            'Date',
                                            'Random'
                                          ].map((String value) {
                                            return new DropdownMenuItem<String>(
                                              value: value,
                                              child: new Text(value),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              viewbyselecttext = value;
                                              saveViewBy(viewbyselecttext);
                                              // getCollectionpost(true);
                                            });
                                          },
                                          value: viewbyselecttext,
                                          style: new TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      )))),
                            ),
                            Spacer(),
                            Center(
                              child: Text(
                                "Creative Journal",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 22,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            Spacer(),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                  margin: EdgeInsets.only(left: 0, top: 0),
                                  child: new Theme(
                                      data: Theme.of(context).copyWith(
                                        canvasColor:
                                            getColorFromHex(AppColors.black),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                          child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButton<String>(
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
                                              sortbyselecttext = value;
                                              getCollectionpost(true);
                                            });
                                          },
                                          value: sortbyselecttext,
                                          style: new TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      )))),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverFixedExtentList(
                      itemExtent: MediaQuery.of(context).size.height,
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Stack(
                            children: <Widget>[
                              Visibility(
                                  visible:
                                      datacollection.length > 0 ? true : false,
                                  child: NotificationListener<
                                          ScrollNotification>(
                                      onNotification:
                                          (ScrollNotification scroll) {
                                        if (isCollectionLoading == false &&
                                            allCollectionLoaded == false &&
                                            scroll.metrics.pixels ==
                                                scroll
                                                    .metrics.maxScrollExtent) {
                                          setState(() {
                                            // _profile_favouritesViewModel.setLoading();
                                            isCollectionLoading = true;
                                            allCollectionLoaded = true;
                                            ++currentpage;
                                            getCollectionpost(false);
                                          });
                                        }
                                        return;
                                      },
                                      child: GridView.builder(
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  childAspectRatio: 1.4 / 1,
                                                  mainAxisSpacing: 5,
                                                  crossAxisCount: 3),
                                          physics: BouncingScrollPhysics(),
                                          itemCount: datacollection.length,
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 550),
                                          itemBuilder:
                                              (BuildContextcontext, int index) {
                                            return viewbyselecttext
                                                        .compareTo("Date") ==
                                                    0
                                                ? Card(
                                                    // margin: EdgeInsets
                                                    //     .symmetric(
                                                    //     vertical: 1,
                                                    //     horizontal: 1),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                      Radius.circular(0),
                                                    )),
                                                    child: InkWell(
                                                        onTap: () {
                                                          print("video");
                                                          DataPost datapost =
                                                              new DataPost();
                                                          datapost.id =
                                                              datacollection[
                                                                      index]
                                                                  .postId;
                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
                                                              .push(MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      PostScreen(
                                                                          datapost)));
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.all(8),
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .rectangle,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                        formatDateString(
                                                                            datacollection[index]
                                                                                .postData
                                                                                .createdAt,
                                                                            "MM"),
                                                                        style: TextStyle(
                                                                            fontWeight:FontWeight.bold,color: Colors.white)),
                                                                    Text(
                                                                        formatDateString(
                                                                            datacollection[index]
                                                                                .postData
                                                                                .createdAt,
                                                                            "yyyy"),
                                                                        style: TextStyle(
                                                                            fontWeight:FontWeight.bold,color: Colors.white)),
                                                                  ],
                                                                ),
                                                                Expanded(child:
                                                                Center(child:
                                                                Text( formatDateString(datacollection[index].postData.createdAt,"dd"),
                                                                    style: TextStyle(fontWeight:FontWeight.bold,color: Colors.white,fontSize: 20)),
                                                                      )) ],
                                                            ))),
                                                  )
                                                : Card(
                                                    // margin: EdgeInsets
                                                    //     .symmetric(
                                                    //     vertical: 1,
                                                    //     horizontal: 1),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                      Radius.circular(0),
                                                    )),
                                                    child: Stack(
                                                      children: <Widget>[
                                                        InkWell(
                                                            onTap: () {
                                                              print("video");
                                                              DataPost
                                                                  datapost =
                                                                  new DataPost();
                                                              datapost.id =
                                                                  datacollection[
                                                                          index]
                                                                      .postId;
                                                              Navigator.of(
                                                                      context,
                                                                      rootNavigator:
                                                                          true)
                                                                  .push(MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          PostScreen(
                                                                              datapost)));
                                                            },
                                                            child: Visibility(
                                                                visible: datacollection[index]
                                                                            .postData
                                                                            .postType ==
                                                                        1
                                                                    ? false
                                                                    : true,
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          shape: BoxShape
                                                                              .rectangle,
                                                                          borderRadius:
                                                                              BorderRadius.all(
                                                                            Radius.circular(8),
                                                                          )),
                                                                  child: Stack(
                                                                    children: <
                                                                        Widget>[
                                                                      FutureBuilder(
                                                                          future:
                                                                              getThumbnail(APIs.userpostvideosbaseurl + datacollection[index].postData.postMediaUrl),
                                                                          builder: (BuildContext context, snapshot) {
                                                                            if (snapshot.connectionState ==
                                                                                ConnectionState.done) {
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
                                                                ))),
                                                        InkWell(
                                                            onTap: () {
                                                              DataPost
                                                                  datapost =
                                                                  new DataPost();
                                                              datapost.id =
                                                                  datacollection[
                                                                          index]
                                                                      .postId;
                                                              Navigator.of(
                                                                      context,
                                                                      rootNavigator:
                                                                          true)
                                                                  .push(MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          PostScreen(
                                                                              datapost)));
                                                            },
                                                            child: Visibility(
                                                                visible: datacollection[index]
                                                                            .postData
                                                                            .postType ==
                                                                        1
                                                                    ? true
                                                                    : false,
                                                                child: Container(
                                                                    decoration: BoxDecoration(
                                                                        shape: BoxShape.rectangle,
                                                                        borderRadius: BorderRadius.all(
                                                                          Radius.circular(
                                                                              8),
                                                                        )),
                                                                    child: getCachedNetworkImage(url: APIs.userpostimagesbaseurl + datacollection[index].postData.postMediaUrl, fit: BoxFit.cover))))
                                                      ],
                                                    ),
                                                  );
                                          }))),
                              Visibility(
                                visible: datacollection.length > 0
                                    ? false
                                    : _favouritesViewModel.getLoading()
                                        ? false
                                        : true,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(top: 50),
                                  child: Text(
                                    "No Data Found",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }, childCount: 1))
                ],
              ),
              getFullScreenProviderLoader(
                  status: isDataLoaded == true ? false : true, context: context)
            ],
          ),
        ));
  }

  void refreshList(List<CollectionData> collectionData) {
    setState(() {
      collectiondatalist.clear();
      if (collectionData != null && collectionData.length > 0) {
        collectiondatalist.addAll(collectionData);
        for (var data in collectiondatalist) {
          if (data.collectionName.compareTo("Creative Journal") == 0) {
            collectiondatalist.remove(data);
            break;
          }
        }
      }
    });
  }

  void showCreateFoler() {
    showDialog(
        context: context,
        barrierDismissible: true,
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
                                  _favouritesViewModel.setLoading();
                                  bool gotInternetConnection =
                                      await hasInternetConnection(
                                    context: context,
                                    mounted: mounted,
                                    canShowAlert: true,
                                    onFail: () {
                                      _favouritesViewModel.hideLoader();
                                    },
                                    onSuccess: () {},
                                  );
                                  if (gotInternetConnection) {
                                    Create_collection_params params =
                                        new Create_collection_params(
                                            userid:
                                                MemoryManagement.getuserId(),
                                            collectionName:
                                                foldername.text.trim());
                                    var response = await _favouritesViewModel
                                        .createcollection(params, context);
                                    Create_collectionresponse
                                        collectionresponse = response;
                                    if (collectionresponse.status
                                            .compareTo("success") ==
                                        0) {
                                      displaytoast(
                                          collectionresponse.message, context);
                                    } else {
                                      displaytoast(
                                          collectionresponse.message, context);
                                    }
                                  }
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
                            setState(() {
                              _favouritesViewModel.setLoading();
                            });

                            bool gotInternetConnection =
                                await hasInternetConnection(
                              context: context,
                              mounted: mounted,
                              canShowAlert: true,
                              onFail: () {
                                setState(() {
                                  _favouritesViewModel.hideLoader();
                                });
                              },
                              onSuccess: () {},
                            );
                            if (gotInternetConnection) {
                              Create_collection_params params =
                                  new Create_collection_params(
                                      userid: MemoryManagement.getuserId(),
                                      collectionName: foldername.text.trim());
                              var response = await _favouritesViewModel
                                  .createcollection(params, context);
                              Create_collectionresponse collectionresponse =
                                  response;
                              setState(() {
                                _favouritesViewModel.hideLoader();
                              });
                              foldername.text = "";
                              Navigator.pop(context);
                              if (collectionresponse.status
                                      .compareTo("success") ==
                                  0) {
                                displaytoast(
                                    collectionresponse.message, context);
                                refreshList(collectionresponse.collectionData);
                              } else {
                                displaytoast(
                                    collectionresponse.message, context);
                              }
                            }
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
                        status: _favouritesViewModel.getLoading(),
                        context: context),
                  ),
                ],
              ),
            );
          });
        });
  }

  Widget getImage(CollectionData collectiondatalist) {
    if (collectiondatalist.post_type != null &&
        collectiondatalist.post_media_url != null &&
        collectiondatalist.post_media_url.trim().length > 0) {
      if (collectiondatalist.post_type == 2) {
        return Container(
          width: 50,
          height: 50,
          margin: EdgeInsets.all(2),
          child: FutureBuilder(
              future: getThumbnail(collectiondatalist.post_media_url),
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
          width: 50,
          height: 50,
          margin: EdgeInsets.all(2),
          child: getCachedNetworkImage(
              url: collectiondatalist.post_media_url, fit: BoxFit.cover),
        );
      }
    } else {
      return new Container(
        width: 50,
        height: 50,
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

  getThumbnail(String url) async {
    return await VideoThumbnail.thumbnailData(
      video: url,
      imageFormat: ImageFormat.PNG,
      maxWidth: 50,
      maxHeight: 50,
      // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 50,
    );
  }

  TextEditingController getCollectionName(String collectionname) {
    print("collectionname=>,$collectionname");
    displaycollection.text = collectionname;

    return displaycollection;
  }

  getsortbytext() {
    if (sortbyselecttext.compareTo("Sort by") == 0 ||
        sortbyselecttext.compareTo("Newest") == 0) {
      return sortby = "newest";
    } else if (sortbyselecttext.compareTo("Oldest") == 0) {
      return sortby = "oldest";
    }

  }
}
