import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trybelocker/model/getplaylist/getplaylistparams.dart';
import 'package:trybelocker/model/getplaylist/getplaylistresponse.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:trybelocker/viewmodel/profile_view_model.dart';
import '../../UniversalFunctions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/src/provider.dart';



class Groupusersfirebase extends StatefulWidget {
  static const String TAG = "/groupuserfirebase";
  String groupname;
  String user;
  String keys;

  Groupusersfirebase(this.user,this.groupname,this.keys);
  GroupusersfirebaseState createState() => GroupusersfirebaseState();
}

class GroupusersfirebaseState extends State<Groupusersfirebase> {
  var addusersreference ;
  DataSnapshot dataSnapshot;
  String username;
  bool isDataLoaded=false;
  ProfileViewModel _profileViewModel;
  List<PlaylistData> playlistdatalist = [];
  @override
  void initState() {
    super.initState();
    print("username=== ${MemoryManagement.getcoverphoto()}");
    if (MemoryManagement.getuserName() != null &&
        MemoryManagement
            .getuserName()
            .isNotEmpty) {
      username = MemoryManagement.getuserName();
    }
    addusersreference = FirebaseDatabase.instance.reference().child('groups').
    child(MemoryManagement.getuserId()).child(widget.keys).child('users');

    new Future.delayed(const Duration(milliseconds: 300), () {
      getCollections();
    });
  }

  getCollections() async{
    dataSnapshot= await addusersreference.orderByKey().once();
    dataSnapshot.key;
    print("length== ${dataSnapshot}");
    isDataLoaded=false;
    getCollectionList();

  }

  void getCollectionList() async {
    _profileViewModel.setLoading();
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _profileViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Getplaylistparams request = new Getplaylistparams(uid:MemoryManagement.getuserId(),other_uid: MemoryManagement.getuserId());
      var response = await _profileViewModel.getplaylist(request, context);
      Getplaylistresponse getplaylistresponse = response;
      if (getplaylistresponse.status.compareTo("success") == 0) {
        setState(() {
          playlistdatalist.clear();
          if (getplaylistresponse.playlistData != null &&
              getplaylistresponse.playlistData.length > 0) {
            playlistdatalist.addAll(getplaylistresponse.playlistData);
            // for (var data in playlistdatalist) {
            //   if (data.collectionName!=null&&data.collectionName.compareTo("Creative Journal") == 0) {
            //     playlistdatalist.remove(data);
            //     break;
            //   }
            // }

            isDataLoaded=true;

          }else{
            isDataLoaded=true;
          }
        });
      }else{
        setState(() {
          isDataLoaded=true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _profileViewModel = Provider.of<ProfileViewModel>(context);

    return  Scaffold(
        backgroundColor: getColorFromHex(AppColors.black),
        appBar: AppBar(
            brightness: Brightness.dark,
            backgroundColor: getColorFromHex(AppColors.black),
            title: Container(
              margin: EdgeInsets.only(left: 5),
              child:Text(widget.groupname,style: TextStyle(color: Colors.white,fontSize: 18),),
            )),
        body: Container(
          margin: EdgeInsets.only(left: 25,top: 10,bottom: 20),
          child:  FirebaseAnimatedList(
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            query: addusersreference,
            reverse: true,
            sort: (a, b) => b.key.compareTo(a.key),
            //comparing timestamp of messages to check which one would appear first
            itemBuilder: (_, DataSnapshot messageSnapshot, Animation<double> animation,int index) {
              print("index= $index");
              print("index= ${messageSnapshot.value}");
              return GestureDetector(
                onTap: () {
                  /*String groupname=messageSnapshot.value['groupname']!=null?messageSnapshot.value['groupname']:"";
    String admin=messageSnapshot.value['admin']!=null?messageSnapshot.value['admin']:"";
    String keys=messageSnapshot.key;
    Navigator.of(context,rootNavigator: true).
    push(MaterialPageRoute(builder: (context) => GroupChat(groupname,admin,keys)));*/
                },
                child: Container(
                  margin: EdgeInsets.only(top: 7,bottom:7,right: 7),

                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[

                      Text(messageSnapshot.value['username']!=null?messageSnapshot.value['username']:"",
                        style: TextStyle(color: Colors.white,fontSize: 18),),

                      InkWell(
                        onTap: () async {
                          print("ontapcalled");
                          // if(groupName.text!=null&&groupName.text.trim().length>0){
                          /*addusersreference.push().set({
                  'username':username,
                  'userid':id,
                  'email':email
                });*/
                          // displaytoast("${messageSnapshot.value['username']}", context);

                          addusersreference.orderByChild('username').
                          equalTo(messageSnapshot.value['username']).onChildAdded.listen((Event event) {
                            addusersreference.child(event.snapshot.key).remove();
                            displaytoast("User deleted successfully", context);
                          }, onError: (Object o) {
                            final DatabaseError error = o;
                            print('Error: ${error.code} ${error.message}');
                            // displaytoast('Error: ${error.code} ${error.message}', context);
                          });

                          //Navigator.pop(context);
                          // }
                        },
                        child: Container(
                            height: 30,
                            width: 90,
                            decoration: BoxDecoration(
                                color: getColorFromHex('#A10000')),
                            child: Center(
                              child: Text(
                                'Delete',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                      )




                    ],
                  ),
                ),
              );
            },
          ),

        ));
  }
}