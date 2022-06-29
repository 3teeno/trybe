import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trybelocker/ResetPassAcclist.dart';
import 'package:trybelocker/settings/groundedaccounts/deletegroundedaccount.dart';
import 'package:trybelocker/settings/groundedaccounts/executoraccountsSettings.dart';
import 'package:trybelocker/settings/groundedaccounts/grounded_account_executer.dart';
import 'package:trybelocker/settings/groundedaccounts/grounded_appoint_executer.dart';
import 'package:trybelocker/settings/groundedaccounts/grounded_password_reset.dart';
import 'package:trybelocker/settings/groundedaccounts/manage_grounded_accounts.dart';
import 'package:trybelocker/settings/groundedaccounts/transfergroundedaccount.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';

import '../../UniversalFunctions.dart';
import 'create_grounded_account.dart';

class GroundedAcctScreen extends StatefulWidget {
  static const String TAG = "/grounded_accounts";

  @override
  GroundedAcctScreenState createState() => GroundedAcctScreenState();
}

class GroundedAcctScreenState extends State<GroundedAcctScreen> {
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              settingsHeader('Grounded Accounts',MemoryManagement.getuserprofilepic()),
              setModuleButton("Create Grounded Account", 0),
              SizedBox(
                height: 15,
              ),
              setModuleButton("Manage Grounded Accounts", 1),
              SizedBox(
                height: 15,
              ),
              setModuleButton("Transfer Account", 2),
              SizedBox(
                height: 15,
              ),
              setModuleButton("Reset Password", 3),
              SizedBox(
                height: 15,
              ),
              setModuleButton("Account Executer", 4),
              SizedBox(
                height: 15,
              ),
              setModuleButton("Delete Account", 5),
            ],
          ),
        ),
      ),
    );
  }

  setModuleButton(text, int type) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: Colors.red)),
          onPressed: () {
            switch (type) {
              case 0:
                navigateToNextScreen(context, false, CreateGroundedScreen(false));
                break;
              case 1:
                navigateToNextScreen(context, false, ManageGroundedAcctScreen());
                break;
              case 2:
                navigateToNextScreen(context, false, TransferUserlistGrouAcc());
                break;
              case 3:
                navigateToNextScreen(context, false, ResetPassAccList());
                break;
              case 4:
                navigateToNextScreen(context, false, GroundedExecuterAcc());
                break;
              case 5:
                navigateToNextScreen(context, false, DeleteGroundedAccScreen());
                break;
            }
          },
          color: Colors.white,
          textColor: Colors.redAccent,
          child: Text(text, style: TextStyle(fontSize: 14)),
        ));
  }
}
