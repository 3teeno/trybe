
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trybelocker/UniversalFunctions.dart';
import 'package:trybelocker/comments.dart';
import 'package:trybelocker/model/search/search_post_response.dart';
import 'package:trybelocker/service/MyService.dart';
import 'package:trybelocker/service/service_locator.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/video_player/videoplayer.dart';
import 'package:trybelocker/viewmodel/home_view_model.dart';
import 'package:provider/src/provider.dart';
import 'package:trybelocker/viewmodel/post_details_view_model.dart';
import 'model/createplaylist/createplaylistparams.dart';
import 'model/createplaylist/createplaylistresponse.dart';
import 'model/favouritecollectios/collection_list_params.dart';
import 'model/favouritecollectios/collection_list_response.dart';
import 'model/favouritecollectios/create_collection_params.dart';
import 'model/favouritecollectios/create_collectionresponse.dart';
import 'model/fullpostdetail/full_detail_post_params.dart';
import 'model/fullpostdetail/full_detail_post_response.dart';
import 'model/getplaylist/getplaylistparams.dart';
import 'model/getplaylist/getplaylistresponse.dart';
import 'model/likepost/likepostparams.dart';
import 'model/likepost/likepostresponse.dart';
import 'model/reportpost/reportpost_params.dart';
import 'model/reportpost/reportpost_response.dart';
import 'model/savecollectionpost/save_post_collection_params.dart';
import 'model/savecollectionpost/savepostcollectionresponse.dart';
import 'model/savecollectionpost/unsave_collection_post_response.dart';
import 'model/savetrybelist/savetrybelistparams.dart';
import 'model/savetrybelist/savetrybelistresponse.dart';
import 'networkmodel/APIs.dart';
import 'package:share/share.dart';

class PostScreen extends StatefulWidget{
  DataPost dataPost;
  PostScreen(this.dataPost);
  PostScreenState createState()=>PostScreenState(dataPost);
}
class PostScreenState extends State<PostScreen>{
  DataPost dataPost;
  PostScreenState(this.dataPost);
  PostDetailsViewModel _postDetailsViewModel;
  Full_detail_post_response fulldetailresponse;
  List<CollectionData> collectiondatalist=[];
  List<PlaylistData> playlistdata = [];
  bool isLikedLoading=false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500),(){
      getPostDetails();
    });
  }
  void getPostDetails() async{
    _postDetailsViewModel.setLoading();

    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _postDetailsViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Full_detail_post_params params= Full_detail_post_params(uid: MemoryManagement.getuserId(),postId:dataPost.id.toString());
      var response = await _postDetailsViewModel.getfullpostdetails(params, context);
       fulldetailresponse = response;
      if (fulldetailresponse.status.compareTo("success") == 0) {
       setState(() {});
      } else {
        displaytoast("Something went wrong", context);
      }

    }

  }

  @override
  Widget build(BuildContext context) {
    _postDetailsViewModel = Provider.of<PostDetailsViewModel>(context);
    return Scaffold(
      backgroundColor: getColorFromHex(AppColors.black),
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: getColorFromHex(AppColors.black),
        title: Text('Post Details',style: TextStyle(fontSize:16,color: Colors.white),),
      ),
      body: Stack(
        children: <Widget>[
          Visibility(
              visible: fulldetailresponse!=null?fulldetailresponse.postData!=null?true:false:false,
              child: fulldetailresponse!=null?fulldetailresponse.postData!=null?
              Column(
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
                                            image: getprofilepic())),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  fulldetailresponse.postData.userInfo.username != null ? fulldetailresponse.postData.userInfo.username.isNotEmpty
                                      ? fulldetailresponse.postData
                                      .userInfo
                                      .username
                                      : ""
                                      : "",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                                new Spacer(),
                                new InkWell(
                                  onTap: () {
                                    setState(() {
                                      if(fulldetailresponse.postData.isSelected==true){
                                        fulldetailresponse.postData.setMenuData(false);
                                      }else{
                                        fulldetailresponse.postData.setMenuData(true);
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
                            visible: fulldetailresponse.postData.postType == 1
                                ? false
                                : true,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 400,
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: VideoPlayerScreen(APIs.userpostvideosbaseurl +fulldetailresponse.postData.postMediaUrl,false),
                            )),
                        Visibility(
                            visible: fulldetailresponse.postData.postType == 1
                                ? true
                                : false,
                            child: Container(
                                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                width: MediaQuery.of(context).size.width,
                                height: 400,
                                child:  Stack(
                                  children: [
                                    getCachedNetworkImage(
                                        url: APIs.userpostimagesbaseurl +
                                            fulldetailresponse
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
                                            fulldetailresponse.postData.postMediaUrl,
                                        fit: BoxFit.contain)
                                  ],
                                ))),
                        Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              children: <Widget>[
                                Visibility(
                                    visible:fulldetailresponse.postData
                                        .isliked !=
                                        null
                                        ? fulldetailresponse.postData.isliked ==
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
                                                        fulldetailresponse.postData.isliked = true;
                                                        fulldetailresponse.postData.likes = fulldetailresponse.postData.likes + 1;
                                                        isLikedLoading=true;
                                                        postlike(fulldetailresponse.postData);
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
                                              fulldetailresponse.postData.likes.toString() + " likes",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ))),
                                // Spacer(),
                                Visibility(
                                    visible: fulldetailresponse.postData
                                        .isliked !=
                                        null
                                        ? fulldetailresponse.postData.isliked ==
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
                                                   fulldetailresponse.postData.isliked = false;
                                                   fulldetailresponse.postData.likes = fulldetailresponse.postData.likes - 1;
                                                   postdislike(fulldetailresponse.postData);
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
                                          fulldetailresponse.postData.likes.toString() + " likes",
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
                                                  CommentScreen(fulldetailresponse.postData.id))).then((value) {
                                             setState(() {
                                               print("value== $value");
                                               fulldetailresponse.postData.comment = value;
                                             });
                                          });
                                        }),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(fulldetailresponse.postData.comment.toString(), style:
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
                                  fulldetailresponse.postData.postCaption != null
                                      ? fulldetailresponse.postData
                                      .postCaption
                                      .trim()
                                      .length >
                                      0
                                      ? fulldetailresponse.postData
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
                        )
                      ],
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Visibility(
                          visible: fulldetailresponse.postData.isSelected != null
                              ? fulldetailresponse.postData.isSelected
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
                                       visible:fulldetailresponse.postData.isSaved==false?true:false,
                                       child:  GestureDetector(
                                         onTap: (){
                                           setState(() {
                                             fulldetailresponse.postData.setMenuData(false);
                                           });
                                           getCollectionList(fulldetailresponse.postData.id);
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
                                       visible:fulldetailresponse.postData.isSaved==false?false:true,
                                       child:  GestureDetector(
                                         onTap: (){
                                           setState(() {
                                             fulldetailresponse.postData.setMenuData(false);
                                           });
                                           unsavefromcollection(fulldetailresponse.postData.id,fulldetailresponse.postData.collectionId);
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
                                      fulldetailresponse.postData.setMenuData(false);
                                    });
                                    MyService service = locator<MyService>();
                                    if(fulldetailresponse.postData.postType==1){
                                      service.startdownload(APIs.userpostimagesbaseurl+fulldetailresponse.postData.postMediaUrl,fulldetailresponse.postData.postType.toString());
                                    }else{
                                      service.startdownload(APIs.userpostvideosbaseurl+fulldetailresponse.postData.postMediaUrl,fulldetailresponse.postData.postType.toString());
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
                                     fulldetailresponse.postData.setMenuData(false);
                                   });
                                    if (fulldetailresponse.postData.postMediaUrl !=
                                        null &&
                                        fulldetailresponse.postData
                                            .postMediaUrl
                                            .trim()
                                            .length >
                                            0) {
                                      Share.share(APIs.userpostimagesbaseurl +
                                          fulldetailresponse.postData.postMediaUrl);
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
                                     fulldetailresponse.postData.setMenuData(false);
                                   });
                                      postreport(fulldetailresponse.postData);
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
                                    visible:true,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          fulldetailresponse.postData.setMenuData(false);
                                        });
                                        getTrybeList(fulldetailresponse.postData.id);
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
                                    visible:false,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          fulldetailresponse.postData.setMenuData(false);
                                        });
                                        unsavefromplaylist(fulldetailresponse.postData.id,fulldetailresponse.postData.playlistId);
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
              ):Container():Container(),),
          getFullScreenProviderLoader(status: _postDetailsViewModel.getLoading(), context: context)
        ],
      )
    );
  }

  getprofilepic() {
    if (fulldetailresponse.postData.userInfo.userImage != null && fulldetailresponse.postData.userInfo.userImage.isNotEmpty) {
      if (fulldetailresponse.postData.userInfo.userImage.contains("https") || fulldetailresponse.postData.userInfo.userImage.contains("http")) {
        return NetworkImage(fulldetailresponse.postData.userInfo.userImage);
      } else {
        return NetworkImage(APIs.userprofilebaseurl + fulldetailresponse.postData.userInfo.userImage);
      }
    } else {
      return NetworkImage(
          "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80");
    }
  }

  void postlike(FullPostData postdata) async {
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
      request.postId = fulldetailresponse.postData.id.toString();

      var response = await _postDetailsViewModel.likepost(request, context);

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
              if (fulldetailresponse.postData.isliked == true) {
                fulldetailresponse.postData.isliked = true;
                isLikedLoading=false;
              } else {
                fulldetailresponse.postData.isliked = false;
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

      var response = await _postDetailsViewModel.dislikepost(request, context);

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

  void postreport(FullPostData getallpostlist) async {
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
      request.postId = getallpostlist.id.toString();

      var response = await _postDetailsViewModel.reportpost(request, context);

      print(response.toString());

      Reportpost_response reportpost_response = response;
      if (reportpost_response != null) {
        if (reportpost_response.status != null &&
            reportpost_response.status.isNotEmpty) {
          if (reportpost_response.status.compareTo("success") == 0) {
            displaytoast(reportpost_response.message, context);
          } else {
            displaytoast(reportpost_response.message, context);
          }
        }
      }
    }
  }
  updateSavedCollection(bool status){
    setState(() {
      if(fulldetailresponse!=null&&fulldetailresponse.postData!=null){
        fulldetailresponse.postData.isSaved=status;
      }
    });
  }

  void getCollectionList(int postid) async {
    _postDetailsViewModel.setLoading();
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _postDetailsViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Collection_list_params request= new Collection_list_params(userid: MemoryManagement.getuserId());
      var response = await _postDetailsViewModel.getallcollections(request, context);
      Collection_list_response collectionresponse = response;
      if (collectionresponse.status.compareTo("success") == 0) {
        setState(() {
          collectiondatalist.clear();
          if(collectionresponse.collectionData!=null&&collectionresponse.collectionData.length>0){
            collectiondatalist.addAll(collectionresponse.collectionData);
            showFavouriteList(collectiondatalist,postid);
          }else{
            displaytoast("Please create folder in favourite section", context);
          }
        });
      }else {
        displaytoast("Please create folder in favourite section", context);
      }
    }
  }

  void unsavefromcollection(int postid, int collectionId) async{
    _postDetailsViewModel.setLoading();
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _postDetailsViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Save_post_collection_params params = new Save_post_collection_params(key: "2",collectionId:collectionId.toString(),postId: postid.toString());
      var response = await _postDetailsViewModel.unsavepostcollection(params, context);
      Unsave_collection_post_response unsave_collection_post_response = response;
      if (unsave_collection_post_response.status.compareTo("success") == 0) {
        setState(() {
          collectiondatalist.clear();
          if(unsave_collection_post_response!=null&&unsave_collection_post_response.message.length>0){
            displaytoast(unsave_collection_post_response.message, context);
            updateSavedCollection(false);
          }else{
            displaytoast("Something went wrong", context);
          }
        });
      }else {
        displaytoast("Something went wrong", context);
      }
    }
  }

  void showFavouriteList(List<CollectionData> collectiondatalist, int postid) {
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
                                  _postDetailsViewModel.showCollectionLoaded();
                                });
                                bool gotInternetConnection = await hasInternetConnection(
                                  context: context,
                                  mounted: mounted,
                                  canShowAlert: true,
                                  onFail: () {
                                    _postDetailsViewModel.hideCollectionLoaded();
                                  },
                                  onSuccess: () {},
                                );
                                if (gotInternetConnection) {
                                  Save_post_collection_params params = new Save_post_collection_params(key: "1",collectionId: data.id.toString(),postId: postid.toString());
                                  var response = await _postDetailsViewModel.savepostcollection(params, context);
                                  Savepostcollectionresponse savecollectioresponse = response;
                                  setState((){
                                    _postDetailsViewModel.hideCollectionLoaded();
                                  });
                                  if (savecollectioresponse!=null&&savecollectioresponse.status.compareTo("success") == 0) {
                                    displaytoast(savecollectioresponse.message, context);
                                    Navigator.pop(context);
                                    updateSavedCollection(true);
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
                              showCreateFoler(postid);
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
                      status: _postDetailsViewModel.getCollectionLoaded(),
                      context: context),
                ),
              ],
            );
          });
        });
  }
  void showCreateFoler(int postid) {
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
                                      createFolderApi(foldername,context,postid);
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
                            createFolderApi(foldername,context,postid);
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
                        status: _postDetailsViewModel.getLoading(),
                        context: context),
                  ),
                ],
              ),
            );
          });

        });
  }
  void createFolderApi(TextEditingController foldername, BuildContext context, int postid) async{
    _postDetailsViewModel.setLoading();
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _postDetailsViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Create_collection_params params= new Create_collection_params(userid:MemoryManagement.getuserId(),collectionName: foldername.text.trim());
      var response = await _postDetailsViewModel.createcollection(params, context);
      Create_collectionresponse collectionresponse = response;
      if (collectionresponse.status.compareTo("success") == 0) {
        if(collectionresponse.collectionData!=null&&collectionresponse.collectionData.length>0){
          showFavouriteList(collectionresponse.collectionData,postid);
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

  void getTrybeList(int postid) async {
    _postDetailsViewModel.setLoading();
    bool gotInternetConnection = await hasInternetConnection(context: context, mounted: mounted, canShowAlert: true,
      onFail: () {
        _postDetailsViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Getplaylistparams request = new Getplaylistparams(uid: MemoryManagement.getuserId(),other_uid: MemoryManagement.getuserId());
      var response = await _postDetailsViewModel.getplaylist(request, context);
      Getplaylistresponse getplaylistresponse = response;
      if (getplaylistresponse.status.compareTo("success") == 0) {
        setState(() {
          playlistdata.clear();
          if (getplaylistresponse.playlistData != null &&
              getplaylistresponse.playlistData.length > 0) {
            playlistdata.addAll(getplaylistresponse.playlistData);
            showPlayListFolders(playlistdata, postid);
          } else {
            displaytoast("No playlist found.Please create a playlist", context);
            showTrybeListFolder(postid);
          }
        });
      } else {
        displaytoast("Error occurred while getting the playlist", context);
      }
    }
  }


  void showPlayListFolders(List<PlaylistData> playlistdata, int postid) {
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
                                  _postDetailsViewModel.showCollectionLoaded();
                                });
                                bool gotInternetConnection = await hasInternetConnection(
                                  context: context,
                                  mounted: mounted,
                                  canShowAlert: true,
                                  onFail: () {
                                    _postDetailsViewModel.hideCollectionLoaded();
                                  },
                                  onSuccess: () {},
                                );
                                if (gotInternetConnection) {
                                  Savetrybelistparams request = new Savetrybelistparams(key: "1",playlistId : trybelistdata.id.toString() ,postId: postid.toString());
                                  var response = await _postDetailsViewModel.savepostplaylist(request, context);
                                  Savetrybelistresponse savetrybelistresponse = response;
                                  setState((){
                                    _postDetailsViewModel.hideCollectionLoaded();
                                  });
                                  if (savetrybelistresponse.status.compareTo("success") == 0) {
                                    if(savetrybelistresponse.message!=null&&savetrybelistresponse.message.trim().length>0){
                                      displaytoast(savetrybelistresponse.message, context);
                                      updateUnsavedTrybeList(true, trybelistdata.id);
                                      Navigator.pop(context);
                                    }else{
                                      displaytoast("Post saved successfully", context);
                                      updateUnsavedTrybeList(true, trybelistdata.id);
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
                              showTrybeListFolder(postid);
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
                      status: _postDetailsViewModel.getCollectionLoaded(),
                      context: context),
                ),
              ],
            );
          });
        });
  }

  void showTrybeListFolder(int postid) {
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
                                      createFolderApi(foldername, context, postid);
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
                            createTrybeListApi(foldername, context, postid);
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
                    child: getDialogLoader(status: _postDetailsViewModel.getLoading(), context: context),
                  ),
                ],
              ),
            );
          });
        });
  }

  void createTrybeListApi(TextEditingController foldername, BuildContext context, int postid) async{
    _postDetailsViewModel.setLoading();
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _postDetailsViewModel.hideLoader();
      },
      onSuccess: () {

      },
    );
    if (gotInternetConnection) {
      Createplaylistparams params = new Createplaylistparams(uid: MemoryManagement.getuserId(), playlistName: foldername.text.trim());
      var response = await _postDetailsViewModel.createplaylist(params, context);
      Createplaylistresponse  createplaylistresponse= response;
      if (createplaylistresponse!=null&&createplaylistresponse.status.compareTo("success") == 0) {
        if (createplaylistresponse.playlistData != null &&
            createplaylistresponse.playlistData.length > 0) {
          playlistdata.clear();
          playlistdata.addAll(createplaylistresponse.playlistData);
          showPlayListFolders(createplaylistresponse.playlistData, postid);
        }
        displaytoast(createplaylistresponse.message, context);
      } else if(createplaylistresponse!=null&&createplaylistresponse.message!=null&&createplaylistresponse.message.trim().length>0){
        displaytoast(createplaylistresponse.message, context);
      }
    }
  }

  void unsavefromplaylist(int postid, int playlistId) async {
    _postDetailsViewModel.setLoading();
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _postDetailsViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Savetrybelistparams request = new Savetrybelistparams(key: "2",playlistId : playlistId.toString() ,postId: postid.toString());
      var response = await _postDetailsViewModel.savepostplaylist(request, context);
      Savetrybelistresponse savetrybelistresponse = response;
      if (savetrybelistresponse.status.compareTo("success") == 0) {
        if(savetrybelistresponse.message!=null&&savetrybelistresponse.message.trim().length>0){
          displaytoast(savetrybelistresponse.message, context);
          updateUnsavedTrybeList(false, 0);
        }else{
          displaytoast("Post unsaved successfully", context);
          updateUnsavedTrybeList(false, 0);
        }
      } else {
        displaytoast("Error occurred while getting the playlist", context);
      }
    }
  }
  void updateUnsavedTrybeList(bool status, int playlistid) {
    setState(() {
      if (fulldetailresponse.postData != null) {
        if (status == true) {
          fulldetailresponse.postData.playlistId = playlistid;
        } else {
          fulldetailresponse.postData.playlistId = 0;
        }
        fulldetailresponse.postData.isPlaylistSaved = status;
      }
    });
  }

}



