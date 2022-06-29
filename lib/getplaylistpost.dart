
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trybelocker/model/createplaylist/createplaylistparams.dart';
import 'package:trybelocker/model/createplaylist/createplaylistresponse.dart';
import 'package:trybelocker/model/fullpostdetail/full_detail_post_response.dart';
import 'package:trybelocker/model/getplaylist/getplaylistparams.dart';
import 'package:trybelocker/model/getplaylist/getplaylistresponse.dart';
import 'package:trybelocker/model/getpostofplaylist/getpostplaylistparams.dart';
import 'package:trybelocker/model/getpostofplaylist/getpostplaylistresponse.dart';
import 'package:trybelocker/model/likepost/likepostparams.dart';
import 'package:trybelocker/model/savetrybelist/savetrybelistparams.dart';
import 'package:trybelocker/model/savetrybelist/savetrybelistresponse.dart';
import 'package:trybelocker/service/MyService.dart';
import 'package:trybelocker/service/service_locator.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/video_player/videoplayer.dart';
import 'package:trybelocker/viewmodel/get_playlist_viewmodel.dart';
import 'package:trybelocker/viewmodel/home_view_model.dart';
import 'package:provider/src/provider.dart';

import 'UniversalFunctions.dart';
import 'comments.dart';
import 'model/favouritecollectios/collection_list_params.dart';
import 'model/favouritecollectios/collection_list_response.dart';
import 'model/favouritecollectios/create_collection_params.dart';
import 'model/favouritecollectios/create_collectionresponse.dart';
import 'model/likepost/likepostresponse.dart';
import 'model/reportpost/reportpost_params.dart';
import 'model/reportpost/reportpost_response.dart';
import 'model/savecollectionpost/collection_post_reponse.dart';
import 'model/savecollectionpost/get_post_collection_params.dart';
import 'model/savecollectionpost/unsave_collection_post_response.dart';
import 'networkmodel/APIs.dart';
import 'package:share/share.dart';
import 'package:trybelocker/model/favouritecollectios/collection_list_response.dart';
import 'package:trybelocker/model/savecollectionpost/save_post_collection_params.dart';
import 'package:trybelocker/model/savecollectionpost/savepostcollectionresponse.dart';
import 'package:trybelocker/UniversalFunctions.dart';
class GetPlaylistPost extends StatefulWidget{
  int playlistid;
  GetPlaylistPost(this.playlistid);

  GetPlaylistPostState createState()=>GetPlaylistPostState(playlistid);
}

class GetPlaylistPostState extends State<GetPlaylistPost>{
  int playlistid;
  int currentpage=1;
  int limit =15;
  List<Data> dataplaylist=[];
  GetPlaylistPostState(this.playlistid);
  bool isPlaylistLoading=false;
  bool allPlaylistLoaded=false;
  GetPlayListViewModel _getPlayListViewModel;
  List<CollectionData> collectiondatalist=[];
  bool isLikedLoading=false;
  bool isPlaylistPostLoaded=false;
  List<PlaylistData> playlistdata = [];
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300),(){
      getplaylistpost(true);
    });
  }
  getplaylistpost(bool isClear) async {
    _getPlayListViewModel.setLoading();
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _getPlayListViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Getpostplaylistparams params= Getpostplaylistparams(playlistId: playlistid.toString(),page: currentpage.toString(),limit: limit.toString(),uid: MemoryManagement.getuserId());
      var response = await _getPlayListViewModel.getpostplaylist(params, context);
      isPlaylistPostLoaded=true;
      Getpostplaylistresponse getpostplaylistresponse = response;
      if(isClear==true){
        dataplaylist.clear();
      }
      if (getpostplaylistresponse.status.compareTo("success") == 0) {
        if(getpostplaylistresponse.postData!=null&&getpostplaylistresponse.postData.data!=null&&getpostplaylistresponse.postData.data.length>0){
          if(getpostplaylistresponse.postData.data.length<limit){
            setState(() {
              isPlaylistLoading=false;
              allPlaylistLoaded=true;
            });
            dataplaylist.addAll(getpostplaylistresponse.postData.data);
          }else{
            setState(() {
              isPlaylistLoading=false;
              allPlaylistLoaded=false;
            });
            dataplaylist.addAll(getpostplaylistresponse.postData.data);
          }
        }else{
          if(dataplaylist.length<0){
            displaytoast("No data found",context);
          }
          setState(() {
            isPlaylistLoading=false;
            allPlaylistLoaded=true;
          });
        }
      } else {
        if(dataplaylist.length<0){
          displaytoast("No data found",context);
        }
        setState(() {
          isPlaylistLoading=false;
          allPlaylistLoaded=true;
        });
      }

    }
  }
  @override
  Widget build(BuildContext context) {
    _getPlayListViewModel= Provider.of<GetPlayListViewModel>(context);
    return  Scaffold(
      backgroundColor: getColorFromHex(AppColors.black),
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: getColorFromHex(AppColors.black),
        title: Text('Playlist Post Details',style: TextStyle(fontSize: 16,color: Colors.white),),
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Stack(
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scroll) {
                      if (isPlaylistLoading == false && allPlaylistLoaded == false &&
                          scroll.metrics.pixels == scroll.metrics.maxScrollExtent) {
                        setState(() {
                          // _profile_getPlayListViewModel.setLoading();
                          isPlaylistLoading = true;
                          allPlaylistLoaded=true;
                          ++currentpage;
                          getplaylistpost(false);
                        });
                      }
                      return;
                    },
                    child: ListView.builder(
                        itemCount: dataplaylist.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Column(children: <Widget>[
                                    SizedBox(height: 10,),
                                    Container(margin: EdgeInsets.only(left: 7),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            InkWell(
                                              onTap: () {},
                                              child: new Container(
                                                width: 30,
                                                height: 30,
                                                margin: EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: new DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: getUserImage(dataplaylist[index].postData!=null?dataplaylist[index].postData.userInfo!=null
                                                            ?dataplaylist[index].postData.userInfo.userImage!=null?dataplaylist[index].postData.userInfo.userImage:"":"":""))),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              dataplaylist[index].postData.userInfo.username != null ? dataplaylist[index].postData.userInfo.username.isNotEmpty
                                                  ? dataplaylist[index].postData
                                                  .userInfo
                                                  .username
                                                  : "Test"
                                                  : "Test",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 12, color: Colors.white),
                                            ),
                                            new Spacer(),
                                            new InkWell(
                                              onTap: () {
                                                setState(() {
                                                  if(dataplaylist[index].postData.isSelected==true){
                                                    dataplaylist[index].postData.setMenuData(false);
                                                  }else{
                                                    dataplaylist[index].postData.setMenuData(true);
                                                  }
                                                });
                                              },
                                              child: Icon(
                                                Icons.more_vert,
                                                color: Colors.white,
                                              ),
                                            )
                                          ],
                                        )),
                                    Visibility(
                                        visible: dataplaylist[index].postData.postType == 1
                                            ? false
                                            : true,
                                        child: Container(
                                          margin: EdgeInsets.only(top: 10),
                                          width: MediaQuery.of(context).size.width,
                                          height: 400,
                                          child: VideoPlayerScreen(APIs.userpostvideosbaseurl +dataplaylist[index].postData.postMediaUrl,false),
                                        )),
                                    Visibility(
                                        visible: dataplaylist[index].postData.postType == 1
                                            ? true
                                            : false,
                                        child: Container(
                                            margin: EdgeInsets.only(top: 10),
                                            width: MediaQuery.of(context).size.width,
                                            height: 400,
                                            child: Stack(
                                              children: [
                                                getCachedNetworkImage(
                                                    url: APIs.userpostimagesbaseurl +
                                                        dataplaylist[index]
                                                            .postData.postMediaUrl,
                                                    fit: BoxFit.cover),
                                                Container(
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width,
                                                  height: 400,
                                                  color: Colors.white.withOpacity(0.4),
                                                ),
                                                getCachedNetworkImage(
                                                    url: APIs.userpostimagesbaseurl +
                                                        dataplaylist[index].postData.postMediaUrl,
                                                    fit: BoxFit.contain)
                                              ],
                                            ))),
                                    Container(
                                        margin: EdgeInsets.only(left: 10, right: 10,top: 10),
                                        child: Row(
                                          children: <Widget>[
                                            Visibility(
                                                visible:dataplaylist[index].postData.isliked !=
                                                    null
                                                    ? dataplaylist[index].postData.isliked ==
                                                    true
                                                    ? false
                                                    : true
                                                    : true,
                                                child: Container(
                                                  // margin: EdgeInsets.only(bottom: 0, right: 10),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Align(
                                                          alignment: Alignment.topLeft,
                                                          child: InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  if(isLikedLoading==false){
                                                                    dataplaylist[index].postData.isliked = true;
                                                                    dataplaylist[index].postData.likes = dataplaylist[index].postData.likes + 1;
                                                                    isLikedLoading=true;
                                                                    postlike(dataplaylist[index].postData,index);
                                                                  }
                                                                });
                                                              },
                                                              child: Icon(
                                                                Icons.favorite_border,
                                                                color: Colors.white,
                                                                size: 26,
                                                              )),
                                                        ),
                                                        SizedBox(
                                                          width: 2,
                                                        ),
                                                        Text(
                                                          dataplaylist[index].postData.likes.toString() + " likes",
                                                          style: TextStyle(
                                                              color: Colors.white),
                                                        ),
                                                      ],
                                                    ))),
                                            // Spacer(),
                                            Visibility(
                                                visible:  dataplaylist[index].postData.isliked !=
                                                    null
                                                    ?  dataplaylist[index].postData.isliked ==
                                                    true
                                                    ? true
                                                    : false
                                                    : false,
                                                child: Row(
                                                  children: <Widget>[
                                                    InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            if(isLikedLoading==false){
                                                              isLikedLoading=true;
                                                              dataplaylist[index].postData.isliked = false;
                                                              dataplaylist[index].postData.likes =  dataplaylist[index].postData.likes - 1;
                                                              postdislike( dataplaylist[index].postData);
                                                            }

                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.favorite,
                                                          color: getColorFromHex(
                                                              AppColors.red),
                                                          size: 26,
                                                        )),
                                                    SizedBox(
                                                      width: 2,
                                                    ),
                                                    Text(
                                                      dataplaylist[index].postData.likes.toString() + " likes",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                )),
                                            Spacer(),
                                            Row(
                                              children: <Widget>[
                                                GestureDetector(
                                                    child: Icon(
                                                      Icons.message,
                                                      color: Colors.white,
                                                    ),
                                                    onTap: () {
                                                      Navigator.of(context,
                                                          rootNavigator: true)
                                                          .push(MaterialPageRoute(
                                                          builder: (context) =>
                                                              CommentScreen( dataplaylist[index].postData.id))).then((value) {
                                                        setState(() {
                                                          print("value== $value");
                                                          dataplaylist[index].postData.comment = value;
                                                        });
                                                      });
                                                    }),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text( dataplaylist[index].postData.comment.toString(), style:
                                                TextStyle(color: Colors.white))
                                              ],
                                            )
                                          ],
                                        )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Container(
                                            margin: EdgeInsets.only(
                                                left: 20 /*,bottom: 20*/),
                                            width:
                                            MediaQuery.of(context).size.width - 64,
                                            child: Text(
                                              dataplaylist[index].postData.postCaption != null
                                                  ?  dataplaylist[index].postData
                                                  .postCaption
                                                  .trim()
                                                  .length >
                                                  0
                                                  ?  dataplaylist[index].postData
                                                  .postCaption
                                                  : ""
                                                  : "",
                                              // maxLines: 3,
                                              textAlign: TextAlign.left,
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  fontStyle: FontStyle.italic),
                                            )),
                                      ],
                                    ),
                                    Visibility(
                                        visible: index==dataplaylist.length-1?true:false ,
                                        child:Container(height: 100,))
                                  ],
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Visibility(
                                      visible:  dataplaylist[index].postData.isSelected != null
                                          ?  dataplaylist[index].postData.isSelected
                                          : false,
                                      // visible: false,
                                      child: Container(
                                        color: getColorFromHex(AppColors.black),
                                        margin: EdgeInsets.only(top: 60, right: 5),
                                        height: 180,
                                        width: 200,
                                        child: Column(
                                          children: <Widget>[
                                            Stack(
                                              children: <Widget>[
                                                Visibility(
                                                    visible: dataplaylist[index].postData.isSaved==false?true:false,
                                                    child:  GestureDetector(
                                                      onTap: (){
                                                        setState(() {
                                                          dataplaylist[index].postData.setMenuData(false);
                                                        });
                                                        getCollectionList( dataplaylist[index].postData.id,index);
                                                      },
                                                      child: Align(
                                                        alignment: Alignment.topLeft,
                                                        child: Container(
                                                          width: 200,
                                                          padding: EdgeInsets.all(10),
                                                          child: Text(
                                                            'Save to Favorites Folder',
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                                fontStyle: FontStyle.italic,
                                                                fontSize: 14,
                                                                color: Colors.white),
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                                Visibility(
                                                    visible: dataplaylist[index].postData.isSaved==false?false:true,
                                                    child:  GestureDetector(
                                                      onTap: (){
                                                        setState(() {
                                                          dataplaylist[index].postData.setMenuData(false);
                                                        });
                                                        unsavefromcollection( dataplaylist[index].postData.id, dataplaylist[index].postData.collectionId,index);
                                                      },
                                                      child: Align(
                                                        alignment: Alignment.topLeft,
                                                        child: Container(
                                                          width: 200,
                                                          padding: EdgeInsets.all(10),
                                                          child: Text(
                                                            'Unsave from Favorites Folder',
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                                fontStyle: FontStyle.italic,
                                                                fontSize: 14,
                                                                color: Colors.white),
                                                          ),
                                                        ),
                                                      ),
                                                    ))
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  dataplaylist[index].postData.setMenuData(false);
                                                });
                                                MyService service = locator<MyService>();
                                                if( dataplaylist[index].postData.postType==1){
                                                  service.startdownload(APIs.userpostimagesbaseurl+ dataplaylist[index].postData.postMediaUrl,dataplaylist[index].postData.postType.toString());
                                                }else{
                                                  service.startdownload(APIs.userpostvideosbaseurl+ dataplaylist[index].postData.postMediaUrl,dataplaylist[index].postData.postType.toString());
                                                }
                                              },
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Container(
                                                  width: 200,
                                                  padding: EdgeInsets.all(10),
                                                  child: Text(
                                                    'Download',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontStyle: FontStyle.italic,
                                                        fontSize: 14,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  dataplaylist[index].postData.setMenuData(false);
                                                });
                                                if ( dataplaylist[index].postData.postMediaUrl !=
                                                    null &&
                                                    dataplaylist[index].postData
                                                        .postMediaUrl
                                                        .trim()
                                                        .length >
                                                        0) {
                                                  Share.share(APIs.userpostimagesbaseurl +
                                                      dataplaylist[index].postData.postMediaUrl);
                                                }
                                              },
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  width: 200,
                                                  child: Text(
                                                    'Share',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontStyle: FontStyle.italic,
                                                        fontSize: 14,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    dataplaylist[index].postData.setMenuData(false);
                                                  });
                                                  postreport( dataplaylist[index].postData);
                                                },
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Container(
                                                    padding: EdgeInsets.all(10),
                                                    width: 200,
                                                    child: Text(
                                                      'Report',
                                                      textAlign: TextAlign.start,
                                                      style: TextStyle(
                                                          fontStyle: FontStyle.italic,
                                                          fontSize: 14,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                )),
                                            Visibility(
                                                visible : dataplaylist[index].postData.isPlaylistSaved == false ? true : false,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    for (int k = 0; k < dataplaylist.length; k++) {
                                                      dataplaylist[k].postData.setMenuData(false);
                                                    }
                                                    getTrybeList(dataplaylist[index].postId, index);
                                                  },
                                                  child: Align(
                                                    alignment: Alignment.topLeft,
                                                    child: Container(
                                                      width: 200,
                                                      padding: EdgeInsets.all(10),
                                                      child: Text(
                                                        'Save to TrybeList Folder',
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(
                                                            fontStyle:
                                                            FontStyle.italic,
                                                            fontSize: 14,
                                                            color: Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                            Visibility(
                                                visible : dataplaylist[index].postData.isPlaylistSaved == false ? false : true,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    for (int k = 0;
                                                    k < dataplaylist.length;
                                                    k++) {
                                                      dataplaylist[k].postData.setMenuData(false);
                                                    }
                                                    unsavefromplaylist(dataplaylist[index].postId, dataplaylist[index].playlistId, index);
                                                  },
                                                  child: Align(
                                                    alignment: Alignment.topLeft,
                                                    child: Container(
                                                      width: 200,
                                                      padding: EdgeInsets.all(10),
                                                      child: Text(
                                                        'Unsave from TrybeList Folder',
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(
                                                            fontStyle:
                                                            FontStyle.italic,
                                                            fontSize: 14,
                                                            color: Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          );
                        }))),
            getFullScreenProviderLoader(status: _getPlayListViewModel.getLoading(), context: context),
            Visibility(
                visible: isPlaylistPostLoaded==true?dataplaylist.length==0?true:false:false,
                child:Container(
                  height: MediaQuery.of(context).size.height-100,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text("No Post Found",style: TextStyle(fontSize: 20,color: Colors.white),),
                  ),
                ))
          ],
        ),

      ),
    );
  }

  void unsavefromplaylist(int postid, int playlistId, int index) async {
    _getPlayListViewModel.setLoading();
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _getPlayListViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Savetrybelistparams request = new Savetrybelistparams(key: "2",playlistId :playlistId.toString() ,postId: postid.toString());
      var response = await _getPlayListViewModel.savepostplaylist(request, context);
      Savetrybelistresponse savetrybelistresponse = response;
      if (savetrybelistresponse.status.compareTo("success") == 0) {
        if(savetrybelistresponse.message!=null&&savetrybelistresponse.message.trim().length>0){
          displaytoast(savetrybelistresponse.message, context);
          updateUnsavedTrybeList(false, index, 0);
        }else{
          displaytoast("Post unsaved successfully", context);
          updateUnsavedTrybeList(false, index, 0);
        }
      } else {
        displaytoast("Error occurred while getting the playlist", context);
      }
    }
  }

  void updateUnsavedTrybeList(bool status, int index, int playlistid) {
    setState(() {
      if (dataplaylist[index] != null) {
        if (status == true) {
          dataplaylist[index].playlistId = playlistid;
        } else {
          dataplaylist[index].playlistId = 0;
        }
        dataplaylist[index].postData.isPlaylistSaved = status;
      }
    });
  }

  void getTrybeList(int postid, int index) async {
    _getPlayListViewModel.setLoading();
    bool gotInternetConnection = await hasInternetConnection(context: context, mounted: mounted, canShowAlert: true,
      onFail: () {
        _getPlayListViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Getplaylistparams request = new Getplaylistparams(uid: MemoryManagement.getuserId(),other_uid: MemoryManagement.getuserId());
      var response = await _getPlayListViewModel.getplaylist(request, context);
      Getplaylistresponse getplaylistresponse = response;
      if (getplaylistresponse.status.compareTo("success") == 0) {
        setState(() {
          playlistdata.clear();
          if (getplaylistresponse.playlistData != null &&
              getplaylistresponse.playlistData.length > 0) {
            playlistdata.addAll(getplaylistresponse.playlistData);
            showPlayListFolders(playlistdata, postid, index);
          } else {
            displaytoast("No playlist found.Please create a playlist", context);
            showTrybeListFolder(postid, index);
          }
        });
      } else {
        displaytoast("Error occurred while getting the playlist", context);
      }
    }
  }

  void showPlayListFolders(List<PlaylistData> playlistdata, int postid, int index) {
    PlaylistData trybelistdata;
    if(playlistdata!=null&&playlistdata.length>0){
      trybelistdata=playlistdata[0];
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
                      padding: EdgeInsets.only(left: 20, top: 20, bottom: 0, right: 20),
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(20),
                              topRight: const Radius.circular(20))),
                      child: Column(
                        children: [
                          Row(children: [
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
                                  _getPlayListViewModel.showCollectionLoaded();
                                });
                                bool gotInternetConnection = await hasInternetConnection(
                                  context: context,
                                  mounted: mounted,
                                  canShowAlert: true,
                                  onFail: () {
                                    _getPlayListViewModel.hideCollectionLoaded();
                                  },
                                  onSuccess: () {},
                                );
                                if (gotInternetConnection) {
                                  Savetrybelistparams request = new Savetrybelistparams(key: "1",playlistId : trybelistdata.id.toString() ,postId: postid.toString());
                                  var response = await _getPlayListViewModel.savepostplaylist(request, context);
                                  Savetrybelistresponse savetrybelistresponse = response;
                                  setState((){
                                    _getPlayListViewModel.hideCollectionLoaded();
                                  });
                                  if (savetrybelistresponse.status.compareTo("success") == 0) {
                                    if(savetrybelistresponse.message!=null&&savetrybelistresponse.message.trim().length>0){
                                      displaytoast(savetrybelistresponse.message, context);
                                      updateUnsavedTrybeList(true, index, trybelistdata.id);
                                      Navigator.pop(context);
                                    }else{
                                      displaytoast("Post saved successfully", context);
                                      updateUnsavedTrybeList(true, index, trybelistdata.id);
                                      Navigator.pop(context);
                                    }
                                  } else {
                                    displaytoast("Error occurred while getting the playlist", context);
                                  }

                                }
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
                              showTrybeListFolder(postid, index);
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
                          playlistdata.length>0?Expanded(
                              child: ListView.builder(
                                  padding: EdgeInsets.only(top: 0, bottom: 10),
                                  itemCount: playlistdata.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (BuildContext context, int index) {
                                    return RadioListTile(value: playlistdata[index],title:Text(playlistdata[index]
                                        .playlistName !=
                                        null
                                        ? playlistdata[index]
                                        .playlistName
                                        : ""), groupValue: trybelistdata,
                                        onChanged: (PlaylistData data){
                                          setState((){
                                            trybelistdata=data;
                                          });
                                        });
                                  })):Container(),
                        ],
                      )),
                ),
                Container(
                  child: getFullScreenProviderLoaders(
                      status: _getPlayListViewModel.getCollectionLoaded(),
                      context: context),
                ),
              ],
            );
          });
        });
  }

  void showTrybeListFolder(int postid, int index) {
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
                                      createFolderApi(foldername, context, postid, index);
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
                          if (foldername != null && foldername.text.trim().length > 0) {
                            Navigator.pop(context);
                            createTrybeListApi(foldername, context, postid, index);
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
                    child: getDialogLoader(status: _getPlayListViewModel.getLoading(), context: context),
                  ),
                ],
              ),
            );
          });
        });
  }

  void createTrybeListApi(TextEditingController foldername, BuildContext context, int postid, int index) async{
    _getPlayListViewModel.setLoading();
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _getPlayListViewModel.hideLoader();
      },
      onSuccess: () {

      },
    );
    if (gotInternetConnection) {
      Createplaylistparams params = new Createplaylistparams(uid: MemoryManagement.getuserId(), playlistName: foldername.text.trim());
      var response = await _getPlayListViewModel.createplaylist(params, context);
      Createplaylistresponse  createplaylistresponse= response;
      if (createplaylistresponse!=null&&createplaylistresponse.status.compareTo("success") == 0) {
        if (createplaylistresponse.playlistData != null &&
            createplaylistresponse.playlistData.length > 0) {
          playlistdata.clear();
          playlistdata.addAll(createplaylistresponse.playlistData);
          showPlayListFolders(createplaylistresponse.playlistData, postid, index);
        }
        displaytoast(createplaylistresponse.message, context);
      } else if(createplaylistresponse!=null&&createplaylistresponse.message!=null&&createplaylistresponse.message.trim().length>0){
        displaytoast(createplaylistresponse.message, context);
      }
    }
  }

  void postlike(FullPostData postdata, int index) async {
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        setState(() {
          isLikedLoading=false;
        });
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Likepostparams request = Likepostparams();
      request.uid = MemoryManagement.getuserId();
      request.key = "1";
      request.postId = dataplaylist[index].postData.id.toString();

      var response = await _getPlayListViewModel.likepost(request, context);

      print(response.toString());

      Likepostresponse likepostresponse = response;
      if (likepostresponse != null) {
        if (likepostresponse.status != null &&
            likepostresponse.status.isNotEmpty) {
          if (likepostresponse.status.compareTo("success") == 0) {
            setState(() {
              isLikedLoading=false;
            });
          } else {
            setState(() {
              if (dataplaylist[index].postData.isliked == true) {
                dataplaylist[index].postData.isliked = true;
                isLikedLoading=false;
              } else {
                dataplaylist[index].postData.isliked = false;
                isLikedLoading=false;
              }
            });
          }
        }else{
          isLikedLoading=false;
        }
      }else{
        isLikedLoading=false;
      }
    }
  }

  void postdislike(FullPostData dataPost) async{
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        setState(() {
          isLikedLoading=false;
        });
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Likepostparams request = Likepostparams();
      request.uid = MemoryManagement.getuserId();
      request.key = "2";
      request.postId = dataPost.id.toString();

      var response = await _getPlayListViewModel.dislikepost(request, context);

      print(response.toString());

      Likepostresponse likepostresponse = response;
      if (likepostresponse != null) {
        if (likepostresponse.status != null &&
            likepostresponse.status.isNotEmpty) {
          if (likepostresponse.status.compareTo("success") == 0) {
            setState(() {
              isLikedLoading=false;
            });
          } else {
            setState(() {
              if (dataPost.isliked == true) {
                dataPost.isliked = true;
              } else {
                dataPost.isliked = false;
              }
              isLikedLoading=false;
            });
          }
        }
      }else{
        setState(() {
          isLikedLoading=false;
        });
      }
    }
  }

  void postreport(FullPostData postData) async{
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {},
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Reportpost_params request = Reportpost_params();
      request.userid = MemoryManagement.getuserId();
      request.postId = postData.id.toString();
      var response = await _getPlayListViewModel.reportpost(request, context);
      print(response.toString());
      Reportpost_response reportpost_response = response;
      if (reportpost_response != null) {
        if (reportpost_response.status != null && reportpost_response.status.isNotEmpty) {
          if (reportpost_response.status.compareTo("success") == 0) {
            displaytoast(reportpost_response.message, context);
          } else {
            displaytoast(reportpost_response.message, context);
          }
        }
      }
    }
  }

  void getCollectionList(int postid,int index) async {
    _getPlayListViewModel.setLoading();
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _getPlayListViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Collection_list_params request= new Collection_list_params(userid: MemoryManagement.getuserId());
      var response = await _getPlayListViewModel.getallcollections(request, context);
      Collection_list_response collectionresponse = response;
      if (collectionresponse.status.compareTo("success") == 0) {
        setState(() {
          collectiondatalist.clear();
          if(collectionresponse.collectionData!=null&&collectionresponse.collectionData.length>0){
            collectiondatalist.addAll(collectionresponse.collectionData);
            showFavouriteList(collectiondatalist,postid,index);
          }else{
            displaytoast("Please create folder in favourite section", context);
          }
        });
      }else {
        displaytoast("Please create folder in favourite section", context);
      }
    }
  }

  void showFavouriteList(List<CollectionData> collectiondatalist, int postid,int index) {
    CollectionData data= collectiondatalist[0];
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
                      padding: EdgeInsets.only(left: 20, top: 20, bottom: 0, right: 20),
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(20),
                              topRight: const Radius.circular(20))),
                      child: Column(
                        children: [
                          Row(children: [Align(
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
                              onTap: () async{
                                setState((){
                                  _getPlayListViewModel.showCollectionLoaded();
                                });
                                bool gotInternetConnection = await hasInternetConnection(
                                  context: context,
                                  mounted: mounted,
                                  canShowAlert: true,
                                  onFail: () {
                                    _getPlayListViewModel.hideCollectionLoaded();
                                  },
                                  onSuccess: () {},
                                );
                                if (gotInternetConnection) {
                                  Save_post_collection_params params = new Save_post_collection_params(key: "1",collectionId: data.id.toString(),postId: postid.toString());
                                  var response = await _getPlayListViewModel.savepostcollection(params, context);
                                  Savepostcollectionresponse savecollectioresponse = response;
                                  setState((){
                                    _getPlayListViewModel.hideCollectionLoaded();
                                  });
                                  if (savecollectioresponse!=null&&savecollectioresponse.status.compareTo("success") == 0) {
                                    updateSavedCollection(true,index,data.id);
                                    displaytoast(savecollectioresponse.message, context);
                                    Navigator.pop(context);

                                  }else if(savecollectioresponse!=null){
                                    displaytoast(savecollectioresponse.message, context);
                                  }
                                }
                              },
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Text(
                                  "Save",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                            )
                          ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.pop(context);
                              showCreateFoler(postid,index);
                            },
                            child: Row(
                              children: <Widget>[
                                SizedBox(width: 25,),
                                Image.asset(
                                  "assets/addwhite.png",
                                  height: 25,
                                  width: 25,
                                  color: getColorFromHex(AppColors.black),
                                ),
                                SizedBox(width: 10,),
                                Text('New Favorites Folder',style: TextStyle(
                                    color: getColorFromHex(AppColors.black),
                                    fontSize: 16
                                ),)
                              ],
                            ),
                          ),
                          SizedBox(height: 10,),
                          Expanded(
                              child: ListView.builder(
                                  padding: EdgeInsets.only(top: 0, bottom: 10),
                                  itemCount:collectiondatalist.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (BuildContext context, int index) {
                                    return RadioListTile(
                                      value: collectiondatalist[index],
                                      title: Text(collectiondatalist[index].collectionName!=null?collectiondatalist[index].collectionName:""),
                                      groupValue: data,
                                      onChanged: (CollectionData collectiondata) {
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
                      status: _getPlayListViewModel.getCollectionLoaded(),
                      context: context),
                ),
              ],
            );
          });
        });
  }

  void showCreateFoler(int postid,int index) {
    TextEditingController foldername=new TextEditingController();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context,setState){
            return Dialog(
              insetPadding: EdgeInsets.all(20),
              child: Stack(
                children: <Widget>[
                  Column(mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(width: 55,),
                          Expanded(
                            child: Container(
                              child: Text(
                                'Create Folder',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18.3),
                              ),
                            ),),
                          IconButton(icon:Icon(Icons.cancel,color: Colors.red,), onPressed: (){
                            Navigator.pop(context);
                          })
                        ],
                      ),
                      SizedBox(height: 10,),
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
                                  onFieldSubmitted: (trem) async{
                                    if(foldername!=null&&foldername.text.trim().length>0){
                                      Navigator.pop(context);
                                      createFolderApi(foldername,context,postid,index);
                                    }else{
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
                        onTap: () async{
                          if(foldername!=null&&foldername.text.trim().length>0){
                            Navigator.pop(context);
                            createFolderApi(foldername,context,postid,index);
                          }else{
                            displaytoast("Folder name required", context);
                          }

                        },
                        child:  Container(
                            height: 40,
                            width: 120,
                            margin: EdgeInsets.only(bottom: 20),
                            decoration:
                            BoxDecoration(color: getColorFromHex('#A10000')),
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
                        status: _getPlayListViewModel.getLoading(),
                        context: context),
                  ),
                ],
              ),
            );
          });

        });
  }


  void createFolderApi(TextEditingController foldername, BuildContext context, int postid,int index) async{
    _getPlayListViewModel.setLoading();
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _getPlayListViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Create_collection_params params= new Create_collection_params(userid:MemoryManagement.getuserId(),collectionName: foldername.text.trim());
      var response = await _getPlayListViewModel.createcollection(params, context);
      Create_collectionresponse collectionresponse = response;
      if (collectionresponse.status.compareTo("success") == 0) {
        if(collectionresponse.collectionData!=null&&collectionresponse.collectionData.length>0){
          showFavouriteList(collectionresponse.collectionData,postid,index);
        }
        displaytoast(collectionresponse.message, context);
      } else {
        displaytoast(collectionresponse.message, context);
      }
    }
  }

  Widget getFullScreenProviderLoaders({
    @required bool status,
    @required BuildContext context,
  }) {
    return status ? getAppThemedLoaders(context: context,) : new Container(height: 350,);
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
      height: 350,
      child: getChildLoader(
        color: color ?? AppColors.kPrimaryBlue,
        strokeWidth: strokeWidth,
      ),
    );
  }

  getUserImage(String userImage) {
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

  void unsavefromcollection(int postid, int collectionId, int index) async{
    _getPlayListViewModel.setLoading();
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _getPlayListViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Save_post_collection_params params = new Save_post_collection_params(key: "2",collectionId:collectionId.toString(),postId: postid.toString());
      var response = await _getPlayListViewModel.unsavepostcollection(params, context);
      Unsave_collection_post_response unsave_collection_post_response = response;
      if (unsave_collection_post_response.status.compareTo("success") == 0) {
        setState(() {
          collectiondatalist.clear();
          if(unsave_collection_post_response!=null&&unsave_collection_post_response.message.length>0){
            displaytoast(unsave_collection_post_response.message, context);
            updateSavedCollection(false,index,collectionId);
          }else{
            displaytoast("Something went wrong", context);
          }
        });
      }else {
        displaytoast("Something went wrong", context);
      }
    }
  }

  void updateSavedCollection(bool status, int index,int collectionId) {
    setState(() {
      if(dataplaylist[index]!=null){
        if(status==true){
          dataplaylist[index].postData.collectionId=collectionId;
        }else{
          dataplaylist[index].postData.collectionId=0;
        }
        dataplaylist[index].postData.isSaved=status;
      }
    });
  }
}