import 'dart:typed_data';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/video_player/videoplayer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../UniversalFunctions.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
var currentUserEmail;

class ChatMessageListItem extends StatelessWidget {
  final DataSnapshot messageSnapshot;
  final Animation animation;

  ChatMessageListItem({this.messageSnapshot, this.animation});

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor:
      new CurvedAnimation(parent: animation, curve: Curves.decelerate),
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          children: MemoryManagement.getuserId() == messageSnapshot.value['id'] ? getSentMessageLayout(context) : getReceivedMessageLayout(context),
        ),
      ),
    );
  }

  List<Widget> getSentMessageLayout(BuildContext context) {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Visibility(
                visible: messageSnapshot.value['posttype']!=null? messageSnapshot.value['imageUrl']!=null? messageSnapshot.value['imageUrl'].toString().trim().length>0?true:false:false:false,
                child: messageSnapshot.value['posttype']!=null?messageSnapshot.value['posttype'].compareTo("1")==0?Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    width: 150,
                    height: 150,
                    child: Stack(
                      children: <Widget>[
                        getCachedNetworkImage(
                            url:  messageSnapshot.value['imageUrl']!=null? messageSnapshot.value['imageUrl'].toString().trim().length>0?messageSnapshot.value['imageUrl']:"":"",
                            fit: BoxFit.cover),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 5,bottom: 5),
                            child: Text(getFormattedDateTime(messageSnapshot.value['createdAt']!=null?messageSnapshot.value['createdAt']:""),textAlign: TextAlign.left,style: TextStyle(fontSize: 12,color: Colors.white),),
                          ),
                        )
                      ],
                    )):Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    width: 150,
                    height: 150,
                    child: Stack(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            SpinKitCircle(
                              itemBuilder: (BuildContext context, int index) {
                                return DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                            FutureBuilder(
                                future:
                                getThumbnail( messageSnapshot.value['imageUrl']!=null? messageSnapshot.value['imageUrl'].toString().trim().length>0?messageSnapshot.value['imageUrl']:"":""),
                                builder: (BuildContext context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.done) {
                                    return GestureDetector(
                                      onTap: (){
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => VideoPlayerScreen(messageSnapshot.value['imageUrl'],false)));
                                      },
                                      child: Stack(
                                        children: <Widget>[
                                          Container(height: 150, width: 150,
                                              child: Stack(
                                                children: <Widget>[
                                                  Positioned.fill(
                                                    child: Image.memory(
                                                      snapshot.data,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                ],
                                              )
                                          ),
                                          Center(
                                            child:Icon(Icons.play_arrow,color: Colors.white,size: 60,),
                                          )
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                }),

                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 5,bottom: 5),
                            child: Text(getFormattedDateTime(messageSnapshot.value['createdAt']!=null?messageSnapshot.value['createdAt']:""),textAlign: TextAlign.left,style: TextStyle(fontSize: 12,color: Colors.white),),
                          ),
                        )
                      ],
                    )):Container()
            ),
            Visibility(
              visible: messageSnapshot.value['text']!=null? messageSnapshot.value['text'].toString().trim().length>0?true:false:false,
              child:Container(
              margin: EdgeInsets.only(left: 50),
              child:  Bubble(
                margin: BubbleEdges.only(top: 10),
                nip: BubbleNip.rightTop,
                color: Color.fromRGBO(225, 255, 199, 1.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(messageSnapshot.value['text'], textAlign: TextAlign.left),
                SizedBox(height: 10,),
                    Text(getFormattedDateTime(messageSnapshot.value['createdAt']!=null?messageSnapshot.value['createdAt']:""),textAlign: TextAlign.left,style: TextStyle(fontSize: 12,color: Colors.grey[600]),),

                  ],
                ),
              ),
            ),)
          ],
        ),
      ),
      // new Column(
      //   children: <Widget>[
      //     new Container(
      //         margin: const EdgeInsets.only(left: 8.0),
      //         child: new CircleAvatar(
      //           backgroundImage: new NetworkImage(messageSnapshot.value['senderPhotoUrl']),
      //         )),
      //   ],
      // ),
    ];
  }

  List<Widget> getReceivedMessageLayout(BuildContext context) {
    return <Widget>[
      new Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          // new Container(
          //     margin: const EdgeInsets.only(left: 8.0),
          //     child: new CircleAvatar(
          //       backgroundImage:
          //       new NetworkImage(messageSnapshot.value['senderPhotoUrl']),
          //     )),
        ],
      ),
          Expanded(child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Visibility(
                  visible: messageSnapshot.value['posttype']!=null?messageSnapshot.value['imageUrl']!=null?
                  messageSnapshot.value['imageUrl'].toString().trim().length>0?true:false:false:false,
                  child: messageSnapshot.value['posttype']!=null? messageSnapshot.value['posttype'].compareTo("1")==0?Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      width: 150,
                      height: 150,
                      child: Stack(
                        children: <Widget>[
                          getCachedNetworkImage(
                              url:  messageSnapshot.value['imageUrl']!=null? messageSnapshot.value['imageUrl'].toString().trim().length>0?messageSnapshot.value['imageUrl']:"":"",
                              fit: BoxFit.cover),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 5,bottom: 5),
                              child: Text(getFormattedDateTime(messageSnapshot.value['createdAt']!=null?messageSnapshot.value['createdAt']:""),textAlign: TextAlign.left,style: TextStyle(fontSize: 12,color: Colors.white),),
                            ),
                          )
                        ],
                      )):Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      width: 150,
                      height: 150,
                      child: Stack(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              SpinKitCircle(
                                itemBuilder: (BuildContext context, int index) {
                                  return DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                              FutureBuilder(
                                  future:
                                  getThumbnail( messageSnapshot.value['imageUrl']!=null? messageSnapshot.value['imageUrl'].toString().trim().length>0?messageSnapshot.value['imageUrl']:"":""),
                                  builder: (BuildContext context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.done) {
                                      return GestureDetector(
                                        onTap: (){
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context) => VideoPlayerScreen(messageSnapshot.value['imageUrl'],false)));
                                        },
                                        child: Stack(
                                          children: <Widget>[
                                            Container(height: 150, width: 150,
                                                child: Stack(
                                                  children: <Widget>[
                                                    Positioned.fill(
                                                      child: Image.memory(
                                                        snapshot.data,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                  ],
                                                )
                                            ),
                                            Center(
                                              child:Icon(Icons.play_arrow,color: Colors.white,size: 60,),
                                            )
                                          ],
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  }),

                            ],
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 5,bottom: 5),
                              child: Text(getFormattedDateTime(messageSnapshot.value['createdAt']!=null?messageSnapshot.value['createdAt']:""),textAlign: TextAlign.left,style: TextStyle(fontSize: 12,color: Colors.white),),
                            ),
                          )
                        ],
                      )):Container()
              ),
            Visibility(
              visible: messageSnapshot.value['text']!=null? messageSnapshot.value['text'].toString().trim().length>0?true:false:false,
              child:  Container(
              margin: EdgeInsets.only(right: 50),
              child:  Bubble(
                margin: BubbleEdges.only(top: 10),
                nip: BubbleNip.leftBottom,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(messageSnapshot.value['text'],style: TextStyle(fontSize: 14),),
                    SizedBox(height: 10,),
                     Text(getFormattedDateTime(messageSnapshot.value['createdAt']!=null?messageSnapshot.value['createdAt']:""),textAlign: TextAlign.left,style: TextStyle(fontSize: 12,color: Colors.grey[600]),),
                  ],
                ),
              ),
            ),)
            ],
          )),

    ];
  }
  String getFormattedDateTime(String datetime){
  try{
    var datetimes = DateFormat('yyyy-MM-dd kk:mm:ss').format(DateTime.parse(datetime));
    var dateTime = DateFormat("yyyy-MM-dd kk:mm:ss").parse(datetimes, false);
    var startdate = DateFormat("dd/MM/yyyy").format(dateTime);
    return startdate;
  }catch(e){
    return "";
  }
  }

  Future<Uint8List> getThumbnail(String url) async {
    print("urllink=>$url");
    return await VideoThumbnail.thumbnailData(
      video: url,
      imageFormat: ImageFormat.PNG,
      maxWidth: 300,
      maxHeight: 300,
      // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 90,
    );
  }
}
