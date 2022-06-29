
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:trybelocker/UniversalFunctions.dart';
import 'package:trybelocker/model/requestexecutor/executor_request_params.dart';
import 'package:trybelocker/model/requestexecutor/executor_response.dart';
import 'package:trybelocker/model/searchfollowfollowing/search_followfollowingparams.dart';
import 'package:trybelocker/model/searchfollowfollowing/search_followfollowingresponse.dart';
import 'package:trybelocker/networkmodel/APIs.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/viewmodel/accountexecutor_viewmodel.dart';

class GroundedAppointExecuter extends StatefulWidget {
  static const String TAG = "/grounded_appointexecuter";

  @override
  GroundedAppointExecuterState createState() => GroundedAppointExecuterState();
}

class GroundedAppointExecuterState extends State<GroundedAppointExecuter> {
  AccountExecutorViewModel _accountExecutorViewModel;
  int pagenumber = 1;
  int limit = 15;
  var searchcontroller = TextEditingController();
  var usernamecontroller = TextEditingController();
  bool isSearchLoading = false;
  bool allSearchLoaded = false;
  List<Users> datauser = [];
  String searchValue = "";
  String otherUid;
  bool islistingshowing= false;
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
        child: Center(
          child: Container(
            child: Column(
              children: [
                settingsHeader('Appoint Executor',  MemoryManagement.getuserprofilepic()),
                SizedBox(
                  height: 20,
                ),
                setFormField("Username", false),
                SizedBox(
                  height: 10,
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
                                  if (searchcontroller.text != null && searchcontroller.text.trim().length > 0) {
                                    searchValue = searchcontroller.text;
                                    allSearchLoaded = false;
                                    isSearchLoading = false;
                                    setState(() {
                                      if (allSearchLoaded == false && isSearchLoading == false) {
                                        pagenumber = 1;
                                        allSearchLoaded = true;
                                        isSearchLoading = true;
                                        islistingshowing = true;
                                        getUserSearchResults(true, searchcontroller.text);
                                      }
                                    });

                                  } else {
                                    displaytoast("Value required", context);
                                  }


                                },
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              filled: true,
                              fillColor: Color(0xFFF2F2F2),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                              ),
                            )),
                      ),
                      Text("Search User",
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ])
                  ],
                ),
                Stack(
                  children: <Widget>[
                    datauser.length>0?islistingshowing==true?
                    Container(
                      margin: EdgeInsets.only(left: 10,right: 10),
                      height: 300,
                      child: NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scroll) {
                            if (isSearchLoading == false && allSearchLoaded == false &&
                                scroll.metrics.pixels == scroll.metrics.maxScrollExtent &&
                                searchValue != null && searchValue.trim().length > 0) {
                              setState(() {
                                isSearchLoading = true;
                                ++pagenumber;
                                getUserSearchResults(false, searchValue);

                              });
                            }
                            return;
                          },
                          child: ListView.builder(
                              itemCount: datauser.length,
                              itemBuilder:
                                  (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {

                                    setState(() {
                                      usernamecontroller.text=datauser[index].username;
                                      searchcontroller.text="";
                                      islistingshowing = false;
                                    });
                                   otherUid=datauser[index].id.toString();
                                   print("OtherUID $otherUid");
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: 15),
                                    child: Row(
                                      children: <Widget>[
                                        new Container(
                                            width: 35,
                                            height: 35,
                                            margin: EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: new DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: getProfileImage(
                                                        datauser[
                                                        index])))),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          datauser[index].username != null
                                              ? datauser[index].username
                                              : "",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              })),
                    ): GestureDetector(
                        onTap: () {
                         if(usernamecontroller.text!=null&&usernamecontroller.text.isNotEmpty){
                           requestExecutor();

                         }else{
                           displaytoast("Please choose username first", context);
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
                        )):GestureDetector(
                        onTap: () {
                          // if (_formKey.currentState.validate()) {
                          //   _formKey.currentState.save();
                          // }
                          if(usernamecontroller.text!=null&&usernamecontroller.text.isNotEmpty){
                            requestExecutor();

                          }else{
                            displaytoast("Please choose username first", context);
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
        ),
      ),
    );
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
              readOnly: true,
              controller: usernamecontroller,
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
                  borderSide: BorderSide(width: 1, color: getColorFromHex(AppColors.red)),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(width: 1, color: getColorFromHex(AppColors.red)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(width: 1, color: getColorFromHex(AppColors.red)),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1, color: getColorFromHex(AppColors.red))),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1, color:getColorFromHex(AppColors.red))),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1, color: getColorFromHex(AppColors.red))),
              )),
          width: 250,
        )
      ],
    );
  }



  void requestExecutor() async {
    ExecutorRequestParams executorRequestParams =ExecutorRequestParams();
    executorRequestParams.uid = MemoryManagement.getuserId();
    executorRequestParams.requestedUid = otherUid;

    var response = await _accountExecutorViewModel.requestexecutor(executorRequestParams, context);

    ExecutorResponse executorResponse = response;

    if (executorResponse != null) {
      if (executorResponse.status != null &&
          executorResponse.status.compareTo("success") == 0) {
        displaytoast(executorResponse.message, context);
        setState(() {
          //executorResponse.remove(executorResponse);
        });
      }
    }
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
      var response = await _accountExecutorViewModel.searchexecutorUser(params, context);
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
}
