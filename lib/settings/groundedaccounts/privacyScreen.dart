import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trybelocker/UniversalFunctions.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/viewmodel/home_view_model.dart';
import 'package:provider/src/provider.dart';
import 'package:trybelocker/model/privacy/privacyparams.dart';
import 'package:trybelocker/model/privacy/privacyresponse.dart';
import 'package:trybelocker/viewmodel/setting_view_model.dart';

class PrivacyScreen extends StatefulWidget {
  static const String TAG = "/privacy_screen";

  @override
  PrivacyScreenState createState() => PrivacyScreenState();
}

class PrivacyScreenState extends State<PrivacyScreen> {
 bool trybelistvalue=false;
 bool trybegroup=false;
 SettingViewModel _settingViewModel;


 @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(MemoryManagement.getTrybegroupPrivate()!=null){
      if(MemoryManagement.getTrybegroupPrivate()==true){
        trybegroup = true;
      }else{
        trybegroup = false;
      }
    }

    if(MemoryManagement.getTrybelistPrivate()!=null){
      if(MemoryManagement.getTrybelistPrivate()==true){
        trybelistvalue = true;
      }else{
        trybelistvalue = false;
      }
    }


  }
  @override
  Widget build(BuildContext context) {
    _settingViewModel = Provider.of<SettingViewModel>(context);
    
    return  Scaffold(
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
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  settingsHeader('Privacy',MemoryManagement.getuserprofilepic()),
                  Container(
                      width: MediaQuery.of(context).size.width-30,
                      child: Text(
                        "Manage what you share on Trybe Lockr. Choose who can see your saved Trybelists, follows, and groups",
                        style: TextStyle(color: Colors.white,fontSize: 16),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width-30,
                      child:Text("Trybelists, follows, and groups",   style: TextStyle(color: Colors.white,fontSize: 16),textAlign: TextAlign.start,)
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 30),
                      child:
                      Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor: Colors.red,
                          ),
                          child: Row(
                            children: [
                              Checkbox(value: trybelistvalue,activeColor: Colors.white,checkColor: getColorFromHex(AppColors.red),
                                  onChanged: (newValue){
                                    setState(() {
                                      trybelistvalue = newValue;

                                    });
                                    changeprivacy(context);
                                  }),
                              Text('Keep all my saved Trybelists private',style: TextStyle(color: Colors.white),)
                            ],
                          ))),
                  Container(
                    margin: EdgeInsets.only(left: 20,right: 20),
                    padding: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: getColorFromHex(AppColors.red))
                    ),
                    child: Text(
                        "Trybelists created by others won’t appear on your channel. Trybelists created by you have separate, individual privacy settings."
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 30),
                      child:
                      Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor: Colors.red,
                          ),
                          child: Row(
                            children: [
                              Checkbox(value: trybegroup,activeColor: Colors.white,checkColor: getColorFromHex(AppColors.red),
                                  onChanged: (newValue){
                                    setState(() {
                                      trybegroup = newValue;
                                    });
                                    changeprivacy(context);
                                  }),
                              Text('Keep all my follows and groups private',style: TextStyle(color: Colors.white), textAlign: TextAlign.center)
                            ],
                          ))),
                  Container(
                    margin: EdgeInsets.only(left: 20,right: 20),
                    padding: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: getColorFromHex(AppColors.red))
                    ),
                    child: Text(
                        "Your follows and groups will not be visible to others. Manage your follows and groups here.",
                        textAlign: TextAlign.center
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                      margin: EdgeInsets.only(left: 20,right: 20),
                      width: MediaQuery.of(context).size.width,
                      child:
                      Text("Ads on TrybeLockr",style: TextStyle(color: Colors.white),textAlign: TextAlign.left,)),
                  Container(
                    margin: EdgeInsets.only(left: 20,right: 20,top: 10),
                    padding: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: getColorFromHex(AppColors.red))
                    ),
                    child: Text(
                      "You may see ads on TrybeLockr based on general factors, like the topic of a video/post. The ads you see may also depend on your Google Ads Settings.",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text("Review TrybeLockr Terms of Service",style: TextStyle(color: Colors.white),),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        ));
  }

  setFormField(String title, pwdType) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 40,
        margin: EdgeInsets.only(left: 20, top: 10, right: 20),
        child: Row(
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
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                  child: TextFormField(
                      maxLines: 1,
                      // controller: _passwordcontroller,
                      obscureText: true,
                      autofocus: false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 0.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 0.0),
                        ),
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(5.0, 0, 0.0, 0.0),
                      ))),
            )
          ],
        ));
  }

 void changeprivacy(BuildContext context,) async{
   bool gotInternetConnection = await hasInternetConnection(
     context: context,
     mounted: mounted,
     canShowAlert: true,
     onFail: () {
     },
     onSuccess: () {
     },
   );
   if (gotInternetConnection) {
     Privacyparams params = new Privacyparams(uid: MemoryManagement.getuserId(),istrybelistprivate:trybelistvalue ,istrybegroupprivate: trybegroup/*,istrybetreeprivate: trybegroup*/);
     var response = await _settingViewModel.changeprivacy(params, context);
     Privacyresponse  privacyresponse= response;
     if (privacyresponse!=null&&privacyresponse.status.compareTo("success") == 0) {
       MemoryManagement.setTrybelistPrivate(trybelistprivate: trybelistvalue);
       MemoryManagement.setTrybegroupPrivate(trybegroupprivate: trybegroup);
     }
   }
 }
  
  
}
