import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trybelocker/model/updateprofile/update_profile_params.dart';
import 'package:trybelocker/model/updateprofile/update_profile_response.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/viewmodel/auth_view_model.dart';
import 'package:provider/src/provider.dart';
import 'package:trybelocker/viewmodel/setting_view_model.dart';
import '../../UniversalFunctions.dart';

class AccountInfoScreen extends StatefulWidget {
  static const String TAG = "/account_info";

  @override
  AccountInfoState createState() => AccountInfoState();
}

class AccountInfoState extends State<AccountInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var fullnameController = TextEditingController();
  var usernameController = TextEditingController();
  var birthdateController = TextEditingController();
  var phonenoController = TextEditingController();
  var aboutController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  SettingViewModel _settingViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setdata();
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
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Center(
                child: Container(
                  child: Column(
                    children: [
                      settingsHeader('Account Information',
                          MemoryManagement.getuserprofilepic()),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            setFormField("Email", false, emailController),
                            SizedBox(
                              height: 15,
                            ),
                            setFormField("Full Name", false, fullnameController),
                            SizedBox(
                              height: 15,
                            ),
                            setFormField("User name", false, usernameController),
                            SizedBox(
                              height: 15,
                            ),
                            setFormField("Birth date", false, birthdateController),
                            SizedBox(
                              height: 15,
                            ),
                            setFormField("Phone number", true, phonenoController,),
                            SizedBox(
                              height: 15,
                            ),
                            setFormField("About", false, aboutController,),
                            GestureDetector(
                                onTap: () {
                                  updateUserProfile();
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
                                        height: 200,
                                      ),
                                      Text(
                                        'Update',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 25),
                                      )
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            getFullScreenProviderLoader(status: _settingViewModel.getLoading(), context: context)
          ],
        ));
  }

  setFormField(String title, numberType, TextEditingController textformfieldController) {
    return Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              title,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            Spacer(),
            SizedBox(
              child: TextFormField(
                  keyboardType: numberType ? TextInputType.phone : TextInputType.text,
                  autofocus: false,
                  maxLines: title.compareTo("About")==0?3:1,
                  controller: textformfieldController,
                  readOnly: title.compareTo("Birth date")==0?true:false,
                  onTap: () {
                    if(title.compareTo("Birth date")==0){
                    _selectDate(context);
                    }
                  },
                  // ignore: missing_return
                  validator: (String arg) {
                    switch (title) {
                      case "Full Name":
                        if (arg.length < 6)
                          return 'FullName must be more than 5 charater';
                        else
                          return null;
                        break;
                      case "User name":
                        if (arg.length < 6)
                          return 'Username must be more than 5 charater';
                        else
                          return null;
                        break;
                      case "Birth date":
                        return null;
                        break;
                      case "Email":
                        Pattern pattern =
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        RegExp regex = new RegExp(pattern);
                        if (!regex.hasMatch(arg))
                          return 'Enter Valid Email';
                        else
                          return null;
                        break;
                      case "Phone number":
                        if (arg.length != 10)
                          return 'Phonenumber must contain 10 digit number';
                        else
                          return null;
                        break;
                    }
                  },
                  style: TextStyle(fontSize: 18),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    filled: true,
                    fillColor: Color(0xFFF2F2F2),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1, color: getColorFromHex(AppColors.red)),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1, color: Colors.red),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1, color: Colors.red),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1, color: Colors.red)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1, color: Colors.red)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1, color: Colors.red)),
                  )),
              width: 250,
            )
          ],
        ));
  }

  void setdata() {

    if (MemoryManagement.getuserName() != null && MemoryManagement.getuserName().isNotEmpty) {
      usernameController.text = MemoryManagement.getuserName();
    }
    if (MemoryManagement.getEmail() != null && MemoryManagement.getEmail().isNotEmpty&&MemoryManagement.getEmail().compareTo("null")!=0) {
      emailController.text = MemoryManagement.getEmail();
    }
    if (MemoryManagement.getfullName() != null && MemoryManagement.getfullName().isNotEmpty) {
      fullnameController.text = MemoryManagement.getfullName();
    }
    if (MemoryManagement.getbirthdate() != null && MemoryManagement.getbirthdate().isNotEmpty) {
      birthdateController.text = MemoryManagement.getbirthdate();
    }
    if (MemoryManagement.getPhonenumber() != null && MemoryManagement.getPhonenumber().isNotEmpty&&MemoryManagement.getPhonenumber().compareTo("null")!=0) {
      phonenoController.text = MemoryManagement.getPhonenumber();
    }
    if (MemoryManagement.getAbout() != null && MemoryManagement.getAbout().isNotEmpty&&MemoryManagement.getAbout().compareTo("null")!=0) {
      aboutController.text = MemoryManagement.getAbout();
    }
  }

  void updateUserProfile() async{

    _settingViewModel.setLoading();

    Update_profile_params request = new Update_profile_params();
    request.phoneNumber = phonenoController.text.trim();
    request.key = "3";
    request.fullName = fullnameController.text;
    request.about = aboutController.text;
    request.email = emailController.text.trim();
    request.birthDate = birthdateController.text.trim();
    request.username = usernameController.text;
    request.privacy_type = "1";
    request.userid = MemoryManagement.getuserId();

    print(request);

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
      var response = await _settingViewModel.updateprofile(request, context);
      UpdateProfileResponse updateProfileResponse = response;
      if (updateProfileResponse.status.compareTo("success") == 0) {
        displaytoast(updateProfileResponse.message,context);

        MemoryManagement.setuserName(username:  updateProfileResponse.userData.username);
        MemoryManagement.setfullName(fullname: updateProfileResponse.userData.fullName);
        MemoryManagement.setEmail(email:  updateProfileResponse.userData.email);
        MemoryManagement.setbirthdate(birthdate: updateProfileResponse.userData.birthDate);
        MemoryManagement.setPhonenumber(phonenumber:  updateProfileResponse.userData.phoneNumber);
        MemoryManagement.setAbout(about:  updateProfileResponse.userData.about);
        MemoryManagement.setlogintype(logintype: updateProfileResponse.userData.loginType.toString());

        Navigator.of(context).pop();
      } else {
        displaytoast(updateProfileResponse.message,context);
      }
    }
  }
  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        birthdateController.text = "${formatDateString(selectedDate.toString(), "dd/MM/yyyy")}";
      });
    }
  }
}
