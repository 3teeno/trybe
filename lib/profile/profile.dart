import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trybelocker/get_collection_post.dart';
import 'package:trybelocker/getplaylistpost.dart';
import 'package:trybelocker/group_chat.dart';
import 'package:trybelocker/model/createplaylist/createplaylistparams.dart';
import 'package:trybelocker/model/createplaylist/createplaylistresponse.dart';
import 'package:trybelocker/model/getplaylist/getplaylistparams.dart';
import 'package:trybelocker/model/getplaylist/getplaylistresponse.dart';
import 'package:trybelocker/model/updateprofile/update_profile_response.dart';
import 'package:trybelocker/model/user_details.dart';
import 'package:trybelocker/networkmodel/APIs.dart';
import 'package:trybelocker/notifications.dart';
import 'package:trybelocker/profile/downloads/downloadscreen.dart';
import 'package:trybelocker/publicprofile/publicprofilescreen.dart';
import 'package:trybelocker/search.dart';
import 'package:trybelocker/settings/settings.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/viewmodel/home_view_model.dart';
import 'package:trybelocker/viewmodel/profile_view_model.dart';

import '../UniversalFunctions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:http/http.dart' as http;

import 'package:trybelocker/profile/user_videos.dart';
import 'package:provider/src/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';
import 'package:trybelocker/profile/history.dart';

class Profile extends StatefulWidget {
  static const String TAG = "/profile";
  // ScrollController controller;
  HomeViewModel homeViewModel;
  Profile({Key key,this.homeViewModel}) : super(key: key);
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  File _image;
  double _maxWidth = 500;
  double _maxHeight = 500;
  final ImagePicker _picker = ImagePicker();
  String username = "";
  String devicetoken = "";
  TextEditingController foldername = TextEditingController();
  TextEditingController groupName = TextEditingController();
  ProfileViewModel _profileViewModel;
  List<PlaylistData> playlistdatalist = [];
  bool isDataLoaded=false;
  bool isPicLoaded=false;
  var reference ;
  DataSnapshot dataSnapshot;
  FirebaseMessaging _firebaseMessaging =  FirebaseMessaging.instance;
  var controller = ScrollController();

  @override
  void initState() {
    super.initState();
    print("username=== ${MemoryManagement.getcoverphoto()}");
    if (MemoryManagement.getuserName() != null &&
        MemoryManagement
            .getuserName()
            .isNotEmpty) {
      username = MemoryManagement.getuserName();
    }

    if(MemoryManagement.getuserId()!=null){
      try {
        reference = FirebaseDatabase.instance.reference().child("groups").child(MemoryManagement.getuserId());
      }catch(e){
        print(e.toString());
      }
    }

    new Future.delayed(const Duration(milliseconds: 300), () {

      getCollections();
    });

    getdevicetoken();
  }

  getCollections() async{
    dataSnapshot= await reference.orderByKey().once();
    dataSnapshot.key;
    print("length== ${dataSnapshot}");
    isDataLoaded=false;
    getCollectionList();

  }

  void getCollectionList() async {
    _profileViewModel.setLoading();
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _profileViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Getplaylistparams request = new Getplaylistparams(uid:MemoryManagement.getuserId(),other_uid: MemoryManagement.getuserId());
      var response = await _profileViewModel.getplaylist(request, context);
      Getplaylistresponse getplaylistresponse = response;
      if (getplaylistresponse.status.compareTo("success") == 0) {
        setState(() {
          playlistdatalist.clear();
          if (getplaylistresponse.playlistData != null &&
              getplaylistresponse.playlistData.length > 0) {
            playlistdatalist.addAll(getplaylistresponse.playlistData);
            // for (var data in playlistdatalist) {
            //   if (data.collectionName!=null&&data.collectionName.compareTo("Creative Journal") == 0) {
            //     playlistdatalist.remove(data);
            //     break;
            //   }
            // }

            isDataLoaded=true;

          }else{
            isDataLoaded=true;
          }
        });
      }else{
        setState(() {
          isDataLoaded=true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _profileViewModel = Provider.of<ProfileViewModel>(context);
    return Scaffold(
        backgroundColor: getColorFromHex(AppColors.black),
        appBar: ScrollAppBar(
          controller: controller,
          brightness: Brightness.dark,
          backgroundColor: getColorFromHex(AppColors.black),
          automaticallyImplyLeading: false,
          title: InkWell(
              onTap: () {
                displaybottomsheet(context,widget.homeViewModel);
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
              onTap: (){
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
                      systemNavigationBarColor:getColorFromHex(AppColors.black),
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
                  // widget.homeViewModel.controller.add(true);
                  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                      statusBarColor: Colors.black,
                      systemNavigationBarColor:getColorFromHex(AppColors.black),
                      statusBarIconBrightness: Brightness.light,
                      systemNavigationBarIconBrightness: Brightness.light));
                  navigateToNextScreen(context, true, SearchScreen());
                },
                child:Image.asset(
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
                  if(!(MemoryManagement.getlogintype().compareTo("4")==0)) {
                    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                        statusBarColor: Colors.black,
                        systemNavigationBarColor: getColorFromHex(AppColors.black),
                        statusBarIconBrightness: Brightness.light,
                        systemNavigationBarIconBrightness: Brightness.light));
                    navigateToNextScreen(context, true, SettingsScreen());
                  }else{
                    displaytoast("You don't have access to open settings", context);
                  }
                },
                child:  Icon(Icons.settings_applications_outlined,color: Colors.white,size: 32,)),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        body:Snap(
        controller: controller.appBar,
        child:  SingleChildScrollView(
    controller: controller,
    child:Stack(
          children: <Widget>[ Container(
                child: Column(
                  children: <Widget>[
                    seperationline(2),
                    Stack(
                      children: <Widget>[
                        Container(
                          height: 170,
                          width: MediaQuery.of(context).size.width,
                          child: getCacheCoverImage(
                              url:MemoryManagement.getcoverphoto()!=null?MemoryManagement.getcoverphoto().trim().length>0?MemoryManagement.getcoverphoto().compareTo("null")!=0?getCoverPhoto(MemoryManagement.getcoverphoto()):
                              "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80":
                              "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80":
                              "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80",fit: BoxFit.cover),
                        ),
                        takeCoverPhoto(),
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height: 80,
                            ),
                            // Text(
                            //   "Profile Page",
                            //   textAlign: TextAlign.center,
                            //   style: TextStyle(
                            //       color: Colors.white,
                            //       fontSize: 18,
                            //       fontWeight: FontWeight.bold),
                            // ),
                            circularImage(),
                            SizedBox(height: 15,),
                            Text(
                              MemoryManagement.getuserName()!=null?MemoryManagement.getuserName():"",
                              style:
                              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),

                      ],
                    ),
                    seperationline(1),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      // height: 90,
                      margin: EdgeInsets.only(left: 20, top: 20),
                      child: gethistorytab(context),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    seperationline(1),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                          margin: EdgeInsets.only(left: 20, top: 20),
                          child: Text(
                            "TrybeList Folder",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: Colors.white,
                                fontSize: 18),
                          )),
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      // height: 90,
                      margin: EdgeInsets.only(left: 10, top: 10),
                      child: getprofilefolder(context),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    seperationline(1),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                          margin: EdgeInsets.only(left: 20, top: 20),
                          child: Text(
                            "TrybeGroups",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: Colors.white,
                                fontSize: 18),
                          )),
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      // height: 90,
                      margin: EdgeInsets.only(left: 20, top: 20),
                      child: GestureDetector(onTap: (){
                        createTrybeGroups();
                      },
                        child: trybefolder,),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 25,top: 10,bottom: 20),
                        child:  FirebaseAnimatedList(
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          query: reference??"",
                          reverse: true,
                          sort: (a, b) => b.key.compareTo(a.key),
                          //comparing timestamp of messages to check which one would appear first
                          itemBuilder: (_, DataSnapshot messageSnapshot, Animation<double> animation,int index) {
                            print("index= $index");
                            print("index= ${messageSnapshot.value}");
                            return GestureDetector(
                              onTap: () {
                                String groupname=messageSnapshot.value['groupname']!=null?messageSnapshot.value['groupname']:"";
                                String admin=messageSnapshot.value['admin']!=null?messageSnapshot.value['admin']:"";
                                String keys=messageSnapshot.key;
                                Navigator.of(context,rootNavigator: true).
                                push(MaterialPageRoute(builder: (context) => GroupChat(groupname,admin,keys)));
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Text(messageSnapshot.value['groupname']!=null?messageSnapshot.value['groupname']:"",style: TextStyle(color: Colors.white,fontSize: 18),),
                              ),
                            );
                          },
                        )

                    )
                  ],
                )),getFullScreenProviderLoader(status:isPicLoaded , context: context)],
        ))));
  }


  void createTrybeGroups() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              insetPadding: EdgeInsets.all(20),
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(width: 55,),
                          Expanded(
                            child: Container(
                              child: Text(
                                'Create TrybeGroup',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18.3),
                              ),
                            ),),
                          IconButton(icon:Icon(Icons.cancel,color: Colors.red,), onPressed: (){
                            Navigator.pop(context);
                          })
                        ],
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
                                  maxLines: 1,
                                  minLines: 1,
                                  controller: groupName,
                                  keyboardType: TextInputType.text,
                                  autofocus: false,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: "Gilroy-SemiBold",
                                      color: Color.fromRGBO(60, 72, 88, 1),
                                      fontSize: 16.7),
                                  onFieldSubmitted: (trem) async {
                                    print("ontapcalled");
                                    if(groupName.text!=null&&groupName.text.trim().length>0){
                                      reference.push().set({
                                        "groupname":groupName.text,
                                        "admin":"true"
                                      });
                                      displaytoast("Succesfully created the group", context);
                                      Navigator.pop(context);
                                    }else{
                                      displaytoast("Group name required", context);
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
                                          fontFamily: "Gilroy-Regular",
                                          fontSize: 13.3)),
                                ),
                              )),
                        ],
                      ),
                      InkWell(
                        onTap: () async {
                          print("ontapcalled");
                          if(groupName.text!=null&&groupName.text.trim().length>0){
                            reference.push().set({
                              "groupname":groupName.text,
                              "admin":"true"
                            });
                            displaytoast("Successfully created the group", context);
                            Navigator.pop(context);
                          }else{
                            displaytoast("Group name required", context);
                          }
                        },
                        child: Container(
                            height: 40,
                            width: 120,
                            margin: EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                                color: getColorFromHex('#A10000')),
                            child: Center(
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                      )
                    ],
                  ),
                  Container(
                    child: getDialogLoader(
                        status: _profileViewModel.getLoading(), context: context),
                  ),
                ],
              ),
            );
          });
        });
  }

  void showCreateFoler() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              insetPadding: EdgeInsets.all(20),
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(width: 55,),
                          Expanded(
                            child: Container(
                              child: Text(
                                'Create Trybe List Folder',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18.3),
                              ),
                            ),),
                          IconButton(icon:Icon(Icons.cancel,color: Colors.red,), onPressed: (){
                            Navigator.pop(context);
                          })
                        ],
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
                                  maxLines: 1,
                                  minLines: 1,
                                  controller: foldername,
                                  keyboardType: TextInputType.text,
                                  autofocus: false,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: "Gilroy-SemiBold",
                                      color: Color.fromRGBO(60, 72, 88, 1),
                                      fontSize: 16.7),
                                  onFieldSubmitted: (trem) async {
                                    if (foldername != null && foldername.text.trim().length > 0) {
                                      _profileViewModel.setLoading();
                                      bool gotInternetConnection =
                                      await hasInternetConnection(
                                        context: context,
                                        mounted: mounted,
                                        canShowAlert: true,
                                        onFail: () {
                                          _profileViewModel.hideLoader();
                                        },
                                        onSuccess: () {},
                                      );
                                      if (gotInternetConnection) {
                                        Createplaylistparams params = new Createplaylistparams(uid: MemoryManagement.getuserId(), playlistName: foldername.text.trim());
                                        var response = await _profileViewModel.createplaylist(params, context);
                                        Createplaylistresponse createplaylistresponse = response;
                                        if (createplaylistresponse.status.compareTo("success") == 0) {
                                          displaytoast(createplaylistresponse.message, context);
                                        } else {
                                          displaytoast(createplaylistresponse.message, context);
                                        }
                                      }
                                    } else {
                                      displaytoast("Folder name required", context);
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
                                          fontFamily: "Gilroy-Regular",
                                          fontSize: 13.3)),
                                ),
                              )),
                        ],
                      ),
                      InkWell(
                        onTap: () async {
                          if (foldername != null &&
                              foldername.text.trim().length > 0) {
                            setState(() {
                              _profileViewModel.setLoading();
                            });

                            bool gotInternetConnection =
                            await hasInternetConnection(
                              context: context,
                              mounted: mounted,
                              canShowAlert: true,
                              onFail: () {
                                setState(() {
                                  _profileViewModel.hideLoader();
                                });
                              },
                              onSuccess: () {},
                            );
                            if (gotInternetConnection) {
                              Createplaylistparams params = new Createplaylistparams(
                                  uid: MemoryManagement.getuserId(),
                                  playlistName: foldername.text.trim());
                              var response = await _profileViewModel.createplaylist(params, context);
                              Createplaylistresponse createplaylistresponse = response;
                              setState(() {
                                _profileViewModel.hideLoader();
                              });
                              foldername.text = "";
                              Navigator.pop(context);
                              if (createplaylistresponse.status.compareTo("success") == 0) {
                                displaytoast(createplaylistresponse.message, context);
                                refreshList(createplaylistresponse.playlistData);
                              } else {
                                displaytoast(
                                    createplaylistresponse.message, context);
                              }
                            }
                          } else {
                            displaytoast("Folder name required", context);
                          }
                        },
                        child: Container(
                            height: 40,
                            width: 120,
                            margin: EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                                color: getColorFromHex('#A10000')),
                            child: Center(
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                      )
                    ],
                  ),
                  Container(
                    child: getDialogLoader(
                        status: _profileViewModel.getLoading(), context: context),
                  ),
                ],
              ),
            );
          });
        });
  }



  void refreshList(List<PlaylistData> playlistdata) {
    setState(() {
      playlistdatalist.clear();
      if (playlistdata != null && playlistdata.length > 0) {
        playlistdatalist.addAll(playlistdata);
        // for (var data in collectiondatalist) {
        //   if (data.collectionName!=null&&data.collectionName.compareTo("Creative Journal") == 0) {
        //     collectiondatalist.remove(data);
        //     break;
        //   }
        // }
      }
    });
  }

  getprofilefolder(BuildContext context) {
    return Column(children: <Widget>[
      SizedBox(
        height: 10,
      ),
      InkWell(
        onTap: () {
          showCreateFoler();
        },
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 15,
            ),
            Image.asset(
              "assets/addwhite.png",
              height: 25,
              width: 25,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'New TrybeList Folder',
              style: TextStyle(color: Colors.white, fontSize: 12),
            )
          ],
        ),
      ),
      Visibility(
        visible: playlistdatalist!=null?playlistdatalist.length>0?true:false:false,
        child: Container(
          margin: EdgeInsets.only(left: 15, top: 15),
          child: ListView.builder(
              itemCount: playlistdatalist.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                            builder: (context) => GetPlaylistPost(
                                playlistdatalist[index].id)));
                  },
                  child: Row(
                    children: <Widget>[
                      getImage(playlistdatalist[index]),
                      SizedBox(
                        width: 15,
                      ),
                      Center(
                        child: Text(
                          playlistdatalist[index].playlistName != null ? playlistdatalist[index].playlistName : "",
                          style: TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                );
              }),
        ),)
    ]);
  }

  Widget getImage(PlaylistData playlistData) {
    if(playlistData.postType!=null&&playlistData.postMediaUrl!=null&&playlistData.postMediaUrl.trim().length>0){
      if(playlistData.postType==2){
        return Container(
          width: 50,
          height: 50,
          margin: EdgeInsets.all(2),
          child:  FutureBuilder(
              future: getThumbnail(playlistData.postMediaUrl),
              builder:
                  (BuildContext context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.done) {
                  return Stack(
                    children: <Widget>[
                      snapshot!=null?snapshot.data!=null?
                      Positioned.fill(
                        child: Image.memory(
                          snapshot.data,
                          fit: BoxFit.cover,
                        ),
                      ):Positioned.fill(
                          child: Image.network("https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80", fit: BoxFit.cover)
                      ) : Positioned.fill(
                          child: Image.network(
                              "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80", fit: BoxFit.cover))
                    ],
                  );
                } else {
                  return SpinKitCircle(
                    itemBuilder:
                        (BuildContext context,
                        int index) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                      );
                    },
                  );
                }
              }),
        );
      }else{
        return Container(
          width: 50,
          height: 50,
          margin: EdgeInsets.all(2),
          child: getCachedNetworkImage(
              url:playlistData.postMediaUrl, fit: BoxFit.cover),
        );
      }
    }else{
      return new Container(
        width: 50,
        height: 50,
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            image: new DecorationImage(
                fit: BoxFit.cover,
                image: new NetworkImage(
                    "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80"))),
      );
    }
  }


  getThumbnail(String url)async {
    final Directory _dir = await getTemporaryDirectory();
    print("thumbnail=>1, $url");
    print("thumbnail=>2, ${_dir.path}");
    var thumbnail = await VideoThumbnail.thumbnailData(
      video: url,
      imageFormat: ImageFormat.PNG,
      maxWidth: 50,
      maxHeight: 50,
      // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 50,
    );
    print("thumbnail=>3, $thumbnail");
    return thumbnail;
  }
  var trybefolder = Column(children: <Widget>[
    Row(
      children: [
        Image.asset(
          "assets/createpost.png",
          height: 22,
          width: 22,
          color: Colors.white,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          "New TrybeGroups",
          style: TextStyle(color: Colors.white),
        ),
      ],
    ),
  ]);
  void getdevicetoken() async {
    await _firebaseMessaging.getToken().then((value) {
      devicetoken = value;
      FirebaseDatabase.instance.reference().child('devicetokens').
      child(MemoryManagement.getuserId()).set({
        'username':MemoryManagement.getuserName(),
        'userid':MemoryManagement.getuserId(),
        'email':MemoryManagement.getEmail(),
        'token':devicetoken
      });
      //displaytoast("devicetokenn $devicetoken", context);
    });
  }

  gethistorytab(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: (){
            Navigator.of(context,rootNavigator: true).push(
                MaterialPageRoute(builder: (context) => History()));
          },
          child: Row(
            children: [
              Icon(
                Icons.history,
                color: Colors.white,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "History",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        InkWell(
            onTap: () {
              Navigator.of(context,rootNavigator: true).push(
                  MaterialPageRoute(builder: (context) => UserVideos()));
            },
            child: Row(
              children: [
                Icon(
                  Icons.play_circle_outline,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Your Videos",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            )),
        SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () {
            Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context) =>
                DownloadScreen()));
          },
          child: Row(
            children: [
              Image.asset(
                "assets/downloads.png",
                height: 22,
                width: 22,
                color: Colors.white,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "Downloads",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        )

      ],
    );
  }

  Widget takeCoverPhoto() {
    return  Align(
      alignment: Alignment.bottomRight,
      child: GestureDetector(
        onTap: () {
          // getImage();
          showMediaOptions(context, 4);
        },
        child: Container(
          width: 38.0,
          height: 38.0,
          margin: EdgeInsets.only(top: 120,right: 10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white70,
          ),
          child: Center(
            child: Icon(
              Icons.camera_alt,
              color: getColorFromHex(AppColors.black),
            ),
          ),
        ),
      ),
    );
  }


  Widget circularImage() {
    return Padding(
      padding: EdgeInsets.only(top: 15.0),
      child: new Stack(fit: StackFit.loose, children: <Widget>[
        new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new GestureDetector(
              onTap: () {
                showMediaOptions(context,2);
                // getImage();
              },
              child: new Container(
                width: 130.0,
                height: 130.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 4,color: Colors.white),
                ),
                child: ClipOval(
                    child: getProfileImage(MemoryManagement.getuserprofilepic())
                ),
              ),
            ),
          ],
        ),
        new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new GestureDetector(
              onTap: () {
                // getImage();
                showMediaOptions(context,2);
              },
              child: Container(
                width: 38.0,
                height: 38.0,
                margin: EdgeInsets.fromLTRB(80, 90, 0, 0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white70,
                ),
                child: Center(
                  child: Icon(
                    Icons.camera_alt,
                    color: getColorFromHex(AppColors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }

  Future getImagefromgallery(int key) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        if (_image != null) {
          Uint8List bytes = _image.readAsBytesSync();
          updateprofilepic(bytes,key);
        }
      } else {
        print('No image selected.');
      }
    });
  }

  void _closeActionSheet(BuildContext contexts) {
    // Navigator.pop(context);
    Navigator.of(context, rootNavigator: true).pop("Discard");
  }

  Future getImagefromcamera(int key) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        if (_image != null) {
          Uint8List bytes = _image.readAsBytesSync();
          updateprofilepic(bytes,key);
        }
      } else {
        print('No image selected.');
      }
    });
  }


  void showMediaOptions(BuildContext context,int key) async {
    var result = await PhotoManager.requestPermission();
    if (result) {
      showGeneralDialog(
        barrierLabel: "Label",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 700),
        context: context,
        pageBuilder: (contexts, anim1, anim2) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                height: 230,
                margin: EdgeInsets.only(bottom: 20, left: 12, right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    new InkWell(
                      onTap: () {
                        _closeActionSheet(context);
                        getImagefromcamera(key);
                      },
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 20.0,
                          ),
                          Image(
                              image: AssetImage('assets/takephoto.png'),
                              height: 30,
                              width: 30),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            'Take Photo',
                            style: TextStyle(
                                color: getColorFromHex(AppColors.black),
                                fontSize: 15),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    new InkWell(
                      onTap: () async {
                        _closeActionSheet(context);
                        getImagefromgallery(key);
                      },
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 20.0,
                          ),
                          Image(
                            image: AssetImage('assets/gallery.png'),
                            height: 30,
                            width: 30,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            'Pick From Gallery',
                            style: TextStyle(
                                color: getColorFromHex(AppColors.black),
                                fontFamily: 'Gilroy-SemiBold',
                                fontSize: 15),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    new InkWell(
                        onTap: () {
                          _closeActionSheet(context);
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(20, 0, 15, 20),
                          width: double.infinity,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.all(Radius.circular(27.7)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: Offset(
                                    2.0, 2.0), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'cancel',
                              style: TextStyle(
                                  color: getColorFromHex(AppColors.black),
                                  fontSize: 16.7,
                                  fontFamily: 'Gilroy-SemiBold'),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return SlideTransition(
            position:
            Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
            child: child,
          );
        },
      );
    } else {
      PhotoManager.openSetting();
    }
  }

  void updateprofilepic(Uint8List image, int key) async {
    setState(() {
      isPicLoaded=true;
    });
    var request = http.MultipartRequest('POST', Uri.parse(APIs.updateprofile));
    request.fields['userid'] = MemoryManagement.getuserId();
    request.fields['key'] = key.toString();
    if(key==2){
      request.files.add(http.MultipartFile.fromBytes('filename', image, filename: "test",
        // contentType: MediaType('application', 'octet-stream'),
      ));
    }else{
      request.files.add(http.MultipartFile.fromBytes('cover_photo', image, filename: "test",
        // contentType: MediaType('application', 'octet-stream'),
      ));
    }
    print(request);
    var response = await request.send();
    print(response.stream);
    print(response.statusCode);
    final res = await http.Response.fromStream(response);
    print(res.body);
    var responseJson = json.decode(res.body);
    UpdateProfileResponse updateProfileResponse = new UpdateProfileResponse.fromJson(responseJson);
    if (updateProfileResponse != null) {
      if (updateProfileResponse.status != null && updateProfileResponse.status.trim().length > 0) {
        if (updateProfileResponse.status.compareTo("success") == 0) {
          if (updateProfileResponse.message != null && updateProfileResponse.message.trim().length > 0) {
            displaytoast(updateProfileResponse.message, context);
          }
          if (updateProfileResponse.userData != null) {
            if (key==2&&updateProfileResponse.userData.userImage != null && updateProfileResponse.userData.userImage.trim().length > 0) {
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
                for(int k=0;k<userdetailsdata.length;k++){
                  if(userdetailsdata[k].userid.compareTo(MemoryManagement.getuserId())==0){
                    userdetailsdata[k].userimage=updateProfileResponse.userData.userImage.trim();
                    break;
                  }
                }
              }
              UserDetails user = new UserDetails(userDetails: userdetailsdata);
              var loggedinvalue = json.encode(user);
              MemoryManagement.setsaveotheraccounts(userDetails: loggedinvalue);
              setState(() {
                MemoryManagement.setuserprofilepic(profilepic: APIs.userprofilebaseurl + updateProfileResponse.userData.userImage.trim());
                isPicLoaded=false;
              });
            }else if(key==4&&updateProfileResponse.userData.cover_photo != null && updateProfileResponse.userData.cover_photo.trim().length > 0){
              setState(() {
                MemoryManagement.setcoverphoto(coverphoto: APIs.user_cover_photo + updateProfileResponse.userData.cover_photo.trim());
                isPicLoaded=false;
              });
            }else{
              setState(() {
                isPicLoaded=false;
              });
            }
          }else{
            setState(() {
              isPicLoaded=false;
            });
          }
        }else{
          setState(() {
            isPicLoaded=false;
          });
        }
      }else{
        setState(() {
          isPicLoaded=false;
        });
      }
    }else{
      setState(() {
        isPicLoaded=false;
      });
    }
  }


  getCoverPhoto(String coverphoto) {
    if (coverphoto.contains("https") || coverphoto.contains("http")){
      return coverphoto;
    }else{
      return APIs.user_cover_photo +coverphoto;
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
