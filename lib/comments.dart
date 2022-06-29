import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trybelocker/model/getallcomment/getallcommentparams.dart';
import 'package:trybelocker/model/getallcomment/getallcommentresponse.dart';
import 'package:trybelocker/model/postcomment/post_comment_params.dart';
import 'package:trybelocker/model/postcomment/post_comment_response.dart';
import 'package:trybelocker/networkmodel/APIs.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/viewmodel/home_view_model.dart';
import 'package:provider/src/provider.dart';
import 'UniversalFunctions.dart';

class CommentScreen extends StatefulWidget {
  static const String TAG = "/commentscreen";
  int postid;

  CommentScreen(this.postid);

  @override
  CommentScreenState createState() => CommentScreenState(postid);
}

class CommentScreenState extends State<CommentScreen> {
  HomeViewModel _homeViewModel;
  List<Data> getcommentlist = [];
  int currentPage = 1;
  int limit = 10;
  bool isnearpostLoading = false;

  bool allnearPost = false;
  int postid;
  var _commentController = TextEditingController();

  CommentScreenState(this.postid);

  @override
  void initState() {
    super.initState();

    new Future.delayed(const Duration(milliseconds: 300), () {
      isnearpostLoading = false;
      currentPage = 1;
      allnearPost = false;
      // _profileHomeViewModel.setLoading();
      if (isnearpostLoading == false && allnearPost == false) {
        setState(() {
          isnearpostLoading = true;
        });
        getallComment(true, currentPage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _homeViewModel = Provider.of<HomeViewModel>(context);

    return  WillPopScope(
            onWillPop: _onBackPressed,
            child: Scaffold(
                backgroundColor: getColorFromHex(AppColors.black),
                appBar: AppBar(
                  brightness: Brightness.dark,
                  title: Text(
                    "Comments",
                  ),
                  backgroundColor: getColorFromHex(AppColors.black),
                ),
                body: Stack(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(10),
                        child: setNotification()),
                    Divider(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        color: getColorFromHex(AppColors.black),
                        child: ListTile(
                            title: TextFormField(
                              style: TextStyle(color: Colors.white),
                              controller: _commentController,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: InputDecoration(
                                  labelText: 'Write a comment...',
                                  labelStyle: TextStyle(color: Colors.white)),
                              onFieldSubmitted: (val) {
                                FocusScope.of(context).unfocus();
                              },
                            ),
                            trailing: OutlineButton(
                                onPressed: () {
                                  if (_commentController.text != null &&
                                      _commentController.text.isNotEmpty)
                                    postComment();
                                },
                                borderSide: BorderSide.none,
                                child: Text(
                                  "Post",
                                  style: TextStyle(color: Colors.white),
                                ))),
                      ),
                    ),
                    getFullScreenProviderLoader(status: _homeViewModel.getLoading(), context: context)
                  ],
                )));
  }

  Future<bool> _onBackPressed() async {
    Navigator.of(context).pop(getcommentlist.length);
  }

  setNotification() {
    return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scroll) {
          if (isnearpostLoading == false &&
              allnearPost == false &&
              scroll.metrics.pixels == scroll.metrics.maxScrollExtent) {
            setState(() {
              // _profileHomeViewModel.setLoading();
              isnearpostLoading = true;
              currentPage++;
              getallComment(false, currentPage);
            });
          }
          return;
        },
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: getcommentlist.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      new Container(
                          width: 40,
                          height: 40,
                          margin: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.cover,
                                  image: getprofilepic(index)))),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getcommentlist[index].userInfo.username,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.clip,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 80,
                            child: Text(
                              getcommentlist[index].commentContent,
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              );
            }));
  }

  getprofilepic(int index) {
    if (getcommentlist[index].userInfo.userImage != null &&
        getcommentlist[index].userInfo.userImage.isNotEmpty) {
      if (getcommentlist[index].userInfo.userImage.contains("https") ||
          getcommentlist[index].userInfo.userImage.contains("http")) {
        return NetworkImage(getcommentlist[index].userInfo.userImage);
      } else {
        return NetworkImage(
            APIs.userprofilebaseurl + getcommentlist[index].userInfo.userImage);
      }
    } else {
      return NetworkImage(
          "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80");
    }
  }

  void postComment() async {
    FocusScope.of(context).unfocus();
    Post_comment_params request = Post_comment_params();
    request.uid = MemoryManagement.getuserId();
    request.postId = postid.toString();
    request.commentContent = _commentController.value.text;
    request.key = "3";

    var response = await _homeViewModel.postComment(request, context);
    Post_comment_response post_comment_response = response;

    if (post_comment_response != null) {
      if (post_comment_response.status != null &&
          post_comment_response.status.isNotEmpty) {
        if (post_comment_response.status.compareTo("success") == 0) {
          isnearpostLoading = false;
          currentPage = 1;
          allnearPost = false;
          // _profileHomeViewModel.setLoading();
          if (isnearpostLoading == false && allnearPost == false) {
            setState(() {
              _commentController.text = "";
            });
            getallComment(true, currentPage);
          }
        } else {}
      }
    }
  }

  void getallComment(bool isClear, int currentPage) async {
    _homeViewModel.setLoading();
    Getallcommentparams request = Getallcommentparams();
    // request.userid = MemoryManagement.getuserId();
    request.postId = postid.toString();
    request.page = currentPage.toString();
    request.limit = limit.toString();

    var response = await _homeViewModel.getallcomment(request, context);
    Getallcommentresponse getallpostsresponse = response;
    if (isClear == true) {
      getcommentlist.clear();
    }

    if (getallpostsresponse != null &&
        getallpostsresponse.postData.data != null &&
        getallpostsresponse.postData.data.length > 0) {
      if (getallpostsresponse.postData.data.length < limit) {
        allnearPost = true;
        isnearpostLoading = false;
      }
      if (getallpostsresponse != null) {
        if (getallpostsresponse.status != null &&
            getallpostsresponse.status.isNotEmpty) {
          if (getallpostsresponse.status.compareTo("success") == 0) {
            getcommentlist.addAll(getallpostsresponse.postData.data);
            currentPage = 2;
            setState(() {});
          } else {}
        }
      }
      setState(() {
        isnearpostLoading = false;
      });
    } else {
      allnearPost = true;
      setState(() {
        isnearpostLoading = false;
      });
    }
  }
}
