import 'dart:async';
//import 'dart:html';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/src/provider.dart';
import 'package:trybelocker/UniversalFunctions.dart';
import 'package:trybelocker/favourites.dart';
import 'package:trybelocker/newsfeed.dart';
import 'package:trybelocker/profile/profile.dart';
import 'package:trybelocker/shield/screen.dart';
import 'package:trybelocker/shield/shield_creation.dart';
import 'package:trybelocker/trybeetree.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/viewmodel/home_view_model.dart';
import 'package:uni_links/uni_links.dart';
import 'package:permission_handler/permission_handler.dart';

import 'addtrybemembers.dart';
import 'createpost/create_post.dart';

class HomeScreen extends StatefulWidget {
  static const String TAG = "/homescreen";

  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  static HomeViewModel _homeViewModel;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  int currentTab = 0;
  Color selectedColor = Colors.red;
  Color unselectedColor = Colors.white;
  bool canback = false;
  bool isLoaded = false;
  var _homescreen = GlobalKey<NavigatorState>();
  var _trybescreen = GlobalKey<NavigatorState>();
  var _createpostscreen = GlobalKey<NavigatorState>();
  var _favoritesscreen = GlobalKey<NavigatorState>();
  var _profileScreen = GlobalKey<NavigatorState>();
  String devicetoken = "";
  var controller = ScrollController();

  GlobalKey<NewsFeedState> _newsfeedstate = new GlobalKey<NewsFeedState>();
  GlobalKey<TrybeeTreeState> _trybestate = new GlobalKey<TrybeeTreeState>();
  GlobalKey<FavouritesState> _favouritesstate =
      new GlobalKey<FavouritesState>();
  GlobalKey<ProfileState> _profilestate = new GlobalKey<ProfileState>();

  //to handle deep links
  String _latestLink = 'Unknown';
  Uri _latestUri;
  StreamSubscription _sub;
  UniLinksType _type = UniLinksType.string;

  initPlatformState() async {
    if (_type == UniLinksType.string) {
      await initPlatformStateForStringUniLinks();
    } else {
      await initPlatformStateForUriUniLinks();
    }
  }

  /// An implementation using a [String] link
  initPlatformStateForStringUniLinks() async {
    // Attach a listener to the links stream
    _sub = linkStream.listen((String link) {
      if (!mounted) return;
      setState(() {
        _latestLink = link ?? 'Unknown';
        _latestUri = null;
        try {
          if (link != null) _latestUri = Uri.parse(link);
        } on FormatException {}
      });
    }, onError: (err) {
      if (!mounted) return;
      setState(() {
        _latestLink = 'Failed to get latest link: $err.';
        _latestUri = null;
      });
    });

    // Attach a second listener to the stream
    linkStream.listen((String link) {
      // print('got_link1: $link');
      _moveToTree(link);
    }, onError: (err) {
      // print('got err: $err');
    });

    // Get the latest link
    String initialLink;
    Uri initialUri;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      initialLink = await getInitialLink();
      // print('initial link: $initialLink');
      // print('got_link2: $initialLink');
      _moveToTree(initialLink);
      if (initialLink != null) initialUri = Uri.parse(initialLink);
    } on PlatformException {
      initialLink = 'Failed to get initial link.';
      initialUri = null;
    } on FormatException {
      initialLink = 'Failed to parse the initial link as Uri.';
      initialUri = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    //setState(() {
    _latestLink = initialLink;
    _latestUri = initialUri;
    // });
  }

  /// An implementation using the [Uri] convenience helpers
  initPlatformStateForUriUniLinks() async {
    // Attach a listener to the Uri links stream
    _sub = uriLinkStream.listen((Uri uri) {
      if (!mounted) return;
      setState(() {
        _latestUri = uri;
        _latestLink = uri?.toString() ?? 'Unknown';
      });
    }, onError: (err) {
      if (!mounted) return;
      setState(() {
        _latestUri = null;
        _latestLink = 'Failed to get latest link: $err.';
      });
    });

    // Attach a second listener to the stream
    getUriLinksStream().listen((Uri uri) {
      // print('got uri: ${uri?.path} ${uri?.queryParametersAll}');
    }, onError: (err) {
      // print('got err: $err');
    });

    // Get the latest Uri
    Uri initialUri;
    String initialLink;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      initialUri = await getInitialUri();
      initialLink = initialUri?.toString();
      _moveToTree(initialLink);
    } on PlatformException {
      initialUri = null;
      initialLink = 'Failed to get initial uri.';
    } on FormatException {
      initialUri = null;
      initialLink = 'Bad parse the initial link as Uri.';
    }

    _latestUri = initialUri;
    _latestLink = initialLink;
  }

  void _moveToTree(String deepLink) {
    try {
      if (deepLink != null) {
        var data = deepLink.split("treeId=");
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (context) => AddTrybeMembers(int.parse(data.last))));
        print('deeplinking${data.last}');
      }
    } catch (ex) {
      print("no tag found $ex");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatformState();

    canMakePayments();
    // makePayment();
    _firebaseMessaging.getToken().then((token) {
      print("tokenid=>,$token");
      // deviceToken=token;
    });
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        new FlutterLocalNotificationsPlugin();
    initializePushNotifications(
      flutterLocalNotificationsPlugin,
      _firebaseMessaging,
      context,
    );

    getdevicetoken();
  }

  @override
  Widget build(BuildContext context) {
    _homeViewModel = Provider.of<HomeViewModel>(context);
    return new WillPopScope(
        onWillPop: _onBackPressed,
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              Scaffold(
                // appBar: PreferredSize(
                //   preferredSize: currentTab==2? Size.fromHeight(0.0): Size.fromHeight(AppBar().preferredSize.height),
                //   child: commonAppbar(context, _homeViewModel,controller),
                // ),
                body: Stack(
                  children: <Widget>[
                    IndexedStack(
                      index: currentTab,
                      children: <Widget>[
                        Navigator(
                          key: _homescreen,
                          onGenerateRoute: (route) => MaterialPageRoute(
                            settings: route,
                            builder: (context) => NewsFeed(
                                key: _newsfeedstate,
                                controller: controller,
                                homeViewModel: _homeViewModel),
                          ),
                        ),
                        Navigator(
                          key: _trybescreen,
                          onGenerateRoute: (route) => MaterialPageRoute(
                              settings: route,
                              builder: (context) => ShieldCreationScreen()),
                        ),
                        // Navigator(
                        //   key: _trybescreen,
                        //   onGenerateRoute: (route) => MaterialPageRoute(
                        //     settings: route,
                        //     builder: (context) => TrybeeTree(
                        //         key: _trybestate,
                        //         homeViewModel: _homeViewModel),
                        //   ),
                        // ),
                        // requestmediapermission(),
                        Navigator(
                          key: _createpostscreen,
                          onGenerateRoute: (route) => MaterialPageRoute(
                            settings: route,
                            builder: (context) => CreatePost(),
                          ),
                        ),
                        Navigator(
                          key: _favoritesscreen,
                          onGenerateRoute: (route) => MaterialPageRoute(
                            settings: route,
                            builder: (context) => Favourites(
                                key: _favouritesstate,
                                homeViewModel: _homeViewModel
                                // controller:controller,
                                ),
                          ),
                        ),
                        Navigator(
                          key: _profileScreen,
                          onGenerateRoute: (route) => MaterialPageRoute(
                            settings: route,
                            builder: (context) => Profile(
                                key: _profilestate,
                                homeViewModel: _homeViewModel
                                // controller:controller,
                                ),
                          ),
                        ),
                      ],
                    ),
                    getFullScreenProviderLoader(
                        status: isLoaded, context: context)
                  ],
                ),
                bottomNavigationBar: BottomAppBar(
                  child: Container(
                      decoration: BoxDecoration(
                          color: getColorFromHex(AppColors.black)),
                      // padding: EdgeInsets.only(/*bottom: 5,*/ top: 5),
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          seperationline(2),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: _bottomTabWidget("assets/home.png",
                                      "Home", currentTab == 0, 0, 20)),
                              Expanded(
                                  child: _bottomTabWidget("assets/shield.png",
                                      "CoA", currentTab == 1, 1, 20)),
                              Expanded(
                                  child: _bottomTabWidget(
                                      "assets/createpost.png",
                                      "",
                                      currentTab == 2,
                                      2,
                                      35)),
                              Expanded(
                                  child: _bottomTabWidget(
                                      "assets/favourite.png",
                                      "Favorites",
                                      currentTab == 3,
                                      3,
                                      20)),
                              Expanded(
                                  child: _bottomTabWidget("assets/profile.png",
                                      "Profile", currentTab == 4, 4, 20))
                            ],
                          ),
                        ],
                      )),
                ),
              ),
              getFullScreenProviderLoader(
                  status: _homeViewModel.getLoading(), context: context)
            ],
          ),
        ));
  }

  void getdevicetoken() async {
    await _firebaseMessaging.getToken().then((value) {
      devicetoken = value;
      MemoryManagement.setDeviceToken(devic_token: devicetoken);
      var instance =
          FirebaseDatabase.instance.reference().child('devicetokens');
      print("instance=>,${instance}");
      if (instance != null) {
        instance.child(MemoryManagement.getuserId()).set({
          'username': MemoryManagement.getuserName(),
          'userid': MemoryManagement.getuserId(),
          'email': MemoryManagement.getEmail(),
          'token': devicetoken
        });
      }
      //displaytoast("devicetokenn $devicetoken", context);
    });
  }

  Widget _bottomTabWidget(
      String icon, String icon_text, bool isChecked, int pos, double size) {
    return MaterialButton(
        // minWidth: 15,
        onPressed: () {
          print("pos== $pos");
          setState(() {
            currentTab = pos;
            canback = false;
            // controller=ScrollController();
          });
          _homeViewModel.controller.add(true);
          if (pos == 0) {
            _newsfeedstate?.currentState?.getNewsFeed();
          } else if (pos == 1) {
            _trybestate?.currentState?.getGroups();
          } else if (pos == 3) {
            _favouritesstate?.currentState?.getCollections();
          } else if (pos == 4) {
            _profilestate?.currentState?.getCollections();
          }
        },
        child: getProfileIcon(icon, icon_text, isChecked, size));
  }

  getProfileIcon(String icon, String icon_text, bool isChecked, double size) {
    return Container(
        child: Column(
      children: [
        Image.asset(
          icon,
          height: size,
          width: size,
          color: isChecked ? selectedColor : unselectedColor,
        ),
        SizedBox(
          height: 3,
        ),
        Visibility(
          visible: icon_text.isNotEmpty,
          child: Text(
            icon_text,
            style: TextStyle(
              color: isChecked ? selectedColor : unselectedColor,
              fontSize: 9,
            ),
            textAlign: TextAlign.center,
          ),
        )
      ],
    ));
  }

  Future<bool> _onBackPressed() async {
    if (canback == true) {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Exit the app?'),
            content: Text('Do you want to exit an App'),
            actions: <Widget>[
              FlatButton(
                child: Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('YES'),
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pop(true);
                    SystemNavigator.pop();
                    //   exit(0);
                  }); //close app
                },
              ),
            ],
          );
        },
      );
    } else {
      setState(() {
        currentTab = 4;
        canback = true;
      });
    }
  }

  // Future<bool> _onBackPressed() async {
  //   bool canPop = false;
  //   switch (currentTab) {
  //     case 0:
  //       {
  //         canPop = _homescreen.currentState.canPop();
  //         if (canPop) _homescreen.currentState.pop();
  //         break;
  //       }
  //
  //     case 1:
  //       {
  //         canPop = _trybescreen.currentState.canPop();
  //         if (canPop) _trybescreen.currentState.pop();
  //
  //         break;
  //       }
  //     case 2:
  //       {
  //         canPop = _createpostscreen.currentState.canPop();
  //         if (canPop) _createpostscreen.currentState.pop();
  //
  //         break;
  //       }
  //
  //     case 3:
  //       {
  //         canPop = _favoritesscreen.currentState.canPop();
  //         if (canPop) _favoritesscreen.currentState.pop();
  //
  //         break;
  //       }
  //
  //     case 4:
  //       {
  //         canPop = _profileScreen.currentState.canPop();
  //         if (canPop) _profileScreen.currentState.pop();
  //
  //         break;
  //       }
  //   }
  //   if (!canPop) //check if screen popped or not and showing home tab data
  //     return showDialog<void>(
  //           context: context,
  //           barrierDismissible: false, // user must tap button!
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               title: Text('Exit the app?'),
  //               content: Text('Do you want to exit an App'),
  //               actions: <Widget>[
  //                 FlatButton(
  //                   child: Text('NO'),
  //                   onPressed: () {
  //                     Navigator.of(context).pop(false);
  //                   },
  //                 ),
  //                 FlatButton(
  //                   child: Text('YES'),
  //                   onPressed: () {
  //                     setState(() {
  //                       Navigator.of(context).pop(true);
  //                     //   exit(0);
  //                     }); //close app
  //                   },
  //                 ),
  //               ],
  //             );
  //           },
  //         ) ??
  //         false;
  // }

  requestmediapermission() async {
    var result = await PhotoManager.requestPermission();

    var status = await Permission.camera.request();

//     if (status.isDenied) {
//     // We didn't ask for permission yet.
//     }
//
// // You can can also directly ask the permission about its status.
//     if (await Permission.location.isRestricted) {
//     // The OS restricts access, for example because of parental controls.
//     }
    if (result) {
      Navigator(
        onGenerateRoute: (route) => MaterialPageRoute(
          settings: route,
          builder: (context) => CreatePost(),
        ),
      );
    } else {
      print("please allow permission");
    }
  }
}

enum UniLinksType { string, uri }
