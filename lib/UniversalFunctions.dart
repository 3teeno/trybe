import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/src/cached_image_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';
import 'package:toast/toast.dart';
import 'package:trybelocker/casting.dart';
import 'package:trybelocker/home_screen.dart';
import 'package:trybelocker/model/login/login_params.dart';
import 'package:trybelocker/model/login/loginresponse.dart';
import 'package:trybelocker/model/logout/logoutparams.dart';
import 'package:trybelocker/model/logout/logoutresponse.dart';
import 'package:trybelocker/model/user_details.dart';
import 'package:trybelocker/networkmodel/APIHandler.dart';
import 'package:trybelocker/networkmodel/APIs.dart';
import 'package:trybelocker/search.dart';
import 'package:trybelocker/settings/groundedaccounts/create_grounded_account.dart';
import 'package:trybelocker/settings/settings.dart';
import 'package:trybelocker/social_login.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/viewmodel/home_view_model.dart';

import 'main.dart';
import 'notifications.dart';

bool emailvalidation(String email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}

bool phonevalidation(String phonenumber) {
  return RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(phonenumber);
}

Color getColorFromHex(String hexColor) {
  hexColor = hexColor.replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  if (hexColor.length == 8) {
    return Color(int.parse("0x$hexColor"));
  }
}

bool passwordvalidation(String password) {
  // return RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
  //     .hasMatch(password);

  if (password.length > 0) {
    return true;
  } else {
    return false;
  }
}

// String formatDateString(String dateString, String format) {
//   try {
//     var datetimes =
//         DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(dateString));
//     var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(datetimes, true);
//     var dateLocal = dateTime.toLocal();
//     return DateFormat(format).format(dateLocal);
//   } catch (e) {
//     print("date error ${e.toString()}");
//     return "";
//   }
// }

String formatDateString(String dateString, String format) {
  try {
    var datetimes =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(dateString));
    var dateTime = DateFormat("yyyy-MM-dd").parse(datetimes);
    return DateFormat(format).format(dateTime);
  } catch (e) {
    print("date error ${e.toString()}");
    return "";
  }
}

void showtoast(String message) {
  showToast(
    message,
    duration: Duration(milliseconds: 3500),
    position: ToastPosition.top,
    backgroundColor: Colors.black.withOpacity(0.8),
    radius: 3.0,
    textStyle: TextStyle(fontSize: 30.0, color: Colors.white),
  );
}

void displaytoast(String message, BuildContext context) {
  Toast.show(message, context,
      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
}

void displaybottomsheet(BuildContext context, HomeViewModel homeViewModel) {
  List<UserDetail> userdetailsdata = [];
  if (MemoryManagement.getsaveotheraccounts() != null) {
    print("userdetails== ${MemoryManagement.getsaveotheraccounts()}");
    UserDetails userDetail = new UserDetails.fromJson(
        jsonDecode(MemoryManagement.getsaveotheraccounts()));
    if (userDetail != null &&
        userDetail.userDetails != null &&
        userDetail.userDetails.length > 0) {
      userdetailsdata.addAll(userDetail.userDetails);
    }
  }

  showModalBottomSheet(
      context: context,
      builder: (builder) {
        return new Container(
          height: 350.0,
          color: Colors.black, //could change this to Color(0xFF737373),
          //so you don't have to change MaterialApp canvasColor
          child: new Container(
              height: 350.0,
              padding: EdgeInsets.only(left: 20, top: 20, bottom: 0, right: 20),
              decoration: new BoxDecoration(
                  color: getColorFromHex(AppColors.bottomsheetbgcolor),
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
                          "Switch Account",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: getColorFromHex(AppColors.red),
                              fontSize: 20),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          logoutmethod(
                              context,
                              "Logout",
                              "Are you sure you want to logout?",
                              homeViewModel);
                        },
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            "Logout",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: ListView.builder(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          itemCount: userdetailsdata.length + 2,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == userdetailsdata.length) {
                              return InkWell(
                                onTap: () {
                                  logoutmethod(
                                      context,
                                      "Add Account",
                                      "To Add account you have to logout current account",
                                      homeViewModel);
                                },
                                child: Row(
                                  children: [
                                    new Container(
                                      width: 40,
                                      height: 40,
                                      margin: EdgeInsets.fromLTRB(2, 10, 2, 2),
                                      child: Image.asset(
                                        "assets/createpost.png",
                                        height: 35,
                                        width: 35,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text("Add Account")
                                  ],
                                ),
                              );
                            } else if (index == userdetailsdata.length + 1) {
                              return InkWell(
                                onTap: () {
                                  // logoutmethod(context, "Add Account",
                                  //     "To Add account you have to logout current account",homeViewModel);
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) =>
                                              CreateGroundedScreen(true)))
                                      .then((value) {
                                    if (value == true) {
                                      Navigator.of(context).pop();
                                    }
                                  });
                                },
                                child: Row(
                                  children: [
                                    new Container(
                                      width: 40,
                                      height: 40,
                                      margin: EdgeInsets.fromLTRB(2, 10, 2, 2),
                                      child: Image.asset(
                                        "assets/createpost.png",
                                        height: 35,
                                        width: 35,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text("Add Grounded Account")
                                  ],
                                ),
                              );
                            } else {
                              return InkWell(
                                onTap: () {
                                  if (userdetailsdata[index].userid.compareTo(
                                          MemoryManagement.getuserId()) !=
                                      0) {
                                    LoginParams loginParams = new LoginParams();
                                    print(
                                        " request=== ${userdetailsdata[index]}");
                                    if (userdetailsdata[index].email != null &&
                                        userdetailsdata[index]
                                            .email
                                            .isNotEmpty &&
                                        userdetailsdata[index]
                                                .email
                                                .trim()
                                                .compareTo("null") !=
                                            0) {
                                      loginParams.emailPhone =
                                          userdetailsdata[index].email;
                                      print(
                                          " request=== ${userdetailsdata[index].email}");
                                    } else if (userdetailsdata[index]
                                                .phonenumber !=
                                            null &&
                                        userdetailsdata[index]
                                            .phonenumber
                                            .isNotEmpty &&
                                        userdetailsdata[index]
                                                .phonenumber
                                                .trim()
                                                .compareTo("null") !=
                                            0) {
                                      print(
                                          " request=== ${userdetailsdata[index].phonenumber}");
                                      loginParams.emailPhone =
                                          userdetailsdata[index].phonenumber;
                                    } else if (userdetailsdata[index]
                                                .username !=
                                            null &&
                                        userdetailsdata[index]
                                            .username
                                            .isNotEmpty &&
                                        userdetailsdata[index]
                                                .username
                                                .trim()
                                                .compareTo("null") !=
                                            0) {
                                      loginParams.emailPhone =
                                          userdetailsdata[index].username;
                                    }
                                    loginParams.device_token =
                                        MemoryManagement.getDeviceToken();
                                    loginParams.key = "4";
                                    loginApi(
                                        loginParams, context, homeViewModel);
                                  }
                                },
                                child: Row(
                                  children: [
                                    new Container(
                                      width: 40,
                                      height: 40,
                                      margin: EdgeInsets.fromLTRB(2, 10, 2, 2),
                                      child: ClipOval(
                                        child: getuserprofilepic(
                                            userdetailsdata[index]),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(userdetailsdata[index].username),
                                    Spacer(),
                                    Visibility(
                                        visible:
                                            userdetailsdata[index].logintype !=
                                                    null
                                                ? userdetailsdata[index]
                                                            .logintype
                                                            .compareTo("4") ==
                                                        0
                                                    ? true
                                                    : false
                                                : false,
                                        child: Text("Grounded Account"))
                                  ],
                                ),
                              );
                            }
                          })),
                ],
              )),
        );
      });
}

getuserprofilepic(UserDetail userdetailsdata) {
  if (userdetailsdata.userimage != null &&
      userdetailsdata.userimage.isNotEmpty) {
    if (userdetailsdata.userimage.contains("https") ||
        userdetailsdata.userimage.contains("http")) {
      return getCachedNetworkImage(
          url: userdetailsdata.userimage, fit: BoxFit.fill);
    } else {
      return getCachedNetworkImage(
          url: APIs.userprofilebaseurl + userdetailsdata.userimage,
          fit: BoxFit.fill);
    }
  } else {
    return getCachedNetworkImage(
        url:
            "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80",
        fit: BoxFit.fill);
  }
}

String timeinminutes(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  // return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  print("timecheck=>,${twoDigits(duration.inMinutes)}:$twoDigitSeconds");
  return "${twoDigits(duration.inMinutes)}:$twoDigitSeconds";
}

File _image;
final picker = ImagePicker();

seperationline(double heightsize) {
  return Container(
    height: heightsize,
    color: getColorFromHex(AppColors.lightgrey),
  );
}

Widget getFullScreenProviderLoader({
  @required bool status,
  @required BuildContext context,
}) {
  return status
      ? getAppThemedLoader(
          context: context,
        )
      : new Container();
}

Widget getFullScreenProviderLoaderWithOutbackground({
  @required bool status,
  @required BuildContext context,
}) {
  return status
      ? getAppThemedLoader1(
          context: context,
        )
      : new Container();
}

Widget getAppThemedLoader1({
  @required BuildContext context,
  Color bgColor,
  Color color,
  double strokeWidth,
}) {
  return new Container(
    // color: bgColor ?? const Color.fromRGBO(1, 1, 1, 0.6),
    height: getScreenSize(context: context).height,
    width: getScreenSize(context: context).width,
    child: getChildLoader(
      color: color ?? AppColors.kPrimaryBlue,
      strokeWidth: strokeWidth,
    ),
  );
}

Size getScreenSize({@required BuildContext context}) {
  return MediaQuery.of(context).size;
}

// Returns app themed loader
Widget getAppThemedLoader({
  @required BuildContext context,
  Color bgColor,
  Color color,
  double strokeWidth,
}) {
  return new Container(
    color: bgColor ?? const Color.fromRGBO(1, 1, 1, 0.6),
    height: getScreenSize(context: context).height,
    width: getScreenSize(context: context).width,
    child: getChildLoader(
      color: color ?? AppColors.kPrimaryBlue,
      strokeWidth: strokeWidth,
    ),
  );
}

void logoutapi(
  BuildContext context,
  HomeViewModel homeViewModel,
) async {
  // getFullScreenProviderLoader(status: true, context: context);
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final facebookLogin = FacebookLogin();
  Logoutparams params = new Logoutparams(uid: MemoryManagement.getuserId());
  var response = await homeViewModel.logout(params, context);
  Logoutresponse privacyresponse = response;

  if (privacyresponse != null &&
      privacyresponse.status.compareTo("success") == 0) {
    displaytoast(privacyresponse.message, context);
    await googleSignIn.signOut();
    await facebookLogin.logOut();
    var loggedindetails = MemoryManagement.getsaveotheraccounts();
    MemoryManagement.clearMemory();
    MemoryManagement.setsaveotheraccounts(userDetails: loggedindetails);
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => SocialLogin(),
        ),
        (route) => false);
  }
}

logoutmethod(BuildContext contexts, String heading, String content,
    HomeViewModel homeViewModel) {
  return showDialog<void>(
    context: contexts,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          heading,
        ),
        content: Text(content),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'NO',
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          FlatButton(
            child: Text(
              'YES',
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              logoutapi(contexts, homeViewModel);
            },
          ),
        ],
      );
    },
  );
}

logoutmethod1(BuildContext contexts, String heading, String content,
    LoginParams request, HomeViewModel homeViewModel) {
  print("request=== ${request.toJson()}");
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final facebookLogin = FacebookLogin();
  return showDialog<void>(
    context: contexts,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          heading,
        ),
        content: Text(content),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'NO',
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          FlatButton(
            child: Text(
              'YES',
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              logoutapi1(contexts, request, homeViewModel);
            },
          ),
        ],
      );
    },
  );
}

void logoutapi1(BuildContext context, LoginParams request,
    HomeViewModel homeViewModel) async {
  // getFullScreenProviderLoader(status: true, context: context);
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final facebookLogin = FacebookLogin();
  Logoutparams params = new Logoutparams(uid: MemoryManagement.getuserId());
  var response = await homeViewModel.logout(params, context);
  Logoutresponse privacyresponse = response;
  if (privacyresponse != null &&
      privacyresponse.status.compareTo("success") == 0) {
    displaytoast(privacyresponse.message, context);
    await googleSignIn.signOut();
    await facebookLogin.logOut();
    var loggedindetails = MemoryManagement.getsaveotheraccounts();
    MemoryManagement.clearMemory();
    MemoryManagement.setsaveotheraccounts(userDetails: loggedindetails);
    var response = await APIHandler.post(
        context: context, url: APIs.loginUrl, requestBody: request.toJson());
    Loginresponse loginresponse = new Loginresponse.fromJson(response);
    if (loginresponse != null &&
        loginresponse.status != null &&
        loginresponse.status.trim().length > 0) {
      if (loginresponse.status.compareTo("success") == 0) {
        MemoryManagement.setUserLoggedIn(isUserLoggedin: true); //mar
        MemoryManagement.setuserName(
            username: loginresponse.userData.username); //mar
        MemoryManagement.setPhonenumber(
            phonenumber: loginresponse.userData.phoneNumber); //mar
        MemoryManagement.setuserId(id: loginresponse.userData.id.toString());
        MemoryManagement.setbirthdate(
            birthdate: loginresponse.userData.birthDate.toString());
        MemoryManagement.setEmail(
            email: loginresponse.userData.email.toString());
        MemoryManagement.setfullName(
            fullname: loginresponse.userData.fullName.toString());
        MemoryManagement.setcoverphoto(
            coverphoto: loginresponse.userData.cover_photo.toString());
        MemoryManagement.setAbout(
            about: loginresponse.userData.about.toString());
        MemoryManagement.setlogintype(
            logintype: loginresponse.userData.loginType.toString());

        if (loginresponse.checkPrivateData != null) {
          if (loginresponse.checkPrivateData.isGroupPrivate.compareTo("1") == 0)
            MemoryManagement.setTrybegroupPrivate(trybegroupprivate: true);
          else
            MemoryManagement.setTrybegroupPrivate(trybegroupprivate: false);

          if (loginresponse.checkPrivateData.isPlaylistPrivate.compareTo("1") ==
              0)
            MemoryManagement.setTrybelistPrivate(trybelistprivate: true);
          else
            MemoryManagement.setTrybelistPrivate(trybelistprivate: false);
        } else {
          MemoryManagement.setTrybegroupPrivate(trybegroupprivate: false);
          MemoryManagement.setTrybelistPrivate(trybelistprivate: false);
        }

        if (loginresponse.userData.userImage != null &&
            loginresponse.userData.userImage.isNotEmpty) {
          if (loginresponse.userData.userImage.contains("https") ||
              loginresponse.userData.userImage.contains("http")) {
            MemoryManagement.setuserprofilepic(
                profilepic: loginresponse.userData.userImage);
          } else {
            MemoryManagement.setuserprofilepic(
                profilepic:
                    APIs.userprofilebaseurl + loginresponse.userData.userImage);
          }
        } else {
          MemoryManagement.setuserprofilepic(
              profilepic:
                  "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80");
        }
        // if(MemoryManagement.getuserprofilepic()!=null&&MemoryManagement.getuserprofilepic().isNotEmpty)
        //   MemoryManagement.setuserprofilepic(profilepic: APIs.userprofilebaseurl+loginresponse.userData.userImage.toString());

        List<UserDetail> userdetailsdata = [];
        if (MemoryManagement.getsaveotheraccounts() != null) {
          UserDetails userDetail = new UserDetails.fromJson(
              jsonDecode(MemoryManagement.getsaveotheraccounts()));
          if (userDetail != null &&
              userDetail.userDetails != null &&
              userDetail.userDetails.length > 0) {
            userdetailsdata.addAll(userDetail.userDetails);
          }
        }

        if (userdetailsdata.length > 0) {
          var contain = userdetailsdata.where((element) =>
              element.userid.compareTo(MemoryManagement.getuserId()) == 0);
          if (contain.isEmpty) {
            UserDetail userdetail = new UserDetail();
            userdetail.email = MemoryManagement.getEmail();
            userdetail.phonenumber = MemoryManagement.getPhonenumber();
            userdetail.password = "";
            userdetail.userimage = MemoryManagement.getuserprofilepic() != null
                ? MemoryManagement.getuserprofilepic()
                : "";
            userdetail.userid = MemoryManagement.getuserId();
            userdetail.username = MemoryManagement.getuserName();
            userdetail.logintype = MemoryManagement.getlogintype();
            userdetailsdata.add(userdetail);
          }
        } else {
          UserDetail userdetail = new UserDetail();
          userdetail.email = MemoryManagement.getEmail();
          userdetail.phonenumber = MemoryManagement.getPhonenumber();
          userdetail.password = "";
          userdetail.userimage = MemoryManagement.getuserprofilepic() != null
              ? MemoryManagement.getuserprofilepic()
              : "";
          userdetail.userid = MemoryManagement.getuserId();
          userdetail.username = MemoryManagement.getuserName();
          userdetail.logintype = MemoryManagement.getlogintype();
          userdetailsdata.add(userdetail);
        }

        UserDetails user = new UserDetails(userDetails: userdetailsdata);
        var loggedinvalue = json.encode(user);
        MemoryManagement.setsaveotheraccounts(userDetails: loggedinvalue);
        print(MemoryManagement.getsaveotheraccounts());
        // Navigator.of(contexts).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomeScreen(),), (route) => true);
        // Navigator.popUntil(contexts, ModalRoute.withName('/'),);
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (BuildContext context) => MyApp(isUserLoggedIn: true),
            ),
            ModalRoute.withName('/'));
      } else {
        displaytoast(loginresponse.message, context);
      }
    } else {
      // displaytoast(loginresponse.message, context);
    }
  }
}

getprofilepic(int index) {
  // if (getnotificationlist[index].userInfo.userImage != null && getnotificationlist[index].userInfo.userImage.isNotEmpty) {
  //   if(getnotificationlist[index].userInfo.userImage.contains("https")||getnotificationlist[index].userInfo.userImage.contains("http")) {
  //     return NetworkImage(getnotificationlist[index].userInfo.userImage);
  //   }else{
  //     return NetworkImage(APIs.userprofilebaseurl + getnotificationlist[index].userInfo.userImage);
  //   }
  // } else{
  return NetworkImage(
      "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80");
  // }
}

Widget getCacheCoverImage({@required String url, BoxFit fit, height, width}) {
  return new CachedNetworkImage(
    width: width ?? double.infinity,
    height: height ?? double.infinity,
    imageUrl: url,
    matchTextDirection: true,
    fit: fit,
    placeholder: (context, String val) {
      return Container(
        decoration: BoxDecoration(color: getColorFromHex("#d3d3d3")),
      );
    },
  );
}

//cached Network image
Widget getCachedNetworkImage(
    {@required String url, BoxFit fit, height, width}) {
  return new CachedNetworkImage(
    width: width ?? double.infinity,
    height: height ?? double.infinity,
    imageUrl: url,
    matchTextDirection: true,
    fit: fit,
    placeholder: (context, String val) {
      return SpinKitCircle(
        itemBuilder: (BuildContext context, int index) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          );
        },
      );
    },
    errorWidget: (BuildContext context, String error, Object obj) {
      return new Center(
          child: Icon(
        Icons.image,
        color: Colors.grey,
        size: 36.0,
      ));
    },
  );
}

Widget getChildLoader({
  Color color,
  double strokeWidth,
}) {
  return new Center(
    child: new CircularProgressIndicator(
      backgroundColor: Colors.transparent,
      valueColor: new AlwaysStoppedAnimation<Color>(
        color ?? Colors.white,
      ),
      strokeWidth: strokeWidth ?? 6.0,
    ),
  );
}

void loginApi(LoginParams request, BuildContext context,
    HomeViewModel homeViewModel) async {
  // logoutmethod1(context, "Add Account", "To Add account you have to logout current account",request);
  logoutmethod1(context, "Switch Account",
      "To Switch you have to logout current account", request, homeViewModel);
}

ScrollAppBar commonAppbar(BuildContext context, HomeViewModel homeViewModel,
    ScrollController controller) {
  return ScrollAppBar(
    controller: controller,
    brightness: Brightness.dark,
    backgroundColor: getColorFromHex(AppColors.black),
    automaticallyImplyLeading: false,
    title: InkWell(
        onTap: () {
          displaybottomsheet(context, homeViewModel);
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
          homeViewModel.controller.add(true);
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
            homeViewModel.controller.add(true);
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                statusBarColor: Colors.black,
                systemNavigationBarColor: getColorFromHex(AppColors.black),
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
            homeViewModel.controller.add(true);
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                statusBarColor: Colors.black,
                systemNavigationBarColor: getColorFromHex(AppColors.black),
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
            homeViewModel.controller.add(true);
            if (!(MemoryManagement.getlogintype().compareTo("4") == 0)) {
              SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                  statusBarColor: Colors.black,
                  systemNavigationBarColor: getColorFromHex(AppColors.black),
                  statusBarIconBrightness: Brightness.light,
                  systemNavigationBarIconBrightness: Brightness.light));
              navigateToNextScreen(context, true, SettingsScreen());
            } else {
              displaytoast("You don't have access to open settings", context);
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
  );
}

settingsHeader(title, [logo]) {
  UserDetail userdetailsdata = new UserDetail();
  userdetailsdata.userimage = logo;

  return Column(
    children: [
      SizedBox(
        height: 20,
      ),
      Container(
        width: 80,
        height: 80,
        margin: EdgeInsets.fromLTRB(2, 10, 2, 2),
        child: ClipOval(
          child: getuserprofilepic(userdetailsdata),
        ),
      ),

      // new CircleAvatar(
      //   radius: 25.0,
      //   backgroundImage:
      // ),
      SizedBox(
        height: 20,
      ),
      Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      SizedBox(
        height: 20,
      ),
    ],
  );
}

void navigateToNextScreen(BuildContext context, bool onRoute, routeName) {
  Navigator.of(context, rootNavigator: onRoute)
      .push(MaterialPageRoute(builder: (context) => routeName));
}

// Checks Internet connection
Future<bool> hasInternetConnection({
  @required BuildContext context,
  bool mounted,
  @required Function onSuccess,
  @required Function onFail,
  bool canShowAlert = true,
}) async {
  try {
    final result = await InternetAddress.lookup('example.com')
        .timeout(const Duration(seconds: 5));
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      onSuccess();
      return true;
    } else {
      if (canShowAlert) {
        onFail();
        /* showAlert(
          context: context,
          titleText: Localization.of(context).trans(LocalizationValues.error),
          message: Messages.noInternetError,
          actionCallbacks: {
            Localization.of(context).trans(LocalizationValues.ok): () {
              return false;
            }
          },
        );*/
      }
    }
  } catch (_) {
    onFail();
    /*  showAlert(
        context: context,
        titleText: Localization.of(context).trans(LocalizationValues.error),
        message: Messages.noInternetError,
        actionCallbacks: {
          Localization.of(context).trans(LocalizationValues.ok): () {
            return false;
          }
        });*/
  }
  return false;
}

Widget getDialogLoader({
  @required bool status,
  @required BuildContext context,
}) {
  return status
      ? getAppThemedLoaders(
          context: context,
        )
      : new Container(
          height: 150,
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
    height: 150,
    child: getChildLoader(
      color: color ?? AppColors.kPrimaryBlue,
      strokeWidth: strokeWidth,
    ),
  );
}

void initializePushNotifications(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    FirebaseMessaging _firebaseMessaging,
    BuildContext context) async {
  var initializationSettingsAndroid =
      new AndroidInitializationSettings('mipmap/ic_launcher');
  var initializationSettingsIOS = new IOSInitializationSettings();
  var initializationSettings = new InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  bool isChecked = false;

  await _firebaseMessaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  RemoteMessage initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null && isChecked == true) {
      await Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen(),
          ),
          (route) => false);
    } else {
      isChecked = true;
    }
  });
//        onSelectNotification: onSelectNotification);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("data=>,");
    print("data=>,${message.data}");
    print("data=>,${message.notification.title}");
    RemoteNotification notification = message.notification;
    AndroidNotification android = message.notification?.android;
    _showNotificationWithDefaultSound(
        message.data, flutterLocalNotificationsPlugin, notification);
  });

  // _firebaseMessaging.onIosSettingsRegistered
  //     .listen((IosNotificationSettings settings) {
  //   print("Settings registered: $settings");
  // });
}

Future _showNotificationWithDefaultSound(
    Map<dynamic, dynamic> data,
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    RemoteNotification notification) async {
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'trybe', 'Download', 'Post Downloading',
      importance: Importance.max, priority: Priority.high, playSound: true);
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

  String title = notification.title ?? "TryBeLocker";
  String messages = notification.body ?? "New message ";

  Random random = new Random();
  int randomNumber = random.nextInt(200);

  var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  if (flutterLocalNotificationsPlugin != null)
    await flutterLocalNotificationsPlugin.show(
      randomNumber,
      title,
      messages,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );

  // if (data != null) {
  //   String title = data['title'] ?? "TryBeLocker";
  //   String messages = data['bodyText'] ?? "New message ";
  //
  //   Random random = new Random();
  //   int randomNumber = random.nextInt(200);
  //
  //   var platformChannelSpecifics = new NotificationDetails(android:androidPlatformChannelSpecifics,iOS: iOSPlatformChannelSpecifics);
  //   if (flutterLocalNotificationsPlugin != null) await flutterLocalNotificationsPlugin.show(randomNumber,
  //     title, messages, platformChannelSpecifics, payload: 'Default_Sound',);
  //
  // }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('BG MESSAGE: ${message.messageId}');
}

Future canMakePayments() async {
  bool result = await flutterPay.canMakePayments();
  print('can make payments $result');
}
