import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:screenshot/screenshot.dart';
import 'package:trybelocker/UniversalFunctions.dart';
import 'package:trybelocker/chat/groupchat/sendnotification.dart';
import 'package:trybelocker/createpost/postprivacyscreen.dart';
import 'package:trybelocker/enums/enums.dart';
import 'package:trybelocker/model/createpost/createpostresponse.dart';
import 'package:trybelocker/model/privacyclass.dart';
import 'package:trybelocker/networkmodel/APIs.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/src/media_type.dart';
import 'package:path/path.dart' as path;
import 'package:trybelocker/utils/memory_management.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_database/firebase_database.dart';

class WritingPostScreen extends StatefulWidget {
  WritingPostScreen();

  WritingPostScreenState createState() => WritingPostScreenState();
}

class WritingPostScreenState extends State<WritingPostScreen>
    with SingleTickerProviderStateMixin {
  var _writepostcontroller = TextEditingController();

  // String privacytype = "Public";
  // String selectaudience = "forkids";
  // String saveto = "";
  List<Widget> bgs = [];
  String selectedImage;
  ScreenshotController screenshotController = ScreenshotController();
  bool isLoading = false;
  Privacyclass privacyclass = Privacyclass();

  var titlecontroller = TextEditingController();

  firebase_storage.FirebaseStorage storage;
  var reference;
  List<String> tokenlist = [];


  WritingPostScreenState();

  @override
  void initState() {
    super.initState();
    bgs.add(createBg("assets/post_bg_4.jpg"));
    bgs.add(createBg("assets/post_bg_5.jpg"));
    bgs.add(createBg("assets/post_bg_6.jpg"));
  }

  @override
  Widget build(BuildContext context) {
    // if (privacyclass.privacy != null &&
    //     privacyclass.privacy.trim().length > 0) {
    //   privacytype = privacyclass.privacy;
    // }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 30, right: 10),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: Navigator.of(context).pop),
                        Text(
                          'New Creative Journal Entry',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        Spacer(),
                        titlecontroller.text != null
                            ? titlecontroller.text.isNotEmpty
                                ? GestureDetector(
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        'Upload',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                      decoration: BoxDecoration(
                                          color: getColorFromHex(AppColors.red),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                    ),
                                    onTap: () {
                                      if (titlecontroller.text != null &&
                                          titlecontroller.text.isNotEmpty) {

                                        uploadpost();
                                        if (privacyclass.trybegroupid != null &&
                                            !(privacyclass.trybegroupid.compareTo("0") == 0)) {
                                            sendimagetogroup();
                                        }
                                      } else
                                        displaytoast(
                                            "Please enter title",
                                            context);
                                    })
                                : GestureDetector(
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        'Next',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                      decoration: BoxDecoration(
                                          color: getColorFromHex(AppColors.red),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                    ),
                                    onTap: () {
                                      if (_writepostcontroller.text != null &&
                                          _writepostcontroller.text.isNotEmpty)
                                        showcreatepostbottomsheet(context);
                                      else
                                        displaytoast(
                                            "Please write something on Post",
                                            context);
                                    })
                            : GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    'Next',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  decoration: BoxDecoration(
                                      color: getColorFromHex(AppColors.red),
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                                onTap: () {
                                  if (_writepostcontroller.text != null &&
                                      _writepostcontroller.text.isNotEmpty)
                                    showcreatepostbottomsheet(context);
                                  else
                                    displaytoast(
                                        "Please write something on post",
                                        context);
                                })
                      ],
                    )),
                SizedBox(
                  height: 20,
                ),
                Screenshot(
                    controller: screenshotController,
                    child: Container(
                        // margin: EdgeInsets.only(left: 10, right: 10),
                        // padding: EdgeInsets.only(left: 10, right: 10),
                        height: MediaQuery.of(context).size.width / 1.2,
                        decoration: BoxDecoration(
                          image: selectedImage == null
                              ? null
                              : DecorationImage(
                                  image: AssetImage(selectedImage),
                                  fit: BoxFit.cover,
                                ),
                          color: Colors.pinkAccent,
                        ),
                        child: Center(
                          child: TextField(
                              controller: _writepostcontroller,
                              // textAlignVertical: TextAlignVertical.center,
                              autofocus: false,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                hintText: "Type Here",
                                hintStyle: TextStyle(color: Colors.white54),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              )),
                        ))),
                SizedBox(
                  height: 20,
                ),
                Container(
                    height: 90,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: bgs,
                    ))
              ],
            ),
            getFullScreenProviderLoader(status: isLoading, context: context)
          ],
        ),
      ),
    );
  }

  createBg(asset) {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedImage = asset;
          });
        },
        child: new CircleAvatar(
          radius: 25.0,
          backgroundImage: AssetImage(asset),
        ),
      ),
    );
  }

  createpost([Uint8List image]) async {
    var request = http.MultipartRequest('POST', Uri.parse(APIs.createpost));
    request.fields['uid'] = MemoryManagement.getuserId();
    request.fields['post_type'] = "1";
    request.fields['post_caption'] = titlecontroller.value.text;
    request.fields['privay_type'] = privacyclass.privacy != null ? privacyclass.privacy.compareTo("Private") == 0
            ? "2" : "1" : "1";
    request.fields['isforkid'] = privacyclass.selectaudience != null ? privacyclass.selectaudience.compareTo("forkids") == 0
            ? "1" : "0" : "1";
    request.fields['is_creative_journal'] = privacyclass.iscreativejournal != null
            ? privacyclass.iscreativejournal.compareTo("0") == 0 ? "0" : "1" : "0";
    request.fields['is_playlist'] = privacyclass.istrybelist != null
        ? privacyclass.istrybelist.compareTo("0") == 0  ? "0": "1" : "0";
    request.fields['playlist_id'] =
        privacyclass.trybelistid != null ? privacyclass.trybelistid : "0";
    request.fields['is_collection'] = privacyclass.isfavorites != null
        ? privacyclass.isfavorites.compareTo("0") == 0
            ? "0"
            : "1"
        : "0";
    request.fields['collection_id'] =
        privacyclass.favoritesid != null ? privacyclass.favoritesid : "0";
    // request.fields['save_in'] = saveto.isNotEmpty ? saveto.compareTo("trybelist") == 0 ? "1" : "2" : "0";
    request.files.add(http.MultipartFile.fromBytes(
      'post_media_file',
      image,
      filename: "test",
      // contentType: MediaType('application', 'octet-stream'),
    ));
    // setState(() {
    //   isLoading = true;
    // });
    var response = await request.send();
    print(response.stream);
    print(response.statusCode);
    final res = await http.Response.fromStream(response);
    print(res.body);
    var responseJson = json.decode(res.body);
    Createpostresponse createpostresponse =
        new Createpostresponse.fromJson(responseJson);
    setState(() {
      isLoading = false;
    });
    if (createpostresponse != null &&
        createpostresponse.status != null &&
        createpostresponse.status.trim().length > 0) {
      if (createpostresponse.status.trim() == "success") {
        if (createpostresponse.message != null &&
            createpostresponse.message.trim().length > 0) {
          displaytoast(createpostresponse.message, context);
          // Navigator.pop(context);
          Navigator.pop(context);
        } else {
          displaytoast("Post Created Successfully", context);
        }
      } else {
        displaytoast("Some thing went wrong", context);
      }
    }
  }

  void showcreatepostbottomsheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          // ignore: missing_return
          return StatefulBuilder(builder: (context, setState) {
            return WillPopScope(
              child: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    // physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    child: new Container(
                      height: 400.0,
                      color: Colors.black,
                      //could change this to Color(0xFF737373),
                      //so you don't have to change MaterialApp canvasColor
                      child: new Container(
                          height: 400.0,
                          padding: EdgeInsets.only(
                              left: 0, top: 10, bottom: 0, right: 0),
                          decoration: new BoxDecoration(
                            color: getColorFromHex(
                                AppColors.createpostbottomsheetbgcolor),
                          ),
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  // IconButton(
                                  //     icon: Icon(
                                  //       Icons.arrow_back,
                                  //       color: Colors.white,
                                  //     ),
                                  //     onPressed: Navigator.of(context).pop),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  new Container(
                                    width: 50,
                                    height: 50,
                                    margin: EdgeInsets.all(2),
                                    child: ClipOval(
                                      child: getProfileImage(
                                          MemoryManagement.getuserprofilepic()),
                                    ),
                                    // decoration: BoxDecoration(
                                    //     shape: BoxShape.circle,
                                    //     image: new DecorationImage(
                                    //         fit: BoxFit.fill,
                                    //         image: getprofilepic(1))),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        MemoryManagement.getuserName(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                      getEmailphone()
                                    ],
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.only(right: 10),
                                      child: Text(
                                        'Submit',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                      decoration: BoxDecoration(
                                          color: getColorFromHex(AppColors.red),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              // Row(
                              //   children: <Widget>[
                              //     SizedBox(
                              //       width: 5,
                              //     ),
                              //     new Container(
                              //       width: 50,
                              //       height: 50,
                              //       margin: EdgeInsets.all(2),
                              //       child: ClipOval(
                              //         child: getProfileImage(
                              //             MemoryManagement.getuserprofilepic()),
                              //       ),
                              //       // decoration: BoxDecoration(
                              //       //     shape: BoxShape.circle,
                              //       //     image: new DecorationImage(
                              //       //         fit: BoxFit.fill,
                              //       //         image: getprofilepic(1))),
                              //     ),
                              //     SizedBox(
                              //       width: 10,
                              //     ),
                              //     Column(
                              //       crossAxisAlignment:
                              //           CrossAxisAlignment.start,
                              //       children: <Widget>[
                              //         Text(
                              //           MemoryManagement.getuserName(),
                              //           style: TextStyle(
                              //             color: Colors.white,
                              //             fontWeight: FontWeight.bold,
                              //           ),
                              //           textAlign: TextAlign.start,
                              //         ),
                              //         getEmailphone()
                              //       ],
                              //     ),
                              //   ],
                              // ),
                              SizedBox(
                                height: 10,
                              ),
                              seperationline(2),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(left: 13, right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Title",
                                      style: TextStyle(color: Colors.white),
                                      textAlign: TextAlign.start,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      height: 40,
                                      child: TextField(
                                        controller: titlecontroller,
                                        autofocus: false,
                                        textAlign: TextAlign.left,
                                        maxLength: 100,
                                        maxLines: 3,
                                        cursorColor: Colors.white,
                                        // onFieldSubmitted: (val){
                                        //   FocusScope.of(context).unfocus();
                                        // },
                                        textInputAction: TextInputAction.done,
                                        onSubmitted: (val) {
                                          FocusScope.of(context).unfocus();
                                        },
                                        decoration: InputDecoration(
                                            counterText: "",
                                            counterStyle:
                                                TextStyle(color: Colors.white),
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            contentPadding: EdgeInsets.fromLTRB(
                                                0, 0, 10, 0),
                                            hintStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                            hintText: "Create a Title"),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              seperationline(2),
                              SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PostPrivacy(privacyclass)))
                                      .then((value) {
                                    setState(() {
                                      if (value != null) {
                                        privacyclass = value;
                                        // iscreativejournal = privacyclass.iscreativejournal;
                                        // privacytype = privacyclass.privacy;
                                        // istrybelist = privacyclass.istrybelist;
                                        // isfavorites = privacyclass.isfavorites;
                                        // istrybegroup = privacyclass.istrybegroup;
                                        // selectaudience = privacyclass.selectaudience;
                                        if (privacyclass.trybegroupid !=
                                            null &&
                                            !(privacyclass.trybegroupid
                                                .compareTo("0") ==
                                                0)) {
                                          reference = FirebaseDatabase
                                              .instance
                                              .reference()
                                              .child('groupmessages')
                                              .child(
                                              privacyclass.trybegroupid);

                                          storage = firebase_storage
                                              .FirebaseStorage.instanceFor();
                                        }
                                      }
                                    });
                                  });
                                },
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Icon(
                                      Icons.public,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      privacyclass.privacy != null
                                          ? privacyclass.privacy
                                                      .compareTo("Private") ==
                                                  0
                                              ? "Private"
                                              : "Public"
                                          : "Private",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              seperationline(2),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  "Regardless of your location, you're legally required to comply with children's Online privacy Protection Act (COPPA) and/or other laws, Your're required to tell whether your videos/posts are made for kids. What's considered \"made for kids\"",
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          )),
                    ),
                  ),
                  // getFullScreenProviderLoaders(status: isLoading, context: context)
                ],
              ),
              onWillPop: () async {
                return false;
              },
            );
          });
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
            height: MediaQuery.of(context).size.height,
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
      height: MediaQuery.of(context).size.height,
      child: getChildLoader(
        color: color ?? AppColors.kPrimaryBlue,
        strokeWidth: strokeWidth,
      ),
    );
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

  getEmailphone() {
    if (MemoryManagement.getEmail() != null &&
        MemoryManagement.getEmail().toLowerCase().compareTo("null") != 0) {
      return Text(
        MemoryManagement.getEmail(),
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.start,
      );
    } else if (MemoryManagement.getPhonenumber() != null &&
        MemoryManagement.getPhonenumber().toLowerCase().compareTo("null") !=
            0) {
      return Text(
        MemoryManagement.getPhonenumber(),
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.start,
      );
    } else {
      return Text(
        "MemoryManagement.getPhonenumber()",
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.start,
      );
    }
  }

  void uploadpost() {
    Uint8List _imageFile = null;
    screenshotController
        .capture(delay: Duration(milliseconds: 10))
        .then((Uint8List image) async {
      _imageFile = image;
      if (_imageFile != null) {
        setState(() {
          isLoading = true;
        });
        createpost(_imageFile);
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  void sendimagetogroup() async {

    Uint8List _imageFile = null;
    screenshotController
        .capture(delay: Duration(milliseconds: 10))
        .then((Uint8List image) async {
      _imageFile = image;
      if (_imageFile != null) {
        Directory systemTempDir = Directory.systemTemp;
        File file = await new File('${systemTempDir.path}/foo.png').create();
        file.writeAsBytes(_imageFile);
        int timestamp = new DateTime.now().millisecondsSinceEpoch;
        firebase_storage.UploadTask task = storage
            .ref('images/' + timestamp.toString() + ".jpg")
            .putFile(file);

        try {
          await task;
          String downloadURL = await storage
              .ref('images/' + timestamp.toString() + ".jpg")
              .getDownloadURL();
          print("downloadurl $downloadURL");
          _sendMessage(messageText: "", imageUrl: downloadURL, posttype: "1");
        } catch (e) {}
      }
    }).catchError((onError) {
      print(onError);
    });


  }
  void _sendMessage({String messageText, String imageUrl, String posttype}) {
    tokenlist.clear();
    String fcmTitle;
    String fcmBody;
    reference.push().set({
      'id': MemoryManagement.getuserId(),
      'text': messageText,
      'posttype': posttype,
      'email': MemoryManagement.getEmail() != null
          ? MemoryManagement.getEmail()
          : "",
      'imageUrl': imageUrl,
      'username': MemoryManagement.getuserName() != null
          ? MemoryManagement.getuserName()
          : "",
      'senderPhotoUrl': MemoryManagement.getuserprofilepic() != null
          ? MemoryManagement.getuserprofilepic()
          : "",
      'createdAt': DateTime.now().toString()
    });

    //
    // service.startupload(100, true);

    var db = FirebaseDatabase.instance
        .reference()
        .child('groups')
        .child(MemoryManagement.getuserId())
        .child(privacyclass.trybegroupid)
        .child('users');
    db.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        print("ChatToken:${values["device_token"]}");
        tokenlist.add("\"" + values["device_token"] + "\"");

        //sendFCMPush(tokenlist);
      });

      if (posttype == null) {
        fcmTitle = MemoryManagement.getuserName();
        fcmBody = messageText;
        sendnotification().sendFcm(fcmTitle, fcmBody, tokenlist);
      } else if (posttype == "1") {
        fcmTitle = MemoryManagement.getuserName();
        fcmBody = "Image posted";
        sendnotification().sendFcm(fcmTitle, fcmBody, tokenlist);
      } else if (posttype == "2") {
        fcmTitle = MemoryManagement.getuserName();
        fcmBody = "Video posted";
        sendnotification().sendFcm(fcmTitle, fcmBody, tokenlist);
      }
      print("ChatTokennn:${tokenlist}");
      final receiverFcmToken =
          "d2i5CEClStyB8Lh1q3hc-s:APA91bGMYLqV-bTLBpvrCRHUR_pfwkz3pyTN0-zH1f5VCsirJIXwTjQravs15-uX9Mz7I-IMAJoUjnDdREhWmLLwH5Afg72SR3c7enNsWe4U1EhGnN2kZux409CFRFFNJ_GP6Jl6wIa2";
    });
  }
}
