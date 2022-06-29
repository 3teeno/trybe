import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trybelocker/RecentsearchesScreen.dart';
import 'package:trybelocker/post_screen.dart';
import 'package:trybelocker/publicprofile/publicprofilescreen.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/viewmodel/home_view_model.dart';
import 'package:provider/src/provider.dart';
import 'package:trybelocker/viewmodel/search_view_model.dart';

import 'UniversalFunctions.dart';
import 'model/search/search_params.dart';
import 'model/search/search_post_response.dart';
import 'model/search/search_response.dart';
import 'networkmodel/APIs.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class SearchScreen extends StatefulWidget {
  static const String TAG = "/searchscreen";

  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  SearchViewModel _searchViewModel;
  TextEditingController searchController = TextEditingController();
  TabController _tabController;
  int pagenumber = 1;
  int limit = 15;
  int currenttab = 0;
  List<DataUser> datauser = [];
  List<DataPost> dataPost = [];
  String searchValue = "";
  bool isSearchLoading = false;
  bool allSearchLoaded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        currenttab = _tabController.index;
        if (searchController.text != null &&
            searchController.text.trim().length > 0) {
          if (currenttab == 0) {
            searchValue = searchController.text;
            allSearchLoaded = false;
            isSearchLoading = false;
            setState(() {
              if (allSearchLoaded == false && isSearchLoading == false) {
                pagenumber = 1;
                allSearchLoaded = true;
                isSearchLoading = true;
                getUserSearchResults(true, searchController.text);
              }
            });
          } else {
            searchValue = searchController.text;
            allSearchLoaded = false;
            isSearchLoading = false;
            setState(() {
              if (allSearchLoaded == false && isSearchLoading == false) {
                pagenumber = 1;
                allSearchLoaded = true;
                isSearchLoading = true;
                getPostSearch(true, searchController.text);
              }
            });
          }
        } else {
          displaytoast("Value required", context);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _searchViewModel = Provider.of<SearchViewModel>(context);
    return Scaffold(
      backgroundColor: getColorFromHex(AppColors.black),
      appBar: AppBar(
        elevation: 0.0,
        brightness: Brightness.dark,
        title: Text(
          "Search",
        ),
        backgroundColor: getColorFromHex(AppColors.black),
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Stack(
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Text("Search",
                            style: TextStyle(color: Colors.grey, fontSize: 16)),
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          width: 180,
                          height: 30,
                          child: TextFormField(
                              autofocus: false,
                              controller: searchController,
                              style: TextStyle(fontSize: 18),
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  child: Container(
                                      child: Icon(
                                        Icons.search,
                                        color: Colors.white,
                                      ),
                                      color: Colors.red),
                                  onTap: () async {
                                    if (searchController.text != null &&
                                        searchController.text.trim().length >
                                            0) {
                                      if (currenttab == 0) {
                                        searchValue = searchController.text;
                                        allSearchLoaded = false;
                                        isSearchLoading = false;
                                        setState(() {
                                          if (allSearchLoaded == false &&
                                              isSearchLoading == false) {
                                            pagenumber = 1;
                                            allSearchLoaded = true;
                                            isSearchLoading = true;
                                            getUserSearchResults(
                                                true, searchController.text);
                                          }
                                        });
                                      } else {
                                        searchValue = searchController.text;
                                        allSearchLoaded = false;
                                        isSearchLoading = false;
                                        setState(() {
                                          if (allSearchLoaded == false &&
                                              isSearchLoading == false) {
                                            pagenumber = 1;
                                            allSearchLoaded = true;
                                            isSearchLoading = true;
                                            getPostSearch(
                                                true, searchController.text);
                                          }
                                        });
                                      }
                                    } else {
                                      displaytoast("Value required", context);
                                    }
                                  },
                                ),
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 10, 10, 0),
                                filled: true,
                                fillColor: Color(0xFFF2F2F2),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                ),
                              )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => RecentSearcheScreen())).then((value) {
                          if(value!=null&&value.toString().trim().length>0){
                            searchController.text = value;
                            if (searchController.text != null &&
                                searchController.text.trim().length >
                                    0) {
                              if (currenttab == 0) {
                                searchValue = searchController.text;
                                allSearchLoaded = false;
                                isSearchLoading = false;
                                setState(() {
                                  if (allSearchLoaded == false &&
                                      isSearchLoading == false) {
                                    pagenumber = 1;
                                    allSearchLoaded = true;
                                    isSearchLoading = true;
                                    getUserSearchResults(
                                        true, searchController.text);
                                  }
                                });
                              } else {
                                searchValue = searchController.text;
                                allSearchLoaded = false;
                                isSearchLoading = false;
                                setState(() {
                                  if (allSearchLoaded == false &&
                                      isSearchLoading == false) {
                                    pagenumber = 1;
                                    allSearchLoaded = true;
                                    isSearchLoading = true;
                                    getPostSearch(
                                        true, searchController.text);
                                  }
                                });
                              }
                            }
                          }
                        });
                      },
                      child: Text("Recent Searches",
                          style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TabBar(
                      controller: _tabController,
                      tabs: [
                        _individualTab('Users', currenttab == 0),
                        _individualTab('Posts', currenttab == 1),
                      ],
                      labelColor: Colors.white,
                      unselectedLabelColor:
                          getColorFromHex(AppColors.lightredcolor),
                      indicatorColor: Colors.white,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelPadding: EdgeInsets.only(left: 10, right: 10),
                      indicatorPadding: EdgeInsets.all(0),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: TabBarView(
                        controller: _tabController,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(bottom: 20),
                            child: NotificationListener<ScrollNotification>(
                                onNotification: (ScrollNotification scroll) {
                                  if (isSearchLoading == false &&
                                      allSearchLoaded == false &&
                                      scroll.metrics.pixels ==
                                          scroll.metrics.maxScrollExtent &&
                                      searchValue != null &&
                                      searchValue.trim().length > 0) {
                                    setState(() {
                                      isSearchLoading = true;
                                      ++pagenumber;
                                      if (currenttab == 0) {
                                        getUserSearchResults(
                                            false, searchValue);
                                      }
                                    });
                                  }
                                  return;
                                },
                                child: ListView.builder(
                                    itemCount: datauser.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          navigateToNextScreen(
                                              context,
                                              true,
                                              PublicProfileScreen(
                                                  datauser[index]));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(top: 15),
                                          child: Row(
                                            children: <Widget>[
                                              new Container(
                                                  width: 35,
                                                  height: 35,
                                                  margin: EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: new DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: getProfileImage(
                                                              datauser[
                                                                  index])))),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Text(
                                                datauser[index].username != null
                                                    ? datauser[index].username
                                                    : "",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    })),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 20),
                            child: NotificationListener<ScrollNotification>(
                                onNotification: (ScrollNotification scroll) {
                                  if (isSearchLoading == false &&
                                      allSearchLoaded == false &&
                                      scroll.metrics.pixels ==
                                          scroll.metrics.maxScrollExtent &&
                                      searchValue != null &&
                                      searchValue.trim().length > 0) {
                                    setState(() {
                                      isSearchLoading = true;
                                      ++pagenumber;
                                      if (currenttab == 0) {
                                        getPostSearch(false, searchValue);
                                      }
                                    });
                                  }
                                  return;
                                },
                                child: ListView.builder(
                                    itemCount: dataPost.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          navigateToNextScreen(context, true,
                                              PostScreen(dataPost[index]));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(top: 15),
                                          child: Row(
                                            children: <Widget>[
                                              Visibility(
                                                  visible: dataPost[index]
                                                              .postType ==
                                                          1
                                                      ? false
                                                      : true,
                                                  child: Container(
                                                    width: 40,
                                                    height: 40,
                                                    child: FutureBuilder(
                                                        future: getThumbnail(APIs
                                                                .userpostvideosbaseurl +
                                                            dataPost[index]
                                                                .postMediaUrl),
                                                        builder: (BuildContext
                                                                context,
                                                            snapshot) {
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .done) {
                                                            return Positioned
                                                                .fill(
                                                              child:
                                                                  Image.memory(
                                                                snapshot.data,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
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
                                                  )),
                                              Visibility(
                                                  visible: dataPost[index]
                                                              .postType ==
                                                          1
                                                      ? true
                                                      : false,
                                                  child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              20, 10, 0, 10),
                                                      width: 40,
                                                      height: 40,
                                                      child: getCachedNetworkImage(
                                                          url: APIs
                                                                  .userpostimagesbaseurl +
                                                              dataPost[index]
                                                                  .postMediaUrl,
                                                          fit: BoxFit.cover))),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Text(
                                                dataPost[index].postCaption !=
                                                        null
                                                    ? dataPost[index]
                                                        .postCaption
                                                    : "",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    })),
                          )
                        ],
                      ),
                    )
                  ],
                )),
            getFullScreenProviderLoaderWithOutbackground(
                status: _searchViewModel.getLoading(), context: context)
          ],
        ),
      ),
    );
  }

  Future<Uint8List> getThumbnail(String url) async {
    return await VideoThumbnail.thumbnailData(
      video: url,
      imageFormat: ImageFormat.PNG,
      maxWidth: 100,
      maxHeight: 100,
      // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 50,
    );
  }

  Widget _individualTab(String text, bool isChecked) {
    return Tab(
      text: text,
    );
  }

  getProfileImage(DataUser datauser) {
    if (datauser != null &&
        datauser.userImage != null &&
        datauser.userImage.trim().length > 0) {
      if (datauser.userImage.contains("https") ||
          datauser.userImage.contains("http")) {
        return NetworkImage(datauser.userImage);
      } else {
        return NetworkImage(APIs.userprofilebaseurl + datauser.userImage);
      }
    } else {
      return NetworkImage(
          "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80");
    }
  }

  void getUserSearchResults(bool isClear, String text) async {
    FocusScope.of(context).unfocus();
    if (isClear == true) {
      _searchViewModel.setLoading();
    }
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _searchViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Search_params params = Search_params(
          searchValue: searchController.text,
          page: pagenumber.toString(),
          uid: MemoryManagement.getuserId(),
          limit: limit.toString());
      var response = await _searchViewModel.searchUser(params, context);
      Search_response searchresponse = response;
      setState(() {
        if (isClear == true) {
          datauser.clear();
        }
        if (searchresponse != null &&
            searchresponse.status != null &&
            searchresponse.status.compareTo("success") == 0) {
          if (searchresponse.userData != null &&
              searchresponse.userData.data.length > 0) {
            if (searchresponse.userData.data.length < limit) {
              allSearchLoaded = true;
              isSearchLoading = false;
              datauser.addAll(searchresponse.userData.data);
            } else {
              allSearchLoaded = false;
              isSearchLoading = false;
              datauser.addAll(searchresponse.userData.data);
            }
          } else {
            allSearchLoaded = false;
            isSearchLoading = false;
            if (datauser.length <= 0) {
              displaytoast("No user found", context);
            }
          }
        } else {
          allSearchLoaded = false;
          isSearchLoading = false;
          if (datauser.length <= 0) {
            displaytoast("No user found", context);
          }
        }
      });
    }
  }

  void getPostSearch(bool isClear, String text) async {
    FocusScope.of(context).unfocus();
    if (isClear == true) {
      _searchViewModel.setLoading();
    }
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _searchViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Search_params params = Search_params(
          searchValue: searchController.text,
          page: pagenumber.toString(),
          uid: MemoryManagement.getuserId(),
          limit: limit.toString());
      var response = await _searchViewModel.searchPost(params, context);
      Search_post_response search_post_response = response;
      setState(() {
        if (isClear == true) {
          dataPost.clear();
        }
        if (search_post_response != null &&
            search_post_response.status != null &&
            search_post_response.status.compareTo("success") == 0) {
          if (search_post_response.postData != null &&
              search_post_response.postData.data.length > 0) {
            if (search_post_response.postData.data.length < limit) {
              allSearchLoaded = true;
              isSearchLoading = false;
              dataPost.addAll(search_post_response.postData.data);
            } else {
              allSearchLoaded = false;
              isSearchLoading = false;
              dataPost.addAll(search_post_response.postData.data);
            }
          } else {
            allSearchLoaded = false;
            isSearchLoading = false;
            if (dataPost.length <= 0) {
              displaytoast("No user found", context);
            }
          }
        } else {
          allSearchLoaded = false;
          isSearchLoading = false;
          if (dataPost.length <= 0) {
            displaytoast("No user found", context);
          }
        }
      });
    }
  }
}
