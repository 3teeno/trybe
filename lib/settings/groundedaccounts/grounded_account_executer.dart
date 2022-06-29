import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trybelocker/UniversalFunctions.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trybelocker/utils/memory_management.dart';

class GroundedAccountExecuter extends StatefulWidget {
  static const String TAG = "/grounded_accountexecuter";

  @override
  GroundedAccountExecuterState createState() => GroundedAccountExecuterState();
}

class GroundedAccountExecuterState extends State<GroundedAccountExecuter> {
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
              settingsHeader('Account Executor',  MemoryManagement.getuserprofilepic()),
              SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Current Account\nExecutor"
                        ,textAlign: TextAlign.center,style: TextStyle(
                    color: Colors.white
                  ),),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      Text(
                        "Username"
                        ,textAlign: TextAlign.center,style: TextStyle(
                          color: Colors.white,
                        fontSize: 22
                      )
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 30,right: 30,top: 10,bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Delete Executor",
                          style: TextStyle(color:getColorFromHex(AppColors.red),fontWeight: FontWeight.bold,fontSize: 15),
                        ),
                      )
                    ],
                  )
                ],
              )
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
}
