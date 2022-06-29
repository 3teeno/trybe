import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';

import '../../UniversalFunctions.dart';

class GroundedProfileScreen extends StatefulWidget {
  static const String TAG = "/grounded_profile";

  @override
  GroundedProfileScreenState createState() => GroundedProfileScreenState();
}

class GroundedProfileScreenState extends State<GroundedProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  File _pickedFile;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: getColorFromHex(AppColors.black),
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text(
          "Setings",
        ),
        backgroundColor: getColorFromHex(AppColors.black),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              settingsHeader('Grounded Account \n Profile Settings',  MemoryManagement.getuserprofilepic()),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    setFormField("Full Name"),
                    SizedBox(
                      height: 20,
                    ),
                    _pickedFile == null
                        ? Image.asset(
                            "assets/default_profile.jpg",
                            width: 80,
                            height: 80,
                          )
                        : Image.file(
                            _pickedFile,
                            width: 80,
                            height: 80,
                          ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(color: Colors.red)),
                          onPressed: () {
                            _selectImage();
                          },
                          color: Colors.white,
                          textColor: Colors.red,
                          child: Text("Update Profile Image",
                              style: TextStyle(fontSize: 14)),
                        )),
                    SizedBox(
                      height: 35,
                    ),
                    GestureDetector(
                        onTap: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
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
                                'Save Profile',
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
    );
  }

  setFormField(String title) {
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
              validator: (String arg) {
                if (arg.length < 3)
                  return 'Name must be more than 2 charater';
                else
                  return null;
              },
              onSaved: (String val) {
                switch (title) {
                  case "Full Name":
                    _name = val;
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

  void _selectImage() {
    showDialog<ImageSource>(
      context: context,
      builder: (context) =>
          AlertDialog(content: Text("Choose image from"), actions: [
        FlatButton(
          child: Text("Camera"),
          onPressed: () => Navigator.pop(context, ImageSource.camera),
        ),
        FlatButton(
          child: Text("Gallery"),
          onPressed: () => Navigator.pop(context, ImageSource.gallery),
        ),
      ]),
    ).then((ImageSource source) async {
      if (source != null) {
        final path = await ImagePicker().getImage(source: source);
        if (path != null) setState(() => _pickedFile = File(path.path));
      }
    });
  }
}
