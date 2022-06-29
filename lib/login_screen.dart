import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:trybelocker/UniversalFunctions.dart';
import 'package:trybelocker/home_screen.dart';
import 'package:trybelocker/model/login/login_params.dart';
import 'package:trybelocker/model/login/loginresponse.dart';
import 'package:trybelocker/model/receiveotpresetpassword/receive_otp_reset_password_params.dart';
import 'package:trybelocker/model/receiveotpresetpassword/receive_otp_reset_password_response.dart';
import 'package:trybelocker/model/sendotptoresetpassword/send_otp_params.dart';
import 'package:trybelocker/model/sendotptoresetpassword/send_otp_response.dart';
import 'package:trybelocker/model/user_details.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/viewmodel/auth_view_model.dart';

import 'forgotpassword/AccessAccount.dart';

class LoginScreen extends StatefulWidget {
  static const String TAG = "/loginscreen";

  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  var emailorphonenumbercontroller = TextEditingController();
  var passwordcontroller = TextEditingController();
  var emailphonecontroller = TextEditingController();
  var otpController = TextEditingController();
  AuthViewModel _authViewModel;
  bool isotpenabled = false;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String devicetoken = null;

  @override
  void initState() {
    // TODO: implement initState
    getdevicetoken();
    super.initState();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      body: Material(
        color: getColorFromHex('#F8CBAD'),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: Container(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset("assets/logo.png",
                          height: MediaQuery.of(context).size.width,
                          width: MediaQuery.of(context).size.width),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 40,
                        width: 250,
                        decoration: BoxDecoration(color: Colors.white),
                        child: TextFormField(
                          autofocus: false,
                          textAlign: TextAlign.left,
                          controller: emailorphonenumbercontroller,
                          // focusNode: emailfocusnode,
                          // onTap: (){
                          //   emailfocusnode.requestFocus();
                          // },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: 'Phone/Email/Username',
                            contentPadding:
                                EdgeInsets.only(left: 10.0, bottom: 10.0),
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 40,
                        width: 250,
                        decoration: BoxDecoration(color: Colors.white),
                        child: TextFormField(
                          autofocus: false,
                          textAlign: TextAlign.left,
                          obscureText: true,
                          controller: passwordcontroller,
                          // focusNode: passwordfocusnode,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: 'Password',
                            contentPadding:
                                EdgeInsets.only(left: 10.0, bottom: 10.0),
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            if (emailorphonenumbercontroller.value.text !=
                                    null &&
                                emailorphonenumbercontroller.value.text
                                        .trim()
                                        .length >
                                    0) {
                              if (emailvalidation(emailorphonenumbercontroller
                                  .value.text
                                  .trim())) {
                                if (passwordvalidation(
                                    emailorphonenumbercontroller.value.text
                                        .trim())) {
                                  LoginParams request = LoginParams();
                                  request.emailPhone =
                                      emailorphonenumbercontroller.value.text
                                          .trim();
                                  request.password =
                                      passwordcontroller.value.text.trim();
                                  request.device_token = devicetoken;
                                  request.key = "3";
                                  loginApi(request);
                                } else {
                                  displaytoast(
                                      "Please enter password", context);
                                }
                              } else if (phonevalidation(
                                  emailorphonenumbercontroller.value.text
                                      .trim())) {
                                if (passwordvalidation(
                                    emailorphonenumbercontroller.value.text
                                        .trim())) {
                                  LoginParams request = LoginParams();
                                  request.emailPhone =
                                      emailorphonenumbercontroller.value.text
                                          .trim();
                                  request.password =
                                      passwordcontroller.value.text.trim();
                                  request.device_token = devicetoken;
                                  request.key = "3";
                                  loginApi(request);
                                } else {
                                  displaytoast(
                                      "Please enter password", context);
                                }
                              } else if (emailorphonenumbercontroller
                                  .value.text.isNotEmpty) {
                                LoginParams request = LoginParams();
                                request.emailPhone =
                                    emailorphonenumbercontroller.value.text
                                        .trim();
                                request.password =
                                    passwordcontroller.value.text.trim();
                                request.device_token = devicetoken;
                                request.key = "3";
                                loginApi(request);
                              }
                            } else {
                              displaytoast(
                                  "Please enter email or mobile number",
                                  context);
                            }
                          },
                          child: Container(
                              height: 40,
                              width: 250,
                              decoration: BoxDecoration(
                                  color: getColorFromHex('#A10000')),
                              child: Center(
                                child: Text(
                                  'LogIn',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ))),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AccessAccount()));
                          },
                          child: Text('Forgot Password',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 14))),
                      SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                )
              ],
            ),
            getFullScreenProviderLoader(
                status: _authViewModel.getLoading(), context: context)
          ],
        ),
      ),
    );
  }

  void loginApi(LoginParams request) async {
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
      var response = await _authViewModel.login(request, context);

      Loginresponse loginresponse = response;

      if (loginresponse.status.compareTo("success") == 0) {
        if (loginresponse.Isdeleted != null &&
            loginresponse.Isdeleted == true) {
          displaytoast("Something went wrong", context);
        } else {
          MemoryManagement.setUserLoggedIn(isUserLoggedin: true);
          MemoryManagement.setuserId(id: loginresponse.userData.id.toString());
          MemoryManagement.setuserName(
              username: loginresponse.userData.username);
          MemoryManagement.setfullName(
              fullname: loginresponse.userData.fullName);
          MemoryManagement.setuserprofilepic(
              profilepic: loginresponse.userData.userImage);
          MemoryManagement.setEmail(email: loginresponse.userData.email);
          MemoryManagement.setPhonenumber(
              phonenumber: loginresponse.userData.phoneNumber);
          MemoryManagement.setPayment(payment: loginresponse.userData.payment);
          MemoryManagement.setlogintype(
              logintype: loginresponse.userData.loginType.toString());
          MemoryManagement.setcoverphoto(
              coverphoto: loginresponse.userData.cover_photo.toString());
          MemoryManagement.setAbout(
              about: loginresponse.userData.about.toString());
          MemoryManagement.setlogintype(
              logintype: loginresponse.userData.loginType.toString());
          if (loginresponse.checkPrivateData != null) {
            if (loginresponse.checkPrivateData.isGroupPrivate.compareTo("1") ==
                0)
              MemoryManagement.setTrybegroupPrivate(trybegroupprivate: true);
            else
              MemoryManagement.setTrybegroupPrivate(trybegroupprivate: false);

            if (loginresponse.checkPrivateData.isPlaylistPrivate
                    .compareTo("1") ==
                0)
              MemoryManagement.setTrybelistPrivate(trybelistprivate: true);
            else
              MemoryManagement.setTrybelistPrivate(trybelistprivate: false);
          } else {
            MemoryManagement.setTrybegroupPrivate(trybegroupprivate: false);
            MemoryManagement.setTrybelistPrivate(trybelistprivate: false);
          }

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
              userdetail.userimage =
                  MemoryManagement.getuserprofilepic() != null
                      ? MemoryManagement.getuserprofilepic()
                      : "";
              userdetail.userid = MemoryManagement.getuserId();
              userdetail.username = MemoryManagement.getuserName();
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
            userdetail.logintype = MemoryManagement.getlogintype();
            userdetailsdata.add(userdetail);
          }

          UserDetails user = new UserDetails(userDetails: userdetailsdata);
          var loggedinvalue = json.encode(user);

          print("Login Whole Data$loggedinvalue");
          MemoryManagement.setsaveotheraccounts(userDetails: loggedinvalue);
          print(MemoryManagement.getsaveotheraccounts());
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomeScreen()));
        }
      } else {
        // showtoast("Something went wrong");
        displaytoast(loginresponse.message, context);
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

  void emaildialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return WillPopScope(
              onWillPop: () async => false,
              child: Dialog(
                insetPadding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                            onTap: () {
                              emailphonecontroller.text = null;
                              otpController.text = null;
                              Navigator.of(context).pop();
                            },
                            child: Container(
                                margin: EdgeInsets.only(right: 20),
                                child: Icon(Icons.cancel)))),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      'Please enter Email/Phonenumber',
                      style: TextStyle(fontSize: 18.3),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: getColorFromHex(AppColors.black)),
                              borderRadius: BorderRadius.circular(10)),
                          // key: _creditsformKey,
                          child: TextFormField(
                            controller: emailphonecontroller,
                            maxLines: 1,
                            minLines: 1,
                            keyboardType: TextInputType.text,
                            autofocus: false,
                            enabled: otpController.value.text != null
                                ? otpController.value.text.trim().length > 0
                                    ? false
                                    : true
                                : true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(60, 72, 88, 1),
                                fontSize: 16.7),
                            onFieldSubmitted: (trem) {},
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: "Enter Email/Phonenumber",
                                contentPadding:
                                    EdgeInsets.fromLTRB(5.0, 0, 0.0, 0.0),
                                hintStyle: TextStyle(
                                    fontFamily: "Gilroy-Regular",
                                    fontSize: 13.3)),
                          ),
                        )),
                      ],
                    ),
                    Visibility(
                      visible: otpController.value.text != null
                          ? otpController.value.text.trim().length > 0
                              ? true
                              : false
                          : false,
                      child: Row(
                        children: [
                          Expanded(
                              child: Container(
                            margin:
                                EdgeInsets.only(left: 20, right: 20, top: 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: getColorFromHex(AppColors.black)),
                                borderRadius: BorderRadius.circular(10)),
                            child: TextFormField(
                              controller: otpController,
                              maxLines: 1,
                              minLines: 1,
                              maxLength: 4,
                              keyboardType: TextInputType.number,
                              autofocus: false,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromRGBO(60, 72, 88, 1),
                                  fontSize: 16.7),
                              onFieldSubmitted: (trem) {},
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  hintText: "Enter Email/Phonenumber",
                                  contentPadding:
                                      EdgeInsets.fromLTRB(5.0, 0, 0.0, 0.0),
                                  hintStyle: TextStyle(
                                      fontFamily: "Gilroy-Regular",
                                      fontSize: 13.3)),
                            ),
                          )),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (otpController.value.text.isEmpty &&
                            isotpenabled != true) {
                          if (emailphonecontroller.value.text != null &&
                              emailphonecontroller.value.text.trim().length >
                                  0) {
                            if (emailvalidation(
                                emailphonecontroller.value.text.trim())) {
                              Send_otp_params send_otp_params =
                                  Send_otp_params();
                              send_otp_params.emailPhone =
                                  emailphonecontroller.value.text.trim();
                              sendotpapi(send_otp_params, setState);
                            } else if (phonevalidation(
                                emailphonecontroller.value.text.trim())) {
                              Send_otp_params send_otp_params =
                                  Send_otp_params();
                              send_otp_params.emailPhone =
                                  emailphonecontroller.value.text.trim();
                              sendotpapi(send_otp_params, setState);
                            } else {
                              displaytoast(
                                  "Please enter valid email or phone number",
                                  context);
                            }
                          } else {
                            displaytoast(
                                "Please enter email or mobile number", context);
                          }
                        } else {
                          emailphonecontroller.text = null;
                          otpController.text = null;
                          // receiveotpapi(request, setState);
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20, top: 10),
                        padding: EdgeInsets.only(
                            left: 40, top: 10, bottom: 10, right: 40),
                        decoration: BoxDecoration(
                            color: getColorFromHex(AppColors.red),
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  void sendotpapi(Send_otp_params request, setState) async {
    // Navigator.of(context).pop();
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
      var response = await _authViewModel.sendotp(request, context);

      Send_otp_response send_otp_response = response;

      if (send_otp_response.status.compareTo("success") == 0) {
        displaytoast(send_otp_response.message, context);
        if (send_otp_response.otp != null &&
            send_otp_response.otp.toString().trim().length > 0) {
          otpController.text = send_otp_response.otp.toString().trim();
          if (otpController.text.isNotEmpty) {
            isotpenabled = true;
          } else {
            isotpenabled = false;
          }
        }
        setState(() {});
      } else {
        displaytoast(send_otp_response.message, context);
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

  void receiveotpapi(Receiveotpresetpasswordparams request, setState) async {
    Navigator.of(context).pop();
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
      var response = await _authViewModel.receiveotp(request, context);

      ReceiveOtpResetPasswordResponse otpResetPasswordResponse = response;

      if (otpResetPasswordResponse.status.compareTo("success") == 0) {
        displaytoast(otpResetPasswordResponse.message, context);

        setState(() {});
      } else {
        displaytoast(otpResetPasswordResponse.message, context);
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

  void getdevicetoken() async {
    await _firebaseMessaging.getToken().then((value) {
      devicetoken = value;
    });
  }
}
