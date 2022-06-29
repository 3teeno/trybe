import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:trybelocker/UniversalFunctions.dart';
import 'package:trybelocker/model/contactus/contact_us_response.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/viewmodel/setting_view_model.dart';

class ContactUsScreen extends StatefulWidget {
  static const String TAG = "/contact_us_screen";

  @override
  ContactUsScreenState createState() => ContactUsScreenState();
}

class ContactUsScreenState extends State<ContactUsScreen> {
  SettingViewModel _settingViewModel;
  var _isLoading = false;

  getLoading() => _isLoading;
  List<Data> desciptionList = [];
  String descriptionValue = "";

  @override
  void initState() {
    super.initState();
    contactUs();
  }

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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  settingsHeader(
                      'Contact Us', MemoryManagement.getuserprofilepic()),
                  Container(
                      width: MediaQuery.of(context).size.width - 30,
                      child: Text(
                        "Most contact pages are designed with function in mind.They slap an email address, phone, and location on a plain background and call it a day But basic contact pages don’t inspire visitors to reach out and connect.Other pages make it easy to contact the company – which is awesome.Except, that can also drive up customer service costs.So what makes the perfect Contact Us page?Most contact pages are designed with function in mind.They slap an email address, phone, and location on a plain background and call it a day.But basic contact pages don’t inspire visitors to reach out and connect.Other pages make it easy to contact the company – which is awesome.Except, that can also drive up customer service costs.So what makes the perfect Contact Us page?",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void contactUs() async {
    _settingViewModel.getLoading();
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
      var response = await _settingViewModel.contactUsAPI(context);
      ContactUsResponse resetpasswordresponse = response;
      if (resetpasswordresponse.status.compareTo("success") == 0) {
        displaytoast("success", context);
      } else {
        displaytoast("failure", context);
      }
    }
  }
}
