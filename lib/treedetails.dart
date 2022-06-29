import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trybelocker/enums/enums.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/viewmodel/home_view_model.dart';
import 'package:trybelocker/viewmodel/trybe_tree_viewmodel.dart';
import 'UniversalFunctions.dart';
import 'model/trybemembers/gettrybe_members_response.dart';
import 'model/trybemembers/trybe_add_members_response.dart';
import 'model/trybemembers/tryebe_add_members_params.dart';
import 'package:provider/src/provider.dart';

class Treedetails extends StatefulWidget {
  int treeid;
  String nodetext;
  MemberData data;
  int nodeid;
  bool isParent = false;

  Treedetails(this.treeid, this.nodetext, this.nodeid, this.isParent,
      {this.data});

  TreedetailsState createState() => TreedetailsState();
}

class TreedetailsState extends State<Treedetails> {
  var malechecked = false;
  var livingchecked = false;
  int id;

  // var femalechecked= false;
  Gender _type = Gender.male;
  Status _status = Status.living;
  var firstnameController = TextEditingController();
  var lastnameControllder = TextEditingController();
  var suffixController = TextEditingController();
  //var relationController = DropdownButton(items: items);
  var birthplaceController = TextEditingController();
  var birthdateController = TextEditingController();
  var deathdateController = TextEditingController();
  var deathplaceController = TextEditingController();
  var notesController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  var birthdate;
  var deathdate;
  TrybeTreeViewModel _trybeTreeViewModel;
  MemberData data;
  bool isEdit = false;
  List<String> _relations = [
    'Father',
    'Mother',
    'Spouse',
    'Son',
    'Daughter',
    'Brother',
    'Sister'
  ];

  String _dropDownRelationValue, selecteddropvalue;
  @override
  void initState() {
    super.initState();
    widget.isParent = true;
    if (widget.data != null) {
      isEdit = true;
      data = widget.data;
      firstnameController.text = data.firstName;
      lastnameControllder.text = data.lastName;
      suffixController.text = data.suffix;
      birthplaceController.text = data.birthPlace;
      birthdateController.text = data.birthDate;
      deathdateController.text = data.deathDate;
      deathplaceController.text = data.deathPlace;
      notesController.text = data.notes;
      id = data.id;
      if (data.gender != null && data.gender.contains("female")) {
        _type = Gender.female;
      }
      if (data.livingStatus != null && data.livingStatus.contains("deceased")) {
        _status = Status.deceased;
      }
    }
    _dropDownRelationValue = widget.nodetext;

    birthdate =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day - 1);
    deathdate = selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    _trybeTreeViewModel = Provider.of<TrybeTreeViewModel>(context);
    var namedetails = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 20,
        ),
        new Flexible(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                      width: 100,
                      child: Text(
                        "First",
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      )),
                  Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      "*",
                      style: TextStyle(
                          color: getColorFromHex(AppColors.red), fontSize: 12),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    /*borderRadius: BorderRadius.circular(5)*/
                  ),
                  child: TextFormField(
                      controller: firstnameController,
                      autofocus: false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(5.0, 0, 0.0, 15.0),
                      ))),
            ],
          ),
        ),
        SizedBox(
          width: 20,
        ),
        new Flexible(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  child: Text(
                "Last",
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.white, fontSize: 12),
              )),
              SizedBox(
                height: 5,
              ),
              Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    /*borderRadius: BorderRadius.circular(5)*/
                  ),
                  child: TextFormField(
                      controller: lastnameControllder,
                      autofocus: false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(5.0, 0, 0.0, 15.0),
                      ))),
            ],
          ),
        ),
        SizedBox(
          width: 20,
        ),
        new Flexible(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  child: Text(
                "Suffix",
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.white, fontSize: 12),
              )),
              SizedBox(
                height: 5,
              ),
              Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    /*borderRadius: BorderRadius.circular(5)*/
                  ),
                  child: TextFormField(
                      controller: suffixController,
                      autofocus: false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(5.0, 0, 0.0, 15.0),
                      ))),
            ],
          ),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );

    var birthdetails = Row(
      // mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          width: 20,
        ),
        new Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Birth Date",
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    /*borderRadius: BorderRadius.circular(5)*/
                  ),
                  child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      controller: birthdateController,
                      autofocus: false,
                      readOnly: true,
                      onTap: () {
                        print("clickedcalled  birthdate");
                        _selectbirthDate(context);
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(5.0, 0, 0.0, 15),
                      ))),
            ],
          ),
        ),
        SizedBox(
          width: 20,
        ),
        new Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Birth Place",
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    /*borderRadius: BorderRadius.circular(5)*/
                  ),
                  child: TextFormField(
                      controller: birthplaceController,
                      autofocus: false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(5.0, 0, 0.0, 15.0),
                      ))),
            ],
          ),
        ),
        SizedBox(
          width: 20,
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
    var deathdetails = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 20,
        ),
        new Flexible(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Death Date",
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    /*borderRadius: BorderRadius.circular(5)*/
                  ),
                  child: TextFormField(
                      controller: deathdateController,
                      autofocus: false,
                      readOnly: true,
                      onTap: () {
                        _selectdeathdate(context);
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(5.0, 0, 0.0, 15.0),
                      ))),
            ],
          ),
        ),
        SizedBox(
          width: 20,
        ),
        new Flexible(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Death Place",
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    /*borderRadius: BorderRadius.circular(5)*/
                  ),
                  child: TextFormField(
                      controller: deathplaceController,
                      autofocus: false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(5.0, 0, 0.0, 15.0),
                      ))),
            ],
          ),
        ),
        SizedBox(
          width: 20,
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );

    var notes = Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Notes",
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          Container(
              margin: EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                /*borderRadius: BorderRadius.circular(5)*/
              ),
              child: TextFormField(
                  controller: notesController,
                  autofocus: false,
                  maxLines: 3,
                  minLines: 3,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.fromLTRB(5.0, 0, 0.0, 15.0),
                  ))),
        ],
      ),
    );

    var savetotrybe = GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        if (firstnameController.text != null &&
            firstnameController.text.trim().length > 0) {
          if (_dropDownRelationValue != null) {
            // if (relationController.text != null &&
            //     relationController.text.trim().length > 0) {
            savetrybemembers();
          } else {
            displaytoast("Relation required", context);
          }
        } else {
          displaytoast("First name required", context);
        }
      },
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(color: getColorFromHex(AppColors.red)),
        child: Text(
          "SAVE TO TRYBE",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );

    var cancel = GestureDetector(
      onTap: () {
        Navigator.of(context).pop(false);
      },
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(color: getColorFromHex(AppColors.orange)),
        child: Text(
          "CANCEL",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );

    return Scaffold(
        backgroundColor: getColorFromHex(AppColors.black),
        appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor: getColorFromHex(AppColors.black),
          title: Row(
            children: <Widget>[
              Image.asset(
                'assets/white_logo.png',
                width: 150,
                height: 150,
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    seperationline(2),
                    SizedBox(
                      height: 10,
                    ),
                    namedetails,
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              child: Text(
                            "Relation",
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          )),
                          SizedBox(
                            height: 5,
                          ),
                          !widget.isParent
                              ? Text(
                                  _dropDownRelationValue,
                                  style: TextStyle(color: Colors.white),
                                )
                              : Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    /*borderRadius: BorderRadius.circular(5)*/
                                  ),
                                  child: DropdownButton(
                                    underline: SizedBox(),
                                    hint: _dropDownRelationValue == null
                                        ? Text('Relation')
                                        : Text(
                                            _dropDownRelationValue,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                    isExpanded: true,
                                    iconSize: 30.0,
                                    style: TextStyle(color: Colors.black),
                                    items: _relations.map(
                                      (val) {
                                        return DropdownMenuItem<String>(
                                          value: val,
                                          child: Text(val),
                                        );
                                      },
                                    ).toList(),
                                    onChanged: (val) {
                                      setState(
                                        () {
                                          _dropDownRelationValue = val;
                                          if (_dropDownRelationValue == "Son" ||
                                              _dropDownRelationValue ==
                                                  "Father" ||
                                              _dropDownRelationValue ==
                                                  "Brother" ||
                                              _dropDownRelationValue ==
                                                  "Spouse") {
                                            _type = Gender.male;
                                          } else if (_dropDownRelationValue ==
                                                  "Mother" ||
                                              _dropDownRelationValue ==
                                                  "Sister" ||
                                              _dropDownRelationValue ==
                                                  "Daughter") {
                                            _type = Gender.female;
                                          }
                                          // displaytoast(_dropDownRelationValue,context);
                                        },
                                      );
                                    },
                                  ),
                                  /* child: TextFormField(
                                      controller: relationController,
                                      autofocus: false,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        contentPadding: EdgeInsets.fromLTRB(
                                            5.0, 0.0, 0.0, 15.0),
                                      ))*/
                                ),
                        ],
                      ),
                    ),
                    new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //gender
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(left: 25, top: 20),
                                    child: Text(
                                      "Gender",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                    margin: EdgeInsets.only(left: 12),
                                    child: Row(
                                      children: [
                                        Theme(
                                          data: ThemeData(
                                              //here change to your color
                                              unselectedWidgetColor:
                                                  Colors.white,
                                              toggleableActiveColor:
                                                  Colors.red),
                                          child: Container(
                                              width: 20,
                                              height: 20,
                                              margin: EdgeInsets.only(
                                                  left: 17,
                                                  top: 10,
                                                  right: 10,
                                                  bottom: 10),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                              ),
                                              // color: Colors.white,
                                              child: Radio(
                                                value: Gender.male,
                                                groupValue: _type,
                                                activeColor: Colors.red,
                                                onChanged: (value) {
                                                  print(value);
                                                  setState(() {
                                                    _type = value;
                                                  });
                                                },
                                              )),
                                        ),
                                        Text(
                                          "Male",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    )),
                                Container(
                                    margin: EdgeInsets.only(left: 12),
                                    child: Row(
                                      children: [
                                        Theme(
                                          data: ThemeData(
                                            //here change to your color
                                            unselectedWidgetColor: Colors.white,
                                            // toggleableActiveColor: Colors.red
                                          ),
                                          child: Container(
                                              width: 20,
                                              height: 20,
                                              margin: EdgeInsets.only(
                                                  left: 17,
                                                  right: 10,
                                                  bottom: 10),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                              ),
                                              // color: Colors.white,
                                              child: Radio(
                                                value: Gender.female,
                                                groupValue: _type,
                                                activeColor: Colors.red,
                                                onChanged: (value) {
                                                  print(value);
                                                  setState(() {
                                                    _type = value;
                                                  });
                                                },
                                              )),
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(bottom: 10),
                                            child: Text(
                                              "Female",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ))
                                      ],
                                    )),
                              ]),
                          //status
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(right: 25, top: 20),
                                    child: Text(
                                      "Status",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                    margin: EdgeInsets.only(right: 12),
                                    child: Row(
                                      children: [
                                        Theme(
                                          data: ThemeData(
                                              //here change to your color
                                              unselectedWidgetColor:
                                                  Colors.white,
                                              toggleableActiveColor:
                                                  Colors.red),
                                          child: Container(
                                              width: 20,
                                              height: 20,
                                              margin: EdgeInsets.only(
                                                  right: 17,
                                                  top: 10,
                                                  bottom: 10),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                              ),
                                              // color: Colors.white,
                                              child: Radio(
                                                value: Status.living,
                                                groupValue: _status,
                                                activeColor: Colors.red,
                                                onChanged: (value) {
                                                  print(value);
                                                  setState(() {
                                                    _status = value;
                                                  });
                                                },
                                              )),
                                        ),
                                        Text(
                                          "Living",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    )),
                                Container(
                                    margin: EdgeInsets.only(right: 12),
                                    child: Row(
                                      children: [
                                        Theme(
                                          data: ThemeData(
                                            //here change to your color
                                            unselectedWidgetColor: Colors.white,
                                            // toggleableActiveColor: Colors.red
                                          ),
                                          child: Container(
                                              width: 20,
                                              height: 20,
                                              margin: EdgeInsets.only(
                                                  right: 17, bottom: 10),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                              ),
                                              // color: Colors.white,
                                              child: Radio(
                                                value: Status.deceased,
                                                groupValue: _status,
                                                activeColor: Colors.red,
                                                onChanged: (value) {
                                                  print(value);
                                                  setState(() {
                                                    _status = value;
                                                  });
                                                },
                                              )),
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(bottom: 10),
                                            child: Text(
                                              "Deceased",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ))
                                      ],
                                    )),
                              ]),
                        ]),
                    birthdetails,
                    SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      child: deathdetails,
                      visible: _status == Status.deceased,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    notes,
                    Container(
                        margin: EdgeInsets.only(left: 20, top: 10),
                        child: Row(children: [
                          savetotrybe,
                          SizedBox(
                            width: 20,
                          ),
                          cancel
                        ])),
                  ])),
              getFullScreenProviderLoader(
                  status: _trybeTreeViewModel.getLoading(), context: context)
            ],
          ),
        ));
  }

  void savetrybemembers() async {
    _trybeTreeViewModel.setLoading();
    var firstname =
        firstnameController.text != null ? firstnameController.text : "";
    var lastname =
        lastnameControllder.text != null ? lastnameControllder.text : "";
    var suffix = suffixController.text != null ? suffixController.text : "";
    var relation =
        // relationController.text != null ? relationController.text : "";
        _dropDownRelationValue != null ? _dropDownRelationValue : "";
    var birthplace =
        birthplaceController.text != null ? birthplaceController.text : "";
    var deathplace =
        deathplaceController.text != null ? deathplaceController.text : "";
    var birthdate =
        birthdateController.text != null ? birthdateController.text : "";
    var deathdate =
        deathdateController.text != null ? deathdateController.text : "";
    var notes = notesController.text != null ? notesController.text : "";
    int nodeid;
    if (widget.nodetext == "Parent Node") {
      nodeid = 0;
    } else {
      nodeid = widget.nodeid;
    }
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        _trybeTreeViewModel.hideLoader();
      },
      onSuccess: () {},
    );
    if (gotInternetConnection) {
      Tryebe_add_members_params tryebe_add_members_params =
          new Tryebe_add_members_params(
              treeId: widget.treeid.toString(),
              firstName: firstname,
              lastName: lastname,
              suffix: suffix,
              relation: relation,
              birthPlace: birthplace,
              deathPlace: deathplace,
              notes: notes,
              birthDate: birthdate,
              deathDate: deathdate,
              livingStatus: _status.toString(),
              gender: _type.toString(),
              id: id,
              tree_relation: nodeid);
      var response = await _trybeTreeViewModel.addtrybemember(
          tryebe_add_members_params, context);
      Trybe_add_members_response trybe_add_members_response = response;
      if (trybe_add_members_response.status.compareTo("success") == 0) {
        displaytoast(trybe_add_members_response.message, context);
        Navigator.of(context).pop(trybe_add_members_response.node_id);
      } else {
        displaytoast(trybe_add_members_response.message, context);
      }
    }
  }

  _selectbirthDate(BuildContext context) async {
    var yesterday =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day - 1);

    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: birthdate,
      firstDate: DateTime(1950),
      lastDate: yesterday,
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        birthdate = picked;
        birthdateController.text =
            "${formatDateString(birthdate.toString(), "dd/MM/yyyy")}";
      });
  }

  _selectdeathdate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: deathdate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null)
      setState(() {
        deathdate = picked;
        deathdateController.text =
            "${formatDateString(deathdate.toString(), "dd/MM/yyyy")}";
      });
  }
}
