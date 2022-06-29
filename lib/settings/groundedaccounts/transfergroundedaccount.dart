import 'package:flutter/material.dart';
import 'package:trybelocker/model/groundedaccountlist/grounded_account_listparams.dart';
import 'package:trybelocker/model/groundedaccountlist/grounded_accountlistResponse.dart';
import 'package:trybelocker/model/recentuserlist/getrecentuserlistparams.dart';
import 'package:trybelocker/model/recentuserlist/getrecentuserlistresponse.dart';
import 'package:trybelocker/networkmodel/APIs.dart';
import 'package:trybelocker/settings/groundedaccounts/transfegroundedacc.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/viewmodel/home_view_model.dart';

import '../../UniversalFunctions.dart';
import 'grounded_account_edit_profile.dart';
import 'package:provider/src/provider.dart';

class TransferUserlistGrouAcc extends StatefulWidget {
  static const String TAG = "/transferuserlistacc";

  @override
  TransferUserlistGrouAccState createState() => TransferUserlistGrouAccState();
}

class TransferUserlistGrouAccState extends State<TransferUserlistGrouAcc> {
  HomeViewModel _homeViewModel;
  bool isnearpostLoading = false;
  bool allnearPost = false;
  int limit = 10;
  int currentPage = 1;
  List<Data> getrecentuserlist = [];
  bool isDataLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    new Future.delayed(const Duration(milliseconds: 300), () {
      isnearpostLoading = false;
      currentPage = 1;
      allnearPost = false;
      isDataLoaded = false;
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
    return Scaffold(
        backgroundColor: getColorFromHex(AppColors.black),
        appBar: AppBar(
          brightness: Brightness.dark,
          title: Text(
            "Settings",
          ),
          backgroundColor: getColorFromHex(AppColors.black),
        ),
        body: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                settingsHeader('Transfer Grounded Accounts',
                    MemoryManagement.getuserprofilepic()),
               getrecentuserlist!=null?getrecentuserlist.length>0? Expanded(child: setAccts(getrecentuserlist)):
              isDataLoaded==true?Container(
                   child: Center(
                     child: Text(
                       "No Data Found",
                       style: TextStyle(
                           color: Colors.white,
                           fontWeight: FontWeight.bold
                           ,fontSize: 20
                       ),
                     ),
                   )
               ):Container():isDataLoaded==true?Container(
                   child: Center(
                     child: Text(
                       "No Data Found",
                       style: TextStyle(
                           color: Colors.white,
                           fontWeight: FontWeight.bold
                           ,fontSize: 20
                       ),
                     ),
                   )
               ):Container()
              ],
            ),
            getFullScreenProviderLoader(status: isnearpostLoading, context: context)
          ],
        ));
  }

  setAccts(List<Data> data) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, i) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
          NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scroll) {
            if (isnearpostLoading == false && allnearPost == false &&
                scroll.metrics.pixels == scroll.metrics.maxScrollExtent) {
              setState(() {
                // _homeViewModel.setLoading();
                isnearpostLoading = true;
                currentPage++;
                getrecentuser(false, currentPage);
              });
            }
            return;
          },
          child:
              InkWell(
                onTap: () {
                  navigateToNextScreen(context, false, TransferGroundedAcc(data[i]));
                },
                child:  Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          children: [
                            new Container(
                              width: 40,
                              height: 40,
                              margin: EdgeInsets.only(left: 20),
                              child:  ClipOval(
                                child: getProfileImage(getrecentuserlist[i].userImage!=null?getrecentuserlist[i].userImage:""),
                              )

                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              getrecentuserlist[i].username,
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        )),
              )),
              Divider(
                color: Colors.white,
              ),
            ],
          );
        });
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
      GroundedAccountListparams request = GroundedAccountListparams();
      request.uid = MemoryManagement.getuserId();
      request.page = currentPage.toString();
      request.limit = limit.toString();

      var response = await _homeViewModel.groundedaccountlist(request, context);

      print(response.toString());

      GroundedAccountlistResponse getrecentuserlistresponse = response;
      if (isClear == true) {
        getrecentuserlist.clear();
      }

      if (getrecentuserlistresponse != null &&
          getrecentuserlistresponse.accountsData.data != null &&
          getrecentuserlistresponse.accountsData.data.length > 0) {
        if (getrecentuserlistresponse.accountsData.data.length < limit) {
          allnearPost = true;
          isnearpostLoading = false;
        }
        if (getrecentuserlistresponse != null) {
          if (getrecentuserlistresponse.status != null &&
              getrecentuserlistresponse.status.isNotEmpty) {
            if (getrecentuserlistresponse.status.compareTo("success") == 0) {
              getrecentuserlist.addAll(getrecentuserlistresponse.accountsData.data);
              currentPage = 2;
              isDataLoaded = true;
              setState(() {});
            } else {}
          }
        }
        setState(() {
          isDataLoaded = true;
          isnearpostLoading = false;
        });
      } else {

        allnearPost = true;
        setState(() {
          isDataLoaded = true;
          isnearpostLoading = false;
        });
      }
    }
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
}
