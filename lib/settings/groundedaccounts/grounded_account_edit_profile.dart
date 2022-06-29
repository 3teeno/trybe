import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trybelocker/enums/enums.dart';
import 'package:trybelocker/model/deleteuseracc/deleteuseraccparams.dart';
import 'package:trybelocker/model/deleteuseracc/deleteuseraccresponse.dart';
import 'package:trybelocker/model/groundedaccountlist/grounded_accountlistResponse.dart';
import 'package:trybelocker/model/updateprofile/update_profile_params.dart';
import 'package:trybelocker/model/updateprofile/update_profile_response.dart';
import 'package:trybelocker/model/user_details.dart';
import 'package:trybelocker/networkmodel/APIs.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/viewmodel/groundedAccount_viewmodel.dart';
import 'package:provider/src/provider.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../UniversalFunctions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class GroundedProfileEditScreen extends StatefulWidget {
  static const String TAG = "/grounded_edit_profile";
  Data groundAcctslist;
  GroundedProfileEditScreen(this.groundAcctslist);

  @override
  GroundedProfileEditState createState() => GroundedProfileEditState(groundAcctslist);
}

class GroundedProfileEditState extends State<GroundedProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  File _image;
  Privacy _type = Privacy.private;
  Data groundAcctslist;
  var fullnameController = TextEditingController();
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  GroundedAccountViewModel _accountViewModel;
  // bool isPicLoaded=false;

  GroundedProfileEditState(this.groundAcctslist);

  @override
  void initState() {
    super.initState();

    setData();

  }

  @override
  Widget build(BuildContext context) {
    _accountViewModel = Provider.of<GroundedAccountViewModel>(context);
    return Scaffold(
      backgroundColor: getColorFromHex(AppColors.black),
      appBar: AppBar(
        title: Text(
          "Settings",
        ),
        backgroundColor: getColorFromHex(AppColors.black),
      ),
      body: Stack(
        children: <Widget>[
         SingleChildScrollView(physics: NeverScrollableScrollPhysics(),
             child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // settingsHeader('Grounded Account \n Profile Settings',  groundAcctslist.userImage),
              groundedaccontheader('Grounded Account \n Profile Settings'),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    setFormField("Full Name",fullnameController),
                    SizedBox(
                      height: 15,
                    ),
                    setFormField("User Name",usernameController),
                    SizedBox(
                      height: 15,
                    ),
                    setFormField("Password",passwordController),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 40),
                child: Theme(
                    data: Theme.of(context).copyWith(
                      unselectedWidgetColor: Colors.red,
                    ),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Container(
                              margin: EdgeInsets.only(top: 13),
                              child:Text(
                                'Privacy',
                                style: new TextStyle(fontSize: 16.0, color: Colors.white),
                              )),
                          SizedBox(
                            width: 15,
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  new Radio(
                                    value: Privacy.public,
                                    groupValue: _type,
                                    activeColor: Colors.white,
                                    onChanged: _handleRadioValueChange,
                                  ),
                                  new Text(
                                    'Public',
                                    style: new TextStyle(fontSize: 16.0, color: Colors.white),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  new Radio(
                                    value: Privacy.private,
                                    groupValue: _type,
                                    activeColor: Colors.white,
                                    onChanged: _handleRadioValueChange,
                                  ),
                                  new Text(
                                    'Private',
                                    style: new TextStyle(fontSize: 16.0, color: Colors.white),
                                  ),
                                ],
                              )
                            ],
                          )
                        ])),
              ),
              SizedBox(
                height: 30,
              ),
              setButton('Update'),
              SizedBox(
                height: 15,
              ),
              setButton('Delete Account'),
            ],
          )),
          getFullScreenProviderLoader(status: _accountViewModel.getLoading(), context: context)
        ],
      ),
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
                showMediaOptions(context,);
                // getImage();
              },
              child: new Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 4,color: Colors.white),
                ),
                // child: ClipOval(
                //     child: getProfileImage(MemoryManagement.getuserprofilepic())
                // ),
                child: _image!=null?ClipOval(
                  child: Image.file(_image,fit: BoxFit.cover,),
                ):ClipOval(
                    child: getProfileImage(groundAcctslist.userImage)
                ),
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

  getProfileImage(String userImage) {
    if(userImage != null && userImage.isNotEmpty){
      if (userImage.contains("https") || userImage.contains("http")){
        return getCachedNetworkImage(url:userImage,fit: BoxFit.cover);
      }else{
        return getCachedNetworkImage(url:APIs.userprofilebaseurl +userImage,fit: BoxFit.cover);
      }
    }else{
    return getCachedNetworkImage(url:
    "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80",fit: BoxFit.cover);
    }
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

  void _closeActionSheet(BuildContext contexts) {
    // Navigator.pop(context);
    Navigator.of(context, rootNavigator: true).pop("Discard");
  }
  Future getImagefromcamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        if (_image != null) {
          Uint8List bytes = _image.readAsBytesSync();
          updateprofilepic(bytes,2);
        }
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImagefromgallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        if (_image != null) {
          Uint8List bytes = _image.readAsBytesSync();
          updateprofilepic(bytes,2);
        }
      } else {
        print('No image selected.');
      }
    });
  }

  setFormField(String title, TextEditingController controller) {
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
              autofocus: false,
              controller: controller,
              validator: (String arg) {
                if(title.compareTo("User Name")==0) {
                  if (arg.isEmpty)
                    return 'Username can not be empty';
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

  setButton(title) {
    return GestureDetector(
      onTap: () {
        if (title == "Update") {
          if (_formKey.currentState.validate()) {
            updateUserProfile();
          }
        } else {
          deletaccountmethod();
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/submitbuttonbg.png',
            width: 220,
          ),
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 22),
          )
        ],
      ),
    );
  }

  void _handleRadioValueChange(Privacy value) {
    setState(() {
      _type = value;
    });
  }

  void setData() {
    if(groundAcctslist!=null){
      if(groundAcctslist.username!=null&&groundAcctslist.username.isNotEmpty){
        usernameController.text=groundAcctslist.username;
      }
      if(groundAcctslist.fullName!=null&&groundAcctslist.fullName.isNotEmpty){
        fullnameController.text = groundAcctslist.fullName;
      }
      if(groundAcctslist.privacy_type!=null&&groundAcctslist.privacy_type==2){
        _type = Privacy.private;
      }else{
        _type = Privacy.public;
      }

    }

  }

  deletaccountmethod() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete an account?'),
          content: Text('Do you want to delete Grounded Account'),
          actions: <Widget>[
            FlatButton(
              child: Text('NO'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text('YES'),
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop(true);
                  deleteuseraccount();
                });
              },
            ),
          ],
        );
      },
    );
  }

  void deleteuseraccount() async {
    _accountViewModel.setLoading();
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _accountViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Deleteuseraccparams params = new Deleteuseraccparams(
          uid: groundAcctslist.id.toString());
      var response = await _accountViewModel.deleteuseraccount(params, context);
      DeleteuseraccResponse deleteuseraccResponse = response;
      if (deleteuseraccResponse.status.compareTo("success") == 0) {
        displaytoast("Sucessfully Deleted", context);
      Navigator.of(context).pop(true);
      } else {
        displaytoast("Failed to delete the account", context);
      }
    }
  }
  void updateprofilepic(Uint8List image, int key) async {
    var request = http.MultipartRequest('POST', Uri.parse(APIs.updateprofile));
    request.fields['userid'] = groundAcctslist.id.toString();
    request.fields['key'] = key.toString();
      request.files.add(http.MultipartFile.fromBytes('filename', image, filename: "test",
        // contentType: MediaType('application', 'octet-stream'),
      ));

    print(request);
    var response = await request.send();
    print(response.stream);
    print(response.statusCode);
    final res = await http.Response.fromStream(response);
    print(res.body);
    var responseJson = json.decode(res.body);
    UpdateProfileResponse updateProfileResponse = new UpdateProfileResponse.fromJson(responseJson);
    if (updateProfileResponse != null) {
      if (updateProfileResponse.status != null && updateProfileResponse.status.trim().length > 0) {
        if (updateProfileResponse.status.compareTo("success") == 0) {
          if (updateProfileResponse.message != null && updateProfileResponse.message.trim().length > 0) {
            displaytoast(updateProfileResponse.message, context);
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
              for(int k=0;k<userdetailsdata.length;k++){
                if(userdetailsdata[k].userid.compareTo(groundAcctslist.id.toString())==0){
                  userdetailsdata[k].userimage=updateProfileResponse.userData.userImage.trim();
                  userdetailsdata[k].logintype = updateProfileResponse.userData.loginType.toString();
                  break;
                }
              }
            }
            UserDetails user = new UserDetails(userDetails: userdetailsdata);
            var loggedinvalue = json.encode(user);
            MemoryManagement.setsaveotheraccounts(userDetails: loggedinvalue);
          }
         else{
            // setState(() {
            //   isPicLoaded=false;
            // });
          }
        }else{
          // setState(() {
          //   isPicLoaded=false;
          // });
        }
      }else{
        // setState(() {
        //   isPicLoaded=false;
        // });
      }
    }else{
      // setState(() {
      //   isPicLoaded=false;
      // });
    }
  }


  void updateUserProfile() async{

    _accountViewModel.setLoading();

    Update_profile_params request = new Update_profile_params();
    request.key = "3";
    request.fullName = fullnameController.text;
    request.username = usernameController.text;
    request.privacy_type = _type==Privacy.public?"1":"2";
    request.password = passwordController.text;
    request.userid = groundAcctslist.id.toString();
    print(request);

    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _accountViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      var response = await _accountViewModel.updateprofile(request, context);
      UpdateProfileResponse updateProfileResponse = response;
      if (updateProfileResponse.status.compareTo("success") == 0) {
        displaytoast(updateProfileResponse.message,context);

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
          for(int k=0;k<userdetailsdata.length;k++){
            if(userdetailsdata[k].userid.compareTo(groundAcctslist.id.toString())==0){
              userdetailsdata[k].userimage=updateProfileResponse.userData.userImage.trim();
              userdetailsdata[k].username = updateProfileResponse.userData.username.trim();
              // userdetailsdata[k].about = updateProfileResponse.userData.about.trim();
              // userdetailsdata[k].phonenumber = updateProfileResponse.userData.phoneNumber;
              // userdetailsdata[k].email = updateProfileResponse.userData.email;
              // userdetailsdata[k].birthdate = updateProfileResponse.userData.birthDate;
              break;
            }
          }
        }
        UserDetails user = new UserDetails(userDetails: userdetailsdata);
        var loggedinvalue = json.encode(user);
        MemoryManagement.setsaveotheraccounts(userDetails: loggedinvalue);

        // MemoryManagement.setuserName(username:  updateProfileResponse.userData.username);
        // MemoryManagement.setfullName(fullname: updateProfileResponse.userData.fullName);
        // MemoryManagement.setEmail(email:  updateProfileResponse.userData.email);
        // MemoryManagement.setbirthdate(birthdate: updateProfileResponse.userData.birthDate);
        // MemoryManagement.setPhonenumber(phonenumber:  updateProfileResponse.userData.phoneNumber);
        // MemoryManagement.setAbout(about:  updateProfileResponse.userData.about);
        // MemoryManagement.setlogintype(logintype: updateProfileResponse.userData.loginType.toString());

        Navigator.of(context).pop(true);
      } else {
        displaytoast(updateProfileResponse.message,context);
      }
    }
  }
}
