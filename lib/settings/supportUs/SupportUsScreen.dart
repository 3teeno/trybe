import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trybelocker/UniversalFunctions.dart';
import 'package:trybelocker/model/deleteuseracc/deleteuseraccresponse.dart';
import 'package:trybelocker/settings/groundedaccounts/contactUsScreen.dart';
import 'package:trybelocker/settings/supportUs/SupportProjectScreen.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/viewmodel/setting_view_model.dart';
import 'package:provider/src/provider.dart';
import 'package:flutter_pay/flutter_pay.dart';

import '../settings.dart';

class SupportUsScreen extends StatefulWidget {
  static const String TAG = "/support_us";

  @override
  SupportUsScreenState createState() => SupportUsScreenState();
}

class SupportUsScreenState extends State<SupportUsScreen> {
  SettingViewModel _settingViewModel;
  bool isPaid = MemoryManagement.getPayment() == 0;

  @override
  Widget build(BuildContext context) {

    _settingViewModel = Provider.of<SettingViewModel>(context);
    return Scaffold(
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
            children: [
              settingsHeader(
                  'Support Us', MemoryManagement.getuserprofilepic()),
              SizedBox(
                height: 100,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side:
                            BorderSide(color: getColorFromHex(AppColors.red))),
                    onPressed: () {
                      // _selectImage();
                      navigateToNextScreen(
                          context, false, SupportProjectScreen());
                    },
                    color: Colors.white,
                    textColor: getColorFromHex(AppColors.red),
                    child: Text("Support the Project",
                        style: TextStyle(fontSize: 14)),
                  )),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side:
                            BorderSide(color: getColorFromHex(AppColors.red))),
                    onPressed: () {
                      makePayment();
                    },
                    color: Colors.white,
                    textColor: getColorFromHex(AppColors.red),
                    child: Text("Remove Ads from Feed",
                        style: TextStyle(fontSize: 14)),
                  )),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side:
                            BorderSide(color: getColorFromHex(AppColors.red))),
                    onPressed: () {
                      navigateToNextScreen(context, false, ContactUsScreen());
                    },
                    color: Colors.white,
                    textColor: getColorFromHex(AppColors.red),
                    child: Text("Contact Us", style: TextStyle(fontSize: 14)),
                  ))
            ],
          ),
        ),
      )),
    );
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
