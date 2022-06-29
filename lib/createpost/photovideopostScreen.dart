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
import 'package:trybelocker/home_screen.dart';
import 'package:trybelocker/model/createpost/createpostresponse.dart';
import 'package:trybelocker/model/privacyclass.dart';
import 'package:trybelocker/networkmodel/APIs.dart';
import 'package:trybelocker/newsfeed.dart';
import 'package:trybelocker/service/MyService.dart';
import 'package:trybelocker/service/service_locator.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/src/media_type.dart';
import 'package:path/path.dart' as path;
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/video_player/videoplayer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:video_compress/video_compress.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_database/firebase_database.dart';

class PhotoVideoPostScreen extends StatefulWidget {
  File galleryselecteitems = null;
  String type = null;

  PhotoVideoPostScreen([this.galleryselecteitems, this.type]);

  PhotoVideoPostScreenState createState() =>
      PhotoVideoPostScreenState(galleryselecteitems, type);
}

class PhotoVideoPostScreenState extends State<PhotoVideoPostScreen>
    with SingleTickerProviderStateMixin {
  // String privacytype = "Public";
  // String selectaudience = "forkids";
  // String saveto = "";
  String selectedImage;
  bool isLoading = false;
  File galleryselecteitems = null;
  String type = null;
  Privacyclass privacyclass = Privacyclass();
  var thumbnail = null;
  var titlecontroller = TextEditingController();

  firebase_storage.FirebaseStorage storage;
  List<String> tokenlist = [];
  var reference;

  MyService service = locator<MyService>();

  PhotoVideoPostScreenState(this.galleryselecteitems, this.type);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (type.compareTo("video") == 0) getThumbnailValue();
    });
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
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: Navigator.of(context).pop),
                        Text(
                          'Add Details',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        Spacer(),
                        GestureDetector(
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
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            onTap: () {
                              if (titlecontroller.text != null &&
                                  titlecontroller.text.isNotEmpty) {
                                if (type.compareTo("video") == 0)
                                  compressvideo(galleryselecteitems);
                                else {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  uploadvideo(galleryselecteitems);
                                  if (privacyclass.trybegroupid != null &&
                                      !(privacyclass.trybegroupid
                                              .compareTo("0") ==
                                          0)) {
                                    sendimagetogroup(galleryselecteitems.path);
                                  }
                                }
                              } else
                                displaytoast(
                                    "Please enter post caption", context);
                            })
                      ],
                    )),
                type.compareTo("image") == 0
                    ? Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: Image.file(
                          galleryselecteitems,
                          fit: BoxFit.cover,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => VideoPlayerScreen(
                                  galleryselecteitems.path, true)));
                        },
                        child: Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          child: thumbnail == null
                              ? Stack(
                                  children: <Widget>[
                                    FutureBuilder(
                                        future: getThumbnail(
                                            galleryselecteitems.path),
                                        builder:
                                            (BuildContext context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            return Stack(
                                              children: <Widget>[
                                                snapshot != null
                                                    ? snapshot.data != null
                                                        ? Positioned.fill(
                                                            child: Image.memory(
                                                              snapshot.data,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          )
                                                        : Positioned.fill(
                                                            child:
                                                                Image.network(
                                                            "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80",
                                                            fit: BoxFit.cover,
                                                          ))
                                                    : Positioned.fill(
                                                        child: Image.network(
                                                        "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80",
                                                        fit: BoxFit.cover,
                                                      ))
                                              ],
                                            );
                                          } else {
                                            return Container();
                                          }
                                        }),
                                    Center(
                                      child: Icon(
                                        Icons.play_circle_outline,
                                        size: 100,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                )
                              : Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Image.memory(
                                        thumbnail,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Center(
                                      child: Icon(
                                        Icons.play_circle_outline,
                                        size: 100,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                        )),
                Stack(
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
                                    SizedBox(
                                      width: 5,
                                    ),
                                    new Container(
                                      width: 50,
                                      height: 50,
                                      margin: EdgeInsets.all(2),
                                      child: ClipOval(
                                        child: getProfileImage(MemoryManagement
                                            .getuserprofilepic()),
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
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                seperationline(2),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(left: 13, right: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              counterStyle: TextStyle(
                                                  color: Colors.white),
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
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
                )
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

  createpost([Uint8List image, String type]) async {
    // Navigator.of(context).pop();

    var request = http.MultipartRequest('POST', Uri.parse(APIs.createpost));
    request.fields['uid'] = MemoryManagement.getuserId();
    request.fields['post_type'] = type.compareTo("video") == 0 ? "2" : "1";
    request.fields['post_caption'] = titlecontroller.value.text;
    request.fields['privacy_type'] = privacyclass.privacy != null
        ? privacyclass.privacy.compareTo("Private") == 0
            ? "2"
            : "1"
        : "1";
    request.fields['isforkid'] = privacyclass.selectaudience != null
        ? privacyclass.selectaudience.compareTo("forkids") == 0
            ? "1"
            : "0"
        : "1";
    request.fields['is_creative_journal'] =
        privacyclass.iscreativejournal != null
            ? privacyclass.iscreativejournal.compareTo("0") == 0
                ? "0"
                : "1"
            : "0";
    request.fields['is_playlist'] = privacyclass.istrybelist != null
        ? privacyclass.istrybelist.compareTo("0") == 0
            ? "0"
            : "1"
        : "0";
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
          //Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewsFeed()),
          );

        } else {
          displaytoast("Post Created Successfully", context);
        }
      } else {
        displaytoast("Some thing went wrong", context);
      }
    }
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

  void getThumbnailValue() async {
    thumbnail = await getThumbnail(galleryselecteitems.path);
  }

  Future<Uint8List> getThumbnail(String url) async {
    return await VideoThumbnail.thumbnailData(
      video: url,
      imageFormat: ImageFormat.PNG,
      maxWidth: getScreenSize(context: context).width.toInt(),
      maxHeight: 200,
      // maxHeight: 500,
      // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 90,
    );
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

  void uploadvideo(File compressedfile) {
    if (compressedfile != null) {
      if (titlecontroller.text != null &&
          titlecontroller.text.trim().length > 0) {
        Uint8List bytes = compressedfile.readAsBytesSync();
        print("uid=>, ${MemoryManagement.getuserId()}");
        print(
          "post_type=>,1",
        );
        print("post_caption=>, ${titlecontroller.value.text}");
        print(
            "privay_type=>, ${privacyclass.privacy != null ? privacyclass.privacy.compareTo("Private") == 0 ? "2" : "1" : "1"}");
        print(
            "isforkid=>, ${privacyclass.selectaudience != null ? privacyclass.selectaudience.compareTo("forkids") == 0 ? "0" : "1" : "1"}");
        print(
            "isCreativeJournal=>, ${privacyclass.iscreativejournal != null ? privacyclass.iscreativejournal.compareTo("0") == 0 ? "0" : "1" : "0"}");
        print(
            "isPlaylist=>, ${privacyclass.istrybelist != null ? privacyclass.istrybelist.compareTo("0") == 0 ? "0" : "1" : "0"}");
        print(
            "playlistId=>, ${privacyclass.trybelistid != null ? privacyclass.trybelistid : "0"}");
        print(
            "isCollection=>, ${privacyclass.isfavorites != null ? privacyclass.isfavorites.compareTo("0") == 0 ? "0" : "1" : "0"}");
        print(
            "collectionId=>, ${privacyclass.favoritesid != null ? privacyclass.favoritesid : "0"}");
        print(
            "trybegroup=>, ${privacyclass.istrybegroup != null ? privacyclass.istrybegroup.compareTo("0") == 0 ? "0" : "1" : "0"}");
        print(
            "trybegroupid=>, ${privacyclass.trybegroupid != null ? privacyclass.trybegroupid : "0"}");

        createpost(bytes, type);
      } else {
        displaytoast("Title required", context);
      }
    } else {
      displaytoast("No Post Found", context);
    }
  }

  void sendvideotogroup(String path) async {
    final videoInfo = FlutterVideoInfo();
    var infos = await videoInfo.getVideoInfo(path);
    print("duarioninfo== ${infos.duration}");
    if (infos.duration != null && infos.duration < 400000) {
      try {
        print("duarioninfo== ${path}");
        await VideoCompress.setLogLevel(0);
        final info = await VideoCompress.compressVideo(
          path,
          quality: VideoQuality.MediumQuality,
          deleteOrigin: false,
          includeAudio: true,
        );
        print("duarioninfo== compressed ${info}");
        int timestamp = new DateTime.now().millisecondsSinceEpoch;
        firebase_storage.UploadTask task = storage
            .ref('video/' + timestamp.toString() + ".mp4")
            .putFile(File(info.path));

        await task;
        String downloadURL = await storage
            .ref('video/' + timestamp.toString() + ".mp4")
            .getDownloadURL();
        print("duarioninfo== downloadURL ${downloadURL}");
        print("downloadurl $downloadURL");

        _sendMessage(messageText: "", imageUrl: downloadURL, posttype: "2");
      } catch (e) {
        print("duarioninfo== exception ${e}");
        // setState(() {
        //   isShow=false;
        // });
      }
    } else {
      displaytoast("Video duration must be less than 4 minutes", context);
    }
  }

  void sendimagetogroup(String path) async {
    int timestamp = new DateTime.now().millisecondsSinceEpoch;
    firebase_storage.UploadTask task = storage
        .ref('images/' + timestamp.toString() + ".jpg")
        .putFile(File(path));

    try {
      await task;
      String downloadURL = await storage
          .ref('images/' + timestamp.toString() + ".jpg")
          .getDownloadURL();
      print("downloadurl $downloadURL");
      _sendMessage(messageText: "", imageUrl: downloadURL, posttype: "1");
    } catch (e) {}
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

  void compressvideo(File pickedfile) async {
    setState(() {
      isLoading = true;
    });
    try {
      print("duarioninfo== ${pickedfile.path}");
      await VideoCompress.setLogLevel(0);
      final info = await VideoCompress.compressVideo(
        pickedfile.path,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false,
        includeAudio: true,
      );
      print("duarioninfo== compressed ${info}");

      uploadvideo(info.file);
      if (privacyclass.trybegroupid != null &&
          !(privacyclass.trybegroupid.compareTo("0") == 0)) {
        sendvideotogroup(info.file.path);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("duarioninfo== exception ${e}");
    }
  }
}
