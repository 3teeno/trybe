import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trybelocker/UniversalFunctions.dart';
import 'package:trybelocker/utils/app_color.dart';


class CustomFloatingButton extends StatelessWidget {
String icon;
bool ischecked;
int pos;
  CustomFloatingButton(this.icon, this.ischecked, this.pos);
  @override
  Widget build(BuildContext context) {

    return Container(
      width: 55,
      height: 55,
      child: Image.asset(
        icon,
        // height: 30,
        // width: 30,
        color: ischecked?Colors.red:Colors.white,
      ),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: getColorFromHex(AppColors.black)),
    );
  }
}
