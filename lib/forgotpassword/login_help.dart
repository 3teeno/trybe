

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trybelocker/forgotpassword/reset_password.dart';
import 'package:trybelocker/model/sendotptoresetpassword/send_otp_params.dart';
import 'package:trybelocker/model/sendotptoresetpassword/send_otp_response.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/verification/otpverify.dart';
import 'package:trybelocker/viewmodel/auth_view_model.dart';

import '../UniversalFunctions.dart';
import 'package:provider/src/provider.dart';
class LoginHelp extends StatefulWidget{
  LoginHelpState createState()=>LoginHelpState();
}
class LoginHelpState extends State<LoginHelp>{
  TextEditingController emailcontroller = TextEditingController();
  AuthViewModel _authViewModel;
  @override
  Widget build(BuildContext context) {
    _authViewModel = Provider.of<AuthViewModel>(context);
    return   Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.0),
        child: AppBar(backgroundColor: Colors.transparent,elevation: 0.0, brightness: Brightness.dark,),
      ),
      backgroundColor: getColorFromHex(AppColors.black),
      body: Stack(
        children: <Widget>[
          Container(
            color: getColorFromHex(AppColors.black),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(height: 15,),
               Row(
                 children: <Widget>[
                   IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,size: 20,), onPressed: (){
                     Navigator.pop(context);
                   }),
                 SizedBox(width: 5,),
                   Text('Login Help',textAlign:TextAlign.start,style: TextStyle(color: Colors.white,fontSize: 18),),
                 ],
               ),
                Expanded(child: Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Find Your Account',style: TextStyle(color: Colors.white,fontSize: 22),),
                        SizedBox(height: 30,),
                        Text('Enter your email linked to your account',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white,fontSize: 12),),
                        SizedBox(height: 20,),
                        Container(height: 40,width: 250,decoration: BoxDecoration(color: Colors.white,shape:BoxShape.rectangle,border: Border.all(color: getColorFromHex(AppColors.red),width: 1), borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: TextFormField(autofocus: false, textAlign: TextAlign.center,
                              controller: emailcontroller,
                              decoration: InputDecoration(border: InputBorder.none,focusedBorder: InputBorder.none,errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,hintText: "email",contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 15),
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 14,),),
                              style: TextStyle(color: Colors.black, fontSize: 14,),),
                          ),),
                        SizedBox(height: 15,),
                        GestureDetector(
                          onTap: () async{
                            FocusScope.of(context).unfocus();
                            if(emailcontroller!=null&&emailcontroller.text.trim().length>0){
                              if(emailvalidation(emailcontroller.text.trim())){
                                _authViewModel.setLoading();
                                bool gotInternetConnection = await hasInternetConnection(
                                  context: context,
                                  mounted: mounted,
                                  canShowAlert: true,
                                  onFail: () {
                                    _authViewModel.hideLoader();
                                  },
                                  onSuccess: () {},
                                );
                                if (gotInternetConnection) {
                                  Send_otp_params params= new Send_otp_params(emailPhone:emailcontroller.text.trim());
                                  var response = await _authViewModel.sendotp(params, context);
                                  Send_otp_response send_otp_response = response;
                                  if (send_otp_response.status.compareTo("success") == 0) {
                                    displaytoast(send_otp_response.message, context);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => OtpVerify(send_otp_response.otp,emailcontroller.text.trim(),true)));
                                  } else {
                                    displaytoast(send_otp_response.message, context);
                                  }

                                }
                              }else{
                                displaytoast("Invalid Email", context);
                              }
                            }else{
                              displaytoast("Email required", context);
                            }

                          },
                          child:   Container(height: 40,width: 250,decoration: BoxDecoration(color: Colors.white,shape: BoxShape.rectangle,border: Border.all(color: getColorFromHex(AppColors.red),width: 1),borderRadius: BorderRadius.circular(10)),
                            child: Center(child: Text("Next",textAlign:TextAlign.center,style:TextStyle(color:getColorFromHex(AppColors.red,),fontSize: 14,fontWeight: FontWeight.bold),),),),
                        ),
                        SizedBox(height: 40,)
                      ],
                    ),
                  )
                ))
              ],
            ),
          ),
          getFullScreenProviderLoader(
              status: _authViewModel.getLoading(), context: context)
        ],
      ),
    );
  }

}