

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trybelocker/model/receiveotpresetpassword/receive_otp_reset_password_params.dart';
import 'package:trybelocker/model/receiveotpresetpassword/receive_otp_reset_password_response.dart';
import 'package:trybelocker/model/sendotptoresetpassword/send_otp_params.dart';
import 'package:trybelocker/model/sendotptoresetpassword/send_otp_response.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/verification/otpverify.dart';
import 'package:trybelocker/viewmodel/auth_view_model.dart';
import 'package:provider/src/provider.dart';
import '../UniversalFunctions.dart';

class GetOtp extends StatefulWidget{
  GetOtpState createState() => GetOtpState();
}
class GetOtpState extends State<GetOtp>{
  AuthViewModel _authViewModel;
  TextEditingController phonenumbercontrollder = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    _authViewModel = Provider.of<AuthViewModel>(context);
    return  Scaffold(
        backgroundColor:getColorFromHex(AppColors.black),
        appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor:getColorFromHex(AppColors.black),
          title:Row(children: <Widget>[
            Image.asset('assets/white_logo.png',width: 150,height: 150,),
          ],),),
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(margin: EdgeInsets.all(0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 100,),
                    Icon(Icons.phone_android,size: 100,
                      color: Colors.grey,),
                    SizedBox(height: 40,),
                    Text("Verification",style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.w500,letterSpacing: 0.3),),
                    SizedBox(height: 20,),
                    Text("We will send a One Time Passsword to your phone number",style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.normal),),
                    SizedBox(height: 20,),
                    Container(height: 40,width: 250,decoration: BoxDecoration(color: Colors.white,shape:BoxShape.rectangle,border: Border.all(color: getColorFromHex(AppColors.red),width: 1), borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: TextFormField(
                          controller: phonenumbercontrollder,
                          autofocus: false, textAlign: TextAlign.center,
                          keyboardType:  TextInputType.number,
                          decoration: InputDecoration(border: InputBorder.none,focusedBorder: InputBorder.none,errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,hintText: "Enter phone number",contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 15),
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 14,),),
                          style: TextStyle(color: Colors.black, fontSize: 14,),),
                      ),),
                    GestureDetector(
                      onTap: () async{
                      FocusScope.of(context).unfocus();
                      if(phonenumbercontrollder!=null&&phonenumbercontrollder.text.trim().length>0){
                        if(phonenumbercontrollder.text.trim().length>=10){
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
                            Send_otp_params params= new Send_otp_params(emailPhone:phonenumbercontrollder.text.trim(),key:"reset-password");
                            var response = await _authViewModel.sendotp(params, context);
                            Send_otp_response send_otp_response = response;
                            if (send_otp_response.status.compareTo("success") == 0) {
                              displaytoast(send_otp_response.message, context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => OtpVerify(send_otp_response.otp,phonenumbercontrollder.text.trim(),false)));
                            } else {
                              displaytoast(send_otp_response.message, context);
                            }

                          }
                        }else{
                          displaytoast("Invalid phone number", context);
                        }
                      }else{
                        displaytoast("Phone number required", context);
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
                              height: 120,
                            ),
                            Text(
                              'Get OTP',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    )

                  ],),),
              getFullScreenProviderLoader(
                  status: _authViewModel.getLoading(), context: context)
            ],
          ),
        )

    );
  }

}