import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trybelocker/UniversalFunctions.dart';
import 'package:trybelocker/settings/groundedaccounts/DeleteExecutorScreen.dart';
import 'package:trybelocker/settings/groundedaccounts/MyExecutorAccounts.dart';
import 'package:trybelocker/settings/groundedaccounts/grounded_appoint_executer.dart';
import 'package:trybelocker/settings/groundedaccounts/viewexecuter.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trybelocker/utils/memory_management.dart';

class GroundedExecuterAcc extends StatefulWidget {
  static const String TAG = "/grounded_executeraccount";

  @override
  GroundedExecuterAccState createState() => GroundedExecuterAccState();
}

class GroundedExecuterAccState extends State<GroundedExecuterAcc> {
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
      body: SingleChildScrollView(child:
      Center(
        child: Container(
          child: Column(
            children: [
              settingsHeader('Executor Account Settings',  MemoryManagement.getuserprofilepic()),
              SizedBox(
                height: 100,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color:getColorFromHex(AppColors.red))),
                    onPressed: () {
                      // _selectImage();
                      navigateToNextScreen(context, false, GroundedAppointExecuter());
                    },
                    color: Colors.white,
                    textColor: getColorFromHex(AppColors.red),
                    child: Text("Appoint Executor",
                        style: TextStyle(fontSize: 14)),
                  )),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: getColorFromHex(AppColors.red))),
                    onPressed: () {
                      navigateToNextScreen(context, false, MyExecutorAccounts());
                    },
                    color: Colors.white,
                    textColor:  getColorFromHex(AppColors.red),
                    child: Text("View Executor",
                        style: TextStyle(fontSize: 14)),
                  )),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: getColorFromHex(AppColors.red))),
                    onPressed: () {
                      navigateToNextScreen(context, false, ViewExecuterScreen());
                    },
                    color: Colors.white,
                    textColor:  getColorFromHex(AppColors.red),
                    child: Text("Activate Executor",
                        style: TextStyle(fontSize: 14)),
                  ))
            ],
          ),
        ),
      )),
    );
  }
}
