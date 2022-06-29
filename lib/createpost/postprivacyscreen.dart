import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:trybelocker/UniversalFunctions.dart';
import 'package:trybelocker/enums/enums.dart';
import 'package:trybelocker/model/createplaylist/createplaylistparams.dart';
import 'package:trybelocker/model/createplaylist/createplaylistresponse.dart';
import 'package:trybelocker/model/favouritecollectios/collection_list_params.dart';
import 'package:trybelocker/model/favouritecollectios/collection_list_response.dart';
import 'package:trybelocker/model/favouritecollectios/create_collection_params.dart';
import 'package:trybelocker/model/favouritecollectios/create_collectionresponse.dart';
import 'package:trybelocker/model/getallposts/getallpostresponse.dart';
import 'package:trybelocker/model/getplaylist/getplaylistparams.dart';
import 'package:trybelocker/model/getplaylist/getplaylistresponse.dart';
import 'package:trybelocker/model/privacyclass.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/viewmodel/createpost_view_model.dart';

class PostPrivacy extends StatefulWidget {
  static const String TAG = "/postprivacy";

  Privacyclass privacyclass;

  PostPrivacy(this.privacyclass);

  PostPrivacyState createState() => PostPrivacyState(privacyclass);
}

class PostPrivacyState extends State<PostPrivacy> {
  Privacy _type = Privacy.private;

  SelectAudience _audience = SelectAudience.forkids;

  TrybeGroup _trybeGroup = TrybeGroup.unselect;

  bool istrybelist = false;
  bool isfavourite = false;
  bool istrybegroup = false;

  bool iscreativeJournal = false;

  Privacyclass privacyclass;

  PostPrivacyState(this.privacyclass);

  CreatePostViewModel _createPostViewModel;
  List<PlaylistData> playlistdata = [];

  List<Data> getallpostlist = [];
  List<CollectionData> collectiondatalist = [];

  String trybelistid = "0";
  String favoritesid = "0";
  String trybegroupid = "0";

  String messagekey = "0";

  var reference;

  DataSnapshot dataSnapshot;

  @override
  void initState() {
    super.initState();

    setData();

    try {
      reference = FirebaseDatabase.instance
          .reference()
          .child("groups")
          .child(MemoryManagement.getuserId());
    } catch (e) {
      print(e.toString());
    }

    new Future.delayed(const Duration(milliseconds: 300), () {
      getdatasnapshotkey();
    });
  }

  @override
  Widget build(BuildContext context) {
    _createPostViewModel = Provider.of<CreatePostViewModel>(context);

    var publishnow = Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 10, top: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Choose Option Below",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 10,
          ),
          setprivacyradiobutton("Public", Privacy.public,
              "Anyone in your Trybe can search for and view"),
          SizedBox(
            height: 10,
          ),
          // setprivacyradiobutton(
          //     "Unlisted", Privacy.unlisted, "Anyone with the link can view"),
          // SizedBox(
          //   height: 10,
          // ),
          setprivacyradiobutton(
              "Private", Privacy.private, "Only people you choose can view"),
          SizedBox(
            height: 10,
          ),
          // setunlistedradiobutton(),
          // setprivateradiobutton(),
        ],
      ),
    );

    var saveto = Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 10, top: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Save to",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 10,
          ),
          setsavetocheckbox("Trybelist", SaveTo.trybelist),
          SizedBox(
            height: 10,
          ),
          setsavetocheckbox("Favorites", SaveTo.favorites),
          SizedBox(
            height: 10,
          ),
          setsavetocheckbox("Trybe Group", SaveTo.trybegroup),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );

    var selectaudience = Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 10, top: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Select Audience",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            "Is this video/post made for kids? (required)",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Regardless of your location, you are legally required to comply with children's Online privacy Protection Act (COPPA) and/or other laws, Your are required to tell whether your videos/posts are made for kids. What's considered \"made for kids\"",
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.start,
          ),
          selectaudienceradiobutton(
              "Yes, it's made for kids", SelectAudience.forkids),
          selectaudienceradiobutton(
              "No, it's not made for kids", SelectAudience.notforkids)
        ],
      ),
    );

    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              title: Text("Privacy Settings"),
              backgroundColor: getColorFromHex(AppColors.black),
            ),
            backgroundColor: getColorFromHex(AppColors.black),
            body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      seperationline(2),
                      setcreativejournalcheckbox(
                          "Creative Journal", CreativeJournal.creativejournal),
                      publishnow,
                      seperationline(4),
                      saveto,
                      seperationline(4),
                      selectaudience
                    ],
                  ),
                ))),
        onWillPop: _onBackPressed);
  }

  Future<bool> _onBackPressed() async {
    getprivacyvalue();
    Navigator.of(context).pop(privacyclass);
  }

  selectaudienceradiobutton(String selectaudiencetext, value) {
    return Row(children: <Widget>[
      Theme(
        data: ThemeData(
            //here change to your color
            unselectedWidgetColor: Colors.white),
        child: Row(
          children: [
            new Radio(
              value: value,
              groupValue: _audience,
              activeColor: getColorFromHex(AppColors.red),
              onChanged: (value) {
                setState(() {
                  _audience = value;
                });
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  selectaudiencetext,
                  style: new TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      ),
    ]);
  }

  setprivacyradiobutton(String privacytypetext, value, subtext) {
    return Row(children: <Widget>[
      Theme(
        data: ThemeData(
            //here change to your color
            unselectedWidgetColor: Colors.white),
        child: Row(
          children: [
            new Radio(
              value: value,
              groupValue: _type,
              activeColor: getColorFromHex(AppColors.red),
              onChanged: (value) {
                setState(() {
                  _type = value;
                });
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  privacytypetext,
                  style: new TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 40.0,
                    child: AutoSizeText(
                      subtext,
                      style: new TextStyle(fontSize: 16.0, color: Colors.white),
                      maxLines: 2,
                    )),
                // new Text(
                //   subtext,
                //   style: new TextStyle(fontSize: 16.0, color: Colors.white),
                // ),
              ],
            )
          ],
        ),
      ),
    ]);
  }

  setsavetocheckbox(String privacytypetext, value) {
    return Row(children: <Widget>[
      Theme(
        data: ThemeData(
            //here change to your color
            unselectedWidgetColor: Colors.white),
        child: Row(
          children: [
            new Checkbox(
              value: setcheckboxvalue(value),
              activeColor: getColorFromHex(AppColors.red),
              checkColor: Colors.white,
              onChanged: (newvalue) {
                setState(() {
                  if (value == SaveTo.trybelist) {
                    if (istrybelist) {
                      istrybelist = false;
                      trybelistid = "0";
                    } else {
                      istrybelist = true;
                      getTrybeList();
                    }
                  } else if (value == SaveTo.trybegroup) {
                    if (istrybegroup) {
                      istrybegroup = false;
                      trybegroupid = "0";
                    } else {
                      istrybegroup = true;
                      gettrybegroup();
                    }
                  } else if (value == SaveTo.favorites) {
                    if (isfavourite) {
                      isfavourite = false;
                      favoritesid = "0";
                    } else {
                      isfavourite = true;
                      getCollectionList();
                    }
                  }
                });
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  privacytypetext,
                  style: new TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ]);
  }

  setcreativejournalcheckbox(String privacytypetext, value) {
    return Row(children: <Widget>[
      Theme(
        data: ThemeData(
            //here change to your color
            unselectedWidgetColor: Colors.white),
        child: Row(
          children: [
            new Checkbox(
              value: setcheckboxvalue(value),
              activeColor: getColorFromHex(AppColors.red),
              checkColor: Colors.white,
              onChanged: (newvalue) {
                setState(() {
                  if (iscreativeJournal) {
                    iscreativeJournal = false;
                  } else {
                    iscreativeJournal = true;
                  }
                });
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  privacytypetext,
                  style: new TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 1,
                ),
                Text(
                  "Only you can view",
                  style: new TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ]);
  }

  setcheckboxvalue(value) {
    if (value == SaveTo.trybelist) {
      return istrybelist;
    } else if (value == SaveTo.favorites) {
      return isfavourite;
    } else if (value == SaveTo.trybegroup) {
      return istrybegroup;
    } else if (value == CreativeJournal.creativejournal) {
      return iscreativeJournal;
    }
  }

  void getprivacyvalue() {
//creativejorunalvalue
    if (iscreativeJournal) {
      privacyclass.iscreativejournal = "1";
    } else {
      privacyclass.iscreativejournal = "0";
    }

    //privacytypevalue
    if (_type == Privacy.public) {
      privacyclass.privacy = "Public";
    }
    /*else if (_type == Privacy.unlisted) {
      privacyclass.privacy = "Unlisted";
    } */
    else if (_type == Privacy.private) {
      privacyclass.privacy = "Private";
    }

    //trybelistvalue
    if (istrybelist) {
      privacyclass.istrybelist = "1";
      privacyclass.trybelistid = trybelistid;
    } else {
      privacyclass.istrybelist = "0";
      privacyclass.trybelistid = "0";
    }

    //favoritelistvalue
    if (isfavourite) {
      privacyclass.isfavorites = "1";
      privacyclass.favoritesid = favoritesid;
    } else {
      privacyclass.isfavorites = "0";
      privacyclass.favoritesid = "0";
    }

    //audiencetype
    if (_audience == SelectAudience.forkids) {
      privacyclass.selectaudience = "forkids";
    } else if (_audience == SelectAudience.notforkids) {
      privacyclass.selectaudience = "notforkids";
    }

    //trybegroupvalue
    if (istrybegroup) {
      privacyclass.istrybegroup = "1";
      privacyclass.trybegroupid = trybegroupid;
    } else {
      privacyclass.istrybegroup = "0";
      privacyclass.trybegroupid = "0";
    }
  }

  void setData() {
    //setcreativejournalvalue

    if (privacyclass.iscreativejournal != null) {
      if (privacyclass.iscreativejournal.compareTo("1") == 0) {
        iscreativeJournal = true;
      } else {
        iscreativeJournal = false;
      }
    }

    if (privacyclass.privacy != null) {
      if (privacyclass.privacy.compareTo("Public") == 0) {
        _type = Privacy.public;
      } else {
        _type = Privacy.private;
      }
    }

    if (privacyclass.istrybelist != null) {
      if (privacyclass.istrybelist.compareTo("1") == 0) {
        istrybelist = true;
      }
    }
    if (privacyclass.isfavorites != null) {
      if (privacyclass.isfavorites.compareTo("1") == 0) {
        isfavourite = true;
      }
    }
    if (privacyclass.trybelistid != null) {
      trybelistid = privacyclass.trybelistid;
    }

    if (privacyclass.favoritesid != null) {
      favoritesid = privacyclass.favoritesid;
    }

    if (privacyclass.selectaudience != null) {
      if (privacyclass.selectaudience.compareTo("forkids") == 0) {
        _audience = SelectAudience.forkids;
      } else {
        _audience = SelectAudience.notforkids;
      }
    }
  }

  void getTrybeList() async {
    _createPostViewModel.setLoading();
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _createPostViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Getplaylistparams request = new Getplaylistparams(
          uid: MemoryManagement.getuserId(),
          other_uid: MemoryManagement.getuserId());
      var response = await _createPostViewModel.getplaylist(request, context);
      Getplaylistresponse getplaylistresponse = response;
      if (getplaylistresponse.status.compareTo("success") == 0) {
        setState(() {
          playlistdata.clear();
          if (getplaylistresponse.playlistData != null &&
              getplaylistresponse.playlistData.length > 0) {
            playlistdata.addAll(getplaylistresponse.playlistData);
            showPlayListFolders(playlistdata);
          } else {
            displaytoast("No playlist found.Please create a playlist", context);
            showTrybeListFolder();
          }
        });
      } else {
        displaytoast("Error occurred while getting the playlist", context);
      }
    }
  }

  void showPlayListFolders(
    List<PlaylistData> playlistdata,
  ) {
    PlaylistData trybelistdata;
    if (playlistdata != null && playlistdata.length > 0) {
      trybelistdata = playlistdata[0];
    }

    showModalBottomSheet(
        context: context,
        builder: (context) {
          // ignore: missing_return
          return StatefulBuilder(builder: (context, setState) {
            return Stack(
              children: <Widget>[
                new Container(
                  height: 350.0,
                  color: Colors.black,
                  child: new Container(
                      height: 350.0,
                      padding: EdgeInsets.only(
                          left: 20, top: 20, bottom: 0, right: 20),
                      decoration: new BoxDecoration(
                          color: Colors.white,
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
                                  "Select TrybeList Folder",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: getColorFromHex(AppColors.red),
                                      fontSize: 14),
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    trybelistid = trybelistdata.id.toString();
                                  });
                                  Navigator.pop(context);
                                },
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "Save",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              showTrybeListFolder();
                            },
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 25,
                                ),
                                Image.asset(
                                  "assets/addwhite.png",
                                  height: 25,
                                  width: 25,
                                  color: getColorFromHex(AppColors.black),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'New TryebList Folder',
                                  style: TextStyle(
                                      color: getColorFromHex(AppColors.black),
                                      fontSize: 16),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          playlistdata.length > 0
                              ? Expanded(
                                  child: ListView.builder(
                                      padding:
                                          EdgeInsets.only(top: 0, bottom: 10),
                                      itemCount: playlistdata.length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return RadioListTile(
                                            value: playlistdata[index],
                                            title: Text(playlistdata[index]
                                                        .playlistName !=
                                                    null
                                                ? playlistdata[index]
                                                    .playlistName
                                                : ""),
                                            groupValue: trybelistdata,
                                            onChanged: (PlaylistData data) {
                                              setState(() {
                                                trybelistdata = data;
                                              });
                                            });
                                      }))
                              : Container(),
                        ],
                      )),
                ),
                Container(
                  child: getFullScreenProviderLoaders(
                      status: _createPostViewModel.getCollectionLoaded(),
                      context: context),
                ),
              ],
            );
          });
        }).then((value) {
      if (trybelistid.compareTo("0") == 0) {
        setState(() {
          istrybelist = false;
        });
      }
    });
  }

  void showTrybeListFolder() {
    TextEditingController foldername = new TextEditingController();
    showDialog(
        context: context,
        barrierDismissible: false,
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
                      Text(
                        'Create TryebeList Folder',
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
                              // controller: creditsController,
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
                                if (foldername != null &&
                                    foldername.text.trim().length > 0) {
                                  Navigator.pop(context);
                                  createFolderApi(foldername, context);
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
                            Navigator.pop(context);
                            createTrybeListApi(foldername, context);
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
                        status: _createPostViewModel.getLoading(),
                        context: context),
                  ),
                ],
              ),
            );
          });
        }).then((value) {
      if (trybelistid.compareTo("0") == 0) {
        setState(() {
          istrybelist = false;
        });
      }
    });
  }

  void createTrybeListApi(
      TextEditingController foldername, BuildContext context) async {
    _createPostViewModel.setLoading();
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _createPostViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Createplaylistparams params = new Createplaylistparams(
          uid: MemoryManagement.getuserId(),
          playlistName: foldername.text.trim());
      var response = await _createPostViewModel.createplaylist(params, context);
      Createplaylistresponse createplaylistresponse = response;
      if (createplaylistresponse != null &&
          createplaylistresponse.status.compareTo("success") == 0) {
        if (createplaylistresponse.playlistData != null &&
            createplaylistresponse.playlistData.length > 0) {
          playlistdata.clear();
          playlistdata.addAll(createplaylistresponse.playlistData);
          showPlayListFolders(createplaylistresponse.playlistData);
        }
        if (createplaylistresponse.message != null &&
            createplaylistresponse.message.isNotEmpty)
          displaytoast(createplaylistresponse.message, context);
      } else if (createplaylistresponse != null &&
          createplaylistresponse.message != null &&
          createplaylistresponse.message.trim().length > 0) {
        displaytoast(createplaylistresponse.message, context);
      }
    }
  }

  void updateUnsavedTrybeList(bool status, int index, int playlistid) {
    setState(() {
      if (getallpostlist[index] != null) {
        if (status == true) {
          getallpostlist[index].playlistId = playlistid;
        } else {
          getallpostlist[index].playlistId = 0;
        }
        getallpostlist[index].isPlaylistSaved = status;
      }
    });
  }

  void createFolderApi(
      TextEditingController foldername, BuildContext context) async {
    _createPostViewModel.setLoading();
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _createPostViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Create_collection_params params = new Create_collection_params(
          userid: MemoryManagement.getuserId(),
          collectionName: foldername.text.trim());
      var response =
          await _createPostViewModel.createcollection(params, context);
      Create_collectionresponse collectionresponse = response;
      if (collectionresponse.status.compareTo("success") == 0) {
        if (collectionresponse.collectionData != null &&
            collectionresponse.collectionData.length > 0) {
          showFavouriteList(collectionresponse.collectionData);
        }
      }
    }
  }

  void showFavouriteList(List<CollectionData> collectiondatalist) {
    CollectionData data = collectiondatalist[0];
    showModalBottomSheet(
        context: context,
        builder: (context) {
          // ignore: missing_return
          return StatefulBuilder(builder: (context, setState) {
            return Stack(
              children: <Widget>[
                new Container(
                  height: 350.0,
                  color: Colors.black,
                  //so you don't have to change MaterialApp canvasColor
                  child: new Container(
                      height: 350.0,
                      padding: EdgeInsets.only(
                          left: 20, top: 20, bottom: 0, right: 20),
                      decoration: new BoxDecoration(
                          color: Colors.white,
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
                                  "Select favourite Folder",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: getColorFromHex(AppColors.red),
                                      fontSize: 14),
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    favoritesid = data.id.toString();
                                  });
                                  Navigator.pop(context);
                                },
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "Save",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              showCreateFoler();
                            },
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 25,
                                ),
                                Image.asset(
                                  "assets/addwhite.png",
                                  height: 25,
                                  width: 25,
                                  color: getColorFromHex(AppColors.black),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'New Favorites Folder',
                                  style: TextStyle(
                                      color: getColorFromHex(AppColors.black),
                                      fontSize: 16),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                              child: ListView.builder(
                                  padding: EdgeInsets.only(top: 0, bottom: 10),
                                  itemCount: collectiondatalist.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return RadioListTile(
                                      value: collectiondatalist[index],
                                      title: Text(collectiondatalist[index]
                                                  .collectionName !=
                                              null
                                          ? collectiondatalist[index]
                                              .collectionName
                                          : ""),
                                      groupValue: data,
                                      onChanged:
                                          (CollectionData collectiondata) {
                                        setState(() {
                                          data = collectiondata;
                                        });
                                      },
                                    );
                                  })),
                        ],
                      )),
                ),
                Container(
                  child: getFullScreenProviderLoaders(
                      status: _createPostViewModel.getCollectionLoaded(),
                      context: context),
                ),
              ],
            );
          });
        }).then((value) {
      if (favoritesid.compareTo("0") == 0) {
        setState(() {
          isfavourite = false;
        });
      }
    });
  }

  void showCreateFoler() {
    TextEditingController foldername = new TextEditingController();
    showDialog(
        context: context,
        barrierDismissible: false,
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
                          SizedBox(
                            width: 55,
                          ),
                          Expanded(
                            child: Container(
                              child: Text(
                                'Create Folder',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18.3),
                              ),
                            ),
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                              onPressed: () {
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
                              // controller: creditsController,
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
                                if (foldername != null &&
                                    foldername.text.trim().length > 0) {
                                  Navigator.pop(context);
                                  createFolderApi(foldername, context);
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
                            Navigator.pop(context);
                            createFolderApi(foldername, context);
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
                        status: _createPostViewModel.getLoading(),
                        context: context),
                  ),
                ],
              ),
            );
          });
        }).then((value) {
      if (favoritesid.compareTo("0") == 0) {
        setState(() {
          isfavourite = false;
        });
      }
    });
  }

  Widget getFullScreenProviderLoaders({
    @required bool status,
    @required BuildContext context,
  }) {
    return status
        ? getAppThemedLoaders(
            context: context,
          )
        : new Container(
            height: 350,
          );
  }

  void updateSavedCollection(bool status, int index, int collectionId) {
    setState(() {
      if (getallpostlist[index] != null) {
        if (status == true) {
          getallpostlist[index].collectionId = collectionId;
        } else {
          getallpostlist[index].collectionId = 0;
        }
        getallpostlist[index].isSaved = status;
      }
    });
  }

  void getCollectionList() async {
    _createPostViewModel.setLoading();
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _createPostViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Collection_list_params request =
          new Collection_list_params(userid: MemoryManagement.getuserId());
      var response =
          await _createPostViewModel.getallcollections(request, context);
      Collection_list_response collectionresponse = response;
      if (collectionresponse.status.compareTo("success") == 0) {
        setState(() {
          collectiondatalist.clear();
          if (collectionresponse.collectionData != null &&
              collectionresponse.collectionData.length > 0) {
            collectiondatalist.addAll(collectionresponse.collectionData);
            for (var data in collectiondatalist) {
              if (data.collectionName != null &&
                  data.collectionName.compareTo("Creative Journal") == 0) {
                // collectionid = data.id;
                collectiondatalist.remove(data);
                break;
              }
            }
            if (collectiondatalist != null && collectiondatalist.length > 0) {
              showFavouriteList(collectiondatalist);
            } else {
              displaytoast("Favorites list not found ", context);
              showCreateFoler();
            }
          } else {
            displaytoast("Favorites list not found, ", context);
            showCreateFoler();
          }
        });
      } else {
        displaytoast("Please create folder in favourite section", context);
      }
    }
  }

  void getdatasnapshotkey() async {
    dataSnapshot = await reference.orderByKey().once();
    dataSnapshot.key;
  }

  void gettrybegroup() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          // ignore: missing_return
          return StatefulBuilder(builder: (context, setState) {
            return Stack(
              children: <Widget>[
                new Container(
                  height: 350.0,
                  color: Colors.black,
                  //so you don't have to change MaterialApp canvasColor
                  child: new Container(
                      height: 350.0,
                      padding: EdgeInsets.only(
                          left: 20, top: 10, bottom: 0, right: 20),
                      decoration: new BoxDecoration(
                          color: Colors.white,
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
                                  "Select TrybeGroup",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: getColorFromHex(AppColors.red),
                                      fontSize: 14),
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    if (messagekey != null &&
                                        messagekey.isNotEmpty) {
                                      trybegroupid = messagekey;
                                    } else {
                                      trybegroupid = "0";
                                    }
                                  });
                                  Navigator.pop(context);
                                },
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "Save",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          // InkWell(
                          //   onTap: () {
                          //     Navigator.pop(context);
                          //     showCreateFoler();
                          //   },
                          //   child: Row(
                          //     children: <Widget>[
                          //       SizedBox(
                          //         width: 25,
                          //       ),
                          //       Image.asset(
                          //         "assets/addwhite.png",
                          //         height: 25,
                          //         width: 25,
                          //         color: getColorFromHex(AppColors.black),
                          //       ),
                          //       SizedBox(
                          //         width: 10,
                          //       ),
                          //       Text(
                          //         'New Favorites Folder',
                          //         style: TextStyle(
                          //             color: getColorFromHex(AppColors.black),
                          //             fontSize: 16),
                          //       )
                          //     ],
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          Container(
                              margin:
                                  EdgeInsets.only(left: 25, top: 0, bottom: 20),
                              child: FirebaseAnimatedList(
                                padding: EdgeInsets.all(0),
                                shrinkWrap: true,
                                query: reference ?? "",
                                reverse: true,
                                sort: (a, b) => b.key.compareTo(a.key),
                                //comparing timestamp of messages to check which one would appear first
                                itemBuilder: (_, DataSnapshot messageSnapshot,
                                    Animation<double> animation, int index) {
                                  print("index= $index");
                                  print("index= ${messageSnapshot.value}");
                                  return GestureDetector(
                                    onTap: () {
                                      // String groupname=messageSnapshot.value['groupname']!=null?messageSnapshot.value['groupname']:"";
                                      // String admin=messageSnapshot.value['admin']!=null?messageSnapshot.value['admin']:"";
                                      // String keys=messageSnapshot.key;
                                      // Navigator.of(context,rootNavigator: true).
                                      // push(MaterialPageRoute(builder: (context) => GroupChat(groupname,admin,keys)));

                                      setState(() {
                                        messagekey = messageSnapshot.key;
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                              messageSnapshot
                                                          .value['groupname'] !=
                                                      null
                                                  ? messageSnapshot
                                                      .value['groupname']
                                                  : "",
                                              style: TextStyle(
                                                  color: getColorFromHex(
                                                      AppColors.black),
                                                  fontSize: 18)),
                                          Spacer(),
                                          new Radio(
                                            value: TrybeGroup.select,
                                            groupValue: _trybeGroup,
                                            activeColor:
                                                getColorFromHex(AppColors.red),
                                            onChanged: (value) {
                                              setState(() {
                                                _trybeGroup = value;
                                                messagekey =
                                                    messageSnapshot.key;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )),
                        ],
                      )),
                ),
                Container(
                  child: getFullScreenProviderLoaders(
                      status: _createPostViewModel.getCollectionLoaded(),
                      context: context),
                ),
              ],
            );
          });
        }).then((value) {
      if (trybegroupid.compareTo("0") == 0) {
        setState(() {
          istrybegroup = false;
        });
      }
    });
  }
}
