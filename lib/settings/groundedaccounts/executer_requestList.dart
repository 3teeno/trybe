import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:trybelocker/model/acceptNCancelGrounded/accept_cancel_grounded_params.dart';
import 'package:trybelocker/model/acceptNCancelGrounded/accept_cancel_grounded_response.dart';
import 'package:trybelocker/model/acceptcancelrequest/accept_cancel_response.dart';
import 'package:trybelocker/model/accountexecutor/accpet_cancelexecutorparams.dart';
import 'package:trybelocker/model/notification/notification_response.dart';
import 'package:trybelocker/networkmodel/APIs.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/viewmodel/notification_view_model.dart';

import '../../UniversalFunctions.dart';

class ExecuterRequestList extends StatefulWidget {
  static const String TAG = "/executerrequest";
  List<dynamic> getfollowrequests;
  int type=0;

  ExecuterRequestList(this.getfollowrequests,this.type);

  @override
  ExecuterRequestListState createState() => ExecuterRequestListState();
}

class ExecuterRequestListState extends State<ExecuterRequestList> {
  NotificationViewModel _notificationViewModel;
  List<dynamic> getfollowrequests = [];
  int type;
  @override
  void initState() {
    super.initState();
    getfollowrequests = (widget.getfollowrequests);
    type=widget.type;
    new Future.delayed(const Duration(milliseconds: 300), () {});
  }

  @override
  Widget build(BuildContext context) {
    _notificationViewModel = Provider.of<NotificationViewModel>(context);

    return Scaffold(
        backgroundColor: getColorFromHex(AppColors.black),
        appBar: AppBar(
          brightness: Brightness.dark,
          title: Text(
            "Request list",
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

  getnotificationdata() {
    if (getfollowrequests.length <= 0) {
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
          children: <Widget>[
            Visibility(
                visible: getfollowrequests != null
                    ? getfollowrequests.length > 0
                        ? true
                        : false
                    : false,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Executor Request",
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )),
            getfollowrequestsmethod(),
          ],
        ),
      );
    }
  }

  setFollowRequest() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: getfollowrequests.length,
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
                      if(type ==0){
                        acceptandcancelrequest(1, getfollowrequests[index]);
                      }
                      if(type ==1){
                        acceptandcancelGroundedrequest(1);
                      }

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
                      if(type ==0){
                        acceptandcancelrequest(0, getfollowrequests[index]);
                      }
                      if(type ==1){
                        acceptandcancelGroundedrequest(0);
                      }
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
        });
  }


  void acceptandcancelGroundedrequest(
      int key) async {
    AcceptCancelGroundedParams request = AcceptCancelGroundedParams();
    request.uid = MemoryManagement.getuserId();
    request.requestedUid = getfollowrequests[0].uid.toString();
    request.groundedUid =getfollowrequests[0].groundedId.toString();
    request.status = key;

    var response = await _notificationViewModel.acceptcancelgroundedrequest(
        request, context);

    AcceptCancelGroundedResponse acceptCancelResponse = response;

    if (acceptCancelResponse != null) {
      if (acceptCancelResponse.status != null &&
          acceptCancelResponse.status.compareTo("success") == 0) {
        displaytoast(acceptCancelResponse.message, context);
        setState(() {
          getfollowrequests.clear();
        });
      }
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

  void acceptandcancelrequest(int key, executorRequests followRequests) async {
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
          getfollowrequests.remove(followRequests);
        });
      }
    }
  }

  getfollowrequestsmethod() {
    if (getfollowrequests != null && getfollowrequests.length > 0) {
      return Expanded(child: setFollowRequest());
    } else {
      return Visibility(
        visible: false,
        child: Container(),
      );
    }
  }
}
