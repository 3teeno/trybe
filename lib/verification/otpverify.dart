


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trybelocker/forgotpassword/reset_password.dart';
import 'package:trybelocker/model/receiveotpresetpassword/receive_otp_reset_password_params.dart';
import 'package:trybelocker/model/receiveotpresetpassword/receive_otp_reset_password_response.dart';
import 'package:trybelocker/model/sendotptoresetpassword/send_otp_params.dart';
import 'package:trybelocker/model/sendotptoresetpassword/send_otp_response.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/viewmodel/auth_view_model.dart';

import '../UniversalFunctions.dart';
import 'package:provider/src/provider.dart';
class OtpVerify extends StatefulWidget{
  int otp;
  String phonenumber;
  bool isEmail;
  OtpVerify(this.otp,this.phonenumber,this.isEmail);

  OtpVerifyState createState()=> OtpVerifyState();
}
class OtpVerifyState extends State<OtpVerify>{
  AuthViewModel _authViewModel;
  TextEditingController otpcontrollder= new TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    otpcontrollder.text=widget.otp.toString();
  }
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
                      Text(widget.isEmail==true?"You will receive a One Time Password via email":"You will receive a One Time Password via SMS",style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.normal),),
                      SizedBox(height: 20,),
                      Container(height: 40,width: 250,decoration: BoxDecoration(color: Colors.white,shape:BoxShape.rectangle,border: Border.all(color: getColorFromHex(AppColors.red),width: 1), borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: TextFormField(autofocus: false, textAlign: TextAlign.center,
                            obscureText: true,
                            controller: otpcontrollder,
                            decoration: InputDecoration(border: InputBorder.none,focusedBorder: InputBorder.none,errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,hintText: "OTP",contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 15),
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 14,),),
                            style: TextStyle(color: Colors.black, fontSize: 14,),),
                        ),),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: GestureDetector(
                          onTap: () async{
                            if(otpcontrollder!=null&&otpcontrollder.text.trim().length>0){
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
                                Receiveotpresetpasswordparams receivedotp= Receiveotpresetpasswordparams(emailPhone:widget.phonenumber,otp: otpcontrollder.text.trim(),key: "reset-password");
                                var response = await _authViewModel.receiveotp(receivedotp, context);
                                ReceiveOtpResetPasswordResponse otpResetPasswordResponse = response;
                                if (otpResetPasswordResponse.status.compareTo("success") == 0) {
                                  displaytoast(otpResetPasswordResponse.message, context);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPassword(widget.phonenumber)));
                                } else {
                                  displaytoast(otpResetPasswordResponse.message, context);
                                }

                              }

                            }else{
                              displaytoast("Otp Required", context);
                            }
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                'assets/submitbuttonbg.png',
                                width: 200,
                                height: 120,
                              ),
                              Text(
                                'Verify',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Didn't receive verification OTP?",style: TextStyle(color: Colors.white,fontSize: 12),),
                          GestureDetector(onTap: () async{
                            FocusScope.of(context).unfocus();
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
                                  _authViewModel.setLoading();
                                  Send_otp_params params= new Send_otp_params(emailPhone:widget.phonenumber,key: "reset-password");
                                  var response = await _authViewModel.sendotp(params, context);
                                  Send_otp_response send_otp_response = response;
                                  if (send_otp_response.status.compareTo("success") == 0) {
                                    displaytoast(send_otp_response.message, context);
                                     otpcontrollder.text=send_otp_response.otp.toString();
                                  } else {
                                    displaytoast(send_otp_response.message, context);
                                  }

                                }


                          },
                          child: Text(" Resend Again ",style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.bold),),)
                        ],
                      )

                    ],),),
                getFullScreenProviderLoader(
                    status: _authViewModel.getLoading(), context: context)
              ],
            )
          )

    );
  }

}