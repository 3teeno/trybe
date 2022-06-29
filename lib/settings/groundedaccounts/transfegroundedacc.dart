import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:trybelocker/UniversalFunctions.dart';
import 'package:trybelocker/model/groundedaccountlist/grounded_accountlistResponse.dart';
import 'package:trybelocker/model/requestGroundedAccount/request_grounded_account_params.dart';
import 'package:trybelocker/model/requestGroundedAccount/request_grounded_response.dart';
import 'package:trybelocker/model/requestexecutor/executor_request_params.dart';
import 'package:trybelocker/model/requestexecutor/executor_response.dart';
import 'package:trybelocker/model/searchfollowfollowing/search_followfollowingparams.dart';
import 'package:trybelocker/model/searchfollowfollowing/search_followfollowingresponse.dart';
import 'package:trybelocker/networkmodel/APIs.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/viewmodel/accountexecutor_viewmodel.dart';

class TransferGroundedAcc extends StatefulWidget {
  static const String TAG = "/ground_profile";
  Data data;

  TransferGroundedAcc(this.data);

  @override
  TransferGroundedAccState createState() => TransferGroundedAccState();
}

class TransferGroundedAccState extends State<TransferGroundedAcc> {
  AccountExecutorViewModel _accountExecutorViewModel;
  List<Users> datauser = [];
  final _formKey = GlobalKey<FormState>();
  var searchcontroller = TextEditingController();
  var usernameController = TextEditingController();
  var otherUsercontroller = TextEditingController();
  String searchValue = "";
  bool isSearchLoading = false;
  bool allSearchLoaded = false;
  bool islistingshowing = false;
  int pagenumber = 1;
  int limit = 15;
  String otherUid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    usernameController.text = widget.data.username;
  }

  @override
  Widget build(BuildContext context) {
    _accountExecutorViewModel = Provider.of<AccountExecutorViewModel>(context);
    return Scaffold(
      backgroundColor: getColorFromHex(AppColors.black),
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text(
          "Settings",
        ),
        backgroundColor: getColorFromHex(AppColors.black),
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              settingsHeader('Transfer Grounded Account',
                  MemoryManagement.getuserprofilepic()),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    setFormField("Grounded Account", false),
                    SizedBox(
                      height: 10,
                    ),
                    setOthetField("Send Account To    ", false),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(children: [
                          Container(
                            width: 180,
                            height: 30,
                            margin: EdgeInsets.only(left: 20),
                            child: TextFormField(
                                autofocus: false,
                                style: TextStyle(fontSize: 18),
                                controller: searchcontroller,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
                                    child: Container(
                                        child: Icon(
                                          Icons.search,
                                          color: Colors.white,
                                        ),
                                        color: getColorFromHex(AppColors.red)),
                                    onTap: () {
                                      if (searchcontroller.text != null &&
                                          searchcontroller.text.trim().length >
                                              0) {
                                        searchValue = searchcontroller.text;
                                        allSearchLoaded = false;
                                        isSearchLoading = false;
                                        setState(() {
                                          if (allSearchLoaded == false &&
                                              isSearchLoading == false) {
                                            pagenumber = 1;
                                            allSearchLoaded = true;
                                            isSearchLoading = true;
                                            islistingshowing = true;
                                            getUserSearchResults(
                                                true, searchcontroller.text);
                                          }
                                        });
                                      } else {
                                        displaytoast("Value required", context);
                                      }
                                    },
                                  ),
                                  isDense: true,
                                  contentPadding:
                                      EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  filled: true,
                                  fillColor: Color(0xFFF2F2F2),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                  ),
                                )),
                          ),
                          Text("Search User",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12)),
                        ])
                      ],
                    ),
                    Stack(
                      children: <Widget>[
                        datauser.length > 0
                            ? islistingshowing == true
                                ? Container(
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    height: 300,
                                    child: NotificationListener<
                                            ScrollNotification>(
                                        onNotification:
                                            (ScrollNotification scroll) {
                                          if (isSearchLoading == false &&
                                              allSearchLoaded == false &&
                                              scroll.metrics.pixels ==
                                                  scroll.metrics
                                                      .maxScrollExtent &&
                                              searchValue != null &&
                                              searchValue.trim().length > 0) {
                                            setState(() {
                                              isSearchLoading = true;
                                              ++pagenumber;
                                              getUserSearchResults(
                                                  false, searchValue);
                                            });
                                          }
                                          return;
                                        },
                                        child: ListView.builder(
                                            itemCount: datauser.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    otherUsercontroller.text =
                                                        datauser[index]
                                                            .username;
                                                    searchcontroller.text = "";
                                                    islistingshowing = false;
                                                  });
                                                  otherUid = datauser[index]
                                                      .id
                                                      .toString();
                                                  print("OtherUID $otherUid");
                                                },
                                                child: Container(
                                                  margin:
                                                      EdgeInsets.only(top: 15),
                                                  child: Row(
                                                    children: <Widget>[
                                                      new Container(
                                                          width: 35,
                                                          height: 35,
                                                          margin:
                                                              EdgeInsets.all(2),
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              image: new DecorationImage(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  image: getProfileImage(
                                                                      datauser[
                                                                          index])))),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      Text(
                                                        datauser[index]
                                                                    .username !=
                                                                null
                                                            ? datauser[index]
                                                                .username
                                                            : "",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.white),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            })),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      if (otherUsercontroller.text != null &&
                                          otherUsercontroller.text.isNotEmpty) {
                                        transferGrounded();

                                      } else {
                                        displaytoast(
                                            "Please choose username first",
                                            context);
                                      }
                                      // navigateToNextScreen(context, false, GroundedAccountExecuter());
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/submitbuttonbg.png',
                                            width: 200,
                                            height: 200,
                                          ),
                                          Text(
                                            'Submit',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          )
                                        ],
                                      ),
                                    ))
                            : GestureDetector(
                                onTap: () {
                                  // if (_formKey.currentState.validate()) {
                                  //   _formKey.currentState.save();
                                  // }
                                  if (otherUsercontroller.text != null &&
                                      otherUsercontroller.text.isNotEmpty) {
                                    transferGrounded();

                                  } else {
                                    displaytoast("Please choose username first",
                                        context);
                                  }
                                  // navigateToNextScreen(context, false, GroundedAccountExecuter());
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/submitbuttonbg.png',
                                        width: 200,
                                        height: 200,
                                      ),
                                      Text(
                                        'Submit',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      )
                                    ],
                                  ),
                                ))
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  setFormField(String title, pwdType) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        SizedBox(
          width: 20,
        ),
        SizedBox(
          child: TextFormField(
              obscureText: pwdType,
              autofocus: false,
              controller: usernameController,
              readOnly: true,
              validator: (String arg) {
                if (arg.length < 3)
                  return 'Name must be more than 2 charater';
                else
                  return null;
              },
              onSaved: (String val) {
                switch (title) {
                  case "Username":
                    // _name = val;
                    break;
                }
              },
              style: TextStyle(fontSize: 18),
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                filled: true,
                fillColor: Color(0xFFF2F2F2),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(width: 1, color: Colors.red),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(width: 1, color: Colors.red),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(width: 1, color: Colors.red),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1, color: Colors.red)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1, color: Colors.red)),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1, color: Colors.red)),
              )),
          width: 200,
        )
      ],
    );
  }

  setOthetField(String title, pwdType) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        SizedBox(
          width: 20,
        ),
        SizedBox(
          child: TextFormField(
              obscureText: pwdType,
              autofocus: false,
              readOnly: true,
              controller: otherUsercontroller,
              validator: (String arg) {
                if (arg.length < 3)
                  return 'Name must be more than 2 charater';
                else
                  return null;
              },
              onSaved: (String val) {
                switch (title) {
                  case "Username":
                    // _name = val;
                    break;
                }
              },
              style: TextStyle(fontSize: 18),
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                filled: true,
                fillColor: Color(0xFFF2F2F2),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(
                      width: 1, color: getColorFromHex(AppColors.red)),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(
                      width: 1, color: getColorFromHex(AppColors.red)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(
                      width: 1, color: getColorFromHex(AppColors.red)),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(
                        width: 1, color: getColorFromHex(AppColors.red))),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(
                        width: 1, color: getColorFromHex(AppColors.red))),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(
                        width: 1, color: getColorFromHex(AppColors.red))),
              )),
          width: 200,
        )
      ],
    );
  }

  void getUserSearchResults(bool isClear, String text) async {
    FocusScope.of(context).unfocus();
    if (isClear == true) {
      _accountExecutorViewModel.setLoading();
    }
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _accountExecutorViewModel.hideLoader();
        setState(() {
          islistingshowing = false;
        });
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Search_followfollowing params = Search_followfollowing(
          searchValue: searchcontroller.text,
          page: pagenumber.toString(),
          uid: MemoryManagement.getuserId(),
          limit: limit.toString());
      var response =
          await _accountExecutorViewModel.searchexecutorUser(params, context);
      Search_followfollowingresponse searchresponse = response;
      setState(() {
        if (isClear == true) {
          datauser.clear();
        }
        if (searchresponse != null &&
            searchresponse.status != null &&
            searchresponse.status.compareTo("success") == 0) {
          if (searchresponse.userData != null &&
              searchresponse.userData.users.length > 0) {
            if (searchresponse.userData.users.length < limit) {
              allSearchLoaded = true;
              isSearchLoading = false;
              datauser.addAll(searchresponse.userData.users);
            } else {
              allSearchLoaded = false;
              isSearchLoading = false;
              datauser.addAll(searchresponse.userData.users);
            }
          } else {
            allSearchLoaded = false;
            isSearchLoading = false;
            if (datauser.length <= 0) {
              displaytoast("No user found", context);
            }
          }
        } else {
          allSearchLoaded = false;
          isSearchLoading = false;
          if (datauser.length <= 0) {
            displaytoast("No user found", context);
          }
        }
      });
    }
  }

  getProfileImage(Users datauser) {
    if (datauser != null &&
        datauser.userImage != null &&
        datauser.userImage.trim().length > 0) {
      if (datauser.userImage.contains("https") ||
          datauser.userImage.contains("http")) {
        return NetworkImage(datauser.userImage);
      } else {
        return NetworkImage(APIs.userprofilebaseurl + datauser.userImage);
      }
    } else {
      return NetworkImage(
          "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80");
    }
  }

  void transferGrounded() async {
    RequestGroundedAccountParams executorRequestParams = RequestGroundedAccountParams();
    executorRequestParams.uid= MemoryManagement.getuserId();
    executorRequestParams.requestedUid = otherUid;
    executorRequestParams.groundedUid =widget.data.id.toString();

    var response = await _accountExecutorViewModel.requestgroundedAcount(
        executorRequestParams, context);

    RequestGroundedResponse executorResponse = response;

    if (executorResponse != null) {
      if (executorResponse.status != null &&
          executorResponse.status.compareTo("success") == 0) {
        displaytoast(executorResponse.message, context);
        setState(() {
          //displaytoast("message", context);
        });
      }
    }
  }
}
