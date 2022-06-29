import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:trybelocker/UniversalFunctions.dart';
import 'package:trybelocker/model/login/loginresponse.dart';
import 'package:trybelocker/model/updateprofile/update_profile_params.dart';
import 'package:trybelocker/model/updateprofile/update_profile_response.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/viewmodel/auth_view_model.dart';
import 'package:trybelocker/model/user_details.dart';
import 'home_screen.dart';

class CompleteProfileScreen extends StatefulWidget {
  UserDatas userData = UserDatas();

  CompleteProfileScreen([this.userData]);

  CompleteProfileScreenState createState() =>
      CompleteProfileScreenState(userData);
}

class CompleteProfileScreenState extends State<CompleteProfileScreen> {
  var _fullnamecontroller = TextEditingController();
  var _birthdatecontroller = TextEditingController();
  var _usernamecontroller = TextEditingController();
  var _passwordcontroller = TextEditingController();
  var _confirmpasswordcontroller = TextEditingController();
  DateTime selectedDate = DateTime.now();
  AuthViewModel _authViewModel;
  UserDatas userData = UserDatas();

  CompleteProfileScreenState(this.userData);

  @override
  void initState() {
    super.initState();
    if (userData.username != null && userData.username.toString().isNotEmpty)
      _usernamecontroller.text = userData.username.toString();
  }

  @override
  Widget build(BuildContext context) {
    _authViewModel = Provider.of<AuthViewModel>(context);
    return  Scaffold(
            backgroundColor: getColorFromHex(AppColors.black),
        appBar: AppBar(backgroundColor: Colors.transparent,elevation: 0.0, brightness: Brightness.dark,),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Complete Your Profile',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          margin: EdgeInsets.only(left: 20, top: 20, right: 20),
                          child: Row(
                            children: [
                              Text(
                                'Full Name',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Expanded(
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: TextFormField(
                                        controller: _fullnamecontroller,
                                        autofocus: false,
                                        maxLines: 1,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.red, width: 0.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.red, width: 0.0),
                                          ),
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          contentPadding: EdgeInsets.fromLTRB(
                                              5.0, 0, 0.0, 0.0),
                                        ))),
                              )
                            ],
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          margin: EdgeInsets.only(left: 20, top: 10, right: 20),
                          child: Row(
                            children: [
                              Text(
                                'Birthdate  ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Expanded(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: TextFormField(
                                          controller: _birthdatecontroller,
                                          maxLines: 1,
                                          autofocus: false,
                                          readOnly: true,
                                          onTap: () {
                                            _selectDate(context);
                                          },
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.red,
                                                  width: 0.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.red,
                                                  width: 0.0),
                                            ),
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            contentPadding: EdgeInsets.fromLTRB(
                                                5.0, 0, 0.0, 0.0),
                                          )))),
                            ],
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          margin: EdgeInsets.only(left: 20, top: 10, right: 20),
                          child: Row(
                            children: [
                              Text(
                                'Username',
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Expanded(
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: TextFormField(
                                        controller: _usernamecontroller,
                                        autofocus: false,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.red, width: 0.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.red, width: 0.0),
                                          ),
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          contentPadding: EdgeInsets.fromLTRB(
                                              5.0, 0, 0.0, 0.0),
                                        ))),
                              )
                            ],
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          margin: EdgeInsets.only(left: 20, top: 10, right: 20),
                          child: Row(
                            children: [
                              Text(
                                'Password ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Expanded(
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: TextFormField(
                                        maxLines: 1,
                                        controller: _passwordcontroller,
                                        obscureText: true,
                                        autofocus: false,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.red, width: 0.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.red, width: 0.0),
                                          ),
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          contentPadding: EdgeInsets.fromLTRB(
                                              5.0, 0, 0.0, 0.0),
                                        ))),
                              )
                            ],
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          margin: EdgeInsets.only(left: 20, top: 10, right: 20),
                          child: Row(
                            children: [
                              Text(
                                'Confirm \nPassword ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Expanded(
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: TextFormField(
                                        controller: _confirmpasswordcontroller,
                                        autofocus: false,
                                        maxLines: 1,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.red, width: 0.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.red, width: 0.0),
                                          ),
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          contentPadding: EdgeInsets.fromLTRB(
                                              5.0, 0, 0.0, 0.0),
                                        ))),
                              )
                            ],
                          )),
                      GestureDetector(
                          onTap: () {
                            // print("valid"=>passwordvalidation(_passwordcontroller.value.text))
                            if (_fullnamecontroller.value.text != null &&
                                _fullnamecontroller.value.text.trim().length >
                                    0) {
                              if (_birthdatecontroller.value.text != null &&
                                  _birthdatecontroller.value.text
                                          .trim()
                                          .length >
                                      0) {
                                if (_usernamecontroller.value.text != null &&
                                    _usernamecontroller.value.text
                                            .trim()
                                            .length >
                                        0) {
                                  if (_passwordcontroller.value.text != null &&
                                      _passwordcontroller.value.text
                                              .trim()
                                              .length >
                                          0) {
                                    if (_passwordcontroller.value.text
                                            .compareTo(
                                                _confirmpasswordcontroller
                                                    .value.text) ==
                                        0) {
                                      Update_profile_params request =
                                          Update_profile_params();
                                      request.userid = userData.id.toString();
                                      request.key = "1";
                                      request.fullName = _fullnamecontroller
                                          .value.text
                                          .toString();
                                      request.birthDate = _birthdatecontroller
                                          .value.text
                                          .toString();
                                      request.email = userData.email;
                                      request.phoneNumber =
                                          userData.phoneNumber;
                                      request.username = _usernamecontroller
                                          .value.text
                                          .toString();
                                      request.password = _passwordcontroller
                                          .value.text
                                          .toString();
                                      request.confirmPassword =
                                          _confirmpasswordcontroller.value.text
                                              .toString();
                                      request.privacy_type="1";

                                      updateprofileApi(request);
                                    } else {
                                      displaytoast(
                                          "Password is not match with confirm password",
                                          context);
                                    }
                                  } else {
                                    displaytoast(
                                        "Please enter password", context);
                                  }
                                } else {
                                  displaytoast(
                                      "Please enter username", context);
                                }
                              } else {
                                displaytoast("Please enter birthdate", context);
                              }
                            } else {
                              displaytoast("Please enter fullname", context);
                            }
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
                                      color: Colors.white, fontSize: 25),
                                )
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
                getFullScreenProviderLoader(
                    status: _authViewModel.getLoading(), context: context)
              ],
            ));
  }

  void updateprofileApi(Update_profile_params request) async {
    _authViewModel.setLoading();
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _authViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      var response = await _authViewModel.updateprofile(request, context);

      UpdateProfileResponse updateProfileResponse = response;

      if (updateProfileResponse.status.compareTo("success") == 0) {
        MemoryManagement.setUserLoggedIn(isUserLoggedin: true); //mar
        MemoryManagement.setuserName(
            username: updateProfileResponse.userData.username); //mar
        MemoryManagement.setPhonenumber(
            phonenumber: updateProfileResponse.userData.phoneNumber); //mar
        MemoryManagement.setuserId(
            id: updateProfileResponse.userData.id.toString());
        MemoryManagement.setbirthdate(
            birthdate: updateProfileResponse.userData.birthDate.toString());
        MemoryManagement.setEmail(
            email: updateProfileResponse.userData.email.toString());
        MemoryManagement.setfullName(
            fullname: updateProfileResponse.userData.fullName.toString());
        MemoryManagement.setAbout(
            about: updateProfileResponse.userData.about.toString());
        MemoryManagement.setlogintype(logintype: updateProfileResponse.userData.loginType.toString());

          MemoryManagement.setTrybegroupPrivate(trybegroupprivate: false);
          MemoryManagement.setTrybelistPrivate(trybelistprivate: false);

        List<UserDetail> userdetailsdata = [];
        if (MemoryManagement.getsaveotheraccounts() != null) {
          UserDetails userDetail = new UserDetails.fromJson(
              jsonDecode(MemoryManagement.getsaveotheraccounts()));
          if (userDetail != null &&
              userDetail.userDetails != null &&
              userDetail.userDetails.length > 0) {
            userdetailsdata.addAll(userDetail.userDetails);
          }
        }

        if (userdetailsdata.length > 0) {
          print("length>0");
          var contain = userdetailsdata.where((element) =>
              element.userid.compareTo(MemoryManagement.getuserId()) == 0);
          if (contain.isEmpty) {
            UserDetail userdetail = new UserDetail();
            userdetail.email = MemoryManagement.getEmail();
            userdetail.phonenumber = MemoryManagement.getPhonenumber();
            userdetail.password = "";
            userdetail.userimage = MemoryManagement.getuserprofilepic() != null
                ? MemoryManagement.getuserprofilepic()
                : "";
            userdetail.userid = MemoryManagement.getuserId();
            userdetail.username = MemoryManagement.getuserName();
            userdetail.about = MemoryManagement.getAbout();
            userdetail.logintype = MemoryManagement.getlogintype();
            userdetailsdata.add(userdetail);
          }
        } else {
          print("length<0");
          UserDetail userdetail = new UserDetail();
          userdetail.email = MemoryManagement.getEmail();
          userdetail.phonenumber = MemoryManagement.getPhonenumber();
          userdetail.password = "";
          userdetail.userimage = MemoryManagement.getuserprofilepic() != null
              ? MemoryManagement.getuserprofilepic()
              : "";
          userdetail.userid = MemoryManagement.getuserId();
          userdetail.username = MemoryManagement.getuserName();
          userdetail.about = MemoryManagement.getAbout();
          userdetail.logintype = MemoryManagement.getlogintype();
          userdetailsdata.add(userdetail);
        }

        UserDetails user = new UserDetails(userDetails: userdetailsdata);
        var loggedinvalue = json.encode(user);
        MemoryManagement.setsaveotheraccounts(userDetails: loggedinvalue);
        print(MemoryManagement.getsaveotheraccounts());

        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        showtoast("Something went wrong");
        displaytoast("Something went wrong",context);
      }

      //check if request was successful or not
      // if (response is APIError) {
      //   APIError apiError = response;
      //   Toast.show(apiError.message.toString(), context,
      //       duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      // } else {
      //navigate to verify otp

      // }
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _birthdatecontroller.text =
            "${formatDateString(selectedDate.toString(), "dd/MM/yyyy")}";
      });
  }
}
