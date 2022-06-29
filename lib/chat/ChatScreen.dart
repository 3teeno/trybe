


import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:io';
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
import 'package:trybelocker/model/getallposts/getallpostresponse.dart';
import 'package:trybelocker/model/search/search_response.dart';
import 'package:trybelocker/networkmodel/APIs.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:bubble/bubble.dart';
import 'package:trybelocker/utils/memory_management.dart';
import '../UniversalFunctions.dart';
import 'package:video_compress/video_compress.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:trybelocker/chat/groupchat/sendnotification.dart';


final googleSignIn = new GoogleSignIn();
final auth = FirebaseAuth.instance;
var currentUserEmail;
var _scaffoldContext;

class ChatScreen extends StatefulWidget {
  DataUser userdata;
  ChatScreen(this.userdata);

  @override
  ChatScreenState createState() {
    return new ChatScreenState(userdata);
  }
}

class ChatScreenState extends State<ChatScreen> {
  DataUser userdata=null;
  ChatScreenState(this.userdata);
  final TextEditingController _textEditingController =
  new TextEditingController();
  var reference;
   String messageId="";
  firebase_storage.FirebaseStorage storage;
  bool isShow=false;
  @override
  void initState() {
    super.initState();
    int currentuserid= int.parse(MemoryManagement.getuserId());
    int otheruserid= userdata.id;
    if(currentuserid<otheruserid){
      messageId=otheruserid.toString()+currentuserid.toString();
      reference = FirebaseDatabase.instance.reference().child('messages').child(messageId);
    }else{
      messageId=currentuserid.toString()+otheruserid.toString();
      reference = FirebaseDatabase.instance.reference().child('messages').child(messageId);
    }

    storage = firebase_storage.FirebaseStorage.instanceFor();

  }

  @override
  Widget build(BuildContext context) {
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
                        image:  getProfileImage(userdata.userImage))),
              ),
              SizedBox(width: 15,),
              Text(userdata.username!=null?userdata.username:"",style: TextStyle(color: Colors.white,fontSize: 14),)
            ],),
          ),),
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
                        return new ChatMessageListItem(messageSnapshot: messageSnapshot, animation: animation,);
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
    String token="";
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


    var db = FirebaseDatabase.instance.reference().child('devicetokens');
    db.once().then((DataSnapshot snapshot){
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key,values) {
        if(values["username"] == userdata.username) {
          print("ChatTokejkkn:${values["token"]}");
          token = values["token"];
          // displaytoast("devicetokenn $token", context);
          if(posttype==null){
            fcmTitle = MemoryManagement.getuserName();
            fcmBody = messageText;
            sendnotification().sendFcmIndividual(fcmTitle, fcmBody, token);
          }
          else if(posttype=="1"){
            fcmTitle = MemoryManagement.getuserName();
            fcmBody = "Image posted";
            sendnotification().sendFcmIndividual(fcmTitle, fcmBody, token);
          }
          else if(posttype=="2"){
            fcmTitle = MemoryManagement.getuserName();
            fcmBody = "Video posted";
            sendnotification().sendFcmIndividual(fcmTitle, fcmBody, token);
          }
        }
        //sendFCMPush(tokenlist);
      });
    });


  }

  Future<Null> _ensureLoggedIn() async {
    GoogleSignInAccount signedInUser = googleSignIn.currentUser;
    if (signedInUser == null)
      signedInUser = await googleSignIn.signInSilently();
    if (signedInUser == null) {
      await googleSignIn.signIn();

    }

    currentUserEmail = googleSignIn.currentUser.email;

    if (await auth.currentUser == null) {
      final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(accessToken: googleSignInAuthentication.accessToken, idToken: googleSignInAuthentication.idToken,);
      final UserCredential authResult = await auth.signInWithCredential(credential);
    }
  }

  Future _signOut() async {
    await auth.signOut();
    googleSignIn.signOut();
    Scaffold
        .of(_scaffoldContext)
        .showSnackBar(new SnackBar(content: new Text('User logged out')));
  }

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
}