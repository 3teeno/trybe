import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:trybelocker/model/login/loginresponse.dart';
import 'package:trybelocker/model/user_details.dart';
import 'package:trybelocker/networkmodel/APIs.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';

import '../../UniversalFunctions.dart';

class CreateGroundedScreen extends StatefulWidget {
  static const String TAG = "/create_grounded";

  bool isaccountsaved;

  CreateGroundedScreen(this.isaccountsaved);

  @override
  CreateGroundedScreenState createState() =>
      CreateGroundedScreenState(isaccountsaved);
}

class CreateGroundedScreenState extends State<CreateGroundedScreen> {
  final _formKey = GlobalKey<FormState>();
  var usernamecontroller = TextEditingController();
  var passwordcontroller = TextEditingController();
  File _image;
  bool isPicLoaded = false;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  var devicetoken = null;

  bool isaccountsaved;

  CreateGroundedScreenState(this.isaccountsaved);

  @override
  void initState() {
    super.initState();
    getdevicetoken();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: getColorFromHex(AppColors.black),
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text(
          "Settings",
        ),
        backgroundColor: getColorFromHex(AppColors.black),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Center(
              child: Container(
                child: Column(
                  children: [
                    groundedaccontheader('Create Grounded Account'),
                    // settingsHeader('Create Grounded Account',MemoryManagement.getuserprofilepic()),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          setFormField("Username", false, usernamecontroller),
                          SizedBox(
                            height: 15,
                          ),
                          setFormField("Password", true, passwordcontroller),
                          SizedBox(
                            height: 30,
                          ),
                          GestureDetector(
                              onTap: () {
                                // if (_formKey.currentState.validate()) {
                                //   _formKey.currentState.save();
                                // }
                                // navigateToNextScreen(context, false, GroundedAccountProfile());
                                if (_image != null) {
                                  if (_formKey.currentState.validate())
                                    updateprofilepic(_image.readAsBytesSync());
                                } else {
                                  displaytoast(
                                      "Please select image first", context);
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
                  ],
                ),
              ),
            ),
          ),
          getFullScreenProviderLoader(status: isPicLoaded, context: context)
        ],
      ),
    );
  }

  setFormField(String title, pwdType, TextEditingController controller) {
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
              controller: controller,
              validator: (String arg) {
                if (title.compareTo("Username") == 0) {
                  if (arg.length < 7)
                    return 'Username should be more than 6 letter';
                  else
                    return null;
                } else if (title.compareTo("Password") == 0) {
                  if (arg.length < 8)
                    return 'Password should be more than 7 letter';
                  else
                    return null;
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
          width: 250,
        )
      ],
    );
  }

  groundedaccontheader(title) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        // Container(
        //   width: 80,
        //   height: 80,
        //   margin:
        //   EdgeInsets.fromLTRB(2, 10, 2, 2),
        //   child: ClipOval(
        //     child: getuserprofilepic(),
        //   ),),
        circularImage(),
        SizedBox(
          height: 20,
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget circularImage() {
    return Padding(
      padding: EdgeInsets.only(top: 15.0),
      child: new Stack(fit: StackFit.loose, children: <Widget>[
        new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new GestureDetector(
              onTap: () {
                showMediaOptions(
                  context,
                );
                // getImage();
              },
              child: new Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 4, color: Colors.white),
                ),
                // child: ClipOval(
                //     child: getProfileImage(MemoryManagement.getuserprofilepic())
                // ),
                child: _image != null
                    ? ClipOval(
                        child: Image.file(
                          _image,
                          fit: BoxFit.cover,
                        ),
                      )
                    : ClipOval(child: getProfileImage()),
              ),
            ),
          ],
        ),
        new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new GestureDetector(
              onTap: () {
                // getImage();
                showMediaOptions(context);
              },
              child: Container(
                width: 38.0,
                height: 38.0,
                margin: EdgeInsets.fromLTRB(80, 60, 20, 0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white70,
                ),
                child: Center(
                  child: Icon(
                    Icons.camera_alt,
                    color: getColorFromHex(AppColors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }

  getProfileImage(/*String userImage*/) {
    // if(userImage != null && userImage.isNotEmpty){
    //   if (userImage.contains("https") || userImage.contains("http")){
    //     return getCachedNetworkImage(url:userImage,fit: BoxFit.fill);
    //   }else{
    //     return getCachedNetworkImage(url:APIs.userprofilebaseurl +userImage,fit: BoxFit.fill);
    //   }
    // }else{
    return getCachedNetworkImage(
        url:
            "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80",
        fit: BoxFit.cover);
    // }
  }

  void showMediaOptions(BuildContext context) async {
    var result = await PhotoManager.requestPermission();
    if (result) {
      showGeneralDialog(
        barrierLabel: "Label",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 700),
        context: context,
        pageBuilder: (contexts, anim1, anim2) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                height: 230,
                margin: EdgeInsets.only(bottom: 20, left: 12, right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    new InkWell(
                      onTap: () {
                        _closeActionSheet(context);
                        getImagefromcamera();
                      },
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 20.0,
                          ),
                          Image(
                              image: AssetImage('assets/takephoto.png'),
                              height: 30,
                              width: 30),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            'Take Photo',
                            style: TextStyle(
                                color: getColorFromHex(AppColors.black),
                                fontSize: 15),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    new InkWell(
                      onTap: () async {
                        _closeActionSheet(context);
                        getImagefromgallery();
                      },
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 20.0,
                          ),
                          Image(
                            image: AssetImage('assets/gallery.png'),
                            height: 30,
                            width: 30,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            'Pick From Gallery',
                            style: TextStyle(
                                color: getColorFromHex(AppColors.black),
                                fontFamily: 'Gilroy-SemiBold',
                                fontSize: 15),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    new InkWell(
                        onTap: () {
                          _closeActionSheet(context);
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(20, 0, 15, 20),
                          width: double.infinity,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(27.7)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: Offset(
                                    2.0, 2.0), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'cancel',
                              style: TextStyle(
                                  color: getColorFromHex(AppColors.black),
                                  fontSize: 16.7,
                                  fontFamily: 'Gilroy-SemiBold'),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return SlideTransition(
            position:
                Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
            child: child,
          );
        },
      );
    } else {
      PhotoManager.openSetting();
    }
  }

  Future getImagefromgallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        if (_image != null) {
          Uint8List bytes = _image.readAsBytesSync();
          // updateprofilepic(bytes,key);
        }
      } else {
        print('No image selected.');
      }
    });
  }

  void updateprofilepic(Uint8List image) async {
    setState(() {
      isPicLoaded = true;
    });
    var request =
        http.MultipartRequest('POST', Uri.parse(APIs.creategroundedaccount));
    request.fields['uid'] = MemoryManagement.getuserId();
    request.fields['email_phone'] = usernamecontroller.text;
    request.fields["password"] = passwordcontroller.text;
    request.files.add(http.MultipartFile.fromBytes(
      'user_image', image, filename: "test",
      // contentType: MediaType('application', 'octet-stream'),
    ));
    request.fields["device_token"] = devicetoken;

    print(request);
    var response = await request.send();
    print(response.stream);
    print(response.statusCode);
    final res = await http.Response.fromStream(response);
    print(res.body);
    var responseJson = json.decode(res.body);
    Loginresponse groundedAccountResponse =
        new Loginresponse.fromJson(responseJson);
    if (groundedAccountResponse != null) {
      if (groundedAccountResponse.status != null &&
          groundedAccountResponse.status.trim().length > 0) {
        if (groundedAccountResponse.status.compareTo("success") == 0) {
          if (groundedAccountResponse.message != null &&
              groundedAccountResponse.message.trim().length > 0) {
            displaytoast(groundedAccountResponse.message, context);

            if (isaccountsaved) {
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
                    element.userid.compareTo(
                        groundedAccountResponse.userData.id.toString()) ==
                    0);
                if (contain.isEmpty) {
                  UserDetail userdetail = new UserDetail();
                  userdetail.email = groundedAccountResponse.userData.email;
                  userdetail.phonenumber =
                      groundedAccountResponse.userData.phoneNumber;
                  userdetail.password = "";
                  userdetail.userimage =
                      groundedAccountResponse.userData.userImage != null
                          ? groundedAccountResponse.userData.userImage
                          : "";
                  userdetail.userid =
                      groundedAccountResponse.userData.id.toString();
                  userdetail.username =
                      groundedAccountResponse.userData.username;
                  userdetail.logintype =
                      groundedAccountResponse.userData.loginType.toString();
                  userdetailsdata.add(userdetail);
                }
              } else {
                print("length<0");
                UserDetail userdetail = new UserDetail();
                userdetail.email = groundedAccountResponse.userData.email;
                userdetail.phonenumber =
                    groundedAccountResponse.userData.phoneNumber;
                userdetail.password = "";
                userdetail.userimage =
                    groundedAccountResponse.userData.userImage != null
                        ? groundedAccountResponse.userData.userImage
                        : "";
                userdetail.userid =
                    groundedAccountResponse.userData.id.toString();
                userdetail.username = groundedAccountResponse.userData.username;
                userdetail.logintype =
                    groundedAccountResponse.userData.loginType.toString();
                userdetailsdata.add(userdetail);
              }

              UserDetails user = new UserDetails(userDetails: userdetailsdata);
              var loggedinvalue = json.encode(user);
              MemoryManagement.setsaveotheraccounts(userDetails: loggedinvalue);
              print(MemoryManagement.getsaveotheraccounts());
            }

            Navigator.of(context).pop(true);
            // setState(() {
            //   isPicLoaded=false;
            // });
          }
        } else {
          setState(() {
            isPicLoaded = false;
          });
        }
      } else {
        setState(() {
          isPicLoaded = false;
        });
      }
    } else {
      setState(() {
        isPicLoaded = false;
      });
    }
  }

  void _closeActionSheet(BuildContext contexts) {
    // Navigator.pop(context);
    Navigator.of(context, rootNavigator: true).pop("Discard");
  }

  Future getImagefromcamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    print("CameraImage2${pickedFile.toString()}");
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print("CameraImage${_image.toString()}");
        if (_image != null) {
          Uint8List bytes = _image.readAsBytesSync();
          // updateprofilepic(bytes,key);
        }
      } else {
        print('No image selected.');
      }
    });
  }

  void getdevicetoken() async {
    await _firebaseMessaging.getToken().then((value) {
      devicetoken = value;
      print("token=>$value");
    });
  }

  getuserprofilepic() {
    // if (userdetailsdata.userimage != null &&
    //     userdetailsdata.userimage.isNotEmpty) {
    //   if (userdetailsdata.userimage.contains("https") ||
    //       userdetailsdata.userimage.contains("http")) {
    //     return getCachedNetworkImage(url:userdetailsdata.userimage,fit: BoxFit.fill);
    //   } else {
    //     return getCachedNetworkImage(url:APIs.userprofilebaseurl + userdetailsdata.userimage,fit: BoxFit.fill);
    //   }
    // } else {
    return getCachedNetworkImage(
        url:
            "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80",
        fit: BoxFit.cover);
    // }
  }
}
