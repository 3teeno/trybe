import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trybelocker/UniversalFunctions.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trybelocker/utils/memory_management.dart';

class GroundedAccountProfile extends StatefulWidget {
  static const String TAG = "/ground_profile";

  @override
  GroundedAccountProfileState createState() => GroundedAccountProfileState();
}

class GroundedAccountProfileState extends State<GroundedAccountProfile> {
  File _image;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColorFromHex(AppColors.black),
      appBar: AppBar(
        title: Text(
          "Settings",
        ),
        backgroundColor: getColorFromHex(AppColors.black),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              settingsHeader('Grounded Account Profile Settings',  MemoryManagement.getuserprofilepic()),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    setFormField("Username", false),
                    SizedBox(
                      height: 15,
                    ),
                    circularImage(),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                        onTap: (){
                          showMediaOptions(context);
                        },
                        child:
                    Container(
                      padding: EdgeInsets.only(left: 30,right: 30,top: 10,bottom: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                          color: getColorFromHex(AppColors.red))),
                      child:Text(
                        "Update Profile Image",
                        style: TextStyle(
                          color: getColorFromHex(AppColors.red),
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    )),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    GestureDetector(
                        onTap: () {
                          // if (_formKey.currentState.validate()) {
                          //   _formKey.currentState.save();
                          // }
                          // navigateToNextScreen(context, false, CreateGroundedScreen());


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
                                'Save Profile',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22),
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
          width: 250,
        )
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
                // showMediaOptions(context);
                // getImage();
              },
              child: new Container(
                width: 115.0,
                height: 115.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0)
                ),
                // child: ClipOval(
                child: _image != null
                    ? Image.file(_image, fit: BoxFit.cover,)
                    : Image.network(
                  "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80",
                  fit: BoxFit.cover,
                ),
                // ),
              ),
            ),
          ],
        ),
        // new Row(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[
        //     new GestureDetector(
        //       onTap: () {
        //         // getImage();
        //
        //       },
        //       child: Container(
        //         width: 33.0,
        //         height: 33.0,
        //         margin: EdgeInsets.fromLTRB(60, 90, 0, 0),
        //         child: Icon(
        //           Icons.camera_alt,
        //           color: getColorFromHex(AppColors.red),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ]),
    );
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
        print('_imagepath=> ${_image}');
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
        print('_imagepath=> ${_image}');
      } else {
        print('No image selected.');
      }
    });
  }
}
