import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trybelocker/treedetails.dart';
import 'package:trybelocker/utils/app_color.dart';
import 'package:trybelocker/utils/memory_management.dart';
import 'package:provider/src/provider.dart';
import 'package:trybelocker/viewmodel/trybe_tree_viewmodel.dart';
import 'UniversalFunctions.dart';
import 'model/treebegroup/delete_trybe.dart';
import 'model/treebegroup/treebe_group_list_response.dart';
import 'package:graphview/GraphView.dart';
import 'model/trybemembers/gettrybe_members_response.dart';
import 'model/trybemembers/get_trybe_members_params.dart';
import 'networkmodel/APIs.dart';
import 'package:flutter_share/flutter_share.dart';

class AddTrybeMembers extends StatefulWidget {
  int trybeid = 0;

  AddTrybeMembers(this.trybeid);

  AddTrybeMembersState createState() => AddTrybeMembersState();
}

class AddTrybeMembersState extends State<AddTrybeMembers> {
  TrybeTreeViewModel _trybeTreeViewModel;
  List<MemberData> membersdatalist = [];
  Graph graph = Graph();
  Node node1;
  Node node2;
  Node node3;
  Node rootNode;
  Node fatherNode;
  Node motherNode;
  int rootNodeId;
  BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();
  bool isOwner = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      getTrybeMembers();
    });
  }

  Widget getFirstNode() {
    return Row(
      children: <Widget>[
        Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image:
                      getProfileImage(MemoryManagement.getuserprofilepic()))),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context, rootNavigator: true)
                .push(MaterialPageRoute(
                    builder: (context) =>
                        Treedetails(widget.trybeid, "Parent Node", 0, true)))
                .then((value) {
              if (value != null) {
                getTrybeMembers();
              }
            });
          },
          child: Container(
            height: 35,
            width: 200,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: getColorFromHex(AppColors.red)),
            child: Center(
              child: Text(
                "+ Add Trybe Member",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        )
      ],
    );
  }

  // Widget getfatherNode(nodeId) {
  //   return Row(
  //     children: <Widget>[
  //       GestureDetector(
  //         onTap: () {
  //           if (nodeId == null) {
  //             displaytoast("Please Add trybemember first", context);
  //             return;
  //           } else {
  //             Navigator.of(context, rootNavigator: true)
  //                 .push(MaterialPageRoute(
  //                     builder: (context) =>
  //                         Treedetails(widget.trybeid, "Father", nodeId,nodeId==rootNodeId)))
  //                 .then((value) {
  //               if (value != null) {
  //                 getTrybeMembers();
  //               }
  //             });
  //           }
  //         },
  //         child: Container(
  //           height: 35,
  //           width: 200,
  //           decoration: BoxDecoration(
  //               shape: BoxShape.rectangle,
  //               color: getColorFromHex(AppColors.red)),
  //           child: Center(
  //             child: Text(
  //               "+ Father",
  //               style: TextStyle(color: Colors.white, fontSize: 16),
  //             ),
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }

  Widget getDefaultNode(nodeId, type) {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (nodeId == null) {
              displaytoast("Please Add trybemember first", context);
              return;
            } else {
              Navigator.of(context, rootNavigator: true)
                  .push(MaterialPageRoute(
                      builder: (context) =>
                          Treedetails(widget.trybeid, type, nodeId, false)))
                  .then((value) {
                if (value != null) {
                  getTrybeMembers();
                }
              });
            }
          },
          child: Container(
            height: 35,
            width: 200,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: getColorFromHex(AppColors.red)),
            child: Center(
              child: Text(
                '+ $type',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        )
      ],
    );
  }

  getProfileImage(String userImage) {
    if (userImage != null && userImage.isNotEmpty) {
      if (userImage.contains("https") || userImage.contains("http")) {
        return NetworkImage(userImage);
      } else {
        return NetworkImage(APIs.userprofilebaseurl + userImage);
      }
    } else {
      return NetworkImage(
          "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjM3Njd9&auto=format&fit=crop&w=750&q=80");
    }
  }

  Widget getNodeText(MemberData data) {
    return GestureDetector(
        onTap: () {
          var nodeData = membersdatalist.firstWhere((element) =>
              element.id.toString() == data.treeRelation.toString());

          AlertDialog alert = AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(data.firstName.toString()),
                TextButton.icon(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.teal,
                      onSurface: Colors.grey,
                    ),
                    label: Text('Add Member'),
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context, rootNavigator: true)
                          .push(MaterialPageRoute(
                              builder: (context) => Treedetails(
                                    widget.trybeid,
                                    data.relation,
                                    data.id,
                                    false,
                                  )))
                          .then((value) {
                        if (value != null) {
                          getTrybeMembers();
                        }
                      });
                    })
              ],
            ),
            content: Text('${nodeData.firstName}`s ${data.relation}'),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                // color: Colors.red,
                child: Text("Delete"),
                onPressed: () async {
                  var node = graph.nodes.firstWhere(
                      (element) =>
                          element.key.toString() ==
                          ValueKey(data.id).toString(),
                      orElse: () => null);

                  Navigator.of(context).pop();
                  var response = await _trybeTreeViewModel.deleteTrybeNode(
                      data.id.toString(), context);
                  getTrybeMembers();
                },
              ),
              TextButton(
                child: Text("Edit"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context, rootNavigator: true)
                      .push(MaterialPageRoute(
                          builder: (context) => Treedetails(
                                widget.trybeid,
                                data.relation,
                                data.treeRelation,
                                false,
                                data: data,
                              )))
                      .then((value) {
                    if (value != null) {
                      getTrybeMembers();
                    }
                  });
                },
              ),
            ],
          );

          // show the dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            },
          );
        },
        child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(color: Colors.white, spreadRadius: 1),
              ],
            ),
            child: Text(
              data.firstName != null ? data.firstName : "Not defined",
              style: TextStyle(fontSize: 14, color: Colors.black),
            )));
  }

  @override
  Widget build(BuildContext context) {
    _trybeTreeViewModel = Provider.of<TrybeTreeViewModel>(context);
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
        actions: isOwner
            ? <Widget>[
                IconButton(icon: Icon(Icons.share), onPressed: () {FlutterShare.share(
        title: 'Share Tree',
        text: 'Share Tree',
        linkUrl: APIs.treeShare + "?treeId=" + widget.trybeid.toString(),
        chooserTitle: 'Chooser Title');
                }),
                IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Delete TrybeTree ?'),
                            content: Text(
                                'Do you really want to delete this trybe tree'),
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
                                    Navigator.of(context).pop(false);
                                    deletetrybegroup();
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }),
                SizedBox(
                  width: 5,
                ),
              ]
            : null,
      ),
      // floatingActionButton: FloatingActionButton(
      //     onPressed: () async {
      //       Navigator.of(context, rootNavigator: true)
      //           .push(MaterialPageRoute(
      //               builder: (context) =>
      //                   Treedetails(widget.trybeid, "Test", -1, false)))
      //           .then((value) {
      //         if (value != null) {
      //           getTrybeMembers();
      //         }
      //       });
      //     },
      //     child: Container(
      //       width: 55,
      //       height: 55,
      //       child: Center(
      //           child: Icon(
      //         Icons.add,
      //         color: Colors.white,
      //         size: 28,
      //       )),
      //       decoration: BoxDecoration(
      //           shape: BoxShape.circle, color: getColorFromHex(AppColors.red)),
      //     ),
      //     heroTag: "floating",
      //     backgroundColor: getColorFromHex(AppColors.red)),
      body: Stack(
        children: <Widget>[
          graph.edges.length > 0
              ? Column(
                  children: <Widget>[
                    Expanded(
                      child: InteractiveViewer(
                          boundaryMargin: EdgeInsets.all(20),
                          constrained: false,
                          minScale: 0.0001,
                          maxScale: 1.0,
                          child: GraphView(
                            graph: graph,
                            algorithm: BuchheimWalkerAlgorithm(
                                builder, TreeEdgeRenderer(builder)),
                            paint: Paint()
                              ..color = Colors.green
                              ..strokeWidth = 1
                              ..style = PaintingStyle.stroke,
                          )),
                    ),
                  ],
                )
              : Container(),
          getFullScreenProviderLoader(
              status: _trybeTreeViewModel.getLoading(), context: context)
        ],
      ),
    );
  }

  void deletetrybegroup() async {
    _trybeTreeViewModel.setLoading();
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
      Delete_trybe params = new Delete_trybe(
          uid: MemoryManagement.getuserId(), id: widget.trybeid.toString());
      var response = await _trybeTreeViewModel.deleteTrybe(params, context);
      Treebe_group_list_response deletetrberesponse = response;
      if (deletetrberesponse.status.compareTo("success") == 0) {
        displaytoast("Sucessfully Deleted", context);
        Navigator.pop(context, true);
      } else {
        displaytoast("Failed to delete the group", context);
      }
    }
  }

  void getTrybeMembers() async {
    membersdatalist.clear();
    _trybeTreeViewModel.setLoading();
    graph = Graph();
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
      Get_trybe_members_params params =
          new Get_trybe_members_params(treeId: widget.trybeid.toString());
      var response = await _trybeTreeViewModel.gettrybemembers(params, context);
      Gettrybe_members_response gettrbemembers = response;
      setState(() {
        isOwner = gettrbemembers.userId.toString() ==
            MemoryManagement.getuserId().toString();
      });
      if (gettrbemembers.status.compareTo("success") == 0) {
        if (gettrbemembers.memberData != null &&
            gettrbemembers.memberData.length > 0) {
          membersdatalist.addAll(gettrbemembers.memberData);
          if (membersdatalist.length == 1) {
            var data = membersdatalist[0];
            rootNode = Node(
                Column(
                  children: [
                    getNodeText(data),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true)
                                .push(MaterialPageRoute(
                                    builder: (context) => Treedetails(
                                        widget.trybeid, "Son", data.id, true)))
                                .then((value) {
                              if (value != null) {
                                getTrybeMembers();
                              }
                            });
                          },
                          child: Container(
                            height: 35,
                            padding: EdgeInsets.only(left: 4, right: 4),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: getColorFromHex(AppColors.red)),
                            child: Center(
                              child: Text(
                                "+ Add",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                key: ValueKey(data.id));
            fatherNode = Node(getDefaultNode(data.id, "Father"));
            motherNode = Node(getDefaultNode(data.id, "Mother"));
            graph.addEdge(rootNode, fatherNode);
            graph.addEdge(rootNode, motherNode);
            // graph.addEdge(node4, node6, paint: Paint()..color = Colors.red);
          } else {
            var graphNodes = graph.nodes;
            for (var data in membersdatalist) {
              var index = membersdatalist.indexOf(data);
              if (index != 0) {
                var node = graphNodes.firstWhere(
                    (element) =>
                        element.key.toString() ==
                        ValueKey(data.treeRelation).toString(),
                    orElse: () => null);
                var nodeData = membersdatalist.firstWhere((element) =>
                    element.id.toString() == data.treeRelation.toString());
                List<String> _relations=['Father', 'Mother'];

                if (node != null) {
                  var dynamicNode =
                      Node(getNodeText(data), key: ValueKey(data.id));
                  graph.addEdge(node, dynamicNode);
                  var currentNodeData = membersdatalist.firstWhere(
                      (element) => element.id.toString() == data.id.toString());

                  if (currentNodeData.relationArray == null &&
                      (currentNodeData.relation == "Mother" ||
                          currentNodeData.relation == "Father")) {
                    graph.addEdge(dynamicNode,
                        Node(getDefaultNode(currentNodeData.id, "Mother")),
                        paint: Paint()..color = Colors.red);
                    graph.addEdge(dynamicNode,
                        Node(getDefaultNode(currentNodeData.id, "Father")),
                        paint: Paint()..color = Colors.red);
                  }
                  for (var relation in _relations) {
                    if (!nodeData.relationArray.contains(relation) &&
                        (currentNodeData.relation == "Mother" ||
                            currentNodeData.relation == "Father")) {
                      graph.addEdge(
                          node, Node(getDefaultNode(nodeData.id, relation)),
                          paint: Paint()..color = Colors.red);
                    }
                  }
                }
              } else {
                rootNodeId = data.id;
                rootNode = Node(
                    Column(
                      children: [
                        getNodeText(data),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .push(MaterialPageRoute(
                                        builder: (context) => Treedetails(
                                            widget.trybeid,
                                            "Son",
                                            data.id,
                                            true)))
                                    .then((value) {
                                  if (value != null) {
                                    getTrybeMembers();
                                  }
                                });
                              },
                              child: Container(
                                height: 35,
                                padding: EdgeInsets.only(left: 4, right: 4),
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: getColorFromHex(AppColors.red)),
                                child: Center(
                                  child: Text(
                                    "+ Add",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    key: ValueKey(data.id));
                graph.addNode(rootNode);
              }
              //graph.addEdge(node1, node2, paint: Paint()..color = Colors.blue);
            }
          }
        }
      } else {
        node1 = Node(getFirstNode());
        node2 = Node(getDefaultNode(null, "Father"));
        node3 = Node(getDefaultNode(null, "Mother"));
        graph.addEdge(node1, node2);
        graph.addEdge(node1, node3, paint: Paint()..color = Colors.red);
      }

      builder
        ..siblingSeparation = (50)
        ..levelSeparation = (50)
        ..subtreeSeparation = (50)
        ..orientation = BuchheimWalkerConfiguration.ORIENTATION_LEFT_RIGHT;
    }
  }
}
