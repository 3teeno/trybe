import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trybelocker/model/recentsearch/recentsearchparams.dart';
import 'package:trybelocker/model/recentsearch/recentsearchresponse.dart';
import 'package:trybelocker/model/recentuserlist/getrecentuserlistparams.dart';
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

class RecentSearcheScreen extends StatefulWidget {
  static const String TAG = "/recentsearchscreen";

  @override
  RecentSearcheScreenState createState() => RecentSearcheScreenState();
}

class RecentSearcheScreenState extends State<RecentSearcheScreen>
    with SingleTickerProviderStateMixin {
  SearchViewModel _searchViewModel;
  List<SearchData> recentuserlist = [];

  @override
  void initState() {
    super.initState();
    new Future.delayed(const Duration(milliseconds: 300), () {
      getrecentsearches();
    });
  }

  @override
  Widget build(BuildContext context) {
    _searchViewModel = Provider.of<SearchViewModel>(context);
    return Scaffold(
      backgroundColor: getColorFromHex(AppColors.black),
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: getColorFromHex(AppColors.black),
        title: Text("Recent Searches"),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.only(left: 0, top: 15),
                      itemCount: recentuserlist.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: (){
                            Navigator.of(context).pop(recentuserlist[index].recentSearch);
                          },
                          child: Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Icon(
                                    Icons.history,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    recentuserlist[index].recentSearch!=null?recentuserlist[index].recentSearch:"",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              )),
                        );
                      }))
            ],
          ),
          getFullScreenProviderLoader(status: _searchViewModel.getLoading(), context: context)
        ],
      ),
    );
  }

  void getrecentsearches() async {
    FocusScope.of(context).unfocus();
    _searchViewModel.setLoading();
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
      Recentsearchparams params =
          Recentsearchparams(uid: MemoryManagement.getuserId());
      var response = await _searchViewModel.getrecentsearchlist(params, context);
      Recentsearchresponse recentsearchresponse = response;
      setState(() {
        if (recentsearchresponse != null &&
            recentsearchresponse.status != null &&
            recentsearchresponse.status.compareTo("success") == 0) {
          if (recentsearchresponse.searchData != null &&
              recentsearchresponse.searchData.length > 0) {
            recentuserlist.addAll(recentsearchresponse.searchData);
          } else {
            if (recentuserlist.length <= 0) {
              displaytoast("No user found", context);
            }
          }
        } else {
          if (recentuserlist.length <= 0) {
            displaytoast("No user found", context);
          }
        }
      });
    }
  }


}
