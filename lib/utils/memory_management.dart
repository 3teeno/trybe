import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SharedPrefsKeys.dart';

class MemoryManagement {
  static SharedPreferences prefs;

  static Future<bool> init() async {
    prefs = await SharedPreferences.getInstance();
    return true;
  }

  static void setuserName({@required String username}) {
   if(username!=null){
     prefs.setString(SharedPrefsKeys.USERNAME, username);
   }else{
     prefs.setString(SharedPrefsKeys.USERNAME, "");
   }
  }

  static String getuserName() {
    return prefs.getString(SharedPrefsKeys.USERNAME);
  }

  static void setuserId({@required String id}) {
    if(id!=null){
      prefs.setString(SharedPrefsKeys.USERID, id);
    }else{
      prefs.setString(SharedPrefsKeys.USERID, "");
    }

  }

  static String getuserId() {
    return prefs.getString(SharedPrefsKeys.USERID);
  }

  static void setUserLoggedIn({@required bool isUserLoggedin}) {
    if(isUserLoggedin!=null){
      prefs.setBool(SharedPrefsKeys.IS_USER_LOGGED_IN, isUserLoggedin);
    }else{
      prefs.setBool(SharedPrefsKeys.IS_USER_LOGGED_IN, false);
    }

  }

  static bool getUserLoggedIn() {
    return prefs.getBool(SharedPrefsKeys.IS_USER_LOGGED_IN);
  }
  static void setfullName({@required String fullname}) {
    if(fullname!=null){
      prefs.setString(SharedPrefsKeys.FULLNAME, fullname);
    }else{
      prefs.setString(SharedPrefsKeys.FULLNAME, "");
    }

  }
  static void setPayment({@required int payment}) {
    if(payment!=null){
      prefs.setInt(SharedPrefsKeys.PAYMENT, payment);
    }else{
      prefs.setInt(SharedPrefsKeys.PAYMENT, 0);
    }

  }

  static int getPayment() {
    return prefs.getInt(SharedPrefsKeys.PAYMENT);
  }
  static String getfullName() {
    return prefs.getString(SharedPrefsKeys.FULLNAME);
  }
  static void setbirthdate({@required String birthdate}) {
    if(birthdate!=null){
      prefs.setString(SharedPrefsKeys.BIRTHDATE, birthdate);
    }else{
      prefs.setString(SharedPrefsKeys.BIRTHDATE, "");
    }

  }

  static String getbirthdate() {
    return prefs.getString(SharedPrefsKeys.BIRTHDATE);
  }
  static void setEmail({@required String email}) {
  if(email!=null){
    prefs.setString(SharedPrefsKeys.EMAIL, email);
  }else{
    prefs.setString(SharedPrefsKeys.EMAIL, "");
  }

  }

  static String getEmail() {
    return prefs.getString(SharedPrefsKeys.EMAIL);
  }

  static void setuserprofilepic({@required String profilepic}) {
  if(profilepic!=null){
    prefs.setString(SharedPrefsKeys.PROFILEPIC, profilepic);
  }else{
    prefs.setString(SharedPrefsKeys.PROFILEPIC, "");
  }

  }

  static String getuserprofilepic() {
    return prefs.getString(SharedPrefsKeys.PROFILEPIC);
  }


  static void setcoverphoto({@required String coverphoto}) {
    if(coverphoto!=null){
      prefs.setString(SharedPrefsKeys.COVER_PHOTO, coverphoto);
    }else{
      prefs.setString(SharedPrefsKeys.COVER_PHOTO, "");
    }

  }

  static String getcoverphoto() {
    return prefs.getString(SharedPrefsKeys.COVER_PHOTO);
  }

  static void setlogintype({@required String logintype}) {
    if(logintype!=null){
      prefs.setString(SharedPrefsKeys.LOGIN_TYPE, logintype);
    }else{
      prefs.setString(SharedPrefsKeys.LOGIN_TYPE, "");
    }

  }

  static String getlogintype() {
    return prefs.getString(SharedPrefsKeys.LOGIN_TYPE);
  }

  static void setPhonenumber({@required String phonenumber}) {
   if(phonenumber!=null){
     prefs.setString(SharedPrefsKeys.PHONENO, phonenumber);
   }else{
     prefs.setString(SharedPrefsKeys.PHONENO, "");
   }
  }

  static String getPhonenumber() {
    return prefs.getString(SharedPrefsKeys.PHONENO);
  }

  static void setAbout({@required String about}) {
    if(about!=null){
      prefs.setString(SharedPrefsKeys.ABOUT, about);
    }else{
      prefs.setString(SharedPrefsKeys.ABOUT, "");
    }
  }
  static String getAbout() {
    return prefs.getString(SharedPrefsKeys.ABOUT);
  }

  static void setnotificationid({@required int id}) {
    prefs.setInt(SharedPrefsKeys.NOTIFICATION_ID, id);
  }

  static int getNotificationId() {
    return prefs.getInt(SharedPrefsKeys.NOTIFICATION_ID);
  }
  static void clearMemory() {
    prefs.clear();
  }
  static String setsaveotheraccounts({@required String userDetails}){
    prefs.setString(SharedPrefsKeys.USER_DETAILS, userDetails);
  }

  static String getsaveotheraccounts(){
   return prefs.getString(SharedPrefsKeys.USER_DETAILS);
  }

  static String setDeviceToken({@required String devic_token}){
    prefs.setString(SharedPrefsKeys.DEVICE_TOKEN, devic_token);
  }

  static String getDeviceToken(){
    return prefs.getString(SharedPrefsKeys.DEVICE_TOKEN);
  }

  static bool setTrybelistPrivate({@required bool trybelistprivate}){
    prefs.setBool(SharedPrefsKeys.TRYBELISTPRIVATE, trybelistprivate);
  }

  static bool getTrybelistPrivate(){
    return prefs.getBool(SharedPrefsKeys.TRYBELISTPRIVATE);
  }

  static bool setTrybegroupPrivate({@required bool trybegroupprivate}){
    prefs.setBool(SharedPrefsKeys.TRYBEGROUPPRIVATE, trybegroupprivate);
  }

  static bool getTrybegroupPrivate(){
    return prefs.getBool(SharedPrefsKeys.TRYBEGROUPPRIVATE);
  }
}
