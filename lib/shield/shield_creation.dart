import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trybelocker/UniversalFunctions.dart';
import 'package:trybelocker/constants/const.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';
import 'package:trybelocker/widgets/vertical_tab.dart';

class CreateShield extends StatefulWidget {
  CreateShield({Key key}) : super(key: key);

  @override
  _CreateShieldState createState() => _CreateShieldState();
}

class _CreateShieldState extends State<CreateShield>
    with TickerProviderStateMixin {
  var controller = ScrollController();
  Widget showWidget;
  String shieldUrl = '';
  String patternUrl = '';
  String ribbonUrl = '';

  TabController _tabController;
  @override
  void initState() {
    shieldUrl = 'assets/shields/1.png';

    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    showWidget = getShieldShape();
  }

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  // SizedBox(
                  //   child: Image.asset(
                  //     'assets/ribbons/Banner1.png',
                  //     width: 100,
                  //   ),
                  // ),
                  Stack(
                    children: [
                      Container(
                        height: 180,
                        color: AppColors.kPrimaryBlue,
                        child: Center(
                          child: Image.asset(shieldUrl,
                              height: 180, width: 250, fit: BoxFit.scaleDown),
                        ),
                      ),
                      patternUrl == ''
                          ? SizedBox()
                          : Center(
                              child: Container(
                                height: 180,
                                child: Center(
                                  child: Image.asset(
                                    patternUrl,
                                    width: 100,
                                  ),
                                ),
                              ),
                            )
                    ],
                  ),
                  ribbonUrl == ''
                      ? SizedBox()
                      : Stack(
                          children: [
                            Center(
                              child: SizedBox(
                                child: Image.asset(
                                  ribbonUrl,
                                  width: 200,
                                ),
                              ),
                            ),
                            // SizedBox(
                            //   height: 65,
                            //   child: Center(
                            //     child: Text(
                            //       'Smith',
                            //       style: TextStyle(
                            //         color: Colors.white,
                            //         letterSpacing: 2.5,
                            //         fontSize: 18,
                            //         fontWeight: FontWeight.bold,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                ],
              ),
            ),
            Divider(
              thickness: 5.0,
              color: getColorFromHex('#545555'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IntrinsicHeight(
                child: Row(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showWidget = getShieldShape();
                        });
                      },
                      child: Text(
                        "Shield",
                        style: TextStyle(
                          color: getColorFromHex(
                            AppColors.red,
                          ),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print('Background');
                        setState(() {
                          showWidget = getBackgoundTab();
                        });
                      },
                      child: Text(
                        "Background",
                        style: TextStyle(
                          color: AppColors.kPrimaryBlue,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print('Ribbon');
                        setState(() {
                          showWidget = getRibbonTab();
                        });
                      },
                      child: Text(
                        "Ribbon",
                        style: TextStyle(
                          color: AppColors.kPrimaryBlue,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print('Save');
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(
                          color: AppColors.kPrimaryBlue,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    //     Container(
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           GestureDetector(
                    //             onTap: () {
                    //               setState(() {
                    //                 showWidget = getShieldShape();
                    //               });
                    //             },
                    //             child: Text(
                    //               "Shield",
                    //               style: TextStyle(
                    //                 color: getColorFromHex(
                    //                   AppColors.red,
                    //                 ),
                    //                 fontSize: 14,
                    //               ),
                    //             ),
                    //           ),
                    //           GestureDetector(
                    //             onTap: () {
                    //               print('Background');
                    //               setState(() {
                    //                 showWidget = getBackgoundTab();
                    //               });
                    //             },
                    //             child: Text(
                    //               "Background",
                    //               style: TextStyle(
                    //                 color: AppColors.kPrimaryBlue,
                    //                 fontSize: 14,
                    //               ),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     // VerticalDivider(
                    //     //   thickness: 2,
                    //     //   width: 20,
                    //     //   color: Colors.white,
                    //     // ),
                    //     // Row(
                    //     //   mainAxisSize: MainAxisSize.min,
                    //     //   children: [
                    //     //     IconButton(
                    //     //       padding: EdgeInsets.zero,
                    //     //       icon: Icon(
                    //     //         Icons.arrow_back_ios,
                    //     //         color: Colors.white,
                    //     //       ),
                    //     //       onPressed: _tabController.index == 0
                    //     //           ? null
                    //     //           : () {
                    //     //               if (_tabController.index > 0) {
                    //     //                 _tabController
                    //     //                     .animateTo(_tabController.index - 1);
                    //     //               }
                    //     //             },
                    //     //     ),
                    //     //     TabBar(
                    //     //       isScrollable: true,
                    //     //       controller: _tabController,
                    //     //       indicatorColor: Colors.transparent,
                    //     //       labelStyle: TextStyle(color: Colors.black),
                    //     //       unselectedLabelColor: Colors.white,
                    //     //       labelColor: Colors.red,
                    //     //       labelPadding: EdgeInsets.only(right: 5.0),
                    //     //       tabs: List.generate(
                    //     //         3,
                    //     //         (index) {
                    //     //           return Tab(
                    //     //             text: "Image${index + 1}",

                    //     //           );
                    //     //         },
                    //     //       ),

                    //     //     ),
                    //     //     IconButton(
                    //     //       padding: EdgeInsets.zero,
                    //     //       icon: Icon(
                    //     //         Icons.arrow_forward_ios,
                    //     //         color: Colors.white,
                    //     //       ),
                    //     //       onPressed: () {
                    //     //         if (_tabController.index + 1 < 3) {
                    //     //           _tabController
                    //     //               .animateTo(_tabController.index + 1);
                    //     //         } else {
                    //     //           Scaffold.of(context).showSnackBar(SnackBar(
                    //     //             content: Text("Can't move forward"),
                    //     //           ));
                    //     //         }
                    //     //       },
                    //     //     ),
                    //     //   ],
                    //     // ),
                    //     // VerticalDivider(
                    //     //   thickness: 2,
                    //     //   width: 20,
                    //     //   color: Colors.white,
                    //     // ),
                    //     Container(
                    //       child: Row(
                    //         children: [
                    //           GestureDetector(
                    //             onTap: () {
                    //               print('Ribbon');
                    //               setState(() {
                    //                 showWidget = getRibbonTab();
                    //               });
                    //             },
                    //             child: Text(
                    //               "Ribbon",
                    //               style: TextStyle(
                    //                 color: AppColors.kPrimaryBlue,
                    //                 fontSize: 14,
                    //               ),
                    //             ),
                    //           ),
                    //           GestureDetector(
                    //             onTap: () {
                    //               print('Save');
                    //             },
                    //             child: Text(
                    //               "Save",
                    //               style: TextStyle(
                    //                 color: AppColors.kPrimaryBlue,
                    //                 fontSize: 14,
                    //               ),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     )
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 5.0,
              color: getColorFromHex('#545555'),
            ),
            Expanded(child: showWidget),
          ],
        ),
      ),
    );
  }

  Widget getPattern() {
    return Container(
      child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          padding: const EdgeInsets.all(4.0),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          children: patternImages.map((String url) {
            var index = patternImages.indexOf(url);
            return GestureDetector(
              onTap: () {
                print(url);
                setState(() {
                  patternUrl = patternImages[index];
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.white,
                  child: GridTile(
                    child: Image.asset(
                      url,
                      height: 30,
                      width: 30,
                    ),
                  ),
                ),
              ),
            );
          }).toList()),
    );
  }

  Widget getColor1() {
    return Container(
      child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 4,
          childAspectRatio: 1.0,
          padding: const EdgeInsets.all(4.0),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          children: color.map((Color url) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.white,
                child: GridTile(
                  child: Container(
                    color: url,
                    height: 25,
                    width: 25,
                  ),
                ),
              ),
            );
          }).toList()),
    );
  }

  Widget getColor2() {
    return Container(
      child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 4,
          childAspectRatio: 1.0,
          padding: const EdgeInsets.all(4.0),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          children: color.map((Color url) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.white,
                child: GridTile(
                  child: Container(
                    color: url,
                    height: 25,
                    width: 25,
                  ),
                ),
              ),
            );
          }).toList()),
    );
  }

  Widget getColor3() {
    return Container(
      child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 4,
          childAspectRatio: 1.0,
          padding: const EdgeInsets.all(4.0),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          children: color.map((Color url) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.white,
                child: GridTile(
                  child: Container(
                    color: url,
                    height: 25,
                    width: 25,
                  ),
                ),
              ),
            );
          }).toList()),
    );
  }

  Widget getTransformation() {
    return Container();
  }

  Widget getBackgoundTab() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            child: VerticalTabs(
              backgroundColor: getColorFromHex('#2E2F2F'),
              tabBackgroundColor: getColorFromHex('#2E2F2F'),
              selectedTabBackgroundColor: Colors.white,
              initialIndex: 0,
              indicatorColor: Colors.transparent,
              selectedTabTextStyle: TextStyle(color: Colors.white),
              tabsWidth: 120,
              tabs: <Tab>[
                Tab(child: Text('PATTERN', style: TextStyle(fontSize: 18))),
                Tab(child: Text('COLOR 1', style: TextStyle(fontSize: 18))),
                Tab(child: Text('COLOR 2', style: TextStyle(fontSize: 18))),
                Tab(child: Text('COLOR 3', style: TextStyle(fontSize: 18))),
                Tab(child: Text('TRANSFORM', style: TextStyle(fontSize: 18))),
              ],
              contents: <Widget>[
                getPattern(),
                getColor1(),
                getColor2(),
                getColor3(),
                getTransformation(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget getShieldShape() {
    return Container(
      child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 4,
          childAspectRatio: 1.0,
          // childAspectRatio: 3 / 2,
          mainAxisSpacing: 0.0,
          crossAxisSpacing: 0.0,
          children: shapes.map((String url) {
            var index = shapes.indexOf(url);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    shieldUrl = shieldShape[index];
                  });
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0.0),
                      border: Border.all(width: 0.2),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 2.0,
                            spreadRadius: 0.4,
                            offset: Offset(0.1, 0.5)),
                      ],
                      color: getColorFromHex('#C4C4C4')),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GridTile(
                      child: Image.asset(
                        url,
                        height: 25,
                        width: 25,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList()),
    );
  }

  Widget getRibbonTab() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            child: VerticalTabs(
              backgroundColor: getColorFromHex('#2E2F2F'),
              tabBackgroundColor: getColorFromHex('#2E2F2F'),
              selectedTabBackgroundColor: Colors.white,
              initialIndex: 0,
              indicatorColor: Colors.transparent,
              selectedTabTextStyle: TextStyle(color: Colors.white),
              tabsWidth: 150,
              tabs: <Tab>[
                Tab(
                    child:
                        Text('CHOOSE RIBBON', style: TextStyle(fontSize: 18))),
                Tab(child: Text('COLOR', style: TextStyle(fontSize: 18))),
                Tab(child: Text('TEXT', style: TextStyle(fontSize: 18))),
              ],
              contents: <Widget>[
                getRibbon(),
                getColor1(),
                getColor2(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  getRibbon() {
    return Container(
      child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          padding: const EdgeInsets.all(4.0),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          children: ribbonImages.map((String url) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    ribbonUrl = url;
                  });
                },
                child: Container(
                  color: Colors.white,
                  child: GridTile(
                    child: Image.asset(
                      url,
                      height: 30,
                      width: 30,
                    ),
                  ),
                ),
              ),
            );
          }).toList()),
    );
  }

  Widget getImage() {
    return Container();
  }
}
