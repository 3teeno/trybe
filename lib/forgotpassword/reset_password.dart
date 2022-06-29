

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trybelocker/UniversalFunctions.dart';
import 'package:trybelocker/model/setnewpassword/new_password_params.dart';
import 'package:trybelocker/model/setnewpassword/new_password_response.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/viewmodel/auth_view_model.dart';
import 'package:provider/src/provider.dart';

import '../login_screen.dart';

class ResetPassword extends StatefulWidget{
  String phonenumber;
  ResetPassword(this.phonenumber);

  ResetPasswordState createState() => ResetPasswordState();
}
class ResetPasswordState extends State<ResetPassword>{
  TextEditingController passwordController= new TextEditingController();
  TextEditingController confirmPasswordController= new TextEditingController();
  AuthViewModel _authViewModel;
  @override
  Widget build(BuildContext context) {
    _authViewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(backgroundColor:getColorFromHex(AppColors.black),
      appBar: AppBar(
        backgroundColor:getColorFromHex(AppColors.black),
        brightness: Brightness.dark,
        title:Row(children: <Widget>[
        Image.asset('assets/white_logo.png',width: 150,height: 150,),
      ],),),
      body: Stack(
        children: <Widget>[
          Container(margin: EdgeInsets.all(0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 50,),
                Text('Create a password at least 8 characters long.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white,fontSize: 14),),
                SizedBox(height: 70,),
                Center(
                  child:Column(children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 10),
                        width: 250, child:Text("New Password",
                      textAlign: TextAlign.left, style: TextStyle(fontSize: 14,color: Colors.white),)),
                    SizedBox(height: 10,),
                    Container(height: 40,width: 250,decoration: BoxDecoration(color: Colors.white,shape:BoxShape.rectangle,border: Border.all(color: getColorFromHex(AppColors.red),width: 1), borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(autofocus: false,obscureText: true, textAlign: TextAlign.left,
                        controller: passwordController,
                        decoration: InputDecoration(border: InputBorder.none,focusedBorder: InputBorder.none,errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 18),
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 14,),),
                        style: TextStyle(color: Colors.black, fontSize: 14,),),
                    ),
                  ],),
                ),
                SizedBox(height: 20,),
                Center(
                  child:Column(children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 10),
                        width: 250, child:Text("New Password Confirmation",
                      textAlign: TextAlign.left, style: TextStyle(fontSize: 14,color: Colors.white),)),
                    SizedBox(height: 10,),
                    Container(height: 40,width: 250,decoration: BoxDecoration(color: Colors.white,shape:BoxShape.rectangle,border: Border.all(color: getColorFromHex(AppColors.red),width: 1), borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(autofocus: false,obscureText: true, textAlign: TextAlign.left,
                        controller: confirmPasswordController,
                        decoration: InputDecoration(border: InputBorder.none,focusedBorder: InputBorder.none,errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 18),
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 14,),),
                        style: TextStyle(color: Colors.black, fontSize: 14,),),
                    ),
                  ],),
                ),
                Expanded(child:Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: GestureDetector(
                      onTap: () async{
                        FocusScope.of(context).unfocus();
                        if(passwordController!=null&&passwordController.text.trim().length>0){
                          if(passwordController.text.toString().length>=8){
                            if(confirmPasswordController!=null&&confirmPasswordController.text.trim().length>0){
                              if(confirmPasswordController.text.trim().compareTo(passwordController.text.trim())==0){
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
                                  New_passsword_params params= new New_passsword_params(emailPhone:widget.phonenumber,password: passwordController.text.trim(),
                                      confirmPassword: confirmPasswordController.text.trim());
                                  var response = await _authViewModel.setNewPassword(params, context);
                                  New_password_response newpasswordresponse = response;
                                  if (newpasswordresponse.status.compareTo("success") == 0) {
                                    displaytoast(newpasswordresponse.message, context);
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) => LoginScreen(),
                                        ),
                                            (route) => false);
                                  } else {
                                    displaytoast(newpasswordresponse.message, context);
                                  }

                                }
                              }else{
                                displaytoast("Password and confirm password get mismatched", context);
                              }
                            }else{
                              displaytoast("Confirm password required", context);
                            }
                          }else{
                            displaytoast("Password should be greater than equal to 8 digits", context);
                          }
                        }else{
                          displaytoast("Password required", context);
                        }
                      },
                      child:  Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/submitbuttonbg.png',
                            width: 250,
                            height: 250,
                          ),
                          Text(
                            'Reset Password',
                            style: TextStyle(
                                color: Colors.white, fontSize: 20),
                          )
                        ],
                      ),
                    )
                ))
              ],),),
          getFullScreenProviderLoader(
              status: _authViewModel.getLoading(), context: context)
        ],
      ));
  }

}