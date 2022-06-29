import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trybelocker/chat/ChatMessageListItem.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trybelocker/chat/groupchat/sendnotification.dart';
import 'package:trybelocker/model/getallposts/getallpostresponse.dart';
import 'package:trybelocker/model/search/search_response.dart';
import 'package:trybelocker/networkmodel/APIs.dart';
import 'package:trybelocker/publicprofile/publicprofilescreen.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:bubble/bubble.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/viewmodel/home_view_model.dart';
import 'package:trybelocker/viewmodel/profile_view_model.dart';
import 'package:video_compress/video_compress.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'Recentpostuserlist.dart';
import 'UniversalFunctions.dart';
import 'chat/groupchat/Groupusersfirebase.dart';
import 'chat/groupchat/RecentUsersForGroup.dart';
import 'group_messaging_list_item.dart';
import 'model/recentuserlist/getrecentuserlistparams.dart';
import 'package:trybelocker/model/recentuserlist/getrecentuserlistparams.dart';
import 'package:trybelocker/model/recentuserlist/getrecentuserlistresponse.dart';
import 'package:trybelocker/viewmodel/recentuserpostviewmodel.dart';
import 'package:provider/src/provider.dart';
import 'networkmodel/APIHandler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';



var _scaffoldContext;
class GroupChat extends StatefulWidget {
  String groupname;
  String admin;
  String keys;

  GroupChat(this.groupname,this.admin,this.keys);
  GroupChatState createState() => GroupChatState();
}
class GroupChatState extends State<GroupChat>{
  final TextEditingController _textEditingController = new TextEditingController();
  var reference;
  var addusersreference;
  String messageId="";
  firebase_storage.FirebaseStorage storage;
  bool isShow=false;
  HomeViewModel _homeViewModel;
  int currentPage = 1;
  int limit = 10;
  List<DataUsers> getrecentuserlist = [];
  List<String> tokenlist = [];
  bool isnearpostLoading = false;
  bool allnearPost = false;
  String devicetoken="";
  ProfileViewModel _profileViewModel;
  final TextEditingController groupName = new TextEditingController();
  FirebaseMessaging _firebaseMessaging =  FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    reference = FirebaseDatabase.instance.reference().child('groupmessages').
    child(widget.keys);
    storage = firebase_storage.FirebaseStorage.instanceFor();
    getdevicetoken();


  }

  @override
  Widget build(BuildContext context) {
    _homeViewModel = Provider.of<HomeViewModel>(context);
    _profileViewModel = Provider.of<ProfileViewModel>(context);

    return  Scaffold(
        backgroundColor:getColorFromHex(AppColors.black),
        appBar: AppBar(
          brightness: Brightness.dark,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          backgroundColor:getColorFromHex(AppColors.black),
          title:Container(
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.only(top: 10),
            child: Row(children: <Widget>[
              IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,), onPressed:(){
                Navigator.pop(context);
              }),
              new Container(
                width: 35,
                height: 35,
                margin: EdgeInsets.all(2),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        fit: BoxFit.cover,
                        image:  getProfileImage(""))),
              ),
              SizedBox(width: 15,),
              new InkWell(
                onTap: () {
                  // displaytoast(widget.groupname, context);
                  navigateToNextScreen(context, true, Groupusersfirebase(groupName.text,widget.groupname,widget.keys));

                },
                child: new Text(widget.groupname ,style: TextStyle(color: Colors.white,fontSize: 14),),

              )
            ],),
          ),
          actions: <Widget>[
            Visibility(visible: widget.admin.compareTo("true")==0?true:false,
                child:  IconButton(icon: Icon(Icons.add,color: Colors.white,), onPressed: (){
                  // navigateToNextScreen(context, true, RecentUsersForGroup());

                  Navigator.of(context, rootNavigator: true)
                      .push(MaterialPageRoute(builder: (context) => RecentUsersForGroup())).then((value) {
                    if(value!=null){
                      DataUser datausers = value;
                      print("UserIdd:${datausers.username}");
                      groupName.text = datausers.username;

                      addusersreference=FirebaseDatabase.instance.reference().child('groups').
                      child(MemoryManagement.getuserId()).child(widget.keys).child('users').
                      child(datausers.username);
                      createGroupsUser( datausers.username,datausers.id,datausers.email,datausers.device_token);
                    }
                  });
                  //getrecentuser();

                })
            )
          ],),
        body: Stack(
          children: <Widget>[
            new Container(
              child: new Column(
                children: <Widget>[
                  SizedBox(height: 15,),
                  new Flexible(
                    child: new FirebaseAnimatedList(
                      query: reference,
                      padding: const EdgeInsets.all(8.0),
                      reverse: true,
                      sort: (a, b) => b.key.compareTo(a.key),
                      //comparing timestamp of messages to check which one would appear first
                      itemBuilder: (_, DataSnapshot messageSnapshot, Animation<double> animation,int index) {
                        print("index= $index");
                        print("index= ${messageSnapshot.value}");

                        return new GroupMessagingListItem(messageSnapshot: messageSnapshot, animation: animation,);
                      },
                    ),
                  ),
                  new Divider(height: 1.0),
                  new Container(
                    decoration:
                    new BoxDecoration(color: Theme.of(context).cardColor),
                    child: _buildTextComposer(),
                  ),
                  new Builder(builder: (BuildContext context) {
                    _scaffoldContext = context;
                    return new Container(width: 0.0, height: 0.0);
                  })
                ],
              ),
              decoration: Theme.of(context).platform == TargetPlatform.iOS
                  ? new BoxDecoration(
                  border: new Border(
                      top: new BorderSide(
                        color: Colors.grey[200],
                      )))
                  : null,
            ),
            getFullScreenProviderLoader(
                status: isShow, context: context)
          ],
        ));
  }



  Future<bool> sendFCMPush(List<String> tokenlist) async {

    final postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "registration_ids" : tokenlist,
      "collapse_key" : "type_a",
      "notification" : {
        "title": 'NewTextTitle',
        "body" : 'NewTextBody',
      }
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=AAAAkw2nRZc:APA91bH52kqvjGtmwgbC1eOTJWNbrqGH7W0olK-q2yH0v78MZAxC6FOJLL6WALUgx_MHsah3VwSGFZRlfy5n7wS1wJP4kzB15_s_GJLxkwltSldTD9byrpBs1lZTEqCtwmnsUKx6W0F3'
    };

    final response = await http.post(Uri.parse(postUrl),
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      // on success do sth
      print('test ok push CFM');
      displaytoast("Notification${response.body}", context);
      return true;
    } else {
      print(' CFM error');
      displaytoast("NotificationError${response}", context);

      // on failure do sth
      return false;
    }
  }


  void createGroupsUser(String username,int id,String email,String device_token) {
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
                                'Create User',
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
                                  autofocus: false,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: "Gilroy-SemiBold",
                                      color: Color.fromRGBO(60, 72, 88, 1),
                                      fontSize: 16.7),
                                  onFieldSubmitted: (trem) async {
                                    print("ontapcalled");
                                    if(groupName.text!=null&&groupName.text.trim().length>0){

                                      addusersreference.set({
                                        'username':username,
                                        'userid':id,
                                        'email':email!=null? email:"",
                                        'device_token':device_token!=null? device_token:"",
                                        'screen_status':"false"
                                      });

                                      displaytoast("Succesfully created the user", context);
                                      //  Navigator.pop(context);
                                    }else{
                                      //displaytoast("Group name required", context);
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
                            addusersreference.set({
                              'username':username,
                              'userid':id,
                              'email':email!=null? email:"",
                              'device_token':device_token!=null? device_token:"",
                              'screen_status':"false"
                            });
                            displaytoast("Succesfully created the user", context);
                            Navigator.pop(context);
                          }else{
                            displaytoast("User name required", context);
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

  CupertinoButton getIOSSendButton() {
    return new CupertinoButton(
      child: new Text("Send"),
      onPressed: () {
        if(_textEditingController.text.length>0){
          _textMessageSubmitted(_textEditingController.text);
        }else{
          displaytoast("Text required", context);
        }

      },
    );
  }

  IconButton getDefaultSendButton() {
    return new IconButton(
      icon: new Icon(Icons.send),
      onPressed: () {
        if(_textEditingController.text.length>0){
          _textMessageSubmitted(_textEditingController.text);
        }else{
          displaytoast("Text required", context);
        }
      },
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(
            color: Theme.of(context).accentColor
        ),
        child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
            children: <Widget>[
              new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: new IconButton(
                    icon: new Icon(
                      Icons.photo_camera,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: () async {
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Choose media type',style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),),
                                  FlatButton(
                                    child: Text(
                                      'Take Photo',
                                      textAlign: TextAlign.left,
                                    ),
                                    onPressed: () async{
                                      Navigator.pop(context);
                                      final pickedfile= await ImagePicker().getImage(source: ImageSource.camera);
                                      if(pickedfile!=null){
                                        setState(() {
                                          isShow=true;
                                        });
                                        int timestamp = new DateTime.now().millisecondsSinceEpoch;
                                        firebase_storage.UploadTask task = storage.ref('images/'+timestamp.toString() + ".jpg")
                                            .putFile(File(pickedfile.path));

                                        try {
                                          await task;
                                          String downloadURL = await storage.ref('images/'+timestamp.toString() + ".jpg").
                                          getDownloadURL();
                                          print("downloadurl $downloadURL");
                                          setState(() {
                                            isShow=false;
                                          });
                                          _sendMessage(messageText: "",imageUrl: downloadURL,posttype: "1");
                                        } catch (e) {
                                          setState(() {
                                            isShow=false;
                                          });
                                        }
                                      }
                                    },
                                  ),
                                  FlatButton(
                                    child: Text(
                                      'Choose from gallery',
                                    ),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      final pickedfile= await ImagePicker().getImage(source: ImageSource.gallery);
                                      if(pickedfile!=null){
                                        setState(() {
                                          isShow=true;
                                        });
                                        int timestamp = new DateTime.now().millisecondsSinceEpoch;
                                        firebase_storage.UploadTask task = storage.ref('images/'+timestamp.toString() + ".jpg")
                                            .putFile(File(pickedfile.path));

                                        try {
                                          await task;
                                          String downloadURL = await storage.ref('images/'+timestamp.toString() + ".jpg").getDownloadURL();
                                          print("downloadurl $downloadURL");
                                          setState(() {
                                            isShow=false;
                                          });
                                          _sendMessage(messageText: "",imageUrl: downloadURL,posttype: "1");
                                        } catch (e) {
                                          setState(() {
                                            isShow=false;
                                          });
                                        }


                                      }
                                    },
                                  ),
                                  FlatButton(
                                    child: Text(
                                      'Choose Video from gallery',
                                    ),
                                    onPressed: () async{
                                      Navigator.pop(context);
                                      final pickedfile= await ImagePicker().getVideo(source: ImageSource.gallery);
                                      if(pickedfile!=null){
                                        setState(() {
                                          isShow=true;
                                        });
                                        final videoInfo = FlutterVideoInfo();
                                        var infos = await videoInfo.getVideoInfo(pickedfile.path);
                                        print("duarioninfo== ${infos.duration}");
                                        if(infos.duration!=null&&infos.duration<400000){
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
                                            int timestamp = new DateTime.now().millisecondsSinceEpoch;
                                            firebase_storage.UploadTask task = storage.ref('video/'+timestamp.toString() + ".mp4")
                                                .putFile(File(info.path));

                                            await task;
                                            String downloadURL = await storage.ref('video/'+timestamp.toString() + ".mp4").getDownloadURL();
                                            print("duarioninfo== downloadURL ${downloadURL}");
                                            print("downloadurl $downloadURL");
                                            setState(() {
                                              isShow=false;
                                            });
                                            _sendMessage(messageText: "",imageUrl: downloadURL,posttype: "2");
                                          } catch (e) {
                                            print("duarioninfo== exception ${e}");
                                            setState(() {
                                              isShow=false;
                                            });
                                          }
                                        }else{
                                          displaytoast("Video duration must be less than 4 minutes", context);
                                        }
                                      }
                                    },
                                  ),
                                  FlatButton(
                                    child: Text(
                                      'Take Video',
                                    ),
                                    onPressed: () async{
                                      Navigator.pop(context);
                                      final pickedfile= await ImagePicker().getVideo(source: ImageSource.camera);
                                      if(pickedfile!=null){
                                        setState(() {
                                          isShow=true;
                                        });
                                        final videoInfo = FlutterVideoInfo();
                                        var infos = await videoInfo.getVideoInfo(pickedfile.path);
                                        print("duarioninfo== ${infos.duration}");
                                        print("duarioninfo== ${infos.path}");
                                        print("duarioninfo== ${infos.width}");
                                        print("duarioninfo== ${infos.height}");
                                        print("duarioninfo== ${infos.date}");
                                        print("duarioninfo== ${infos.filesize}");
                                        print("duarioninfo== ${infos.orientation}");
                                        if(infos.duration!=null&&infos.duration<400000){
                                          await VideoCompress.setLogLevel(0);
                                          final info = await VideoCompress.compressVideo(pickedfile.path, quality: VideoQuality.MediumQuality, deleteOrigin: false,
                                            includeAudio: true,
                                          );
                                          final File compressed = File(info.path);
                                          int timestamp = new DateTime.now().millisecondsSinceEpoch;
                                          firebase_storage.UploadTask task = storage.ref('video/'+timestamp.toString() + ".mp4")
                                              .putFile(File(compressed.path));

                                          try {
                                            await task;
                                            String downloadURL = await storage.ref('video/'+timestamp.toString() + ".mp4").getDownloadURL();
                                            print("downloadurl $downloadURL");
                                            setState(() {
                                              isShow=false;
                                            });
                                            _sendMessage(messageText: "",imageUrl: downloadURL,posttype: "2");
                                          } catch (e) {
                                            setState(() {
                                              isShow=false;
                                            });
                                          }
                                        }else{
                                          setState(() {
                                            isShow=false;
                                          });
                                          displaytoast("Video duration must be less than 4 minutes", context);
                                        }
                                      }
                                    },
                                  ),
                                  FlatButton(
                                    child: Text(
                                      'Cancel',
                                    ),
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              )
                          );
                        },
                      );
                    }),
              ),
              new Flexible(
                child: new TextField(
                  controller: _textEditingController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onChanged: (value) {

                  },
                  onSubmitted: _textMessageSubmitted,
                  decoration: new InputDecoration.collapsed(hintText: "Send a message"),
                ),
              ),
              new Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? getIOSSendButton()
                    : getDefaultSendButton(),
              ),
            ],
          ),
        ));
  }

  Future<Null> _textMessageSubmitted(String text) async {
    _textEditingController.clear();
    _sendMessage(messageText: text, imageUrl: null,posttype:null);
  }

  void _sendMessage({String messageText, String imageUrl,String posttype}) {
    tokenlist.clear();
    String fcmTitle;
    String fcmBody;
    reference.push().set({
      'id':MemoryManagement.getuserId(),
      'text': messageText,
      'posttype': posttype,
      'email': MemoryManagement.getEmail()!=null? MemoryManagement.getEmail():"",
      'imageUrl': imageUrl,
      'username': MemoryManagement.getuserName()!=null?MemoryManagement.getuserName():"",
      'senderPhotoUrl': MemoryManagement.getuserprofilepic()!=null? MemoryManagement.getuserprofilepic():"",
      'createdAt':DateTime.now().toString()
    });

    var db = FirebaseDatabase.instance.reference().child('groups').
    child(MemoryManagement.getuserId()).child(widget.keys).child('users');
    db.once().then((DataSnapshot snapshot){
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key,values) {
        print("ChatToken:${values["device_token"]}");
        tokenlist.add("\""+values["device_token"]+"\"");

        //sendFCMPush(tokenlist);
      });

      if(posttype==null){
        fcmTitle = MemoryManagement.getuserName();
        fcmBody = messageText;
        sendnotification().sendFcm(fcmTitle, fcmBody, tokenlist);
      }
      else if(posttype=="1"){
        fcmTitle = MemoryManagement.getuserName();
        fcmBody = "Image posted";
        sendnotification().sendFcm(fcmTitle, fcmBody, tokenlist);
      }
      else if(posttype=="2"){
        fcmTitle = MemoryManagement.getuserName();
        fcmBody = "Video posted";
        sendnotification().sendFcm(fcmTitle, fcmBody, tokenlist);
      }
      print("ChatTokennn:${tokenlist}");
      final receiverFcmToken = "d2i5CEClStyB8Lh1q3hc-s:APA91bGMYLqV-bTLBpvrCRHUR_pfwkz3pyTN0-zH1f5VCsirJIXwTjQravs15-uX9Mz7I-IMAJoUjnDdREhWmLLwH5Afg72SR3c7enNsWe4U1EhGnN2kZux409CFRFFNJ_GP6Jl6wIa2";


    });


  }
  /* static Future<List<Chattokens>> getTokens() async {
    Query needsSnapshot = await FirebaseDatabase.instance
        .reference()
        .child("needs-posts")
        .orderByKey();

    print(needsSnapshot); // to debug and see if data is returned

    List<Chattokens> tokenlist;

    Map<dynamic, dynamic> values = needsSnapshot.data.value;
    values.forEach((key, values) {
      tokenlist.add(Chattokens.fromSnapshot(values));
    });

    return tokenlist;
  }*/


  getProfileImage(String userImage) {
    if(userImage != null && userImage.isNotEmpty){
      if (userImage.contains("https") || userImage.contains("http")){
        return NetworkImage(userImage);
      }else{
        return NetworkImage(APIs.userprofilebaseurl +userImage);
      }
    }else{
      return NetworkImage(
          "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80");
    }
  }

  getProfileImageeapi(String userImage) {
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

  void getdevicetoken() async {
    await _firebaseMessaging.getToken().then((value) {
      devicetoken = value;
      //displaytoast("devicetokenn $devicetoken", context);
    });
  }
}