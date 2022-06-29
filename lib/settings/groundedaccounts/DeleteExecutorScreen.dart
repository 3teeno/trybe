import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:trybelocker/UniversalFunctions.dart';
import 'package:trybelocker/model/accountexecutorlist/executor_list_response.dart';
import 'package:trybelocker/model/deleteExecutor/delete_exe_params.dart';
import 'package:trybelocker/model/deleteExecutor/delete_exe_response.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/viewmodel/accountexecutor_viewmodel.dart';

class DeleteExecutorScreen extends StatefulWidget {
  static const String TAG = "/delete_executor_screen";
  UserData groundAcctslist;

  DeleteExecutorScreen(this.groundAcctslist);

  @override
  DeleteExecutorScreenState createState() =>
      DeleteExecutorScreenState(groundAcctslist);
}

class DeleteExecutorScreenState extends State<DeleteExecutorScreen> {
  UserData groundAcctslist;

  DeleteExecutorScreenState(this.groundAcctslist);

  AccountExecutorViewModel _accountExecutorViewModel;

  @override
  Widget build(BuildContext context) {
    _accountExecutorViewModel = Provider.of<AccountExecutorViewModel>(context);
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
                  'Account Executor', MemoryManagement.getuserprofilepic()),
              SizedBox(
                height: 100,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(groundAcctslist.username,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.white))),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side:
                            BorderSide(color: getColorFromHex(AppColors.red))),
                    onPressed: () {
                      deletaccountmethod();
                    },
                    color: Colors.white,
                    textColor: getColorFromHex(AppColors.red),
                    child:
                        Text("Delete Executor", style: TextStyle(fontSize: 14)),
                  )),
            ],
          ),
        ),
      )),
    );
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
            TextButton(
              child: Text('NO'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
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
    _accountExecutorViewModel.setLoading();
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _accountExecutorViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      DeleteExeParams params = new DeleteExeParams();
      params.uid = MemoryManagement.getuserId();
      params.executorId = groundAcctslist.id;

      var response =
          await _accountExecutorViewModel.deleteExecutor(params, context);
      DeleteExeResponse deleteuseraccResponse = response;
      if (deleteuseraccResponse.status.compareTo("success") == 0) {
        displaytoast("Successfully Deleted", context);
        
      } else {
        displaytoast("Failed to delete the account", context);
      }
    }
  }
}
