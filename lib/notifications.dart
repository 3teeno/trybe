import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:trybelocker/followerrequestlist.dart';
import 'package:trybelocker/model/acceptNCancelGrounded/accept_cancel_grounded_params.dart';
import 'package:trybelocker/model/acceptNCancelGrounded/accept_cancel_grounded_response.dart';
import 'package:trybelocker/model/acceptcancelrequest/accept_cancel_response.dart';
import 'package:trybelocker/model/acceptcancelrequest/accpet_cancelparams.dart';
import 'package:trybelocker/model/notification/notification_params.dart';
import 'package:trybelocker/model/notification/notification_response.dart';
import 'package:trybelocker/networkmodel/APIs.dart';
import 'package:trybelocker/settings/groundedaccounts/executer_requestList.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/viewmodel/notification_view_model.dart';

import 'UniversalFunctions.dart';
import 'model/accountexecutor/accpet_cancelexecutorparams.dart';

class NotificationScreen extends StatefulWidget {
  static const String TAG = "/notifications";

  @override
  NotificationState createState() => NotificationState();
}

class NotificationState extends State<NotificationScreen> {
  NotificationViewModel _notificationViewModel;
  List<Data> getnotificationlist = [];
  List<FollowRequests> getfollowrequests = [];
  List<executorRequests> getExecuterRequest = [];
  List<transferGroundedRequests> gettransferGroundedRequests = [];

  int currentPage = 1;
  int limit = 10;
  bool isnearpostLoading = false;
  bool allnearPost = false;
  bool isDataLoaded = false;

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
        getnotification(true, currentPage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _notificationViewModel = Provider.of<NotificationViewModel>(context);

    return Scaffold(
        backgroundColor: getColorFromHex(AppColors.black),
        appBar: AppBar(
          brightness: Brightness.dark,
          title: Text(
            "Notification",
          ),
          backgroundColor: getColorFromHex(AppColors.black),
        ),
        body: Stack(
          children: <Widget>[
            getnotificationdata(),
            getFullScreenProviderLoader(
                status: _notificationViewModel.getLoading(), context: context)
          ],
        ));
  }

  setFollowRequest() {
    return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scroll) {
          if (isnearpostLoading == false &&
              allnearPost == false &&
              scroll.metrics.pixels == scroll.metrics.maxScrollExtent) {
            setState(() {
              // _profileHomeViewModel.setLoading();
              isnearpostLoading = true;
              currentPage++;
              getnotification(false, currentPage);
            });
          }
          return;
        },
        child: ListView.builder(
            shrinkWrap: true,
            itemCount:
                getfollowrequests.length > 2 ? 2 : getfollowrequests.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Container(
                          width: 40,
                          height: 40,
                          margin: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.cover,
                                  image: getfollowerprofilepic(index)))),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          getfollowrequests[index].message.toString(),
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          acceptandcancelrequest("1", getfollowrequests[index]);
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            "Accept",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          acceptandcancelrequest("2", getfollowrequests[index]);
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 8, bottom: 8),
                          decoration: BoxDecoration(
                              color: getColorFromHex(AppColors.black),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.white)),
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              );
            }));
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
              getnotification(false, currentPage);
            });
          }
          return;
        },
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: getnotificationlist.length,
            itemBuilder: (BuildContext context, int index) {
              return getnotificationlist[index].message.isEmpty
                  ? Container()
                  : Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
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
                            Expanded(
                              child: Text(
                                getnotificationlist[index].message.toString(),
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                            // SizedBox(
                            //   width: 5,
                            // ),
                            // GestureDetector(
                            //   onTap: (){
                            //     acceptandcancelrequest( "1",getnotificationlist[index]);
                            //   },
                            //   child: Container(
                            //     padding: EdgeInsets.only(
                            //         left: 20, right: 20, top: 10, bottom: 10),
                            //     decoration: BoxDecoration(
                            //         color: Colors.blue,
                            //         borderRadius: BorderRadius.circular(5)),
                            //     child: Text(
                            //       "Accept",
                            //       style: TextStyle(color: Colors.white),
                            //     ),
                            //   ),
                            // ),
                            // SizedBox(
                            //   width: 5,
                            // ),
                            // GestureDetector(
                            //   onTap: (){
                            //     acceptandcancelrequest("2",getnotificationlist[index]);
                            //   },
                            //   child: Container(
                            //     padding: EdgeInsets.only(
                            //         left: 20, right: 20, top: 8, bottom: 8),
                            //     decoration: BoxDecoration(
                            //         color: getColorFromHex(AppColors.black),
                            //         borderRadius: BorderRadius.circular(5),
                            //         border: Border.all(color: Colors.white)),
                            //     child: Text(
                            //       "Cancel",
                            //       style: TextStyle(color: Colors.white),
                            //     ),
                            //   ),
                            // )
                          ],
                        )
                      ],
                    );
            }));
  }

  getprofilepic(int index) {
    if (getnotificationlist[index].userInfo.userImage != null &&
        getnotificationlist[index].userInfo.userImage.isNotEmpty) {
      if (getnotificationlist[index].userInfo.userImage.contains("https") ||
          getnotificationlist[index].userInfo.userImage.contains("http")) {
        return NetworkImage(getnotificationlist[index].userInfo.userImage);
      } else {
        return NetworkImage(APIs.userprofilebaseurl +
            getnotificationlist[index].userInfo.userImage);
      }
    } else {
      return NetworkImage(
          "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80");
    }
  }

  getfollowerprofilepic(int index) {
      if (getfollowrequests[index].userInfo.userImage != null &&
          getfollowrequests[index].userInfo.userImage.isNotEmpty) {
        if (getfollowrequests[index].userInfo.userImage.contains("https") ||
            getfollowrequests[index].userInfo.userImage.contains("http")) {
          return NetworkImage(getfollowrequests[index].userInfo.userImage);
        } else {
          return NetworkImage(APIs.userprofilebaseurl +
              getfollowrequests[index].userInfo.userImage);
        }
      } else {
        return NetworkImage(
            "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80");
      }

  }


  getgroundedprofilepic(int index) {
    if(gettransferGroundedRequests[index].userInfo !=null && gettransferGroundedRequests[index].userInfo.userImage.length >0) {
      if (gettransferGroundedRequests[index].userInfo.userImage != null &&
          gettransferGroundedRequests[index].userInfo.userImage.isNotEmpty) {
        if (gettransferGroundedRequests[index].userInfo.userImage.contains("https") ||
            gettransferGroundedRequests[index].userInfo.userImage.contains("http")) {
          return NetworkImage(gettransferGroundedRequests[index].userInfo.userImage);
        } else {
          return NetworkImage(APIs.userprofilebaseurl +
              gettransferGroundedRequests[index].userInfo.userImage);
        }
      } else {
        return NetworkImage(
            "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80");
      }
    }
  }
  getexecuterprofilepic(int index) {
  if(getExecuterRequest[index].userInfo !=null && getExecuterRequest[index].userInfo.userImage.length >0) {
    if (getExecuterRequest[index].userInfo.userImage != null &&
        getExecuterRequest[index].userInfo.userImage.isNotEmpty) {
      if (getExecuterRequest[index].userInfo.userImage.contains("https") ||
          getExecuterRequest[index].userInfo.userImage.contains("http")) {
        return NetworkImage(getExecuterRequest[index].userInfo.userImage);
      } else {
        return NetworkImage(APIs.userprofilebaseurl +
            getExecuterRequest[index].userInfo.userImage);
      }
    } else {
      return NetworkImage(
          "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80");
    }
  }
  }

  void getnotification(bool isClear, int currentPage) async {
    _notificationViewModel.setLoading();
    Notification_params request = Notification_params();
    request.userid = MemoryManagement.getuserId();
    request.page = currentPage.toString();
    request.limit = limit.toString();

    var response = await _notificationViewModel.notification(request, context);
    Notification_response getallpostsresponse = response;
    isDataLoaded = true;
    if (isClear == true) {
      getnotificationlist.clear();
      getfollowrequests.clear();
      getExecuterRequest.clear();
      gettransferGroundedRequests.clear();

    }

    if (getallpostsresponse != null) {
      if (getallpostsresponse.postData.data != null &&
          getallpostsresponse.postData.data.length > 0) {
        if (getallpostsresponse.postData.data.length < limit) {
          allnearPost = true;
          isnearpostLoading = false;
        }
        if (getallpostsresponse != null) {
          if (getallpostsresponse.status != null &&
              getallpostsresponse.status.isNotEmpty) {
            if (getallpostsresponse.status.compareTo("success") == 0) {
              getnotificationlist.addAll(getallpostsresponse.postData.data);
              print("listsize,${getallpostsresponse.executorRequest}");
              getfollowrequests.clear();
              getfollowrequests.addAll(getallpostsresponse.followRequests);
              getExecuterRequest.addAll(getallpostsresponse.executorRequest);
              gettransferGroundedRequests.addAll(getallpostsresponse.transferGroundedRequest);

              setState(() {});
            } else {}
          }
        }
        setState(() {
          isnearpostLoading = false;
        });
      } else if (getallpostsresponse.followRequests != null &&
          getallpostsresponse.followRequests.length > 0) {
        if (getallpostsresponse != null) {
          if (getallpostsresponse.status != null &&
              getallpostsresponse.status.isNotEmpty) {
            if (getallpostsresponse.status.compareTo("success") == 0) {
              getfollowrequests.clear();
              getfollowrequests.addAll(getallpostsresponse.followRequests);
              setState(() {});
            } else {}
          }
        }
        setState(() {
          isnearpostLoading = false;
        });
      }
    } else {
      allnearPost = true;
      setState(() {
        isnearpostLoading = false;
      });
    }
  }

  void acceptandcancelrequest(String key, FollowRequests followRequests) async {
    AccpetCancelparams request = AccpetCancelparams();
    request.userId = MemoryManagement.getuserId();
    request.requestBy = followRequests.followRequestBy.toString();
    request.key = key;

    var response =
        await _notificationViewModel.acceptcancelrequest(request, context);

    AcceptCancelResponse acceptCancelResponse = response;

    if (acceptCancelResponse != null) {
      if (acceptCancelResponse.status != null &&
          acceptCancelResponse.status.compareTo("success") == 0) {
        setState(() {
          getfollowrequests.remove(followRequests);
        });
      }
    }
  }




  void acceptandcancelExecutorrequest(
      int key, executorRequests followRequests) async {
    AccpetCancelExecutorparams request = AccpetCancelExecutorparams();
    request.userId = MemoryManagement.getuserId();
    request.requestBy = followRequests.uid.toString();
    request.key = key;

    var response = await _notificationViewModel.acceptcancelexecutorrequest(
        request, context);

    AcceptCancelResponse acceptCancelResponse = response;

    if (acceptCancelResponse != null) {
      if (acceptCancelResponse.status != null &&
          acceptCancelResponse.status.compareTo("success") == 0) {
        setState(() {
          getExecuterRequest.clear();
        });
      }
    }
  }

  void acceptandcancelGroundedrequest(
      int key) async {
    AcceptCancelGroundedParams request = AcceptCancelGroundedParams();
    request.uid = MemoryManagement.getuserId();
    request.requestedUid = gettransferGroundedRequests[0].uid.toString();
    request.groundedUid =gettransferGroundedRequests[0].groundedId.toString();
    request.status = key;

    var response = await _notificationViewModel.acceptcancelgroundedrequest(
        request, context);

    AcceptCancelGroundedResponse acceptCancelResponse = response;

    if (acceptCancelResponse != null) {
      if (acceptCancelResponse.status != null &&
          acceptCancelResponse.status.compareTo("success") == 0) {
        displaytoast(acceptCancelResponse.message, context);
        setState(() {
          gettransferGroundedRequests.clear();
        });
      }
    }
  }

  getfollowrequestsmethod() {
    if (getfollowrequests != null && getfollowrequests.length > 0) {
      return Container(
          height: getfollowrequests.length > 1 ? 120 : 60,
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: setFollowRequest());
    } else {
      return Visibility(
        visible: false,
        child: Container(),
      );
    }
  }

  gettransferGroundData(int index){
    if(gettransferGroundedRequests != null && gettransferGroundedRequests.length > 0 && gettransferGroundedRequests[index].userInfo !=null){

      return Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                  "Transfer Grounded Request",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 20))),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Container(
                  width: 40,
                  height: 40,
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.cover,
                          image: getgroundedprofilepic(0)))),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  gettransferGroundedRequests[0].message.toString(),
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.clip,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              ElevatedButton(
                  child: Text("Accept".toUpperCase(),
                      style: TextStyle(fontSize: 14)),
                  style: ButtonStyle(
                      foregroundColor:
                      MaterialStateProperty.all<Color>(
                          Colors.white),
                      backgroundColor:
                      MaterialStateProperty.all<Color>(
                          Colors.blue),
                      shape: MaterialStateProperty.all<
                          RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(8.0),
                              side: BorderSide(
                                  color: Colors.blue)))),
                  onPressed: () {
                    acceptandcancelGroundedrequest(
                        1);
                  }),
              SizedBox(
                width: 5,
              ),
              ElevatedButton(
                  child: Text("Cancel".toUpperCase(),
                      style: TextStyle(fontSize: 14)),
                  style: ButtonStyle(
                      foregroundColor:
                      MaterialStateProperty.all<Color>(
                          Colors.white),
                      backgroundColor:
                      MaterialStateProperty.all<Color>(
                          Colors.transparent),
                      shape: MaterialStateProperty.all<
                          RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(8.0),
                              side: BorderSide(
                                  color: Colors.white)))),
                  onPressed: () {
                    acceptandcancelGroundedrequest(
                        0);
                  }),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                  builder: (context) => ExecuterRequestList(gettransferGroundedRequests,1)))
                  .then((value) {
                isnearpostLoading = false;
                currentPage = 1;
                allnearPost = false;
                // _profileHomeViewModel.setLoading();
                if (isnearpostLoading == false &&
                    allnearPost == false) {
                  setState(() {
                    isnearpostLoading = true;
                  });
                  getnotification(true, currentPage);
                }
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(bottom: 10),
              child: Text(
                "Show more",
                style:
                TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.start,
              ),
            ),
          )
        ],
      );

    }
    else{
      return Container();
    }

  }

  getMessageData(int index){
    if(getExecuterRequest != null && getExecuterRequest.length > 0 && getExecuterRequest[index].userInfo !=null){

        return Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                    "Executor Request",
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.white, fontSize: 20))),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                 new Container(
                                width: 40,
                                height: 40,
                                margin: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.cover,
                                        image: getexecuterprofilepic(0)))),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    getExecuterRequest[0].message.toString(),
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.clip,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                    child: Text("Accept".toUpperCase(),
                        style: TextStyle(fontSize: 14)),
                    style: ButtonStyle(
                        foregroundColor:
                        MaterialStateProperty.all<Color>(
                            Colors.white),
                        backgroundColor:
                        MaterialStateProperty.all<Color>(
                            Colors.blue),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(8.0),
                                side: BorderSide(
                                    color: Colors.blue)))),
                    onPressed: () {
                      acceptandcancelExecutorrequest(
                          1, getExecuterRequest[0]);
                    }),
                SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                    child: Text("Cancel".toUpperCase(),
                        style: TextStyle(fontSize: 14)),
                    style: ButtonStyle(
                        foregroundColor:
                        MaterialStateProperty.all<Color>(
                            Colors.white),
                        backgroundColor:
                        MaterialStateProperty.all<Color>(
                            Colors.transparent),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(8.0),
                                side: BorderSide(
                                    color: Colors.white)))),
                    onPressed: () {
                      acceptandcancelExecutorrequest(
                          0, getExecuterRequest[0]);
                    }),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                    builder: (context) => ExecuterRequestList(
                        getExecuterRequest,0)))
                    .then((value) {
                  isnearpostLoading = false;
                  currentPage = 1;
                  allnearPost = false;
                  // _profileHomeViewModel.setLoading();
                  if (isnearpostLoading == false &&
                      allnearPost == false) {
                    setState(() {
                      isnearpostLoading = true;
                    });
                    getnotification(true, currentPage);
                  }
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(bottom: 10),
                child: Text(
                  "Show more",
                  style:
                  TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.start,
                ),
              ),
            )
          ],
        );

    }
    else{
      return Container();
    }

  }

  getnotificationdata() {
    if (getnotificationlist.length <= 0 && getfollowrequests.length <= 0) {
      print("lenght=>,${getnotificationlist.length}");
      print("lenght=>,${getfollowrequests.length}");
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Text(
            "No Data Found",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else {
      return Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: [
              (getfollowrequests != null && getfollowrequests.length > 0)
                  ? Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Follow Request",
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Container(
                                width: 40,
                                height: 40,
                                margin: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.cover,
                                        image: getfollowerprofilepic(0)))),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                getfollowrequests[0].message.toString(),
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            ElevatedButton(
                                child: Text("Accept".toUpperCase(),
                                    style: TextStyle(fontSize: 14)),
                                style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.blue),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            side: BorderSide(
                                                color: Colors.blue)))),
                                onPressed: () {
                                  acceptandcancelrequest(
                                      "1", getfollowrequests[0]);
                                }),
                            SizedBox(
                              width: 5,
                            ),
                            ElevatedButton(
                                child: Text("Cancel".toUpperCase(),
                                    style: TextStyle(fontSize: 14)),
                                style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.transparent),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            side: BorderSide(
                                                color: Colors.white)))),
                                onPressed: () {
                                  acceptandcancelrequest(
                                      "2", getfollowrequests[0]);
                                }),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) =>
                                        FollowRequestScreen(getfollowrequests)))
                                .then((value) {
                              isnearpostLoading = false;
                              currentPage = 1;
                              allnearPost = false;
                              // _profileHomeViewModel.setLoading();
                              if (isnearpostLoading == false &&
                                  allnearPost == false) {
                                setState(() {
                                  isnearpostLoading = true;
                                });
                                getnotification(true, currentPage);
                              }
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(bottom: 10),
                            child: Text(
                              "Show more",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        )
                      ],
                    )
                  : Container(),
              SizedBox(
                height: 10,
              ),
              getMessageData(0),
              gettransferGroundData(0),
              SizedBox(
                height: 10,
              ),
              (getnotificationlist != null && getnotificationlist.length > 0)
                  ? Expanded(
                      child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Notifications",
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                        Expanded(child: setNotification())
                      ],
                    ))
                  : Container(),
            ],
          ));

      //      SingleChildScrollView(
      //   child: Container(
      //     margin: EdgeInsets.only(left: 10,right: 10),
      //     child:  Column(
      //       children: <Widget>[
      //         Visibility(
      //             visible: getfollowrequests != null
      //                 ? getfollowrequests.length > 0?true:false:false,
      //             child: Container(
      //               width: MediaQuery.of(context).size.width,
      //               child: Text("Follow Request",
      //                 textAlign: TextAlign.left,
      //                 style: TextStyle(
      //                     color: Colors.white,fontSize: 20
      //                 ),),
      //             )),
      //         getfollowrequestsmethod(),
      //         GestureDetector(
      //           onTap: (){
      //             Navigator.of(context).push(MaterialPageRoute(
      //                 builder: (context) => FollowRequestScreen(getfollowrequests))).then((value){
      //               isnearpostLoading = false;
      //               currentPage = 1;
      //               allnearPost = false;
      //               // _profileHomeViewModel.setLoading();
      //               if (isnearpostLoading == false && allnearPost == false) {
      //                 setState(() {
      //                   isnearpostLoading = true;
      //                 });
      //                 getnotification(true, currentPage);
      //               }
      //             });
      //           },
      //           child:  Visibility(
      //               visible: getfollowrequests!=null?getfollowrequests.length>0?true:false:false,
      //               child:  Container(
      //                 width: MediaQuery.of(context).size.width,
      //                 margin: EdgeInsets.only(bottom: 10),
      //                 child: Text("Show more",style: TextStyle(color: Colors.white,fontSize: 16),textAlign: TextAlign.start,),
      //               )),
      //         )
      //        ,
      //         Visibility(
      //             visible:    getnotificationlist != null
      //                 ? getnotificationlist.length > 0?true:false:false,
      //             child: Container(
      //               width: MediaQuery.of(context).size.width,
      //               child: Text("Notifications",
      //                 textAlign: TextAlign.left,
      //                 style: TextStyle(
      //                     color: Colors.white,fontSize: 20
      //                 ),),
      //             )),
      //         /* getnotificationlist != null
      //             ? getnotificationlist.length > 0
      //             ?*/ Visibility(
      //             visible: getnotificationlist!=null?getnotificationlist.length>0?true:false:false,
      //             child: Container(
      //                 height: MediaQuery.of(context).size.height-120,
      //                 margin: EdgeInsets.all(10), child: setNotification()))
      //         /*: Visibility(
      //             visible: isDataLoaded
      //                 ? _notificationViewModel.getLoading()
      //                 ? false
      //                 : true
      //                 : false,
      //             child: Center(
      //               child: Text(
      //                 "No Data Found",
      //                 style: TextStyle(
      //                     color: Colors.white,
      //                     fontSize: 18,
      //                     fontWeight: FontWeight.bold),
      //               ),
      //             ))*/
      //         /* : Visibility(
      //             visible: isDataLoaded
      //                 ? _notificationViewModel.getLoading()
      //                 ? false
      //                 : true
      //                 : false,
      //             child: Center(
      //               child: Text(
      //                 "No Data Found",
      //                 style: TextStyle(
      //                     color: Colors.white,
      //                     fontSize: 18,
      //                     fontWeight: FontWeight.bold),
      //               ),
      //             ))*/
      //       ],
      //     ),
      //   ),
      // );

    }
  }
}
