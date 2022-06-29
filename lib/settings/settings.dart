import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_pay/flutter_pay.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/src/provider.dart';
import 'package:trybelocker/model/deleteuseracc/deleteuseraccparams.dart';
import 'package:trybelocker/model/deleteuseracc/deleteuseraccresponse.dart';
import 'package:trybelocker/settings/groundedaccounts/contactUsScreen.dart';
import 'package:trybelocker/settings/groundedaccounts/privacyScreen.dart';
import 'package:trybelocker/settings/resetpassword/reset_password.dart';
import 'package:trybelocker/settings/supportUs/SupportUsScreen.dart';
import 'package:trybelocker/settings/switchaccount/switch_account.dart';
import 'package:trybelocker/social_login.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/viewmodel/setting_view_model.dart';

import '../UniversalFunctions.dart';
import 'accountinfo/account_info.dart';
import 'groundedaccounts/grounded_accounts.dart';

FlutterPay flutterPay = FlutterPay();

class SettingsScreen extends StatefulWidget {
  static const String TAG = "/settingscreen";

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<SettingsScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final facebookLogin = FacebookLogin();
  SettingViewModel _settingViewModel;
  bool isPaid = MemoryManagement.getPayment() == 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("logintype=>,${MemoryManagement.getlogintype()}");

    _settingViewModel = Provider.of<SettingViewModel>(context);
    // TODO: implement build
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
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
                  settingsHeader(
                      'Account Settings', MemoryManagement.getuserprofilepic()),
                  setModuleButton("Account Information", 0),
                  SizedBox(
                    height: 15,
                  ),
                  setModuleButton("Grounded Accounts", 1),
                  SizedBox(
                    height: 15,
                  ),
                  setModuleButton("Privacy", 2),
                  SizedBox(
                    height: 15,
                  ),
                  setModuleButton("Password Reset", 3),
                  Visibility(
                    visible: MemoryManagement.getlogintype() != null
                        ? MemoryManagement.getlogintype().compareTo("3") == 0
                            ? false
                            : true
                        : true,
                    child: SizedBox(
                      height: 15,
                    ),
                  ),
                  setModuleButton("Switch Account", 4),
                  SizedBox(
                    height: 15,
                  ),
                  setModuleButton("Delete Account", 5),
                  /*SizedBox(
                    height: 15,
                  ),
                  setModuleButton("Contact Us", 6),*/
                  /*SizedBox(
                    height: 15,
                  ),
                  isPaid ? Container() : setModuleButton("Remove Ads", 7),*/
                  SizedBox(
                    height: 15,
                  ),
                  setModuleButton("Support Us", 8),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future<bool> _onBackPressed() async {
    Navigator.of(context).pop(true);
  }

  setModuleButton(text, int type) {
    return Visibility(
        visible: type == 3
            ? MemoryManagement.getlogintype() != null
                ? MemoryManagement.getlogintype().compareTo("3") == 0
                    ? false
                    : true
                : true
            : true,
        child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: BorderSide(color: Colors.red)),
              onPressed: () {
                switch (type) {
                  case 0:
                    navigateToNextScreen(context, false, AccountInfoScreen());
                    break;
                  case 1:
                    navigateToNextScreen(context, false, GroundedAcctScreen());
                    break;
                  case 2:
                    navigateToNextScreen(context, false, PrivacyScreen());
                    break;
                  case 3:
                    navigateToNextScreen(context, false, Passwordreset());
                    break;
                  case 4:
                    navigateToNextScreen(context, false, SwitchAcctScreen());
                    break;
                  case 5:
                    deletaccountmethod();
                    break;
                  case 6:
                    navigateToNextScreen(context, false, ContactUsScreen());
                    break;
                  case 7:
                    makePayment();
                    break;
                  case 8:
                    navigateToNextScreen(context, false, SupportUsScreen());
                    break;
                }
              },
              color: Colors.white,
              textColor: Colors.redAccent,
              child: Text(text, style: TextStyle(fontSize: 14)),
            )));
  }

  deletaccountmethod() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete an account?'),
          content: Text('Do you want to delete an Account'),
          actions: <Widget>[
            FlatButton(
              child: Text('NO'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text('YES'),
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop(true);
                  deleteuseraccount();
                });
              },
            ),
          ],
        );
      },
    );
  }

  void deleteuseraccount() async {
    _settingViewModel.setLoading();
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _settingViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Deleteuseraccparams params =
          new Deleteuseraccparams(uid: MemoryManagement.getuserId());
      var response = await _settingViewModel.deleteuseraccount(params, context);
      DeleteuseraccResponse deleteuseraccResponse = response;
      if (deleteuseraccResponse.status.compareTo("success") == 0) {
        displaytoast("Sucessfully Deleted", context);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (BuildContext context) => SocialLogin(),
            ),
            (route) => false);
      } else {
        displaytoast("Failed to delete the account", context);
      }
    }
  }

  void sendStripeToken(token) async {
    _settingViewModel.setLoading();
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _settingViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Map data = {
        'amount': '1',
        'stripeToken': token.toString(),
        'uid': MemoryManagement.getuserId()
      };
      var response = await _settingViewModel.sendStripeToken(data, context);
      DeleteuseraccResponse deleteuseraccResponse = response;
      if (deleteuseraccResponse.status.compareTo("success") == 0) {
        displaytoast("Add removed Successfully", context);
        setState(() {
          isPaid = true;
          MemoryManagement.setPayment(payment: 1);
        });
      } else {
        displaytoast("Failed to delete the account", context);
      }
    }
  }

  void makePayment() async {
    print("here");
    List<PaymentItem> items = [PaymentItem(name: "Banner Ads", price: 1)];

    flutterPay.setEnvironment(environment: PaymentEnvironment.Test);

    String token = await flutterPay.requestPayment(
      googleParameters: GoogleParameters(
        merchantId: "Trybe",
        merchantName: "Trybe",
        gatewayName: "stripe",
        gatewayMerchantId:
            "pk_test_51J7fofEctKEdp2Prz5hG05WV7PkvbfZc1zNri4w7feyKJiw9z9TdEAAxBw1qKsEWwXdYE3EOsLPQPD2w0fehhb1400U6muAwJn",
      ),
      appleParameters:
          AppleParameters(merchantIdentifier: "merchant.trybe.lock"),
      currencyCode: "USD",
      countryCode: "US",
      paymentItems: items,
    );
    var stripeData = json.decode(token);
    print(stripeData['id']);
    sendStripeToken(stripeData['id']);
  }
}
