

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trybelocker/forgotpassword/login_help.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/verification/get_otp.dart';

import '../UniversalFunctions.dart';

class AccessAccount extends StatefulWidget{
  AccessAccountState createState() => AccessAccountState();
}
class AccessAccountState extends State<AccessAccount>{
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
     appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.0),
        child: AppBar(backgroundColor: Colors.transparent,elevation: 0.0, brightness: Brightness.dark,),
      ),
      backgroundColor: getColorFromHex(AppColors.black),
      body: Container(
        margin: EdgeInsets.all(15),
        child:  Column(
          children: <Widget>[
            Row(children: <Widget>[
                IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,size: 30,), onPressed: (){
                  Navigator.of(context).pop();
                }),
                SizedBox(width: 10,),
                Text('Access Your Account',style: TextStyle(color: Colors.white,fontSize: 18),),
              ],),

            SizedBox(height: 40,),
        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginHelp()));
          },
          child:   Row(children: <Widget>[
            IconButton(icon: Icon(Icons.email_outlined,color: Colors.white,size: 35,), onPressed: (){}),
            SizedBox(width: 15,),
            Text('Send an Email',style: TextStyle(color: Colors.white,fontSize: 14),),
          ],),
        ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => GetOtp()));
              },
              child: Row(children: <Widget>[
                IconButton(icon: Icon(Icons.phone_android_sharp,color: Colors.white,size: 35,), onPressed: (){}),
                SizedBox(width: 15,),
                Text('Send an SMS',style: TextStyle(color: Colors.white,fontSize: 14),),
              ],),
            ),
            Expanded(child: Align(alignment: Alignment.bottomCenter,
              child:Container(
                margin: EdgeInsets.all(20),
                child:Text('Need More Help Email Us At TrybeLockr@gmail.com',textAlign:TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 14),),),))
      ],
       ),
      ),
    );
  }

}