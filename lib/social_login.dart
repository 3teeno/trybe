

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trybelocker/UniversalFunctions.dart';
import 'package:trybelocker/completeprofilescreen.dart';
import 'package:trybelocker/home_screen.dart';
import 'package:trybelocker/login_screen.dart';
import 'package:trybelocker/model/login/login_params.dart';
import 'package:trybelocker/model/login/loginresponse.dart';
import 'package:trybelocker/model/registration/registration_params.dart';
import 'package:trybelocker/model/registration/registration_response.dart';
import 'package:trybelocker/model/updateprofile/update_profile_params.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/viewmodel/auth_view_model.dart';
import 'package:provider/src/provider.dart';
import 'package:toast/toast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'package:trybelocker/model/user_details.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_twitter/flutter_twitter.dart';
// import 'package:apple_sign_in/apple_sign_in.dart';

class SocialLogin extends StatefulWidget {
  static const String TAG = "/sociallogin";

  SocialLoginState createState() => SocialLoginState();
}

class SocialLoginState extends State<SocialLogin> with TickerProviderStateMixin{
  final facebookLogin = FacebookLogin();
  var emailorphonenumber = TextEditingController();
  AuthViewModel _authViewModel;
  var otpcontroller = TextEditingController();
  var isLoading = false;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  // final TwitterLogin twitterLogin = new TwitterLogin(
  //   consumerKey: 'LPcdZfEt2JYsZhXQJIl2L5mwh',
  //   consumerSecret: 'pGFsizEKok3GHwzZXzltFaxjIWUZc7MlN0kAjILDjZ1XgUzwma',
  // );
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map userProfile;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  var devicetoken = null;

  AnimationController controller;
  Animation<Offset> offset;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    offset = Tween<Offset>(begin: Offset(0,1) , end: Offset.zero)
        .animate(controller);


    controller.forward();

    getdevicetoken();
  }

  @override
  Widget build(BuildContext context) {
    _authViewModel = Provider.of<AuthViewModel>(context);

    BoxShadow boxShadow = BoxShadow(
      color: Colors.grey[350],
      blurRadius: 5.0,
    );

    return Scaffold(
      body: Material(
        color: getColorFromHex('#F8CBAD'),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
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
                  child:SlideTransition(
                    position: offset,
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new GestureDetector(
                              onTap: () {
                                signInWithGoogle().then((result) async {
                                  if (result != null) {
                                    UserDatas userdatas = new UserDatas();
                                    userdatas.fullName = result.displayName;
                                    userdatas.username = result.displayName;
                                    userdatas.email = result.email;
                                    userdatas.userImage = result.photoURL;
                                    userdatas.socialId = result.uid;
                                    userdatas.device_token = devicetoken;

                                    socialsignin(userdatas);

                                    // Navigator.of(context).push(MaterialPageRoute(
                                    //     builder: (context) => HomeScreen()));

                                    // LoginRequest loginRequest = LoginRequest();
                                    // var userName = result.displayName;
                                    // var firstLastName = userName.split(" ");
                                    // if (firstLastName.length >= 2) {
                                    //   loginRequest.firstname =
                                    //       firstLastName.first;
                                    //   loginRequest.lastname =
                                    //       firstLastName.last;
                                    // } else {
                                    //   loginRequest.firstname = userName;
                                    //   loginRequest.lastname = "";
                                    // }
                                    // loginRequest.fullName = userName;
                                    // loginRequest.email = result.email;
                                    // loginRequest.socialid = result.uid;
                                    // loginRequest.avatar = result.photoURL;
                                    // loginRequest.provider =
                                    //     AUTHTYPE.Google.toString()
                                    //         .split(".")
                                    //         .last
                                    //         .toLowerCase();
                                    //
                                    // _doSocialLogin(loginRequest);
                                  } else {
                                    // showToastWidget(Text(
                                    //     "Login via Google failed. Please Retry."));
                                  }
                                });
                              },
                              child: Image.asset("assets/google.png",
                                  height: 40, width: 40),
                            ),
                            Visibility(
                                visible:Platform.isIOS,
                                child:
                                SizedBox(
                                  width: 15,
                                )),
                            // new GestureDetector(
                            //   onTap: () {},
                            //   child: Image.asset("assets/instagram.png",
                            //       height: 40, width: 40),
                            // ),
                            Visibility(
                              visible:Platform.isIOS,
                              child:InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  // applesignin().then((result) {
                                  //
                                  //   if (result != null) {
                                  //
                                  //     if (result.displayName!=null&&result.displayName.trim().length>0){
                                  //       UserDatas userdatas = new UserDatas();
                                  //       userdatas.fullName = result.displayName;
                                  //       userdatas.username = result.displayName;
                                  //       userdatas.email = result.email;
                                  //       userdatas.socialId = result.uid;
                                  //       userdatas.userImage = result.photoURL;
                                  //       userdatas.device_token = devicetoken;
                                  //
                                  //       socialsignin(userdatas);
                                  //
                                  //       Navigator.of(context).push(MaterialPageRoute(
                                  //           builder: (context) => HomeScreen()));
                                  //     }else{
                                  //       UserDatas userdatas = new UserDatas();
                                  //       userdatas.fullName = result.displayName;
                                  //       userdatas.username = result.displayName;
                                  //       userdatas.email = result.email;
                                  //       userdatas.socialId = result.uid;
                                  //       userdatas.userImage = result.photoURL;
                                  //       userdatas.device_token = devicetoken;
                                  //
                                  //       socialsignin(userdatas);
                                  //
                                  //       Navigator.of(context).push(MaterialPageRoute(
                                  //           builder: (context) => HomeScreen()));
                                  //     }
                                  //   } else {
                                  //
                                  //     displaytoast("Login via Apple failed. Please Retry.", context);
                                  //   }
                                  // });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white
                                  ),
                                  child: Image.asset( "assets/appleicon.png",
                                      height: 41, width:41),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            new GestureDetector(
                              onTap: () {
                                // signInWithTwitter().then((result) {
                                //   if (result != null) {
                                //     UserDatas userdatas = new UserDatas();
                                //     userdatas.fullName = result.displayName;
                                //     userdatas.username = result.displayName;
                                //     userdatas.email = result.email;
                                //     userdatas.userImage = result.photoURL;
                                //     userdatas.socialId = result.uid;
                                //     userdatas.device_token = devicetoken;
                                //
                                //     print(result.displayName);
                                //     print(result.email);
                                //     print(result.photoURL);
                                //     print(result.uid);
                                //
                                //     socialsignin(userdatas);
                                //   } else {
                                //     print("error ${result}");
                                //   }
                                // });
                              },
                              child: Image.asset("assets/twitter.png",
                                  height: 40, width: 40),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            new GestureDetector(
                              onTap: () {
                                signInWithFacebook().then((result) {
                                  if (result != null) {
                                    UserDatas userdatas = new UserDatas();
                                    userdatas.fullName =
                                        result["name"].toString();
                                    userdatas.username =
                                        result["name"].toString();
                                    userdatas.email = result["email"];
                                    userdatas.userImage =
                                    result["picture"]["data"]["url"];
                                    userdatas.socialId = int.parse(result["id"]);
                                    userdatas.device_token = devicetoken;

                                    socialsignin(userdatas);
                                  } else {
                                    print("error ${result}");
                                  }
                                });
                              },
                              child: Image.asset("assets/facebook.png",
                                  height: 40, width: 40),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: 30,
                          width: 250,
                          decoration: BoxDecoration(color: Colors.white),
                          child: TextFormField(
                            autofocus: false,
                            textAlign: TextAlign.center,
                            controller: emailorphonenumber,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: 'Email/Phone',
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
                        GestureDetector(
                            onTap: () {
                              if (emailorphonenumber.value.text != null && emailorphonenumber.value.text.trim().length > 0) {
                                if (emailvalidation(emailorphonenumber.value.text.trim())) {
                                  RegistrationParams registrationparams =
                                  RegistrationParams();
                                  registrationparams.emailPhone = emailorphonenumber.value.text.trim();
                                  registrationparams.device_token = devicetoken;
                                  registrationapi(registrationparams, 1,
                                      emailorphonenumber.value.text.trim());
                                } else if (phonevalidation(
                                    emailorphonenumber.value.text.trim())) {
                                  RegistrationParams registrationparams =
                                  RegistrationParams();
                                  registrationparams.emailPhone =
                                      emailorphonenumber.value.text.trim();
                                  registrationparams.device_token = devicetoken;
                                  registrationapi(registrationparams, 2,
                                      emailorphonenumber.value.text.trim());
                                } else {
                                  // showtoast("Please enter valid email or phone number");
                                  displaytoast(
                                      "Please enter valid email or mobile number",
                                      context);
                                }
                              } else {
                                // showtoast("Please enter email or mobile number");
                                displaytoast(
                                    "Please enter email or mobile number",
                                    context);
                              }
                            },
                            child: Container(
                                height: 30,
                                width: 250,
                                decoration: BoxDecoration(
                                    color: getColorFromHex('#A10000')),
                                child: Center(
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ))),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Already have an account.',
                                style:
                                TextStyle(color: Colors.black, fontSize: 14)),
                            SizedBox(
                              width: 2,
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                                },
                                child: Text('Login',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14))),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        )
                      ],
                    ),
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

  void registrationapi(
      RegistrationParams request, int i, String phoneoremail) async {
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
      var response = await _authViewModel.registration(request, context);

      print(response.toString());

      RegistrationResponse registrationResponse = response;

      print(registrationResponse.toString());

      if (registrationResponse != null) {
        if (registrationResponse.status.compareTo("success") == 0) {
          if (registrationResponse.otp != null) {
            otpcontroller.text = registrationResponse.otp.toString();
            verifyotp(i, phoneoremail, registrationResponse.otp);
          }
        } else {
          displaytoast(registrationResponse.message, context);
        }
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

  void loginApi(LoginParams request) async {
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
      var response = await _authViewModel.login(request, context);

      Loginresponse loginresponse = response;

      if (loginresponse.status.compareTo("success") == 0) {
        if (loginresponse.Isdeleted != null &&
            loginresponse.Isdeleted == true) {
          displaytoast("Something went wrong", context);
        } else {
          if (loginresponse.userData != null &&
              loginresponse.userData.id != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CompleteProfileScreen(loginresponse.userData)));
          }
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

  void verifyotp(int key, String phoneoremail, int otp) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Please enter otp',
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
                            controller: otpcontroller,
                            maxLines: 1,
                            minLines: 1,
                            maxLength: 4,
                            keyboardType: TextInputType.number,
                            autofocus: false,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: "Gilroy-SemiBold",
                                color: Color.fromRGBO(60, 72, 88, 1),
                                fontSize: 16.7),
                            onFieldSubmitted: (trem) {
                              LoginParams loginParams = LoginParams();
                              loginParams.emailPhone = phoneoremail;
                              loginParams.key = key.toString();
                              loginParams.otp = otpcontroller.value.text.trim();
                              loginParams.device_token=devicetoken;
                              loginApi(loginParams);
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: "Enter Otp",
                                contentPadding:
                                EdgeInsets.fromLTRB(5.0, 0, 0.0, 0.0),
                                hintStyle: TextStyle(
                                    fontFamily: "Gilroy-Regular", fontSize: 13.3)),
                          ),
                        )),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Future<User> signInWithGoogle() async {
    await Firebase.initializeApp();

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
    await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      print('signInWithGoogle succeeded: $user');

      return user;
    }

    return null;
  }

  // Future<User> signInWithTwitter() async {
  //   final TwitterLoginResult result = await twitterLogin.authorize();
  //   switch (result.status) {
  //     case TwitterLoginStatus.loggedIn:
  //       var session = result.session;
  //       final AuthCredential credential = TwitterAuthProvider.credential(accessToken: session.token, secret: session.secret);
  //
  //       try{
  //         UserCredential firebaseUser = await _auth.signInWithCredential(credential);
  //         final User user = firebaseUser.user;
  //         if (user != null) {
  //           assert(!user.isAnonymous);
  //           assert(await user.getIdToken() != null);
  //
  //           final User currentUser = _auth.currentUser;
  //           assert(user.uid == currentUser.uid);
  //
  //           print('signInWithGoogle succeeded: $user');
  //
  //           return user;
  //         }
  //       }catch(e){
  //         displaytoast("User is already exists with this email", context);
  //       }
  //       break;
  //     case TwitterLoginStatus.cancelledByUser:
  //       return null;
  //       break;
  //     case TwitterLoginStatus.error:
  //       return null;
  //       break;
  //   }
  // }

  Future<Map> signInWithFacebook() async {
    final result = await facebookLogin.logIn(permissions: [
      FacebookPermission.email,
      FacebookPermission.publicProfile,
    ]);
    print("status=>${result.status}");
    switch (result.status) {
      case FacebookLoginStatus.success:
        print("status1");
        final token = result.accessToken.token;
        final graphResponse = await http.get(Uri.parse(
            'https://graph.facebook.com/v2.12/me?fields=name,picture.width(800).height(800),email&access_token=${token}'));

        print("graphresponse=>${graphResponse.body}");

        final profile = JSON.jsonDecode(graphResponse.body);

        setState(() {
          userProfile = profile;
        });
        return userProfile;
        break;
      case FacebookLoginStatus.cancel:
        print("status2");
        return null;
        break;
      case FacebookLoginStatus.error:
        print("status3=>${result.error}");
        return null;
        break;
    }
  }

  void socialsignin(UserDatas userdatas) async {
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
      print("request=>,$userdatas");
      var response = await _authViewModel.sociallogin(userdatas, context);

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
          MemoryManagement.setuserprofilepic(profilepic: loginresponse.userData.userImage);
          MemoryManagement.setcoverphoto(coverphoto: loginresponse.userData.cover_photo.toString());
          MemoryManagement.setEmail(email: loginresponse.userData.email);
          MemoryManagement.setPhonenumber(phonenumber: loginresponse.userData.phoneNumber);
          MemoryManagement.setAbout(about: loginresponse.userData.about);
          MemoryManagement.setbirthdate(birthdate: loginresponse.userData.birthDate);
          MemoryManagement.setlogintype(
              logintype: loginresponse.userData.loginType.toString());
          if(loginresponse.checkPrivateData!=null) {
            if(loginresponse.checkPrivateData.isGroupPrivate.compareTo("1")==0)
              MemoryManagement.setTrybegroupPrivate(trybegroupprivate: true);
            else
              MemoryManagement.setTrybegroupPrivate(trybegroupprivate: false);

            if(loginresponse.checkPrivateData.isPlaylistPrivate.compareTo("1")==0)
              MemoryManagement.setTrybelistPrivate(trybelistprivate: true);
            else
              MemoryManagement.setTrybelistPrivate(trybelistprivate: false);
          }else{
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
            userdetailsdata.add(userdetail);
          }

          UserDetails user = new UserDetails(userDetails: userdetailsdata);
          var loggedinvalue = json.encode(user);
          MemoryManagement.setsaveotheraccounts(userDetails: loggedinvalue);
          print(MemoryManagement.getsaveotheraccounts());
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomeScreen()));
        }
      } else {
        displaytoast(loginresponse.message, context);
      }
    }
  }

  void getdevicetoken() async {
    await _firebaseMessaging.getToken().then((value) {
      devicetoken = value;
    });
  }

  // Future<User> applesignin() async {
  //   await Firebase.initializeApp();
  //
  //
  //   final result  = await AppleSignIn.performRequests([
  //     AppleIdRequest(requestedScopes: [Scope.email,Scope.fullName])
  //   ]);
  //
  //   print("successfull sign in");
  //   final AppleIdCredential appleIdCredential = result.credential;
  //
  //   OAuthProvider oAuthProvider =
  //   new OAuthProvider("apple.com");
  //
  //   final AuthCredential credential = oAuthProvider.credential(idToken:
  //   String.fromCharCodes(appleIdCredential.identityToken),
  //     accessToken:
  //     String.fromCharCodes(appleIdCredential.authorizationCode),
  //   );
  //
  //
  //   final UserCredential authResult = await _auth.signInWithCredential(credential);
  //
  //   final User user = authResult.user;
  //
  //   if (user!=null){
  //
  //
  //     print("8=>");
  //     print("signInWithApple: ${user}");
  //
  //     return user;
  //   }
  //
  //   return null;
  //
  // }

}
