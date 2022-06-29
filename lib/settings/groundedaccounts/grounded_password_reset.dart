import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trybelocker/UniversalFunctions.dart';
import 'package:trybelocker/model/groundedaccountlist/grounded_accountlistResponse.dart';
import 'package:trybelocker/model/resetpassword/resetpasswordparams.dart';
import 'package:trybelocker/model/resetpassword/resetpasswordresponse.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/viewmodel/groundedAccount_viewmodel.dart';
import 'package:provider/src/provider.dart';

class GroundedPasswordreset extends StatefulWidget {
  static const String TAG = "/grounded_reset_password";
Data groundAcctslist;
  GroundedPasswordreset(this.groundAcctslist);

  @override
  GroundedPasswordresetState createState() => GroundedPasswordresetState(groundAcctslist);
}

class GroundedPasswordresetState extends State<GroundedPasswordreset> {
  File _image;
  final _formKey = GlobalKey<FormState>();
  var _currentPasswordController = TextEditingController();
  var _newpasswordController = TextEditingController();
  var _confirmPasswordController = TextEditingController();
  GroundedAccountViewModel _accountViewModel;

  Data groundAcctslist;
  GroundedPasswordresetState(this.groundAcctslist);

  @override
  Widget build(BuildContext context) {
    _accountViewModel = Provider.of<GroundedAccountViewModel>(context);
    
    return Scaffold(
      backgroundColor: getColorFromHex(AppColors.black),
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text(
          "Settings",
        ),
        backgroundColor: getColorFromHex(AppColors.black),
      ),
      body: Stack(children: <Widget>[
       SingleChildScrollView(
         physics: NeverScrollableScrollPhysics(),
         child:  Center(
           child: Container(
             child: Column(
               children: [
                 settingsHeader('Grounded Account Password Reset',  MemoryManagement.getuserprofilepic()),
                 Form(
                   key: _formKey,
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.center,
                     mainAxisSize: MainAxisSize.min,
                     children: <Widget>[
                       setFormField("Current \nPassword", true,
                           _currentPasswordController),
                       setFormField(
                           "New \nPassword", true, _newpasswordController),
                       setFormField("Confirm \nPassword", true,
                           _confirmPasswordController),
                       GestureDetector(
                           onTap: () {
                             if (_currentPasswordController.text.length <
                                 8) {
                               displaytoast(
                                   'Current password must be more than 7 charater',
                                   context);
                             } else if (_newpasswordController
                                 .text.length <
                                 8) {
                               displaytoast(
                                   'New password must be more than 7 charater',
                                   context);
                             } else if (_confirmPasswordController
                                 .text.length <
                                 8) {
                               displaytoast(
                                   'Confirm password must be more than 7 charater',
                                   context);
                             } else {
                               Resetpasswordparams resetpsswdprms =
                               new Resetpasswordparams();
                               resetpsswdprms.uid =
                                  groundAcctslist.id.toString();
                               resetpsswdprms.currentPassword =
                                   _currentPasswordController.text;
                               resetpsswdprms.confirmPassword =
                                   _confirmPasswordController.text;
                               resetpsswdprms.newPassword =
                                   _newpasswordController.text;
                               resetnewpassword(resetpsswdprms);
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
       ), getFullScreenProviderLoader(
          status: _accountViewModel.getLoading(), context: context)],) 
       
    );
  }

  setFormField(String title, pwdType, TextEditingController _controller) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 40,
        margin: EdgeInsets.only(left: 20, top: 10, right: 20),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 30,
            ),
            Expanded(
              child: TextFormField(
                  maxLines: 1,
                  controller: _controller,
                  obscureText: true,
                  autofocus: false,
                  // validator: (String arg) {
                  //   switch (title) {
                  //     case "Current \nPassword":
                  //       if (arg.length < 8)
                  //         return 'Current password must be more than 7 charater';
                  //       else
                  //         return null;
                  //       break;
                  //     case "New \nPassword":
                  //       if (arg.length < 8)
                  //         return 'New Password must be more than 7 charater';
                  //       else
                  //         return null;
                  //       break;
                  //     case "Confirm \nPassword":
                  //       if (arg.length < 8)
                  //         return 'New Password must be more than 7 charater';
                  //       else
                  //         return null;
                  //       break;
                  //   }
                  // },
                  decoration: InputDecoration(
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
                    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  )),
            )
          ],
        ));
  }
  void resetnewpassword(Resetpasswordparams request) async {
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
      var response = await _accountViewModel.resetpassword(request, context);
      Resetpasswordresponse resetpasswordresponse = response;
      if (resetpasswordresponse.status.compareTo("success") == 0) {
        displaytoast(resetpasswordresponse.message, context);
        Navigator.of(context).pop();
      } else {
        displaytoast(resetpasswordresponse.message, context);
      }
    }
  }
}
