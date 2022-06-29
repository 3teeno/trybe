import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trybelocker/model/login/login_params.dart';
import 'package:trybelocker/model/user_details.dart';
import 'package:trybelocker/networkmodel/APIs.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/viewmodel/home_view_model.dart';
import '../../UniversalFunctions.dart';
import 'package:provider/src/provider.dart';

class SwitchAcctScreen extends StatefulWidget {
  static const String TAG = "/switch_accounts";

  @override
  SwitchAcctScreenState createState() => SwitchAcctScreenState();
}

class SwitchAcctScreenState extends State<SwitchAcctScreen> {
  List<UserDetail> userdetailsdata = [];
  HomeViewModel _homeViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (MemoryManagement.getsaveotheraccounts() != null) {
      print("userdetails== ${MemoryManagement.getsaveotheraccounts()}");
      UserDetails userDetail = new UserDetails.fromJson(
          jsonDecode(MemoryManagement.getsaveotheraccounts()));
      if (userDetail != null &&
          userDetail.userDetails != null &&
          userDetail.userDetails.length > 0) {
        userdetailsdata.addAll(userDetail.userDetails);
        // getComments();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _homeViewModel = Provider.of<HomeViewModel>(context);
    return Scaffold(
        backgroundColor: getColorFromHex(AppColors.black),
        appBar: AppBar(
          title: Text(
            "Settings",
          ),
          backgroundColor: getColorFromHex(AppColors.black),
          brightness: Brightness.dark,
        ),
        body: Stack(
          children: <Widget>[
            Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                settingsHeader(
                    'Switch Account', MemoryManagement.getuserprofilepic()),
                Expanded(child: setAccts())
              ],
            )),
            getFullScreenProviderLoader(
                status: _homeViewModel.getLoading(), context: context)
          ],
        ));
  }

  setAccts() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: userdetailsdata.length,
        itemBuilder: (context, index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  if (userdetailsdata[index]
                          .userid
                          .compareTo(MemoryManagement.getuserId()) !=
                      0) {
                    LoginParams loginParams = new LoginParams();
                    print(" request=== ${userdetailsdata[index]}");
                    if (userdetailsdata[index].email != null &&
                        userdetailsdata[index].email.isNotEmpty &&
                        userdetailsdata[index].email.trim().compareTo("null") !=
                            0) {
                      loginParams.emailPhone = userdetailsdata[index].email;
                      print(" request=== ${userdetailsdata[index].email}");
                    } else if (userdetailsdata[index].phonenumber != null &&
                        userdetailsdata[index].phonenumber.isNotEmpty &&
                        userdetailsdata[index]
                                .phonenumber
                                .trim()
                                .compareTo("null") !=
                            0) {
                      print(
                          " request=== ${userdetailsdata[index].phonenumber}");
                      loginParams.emailPhone =
                          userdetailsdata[index].phonenumber;
                    } else if (userdetailsdata[index].username != null &&
                        userdetailsdata[index].username.isNotEmpty &&
                        userdetailsdata[index]
                                .username
                                .trim()
                                .compareTo("null") !=
                            0) {
                      print(" request=== ${userdetailsdata[index].username}");
                      loginParams.emailPhone = userdetailsdata[index].username;
                    }
                    loginParams.device_token = MemoryManagement.getDeviceToken();
                    loginParams.key = "4";
                    loginApi(loginParams, context, _homeViewModel);
                  }
                },
                child: Container(
                  child: Row(
                    children: <Widget>[
                      new Container(
                        width: 40,
                        height: 40,
                        margin: EdgeInsets.only(left: 20),
                        decoration: BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: ClipOval(
                          child: getProfileImage(
                              userdetailsdata[index].userimage != null
                                  ? userdetailsdata[index].userimage
                                  : ""),
                          // child: userdetailsdata[index].userimage!=null?userdetailsdata[index].userimage.isNotEmpty?NetworkImage(getProfileImage(userdetailsdata[index].userimage)):NetworkImage("https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80"):NetworkImage("https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80"),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        userdetailsdata[index].username,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                // child: ListTile(
                //   title: Text(
                //     userdetailsdata[index].username,
                //     style: TextStyle(color: Colors.white),
                //   ),
                //   leading: CircleAvatar(
                //     backgroundImage: userdetailsdata[index].userimage!=null?userdetailsdata[index].userimage.isNotEmpty?NetworkImage(getProfileImage(userdetailsdata[index].userimage)):NetworkImage("https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80"):NetworkImage("https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80"),
                //   ),
                // ),
              ),
              Divider(
                color: Colors.white,
              ),
            ],
          );
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
}
