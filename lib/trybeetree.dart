import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trybelocker/model/treebegroup/rename_tree.dart';
import 'package:trybelocker/notifications.dart';
import 'package:trybelocker/search.dart';
import 'package:trybelocker/settings/settings.dart';
import 'package:trybelocker/treedetails.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/viewmodel/home_view_model.dart';
import 'package:provider/src/provider.dart';
import 'package:trybelocker/viewmodel/trybe_tree_viewmodel.dart';
import 'UniversalFunctions.dart';
import 'package:flutter_share/flutter_share.dart';

import 'addtrybemembers.dart';
import 'model/treebegroup/create_trybe_params.dart';
import 'model/treebegroup/delete_trybe.dart';
import 'model/treebegroup/treebe_group_list_response.dart';
import 'model/treebegroup/treebe_list_params.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';

import 'networkmodel/APIs.dart';

class TrybeeTree extends StatefulWidget {
  HomeViewModel homeViewModel;

  TrybeeTree({Key key, this.homeViewModel}) : super(key: key);

  TrybeeTreeState createState() => TrybeeTreeState();
}

class TrybeeTreeState extends State<TrybeeTree> {
  var _tapPosition;
  List<TreeData> treedatalist = [];
  int _tempCount = 4;
  TrybeTreeViewModel _trybeTreeViewModel;
  TextEditingController treebename = TextEditingController();
  bool isDataLoaded = false;
  bool isPaid = false;
  BannerAd myBanner;
  var controller = ScrollController();

  @override
  void initState() {
    super.initState();
    isPaid = MemoryManagement.getPayment() == 1;
    
    print("hdhdhhd" + MemoryManagement.getPayment().toString());
  }

   initialzeBanners() {
    AdSize adSize = AdSize(width: 300, height: 60);
    myBanner = BannerAd(
      adUnitId: 'ca-app-pub-7410464693885383/1095703406',
      size: adSize,
      request: AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) {},
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // Dispose the ad here to free resources.

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
    return Container(
                          child: AdWidget(
                            ad: myBanner,
                          ),
                          width: myBanner.size.width.toDouble(),
                          height: myBanner.size.height.toDouble(),
                        );

  }

  getGroups() {
    isDataLoaded = false;
    _tapPosition = Offset(0.0, 0.0);
    getAllTreeGroups();
  }

  void getAllTreeGroups() async {
    _trybeTreeViewModel.setLoading();
    Treebe_list_params params =
        Treebe_list_params(uid: MemoryManagement.getuserId());
    var response =
        await _trybeTreeViewModel.getAllTreebeGroups(params, context);
    treedatalist.clear();
    Treebe_group_list_response treebegroup = response;
    if (treebegroup != null &&
        treebegroup.treeData != null &&
        treebegroup.treeData.length > 0) {
      setState(() {
        isDataLoaded = true;
        treedatalist.addAll(treebegroup.treeData);
        print("length== ${treedatalist.length}");
      });
    } else {
      setState(() {
        isDataLoaded = true;
      });
    }
  }

  refreshList(List<TreeData> treeData) {
    if (treeData != null && treeData.length > 0) {
      setState(() {
        treedatalist.clear();
        treedatalist.addAll(treeData);
        print("length== ${treedatalist.length}");
      });
    }
  }

  

  @override
  Widget build(BuildContext context) {
    _trybeTreeViewModel = Provider.of<TrybeTreeViewModel>(context);

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
        body: Stack(
          children: <Widget>[
            Column(
              children: [seperationline(2),    ConstrainedBox(
                constraints: new BoxConstraints(
                  minHeight: 35.0,
                  maxHeight: 100.0,
                ),
                child: getTrybeList(),
              ),Expanded(child: Container()),isPaid?Container():initialzeBanners(),SizedBox(height: 10,)],
            ),
            getFullScreenProviderLoader(
                status: isDataLoaded == true
                    ? _trybeTreeViewModel.getLoading()
                        ? true
                        : false
                    : true,
                context: context),
          ],
        ));
  }

  void deletetrybegroup(String treeId) async {
    _trybeTreeViewModel.setLoading();
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _trybeTreeViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Delete_trybe params =
          new Delete_trybe(uid: MemoryManagement.getuserId(), id: treeId);
      var response = await _trybeTreeViewModel.deleteTrybe(params, context);
      Treebe_group_list_response deletetrberesponse = response;
      if (deletetrberesponse.status.compareTo("success") == 0) {
        displaytoast("Sucessfully Deleted", context);
        //Navigator.pop(context, true);
        refreshList(deletetrberesponse.treeData);
      } else {
        displaytoast("Failed to delete the group", context);
      }
    }
  }

  void showrenamedialog({treeId, treeName}) {
    if (treeName != null) treebename.text = treeName;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext contexts) {
          return Dialog(
            insetPadding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Please enter tree name',
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
                        controller: treebename,
                        maxLines: 1,
                        minLines: 1,
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Gilroy-SemiBold",
                            color: Color.fromRGBO(60, 72, 88, 1),
                            fontSize: 16.7),
                        onFieldSubmitted: (trem) async {
                          if (treebename != null &&
                              treebename.text.length > 0) {
                            Navigator.pop(contexts);
                            _trybeTreeViewModel.setLoading();
                            Rename_tree params = Rename_tree(
                                uid: MemoryManagement.getuserId(),
                                id: treeId,
                                treeName: treebename.text);
                            var response = await _trybeTreeViewModel
                                .renameTrybe(params, context);
                            Treebe_group_list_response treebegroup = response;
                            treebename.text = "";
                            if (treebegroup != null &&
                                treebegroup.treeData != null &&
                                treebegroup.treeData.length > 0) {
                              if (treebegroup.status.compareTo("success") ==
                                  0) {
                                displaytoast("Successfully Renamed", context);
                              } else {
                                displaytoast("Something went wrong", context);
                              }
                              refreshList(treebegroup.treeData);
                            } else {
                              displaytoast("Something went wrong", context);
                            }
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
                                fontFamily: "Gilroy-Regular", fontSize: 13.3)),
                      ),
                    )),
                  ],
                ),
              ],
            ),
          );
        });
  }

  void showtreenamedialog({treeId, treeName}) {
    if (treeName != null) treebename.text = treeName;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext contexts) {
          return Dialog(
            insetPadding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Please enter tree name',
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
                        controller: treebename,
                        maxLines: 1,
                        minLines: 1,
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Gilroy-SemiBold",
                            color: Color.fromRGBO(60, 72, 88, 1),
                            fontSize: 16.7),
                        onFieldSubmitted: (trem) async {
                          if (treebename != null &&
                              treebename.text.length > 0) {
                            Navigator.pop(contexts);
                            _trybeTreeViewModel.setLoading();
                            Create_trybe_params params = Create_trybe_params(
                                uid: MemoryManagement.getuserId(),
                                treeName: treebename.text);
                            var response = await _trybeTreeViewModel
                                .createTrybeTree(params, context);
                            Treebe_group_list_response treebegroup = response;
                            treebename.text = "";
                            if (treebegroup != null &&
                                treebegroup.treeData != null &&
                                treebegroup.treeData.length > 0) {
                              if (treebegroup.status.compareTo("success") ==
                                  0) {
                                displaytoast("Successfully Created", context);
                              } else {
                                displaytoast("Something went wrong", context);
                              }
                              refreshList(treebegroup.treeData);
                            } else {
                              displaytoast("Something went wrong", context);
                            }
                          }
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => Treedetails()));
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
                                fontFamily: "Gilroy-Regular", fontSize: 13.3)),
                      ),
                    )),
                  ],
                ),
              ],
            ),
          );
        });
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  Future<void> _share(id) async {
    await FlutterShare.share(
        title: 'Share Tree',
        text: 'Share Tree',
        linkUrl: APIs.treeShare + "?treeId=" + id.toString(),
        chooserTitle: 'Chooser Title');
  }

  getTrybeList() {
    return ListView.builder(
        // shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: treedatalist.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Container(
              margin: EdgeInsets.only(right: 10),
              child: Column(
                children: <Widget>[
                  // SizedBox(height: ,10),
                  new Container(
                      width: 60,
                      height: 60,
                      margin: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        children: [
                          Image.asset(
                            "assets/whitetree.png",
                            fit: BoxFit.fill,
                          ),
                          Align(
                              alignment: Alignment.bottomRight,
                              child: Stack(
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(left: 7, top: 7),
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white)),
                                  InkWell(
                                    onTap: () {
                                      showtreenamedialog();
                                    },
                                    child: Icon(
                                      Icons.add_circle_outlined,
                                      size: 24,
                                      color: getColorFromHex(AppColors.red),
                                    ),
                                  )
                                ],
                              ))
                        ],
                      )),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    'New Trybe',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  )
                ],
              ),
            );
          } else {
            return GestureDetector(
                onTapDown: _storePosition,
                onTap: () {
                  Navigator.of(context, rootNavigator: true)
                      .push(MaterialPageRoute(
                          builder: (context) =>
                              AddTrybeMembers(treedatalist[index - 1].id)))
                      .then((value) {
                    if (value != null && value == true) {
                      getAllTreeGroups();
                    }
                  });
                },
                onLongPress: () async {
                  /*displaytoast(
                              "" + treedatalist[index - 1].id.toString(), context);*/
                  final RenderBox overlay =
                      Overlay.of(context).context.findRenderObject();
                  int selected = await showMenu(
                    position: RelativeRect.fromRect(
                        _tapPosition & Size(40, 40),
                        // smaller rect, the touch area
                        Offset.zero &
                            overlay.size // Bigger rect, the entire screen
                        ),
                    items: <PopupMenuEntry<int>>[
                      PopupMenuItem(
                        value: 0,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.copy),
                            Text("Copy"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 1,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.delete),
                            Text("Delete"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.edit),
                            Text("Rename"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 3,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.share),
                            Text("Share"),
                          ],
                        ),
                      ),
                    ],
                    context: context,
                  );
                  if (selected == 1) {
                    setState(() {
                      // --_tempCount;
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false,
                        // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Delete TrybeTree ?'),
                            content: Text(
                                'Do you really want to delete a trybe group'),
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
                                    Navigator.of(context).pop(false);
                                    deletetrybegroup(
                                        treedatalist[index - 1].id.toString());
                                    print('Deleted  Id:' +
                                        treedatalist[index - 1].id.toString());
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      );
                    });
                  } else if (selected == 3) {
                    _share(treedatalist[index - 1].id);
                  } else if (selected == 2) {
                    /*renameTree(
                                treeId: treedatalist[index - 1].id.toString(),
                                treeName: treedatalist[index - 1].treeName
                                );*/
                    showrenamedialog(
                        treeId: treedatalist[index - 1].id.toString(),
                        treeName: treedatalist[index - 1].treeName);
                  }
                },
                child: Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Column(
                      children: <Widget>[
                        // SizedBox(height: ,10),
                        new Container(
                          width: 60,
                          height: 60,
                          margin: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            "assets/whitetree.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          treedatalist[index - 1].treeName != null
                              ? treedatalist[index - 1].treeName
                              : "",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        )
                      ],
                    )));
          }
        });
  }
}
