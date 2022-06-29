import 'package:flutter/material.dart';
import 'package:trybelocker/UniversalFunctions.dart';
import 'package:trybelocker/addtrybemembers.dart';
import 'package:trybelocker/model/treebegroup/treebe_group_list_response.dart';
import 'package:trybelocker/shield/shield_creation.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';

class ShieldCreationScreen extends StatefulWidget {
  const ShieldCreationScreen({Key key}) : super(key: key);

  @override
  _ShieldCreationScreenState createState() => _ShieldCreationScreenState();
}

class _ShieldCreationScreenState extends State<ShieldCreationScreen> {
  var controller = ScrollController();
  List<TreeData> treedatalist = [];
  var _createpostscreen = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColorFromHex(AppColors.black),
      appBar: ScrollAppBar(
        controller: controller,
        brightness: Brightness.dark,
        backgroundColor: getColorFromHex(AppColors.black),
        automaticallyImplyLeading: false,
        title: InkWell(
            onTap: () {
              // displaybottomsheet(context, widget.homeViewModel);
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
              // navigateToNextScreen(context, true, Casting());
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
                // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                //     statusBarColor: Colors.black,
                //     systemNavigationBarColor:
                //     getColorFromHex(AppColors.black),
                //     statusBarIconBrightness: Brightness.light,
                //     systemNavigationBarIconBrightness: Brightness.light));
                // navigateToNextScreen(context, true, NotificationScreen());
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
                // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                //     statusBarColor: Colors.black,
                //     systemNavigationBarColor:
                //     getColorFromHex(AppColors.black),
                //     statusBarIconBrightness: Brightness.light,
                //     systemNavigationBarIconBrightness: Brightness.light));
                // navigateToNextScreen(context, true, SearchScreen());
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
                // if (!(MemoryManagement.getlogintype().compareTo("4") == 0)) {
                //   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                //       statusBarColor: Colors.black,
                //       systemNavigationBarColor:
                //       getColorFromHex(AppColors.black),
                //       statusBarIconBrightness: Brightness.light,
                //       systemNavigationBarIconBrightness: Brightness.light));
                //   navigateToNextScreen(context, true, SettingsScreen());
                // } else {
                //   displaytoast(
                //       "You don't have access to open settings", context);
                // }
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
      body: Container(
        child: getTrybeList(),
      ),
    );
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
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        children: [
                          Image.asset(
                            "assets/shield.png",
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
                                      Navigator.of(context, rootNavigator: true)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  CreateShield()));
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
                    'New CoA',
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
                      // getAllTreeGroups();
                    }
                  });
                },
                onLongPress: () async {
                  /*displaytoast(
                              "" + treedatalist[index - 1].id.toString(), context);*/
                  // final RenderBox overlay =
                  // Overlay.of(context).context.findRenderObject();
                  // int selected = await showMenu(
                  //   position: RelativeRect.fromRect(
                  //       _tapPosition & Size(40, 40),
                  //       // smaller rect, the touch area
                  //       Offset.zero &
                  //       overlay.size // Bigger rect, the entire screen
                  //   ),
                  //   items: <PopupMenuEntry<int>>[
                  //     PopupMenuItem(
                  //       value: 0,
                  //       child: Row(
                  //         children: <Widget>[
                  //           Icon(Icons.copy),
                  //           Text("Copy"),
                  //         ],
                  //       ),
                  //     ),
                  //     PopupMenuItem(
                  //       value: 1,
                  //       child: Row(
                  //         children: <Widget>[
                  //           Icon(Icons.delete),
                  //           Text("Delete"),
                  //         ],
                  //       ),
                  //     ),
                  //     PopupMenuItem(
                  //       value: 2,
                  //       child: Row(
                  //         children: <Widget>[
                  //           Icon(Icons.edit),
                  //           Text("Rename"),
                  //         ],
                  //       ),
                  //     ),
                  //     PopupMenuItem(
                  //       value: 3,
                  //       child: Row(
                  //         children: <Widget>[
                  //           Icon(Icons.share),
                  //           Text("Share"),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  //   context: context,
                  // );
                  // if (selected == 1) {
                  //   setState(() {
                  //     // --_tempCount;
                  //     showDialog<void>(
                  //       context: context,
                  //       barrierDismissible: false,
                  //       // user must tap button!
                  //       builder: (BuildContext context) {
                  //         return AlertDialog(
                  //           title: Text('Delete TrybeTree ?'),
                  //           content: Text(
                  //               'Do you really want to delete a trybe group'),
                  //           actions: <Widget>[
                  //             FlatButton(
                  //               child: Text('NO'),
                  //               onPressed: () {
                  //                 Navigator.of(context).pop(false);
                  //               },
                  //             ),
                  //             FlatButton(
                  //               child: Text('YES'),
                  //               onPressed: () {
                  //                 setState(() {
                  //                   Navigator.of(context).pop(false);
                  //                   // deletetrybegroup(
                  //                   //     treedatalist[index - 1].id.toString());
                  //                   print('Deleted  Id:' +
                  //                       treedatalist[index - 1].id.toString());
                  //                 });
                  //               },
                  //             ),
                  //           ],
                  //         );
                  //       },
                  //     );
                  //   });
                  // } else if (selected == 3) {
                  //   // _share(treedatalist[index - 1].id);
                  // } else if (selected == 2) {
                  //   /*renameTree(
                  //               treeId: treedatalist[index - 1].id.toString(),
                  //               treeName: treedatalist[index - 1].treeName
                  //               );*/
                  //   // showrenamedialog(
                  //   //     treeId: treedatalist[index - 1].id.toString(),
                  //   //     treeName: treedatalist[index - 1].treeName);
                  // }
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

  void _storePosition(TapDownDetails details) {
    // _tapPosition = details.globalPosition;
  }
}
