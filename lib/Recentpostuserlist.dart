import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trybelocker/UniversalFunctions.dart';
import 'package:trybelocker/model/recentuserlist/getrecentuserlistparams.dart';
import 'package:trybelocker/model/recentuserlist/getrecentuserlistresponse.dart';
import 'package:trybelocker/model/search/search_response.dart';
import 'package:trybelocker/networkmodel/APIs.dart';
import 'package:trybelocker/notifications.dart';
import 'package:trybelocker/publicprofile/publicprofilescreen.dart';
import 'package:trybelocker/search.dart';
import 'package:trybelocker/settings/settings.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/viewmodel/home_view_model.dart';
import 'package:provider/src/provider.dart';

class RecentPostUserList extends StatefulWidget {
  static const String TAG = "/recentpostuser";

  RecentPostUserListState createState() => RecentPostUserListState();
}

class RecentPostUserListState extends State<RecentPostUserList> {
  var sortbyselecttext = "Sort by";
  HomeViewModel _homeViewModel;
  int currentPage = 1;
  int limit = 10;
  List<DataUsers> getrecentuserlist = [];
  bool isnearpostLoading = false;
  bool allnearPost = false;

  String sortby="newest";

  @override
  void initState() {
    super.initState();
    new Future.delayed(const Duration(milliseconds: 300), () {
      isnearpostLoading = false;
      currentPage = 1;
      allnearPost = false;
      _homeViewModel.setLoading();
      if (isnearpostLoading == false && allnearPost == false) {
        setState(() {
          isnearpostLoading = true;
        });
        getrecentuser(
          true,
          currentPage,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _homeViewModel = Provider.of<HomeViewModel>(context);
    return  Scaffold(
        backgroundColor: getColorFromHex(AppColors.black),
        appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor: getColorFromHex(AppColors.black),
          title: Container(
              margin: EdgeInsets.only(left: 5),
              child: Image.asset(
                "assets/white_logo.png",
                height: 120,
                width: 120,
              )),
        ),
        body: RefreshIndicator(
            onRefresh: () async {
              isnearpostLoading = false;
              currentPage = 1;
              allnearPost = false;
              _homeViewModel.setLoading();
              if (isnearpostLoading == false && allnearPost == false) {
                isnearpostLoading = true;
                return getrecentuser(true, currentPage);
              }
            },
            child: Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 20, top: 20),
                        child: new Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: getColorFromHex(AppColors.black),
                            ),
                            child: DropdownButtonHideUnderline(
                                child: ButtonTheme(
                                  alignedDropdown: true,
                                  child: DropdownButton<String>(
                                    iconEnabledColor: Colors.white,
                                    items: <String>[
                                      'Sort by',
                                      'A-Z',
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
                                        currentPage=0;
                                        getrecentuser(true, currentPage);
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
                              if (isnearpostLoading == false &&
                                  allnearPost == false &&
                                  scroll.metrics.pixels ==
                                      scroll.metrics.maxScrollExtent) {
                                setState(() {
                                  // _homeViewModel.setLoading();
                                  isnearpostLoading = true;
                                  currentPage++;
                                  getrecentuser(false, currentPage);
                                });
                              }
                              return;
                            },
                            child: ListView.builder(
                                padding: EdgeInsets.only(bottom: 20),
                                itemCount: getrecentuserlist.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      DataUser datausers = new DataUser();
                                      datausers.id = getrecentuserlist[index].id;
                                      datausers.username = getrecentuserlist[index].username;
                                      datausers.userImage = getrecentuserlist[index].userImage;
                                      datausers.email = getrecentuserlist[index].email;
                                      datausers.phoneNumber = getrecentuserlist[index].phoneNumber;
                                      datausers.fullName = getrecentuserlist[index].fullName;
                                      datausers.birthDate = getrecentuserlist[index].birthDate;
                                      datausers.loginType = getrecentuserlist[index].loginType;
                                      datausers.socialId = getrecentuserlist[index].socialId;
                                      datausers.about = getrecentuserlist[index].about;
                                      datausers.createdAt = getrecentuserlist[index].createdAt;
                                      navigateToNextScreen(context, true, PublicProfileScreen(datausers));
                                    },
                                    child: Container(
                                        margin: EdgeInsets.only(top: 20),
                                        child: Row(
                                          children: [
                                            new Container(
                                              width: 40,
                                              height: 40,
                                              margin: EdgeInsets.only(left: 20),
                                              child: ClipOval(
                                                child: getProfileImage(getrecentuserlist[index].userImage!=null?getrecentuserlist[index].userImage:""),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              getrecentuserlist[index].username,
                                              style: TextStyle(color: Colors.white),
                                            )
                                          ],
                                        )),
                                  );
                                })))
                  ],
                ),
                getFullScreenProviderLoader(status: _homeViewModel.getLoading(), context: context)
              ],
            )));
  }

  getProfileImage(String userImage) {
    if(userImage != null && userImage.isNotEmpty){
      if (userImage.contains("https") || userImage.contains("http")){
        return getCachedNetworkImage(url:userImage,fit: BoxFit.cover);
      }else{
        return getCachedNetworkImage(url:APIs.userprofilebaseurl +userImage,fit: BoxFit.cover);
      }
    }else{
      return getCachedNetworkImage(url:
      "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80",fit: BoxFit.cover);
    }

  }

  void getrecentuser(bool isClear, int currentPage) async {
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
      request.key = "1";
      request.sort_by= getsortbytext();
      request.page = currentPage.toString();

      var response = await _homeViewModel.getrecentuserlist(request, context);

      print(response.toString());

      Getrecentuserlistresponse getrecentuserlistresponse = response;
      if (isClear == true) {
        getrecentuserlist.clear();
      }

      if (getrecentuserlistresponse != null &&
          getrecentuserlistresponse.postData != null &&
          getrecentuserlistresponse.postData.userData != null &&
          getrecentuserlistresponse.postData.userData != null) {
        if (getrecentuserlistresponse.postData.userData.data.length < limit) {
          allnearPost = true;
          isnearpostLoading = false;
        }
        if (getrecentuserlistresponse != null) {
          if (getrecentuserlistresponse.status != null &&
              getrecentuserlistresponse.status.isNotEmpty) {
            if (getrecentuserlistresponse.status.compareTo("success") == 0) {
              getrecentuserlist
                  .addAll(getrecentuserlistresponse.postData.userData.data);

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
  }

  getprofilepic(int index) {
    if (getrecentuserlist[index].userImage != null &&
        getrecentuserlist[index].userImage.isNotEmpty) {
      if (getrecentuserlist[index].userImage.contains("https") ||
          getrecentuserlist[index].userImage.contains("http")) {
        return NetworkImage(getrecentuserlist[index].userImage);
      } else {
        return NetworkImage(
            APIs.userprofilebaseurl + getrecentuserlist[index].userImage);
      }
    } else {
      return NetworkImage(
          "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80");
    }
  }
  getsortbytext() {

    if(sortbyselecttext.compareTo("Sort by")==0||sortbyselecttext.compareTo("Newest")==0){
      return sortby = "newest";
    }else if(sortbyselecttext.compareTo("Oldest")==0){
      return sortby = "oldest";
    }else if(sortbyselecttext.compareTo("A-Z")==0){
      return sortby = "a-z";
    }


  }
}
