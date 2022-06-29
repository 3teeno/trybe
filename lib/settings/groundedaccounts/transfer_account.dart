import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trybelocker/UniversalFunctions.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trybelocker/utils/memory_management.dart';

class TransferGroundedAcc extends StatefulWidget {
  static const String TAG = "/transferacc";

  @override
  TransferGroundedAccState createState() => TransferGroundedAccState();
}

class TransferGroundedAccState extends State<TransferGroundedAcc> {
  File _image;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColorFromHex(AppColors.black),
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text(
          "Settings",
        ),
        backgroundColor: getColorFromHex(AppColors.black),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              settingsHeader('Transfer Grounded Account',  MemoryManagement.getuserprofilepic()),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    setFormField("Transferee Email", false),
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
                                'Verify Email',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
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

}
