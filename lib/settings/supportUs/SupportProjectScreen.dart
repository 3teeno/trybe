import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trybelocker/UniversalFunctions.dart';
import 'package:trybelocker/model/supportUs/support_us_response.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/viewmodel/SupportUsViewModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/src/provider.dart';

class SupportProjectScreen extends StatefulWidget {
  static const String TAG = "/support_project_screen";

  @override
  SupportProjectScreenState createState() => SupportProjectScreenState();
}

class SupportProjectScreenState extends State<SupportProjectScreen> {
  List<Data> supportUsList = [];
  SupportUsViewModel _supportUsViewModel;
  bool isDataLoaded = false;
  bool isnearpostLoading = false;
  int currentPage = 1;
  int limit = 10;
  bool allnearPost = false;

  @override
  void initState() {
    super.initState();
    new Future.delayed(const Duration(milliseconds: 300), () {
      getlist();
    });
  }

  void getlist() {
    isDataLoaded = false;
    isnearpostLoading = false;
    currentPage = 1;
    allnearPost = false;
    if (isnearpostLoading == false && allnearPost == false) {
      setState(() {
        isnearpostLoading = true;
      });
      getSupportusData();
    }
  }

  void getSupportusData() async {
    var response = await _supportUsViewModel.supportUs(context);
    SupportUsResponse supportUsResponse = response;

    isDataLoaded = true;
    if (supportUsResponse != null &&
        supportUsResponse.data != null &&
        supportUsResponse.data.length > 0) {
      if (supportUsResponse.data.length < limit) {
        allnearPost = true;
        isnearpostLoading = false;
      }
      if (supportUsResponse != null) {
        if (supportUsResponse.status != null &&
            supportUsResponse.status.isNotEmpty) {
          if (supportUsResponse.status.compareTo("success") == 0) {
            supportUsList.addAll(supportUsResponse.data);

            setState(() {});
          } else {}
        }
      }
      setState(() {
        isnearpostLoading = false;
      });
    } else {
      allnearPost = true;
      setState(() {
        isnearpostLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    _supportUsViewModel = Provider.of<SupportUsViewModel>(context);
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
                  'Support the Project', MemoryManagement.getuserprofilepic()),
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
                    _launchPatreonURL(supportUsList[0].patreon);
                    //_launchPatreonURL("https://aquantuo.com/");
                    },
                    color: Colors.white,
                    textColor: getColorFromHex(AppColors.red),
                    child: Text("Patreon", style: TextStyle(fontSize: 14)),
                  )),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side:
                            BorderSide(color: getColorFromHex(AppColors.red))),
                    onPressed: () {
                      _launchPatreonURL(supportUsList[0].paypal);
                    },
                    color: Colors.white,
                    textColor: getColorFromHex(AppColors.red),
                    child: Text("Paypal", style: TextStyle(fontSize: 14)),
                  )),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side:
                            BorderSide(color: getColorFromHex(AppColors.red))),
                    onPressed: () {
                      _launchPatreonURL(supportUsList[0].bitcoin);
                    },
                    color: Colors.white,
                    textColor: getColorFromHex(AppColors.red),
                    child: Text("Stripe", style: TextStyle(fontSize: 14)),
                  ))
            ],
          ),
        ),
      )),
    );
  }

  _launchPatreonURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
