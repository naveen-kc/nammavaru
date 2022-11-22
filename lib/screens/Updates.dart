import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nammavaru/controller/UpdateController.dart';
import 'package:nammavaru/network/ApiEndpoints.dart';
import 'package:nammavaru/utils/Helpers.dart';
import 'package:nammavaru/widgets/alert_box.dart';

import '../utils/constants.dart';
import '../widgets/dialog_box.dart';
import '../widgets/loader.dart';
import '../widgets/lottie.dart';

class Updates extends StatefulWidget {
  const Updates({Key? key}) : super(key: key);

  @override
  State<Updates> createState() => _UpdatesState();
}

class _UpdatesState extends State<Updates> {
  
  bool loading=false;
  List<dynamic> individualUpdates=[];
  Helpers helpers=Helpers();

  @override
  void initState(){
    super.initState();
    getYourUpdates();
  }

  void getYourUpdates()async{
    setState((){
      loading=true;
    });
    var data=await UpdateController().getIndividualUpdates();
    log("data :"+data.toString());
    if(data['status']){
      setState((){
        individualUpdates=data['updates'];
      });
      setState((){
        loading=false;
      });
    }else{
      setState((){
        loading=false;
      });
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AppDialog(
              header: "Error",
              description: data['message'],
            );
          });
    }

    setState((){
      loading=false;
    });
  }


  void deleteUpdate(String time,String image)async{
    setState((){
      loading=true;
    });

    var data=await UpdateController().deleteUpdate(time,image);
    log("data :"+data.toString());
    if(data['status']){
      Navigator.pop(context,true);
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AppDialog(
              header: "Success",
              description: data['message'],
            );
          });
      setState((){
        loading=false;
      });
    }else{
      setState((){
        loading=false;
      });
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AppDialog(
              header: "Error",
              description: data['message'],
            );
          });
    }

    setState((){
      loading=false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.soil,
          iconTheme: IconThemeData(
            color: AppColors.black,
          ),
          elevation: 0,
          title: Text(
            "My Updates",
            style: TextStyle(fontFamily: 'HindBold', color: AppColors.black),
          )),
        body:loading
        ? LottiePage()
        : SafeArea(
      child: Container(
        color: AppColors.white,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: individualUpdates.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              //height: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(color: AppColors.lightGrey2, spreadRadius: 3),
                                ],
                              ),
                              margin: EdgeInsets.zero,
                              child: Row(
                                children:[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: SizedBox(
                                      height: 110,
                                      width: 150,
                                        child:Image.network(ApiConstants.baseUrl+'/'+individualUpdates[index]['image'])
                                    ),
                              ),
                                       Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height:80,
                                                  width: 140,
                                                  child: Text(
                                                    individualUpdates[index]["description"],
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                        fontFamily: 'HindBold'
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  individualUpdates[index]["time"],
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: AppColors.grey,
                                                      fontFamily: 'HindRegular'
                                                  ),
                                                ),
                                              ],
                                            ),
                                           Spacer(),
                                           IconButton(
                                              icon:  Icon(Icons.delete_outline),
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (BuildContext context) {
                                                      return AlertBox(
                                                        header: "Delete update",
                                                        description: "Do you really want to permanently delete this update?",
                                                        okay: () {
                                                          deleteUpdate(individualUpdates[index]['time'],individualUpdates[index]['image']);
                                                        },
                                                      );
                                                    });
                                              },
                                            ),

                              ]
                              ),





                              // child: Column(
                              //   children: [
                              //     Padding(
                              //       padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                              //       child: GestureDetector(
                              //         onTap: () {},
                              //         child: Container(
                              //           decoration: BoxDecoration(
                              //             borderRadius:
                              //             BorderRadius.circular(10),
                              //             color:AppColors.divider_line,
                              //           ),
                              //           height: 100,
                              //           child: ListTile(
                              //             leading: Padding(
                              //               padding:
                              //               const EdgeInsets.only(top: 10),
                              //               child: SizedBox(
                              //                 height: 80,
                              //                 width: 100,
                              //                   child:Image.network(ApiConstants.baseUrl+'/'+individualUpdates[index]['image'])
                              //               ),
                              //             ),
                              //             title:  Column(
                              //               mainAxisAlignment: MainAxisAlignment.center,
                              //               crossAxisAlignment: CrossAxisAlignment.start,
                              //               children: [
                              //                 SizedBox(
                              //                   height:50,
                              //                   child: Text(
                              //                     individualUpdates[index]["description"],
                              //                     style: TextStyle(
                              //                         fontSize: 16,
                              //                         color: Colors.black,
                              //                         fontFamily: 'HindBold'
                              //                     ),
                              //                   ),
                              //                 ),
                              //
                              //
                              //                 Text(
                              //                   individualUpdates[index]["time"],
                              //                   style: TextStyle(
                              //                       fontSize: 12,
                              //                       color: AppColors.grey,
                              //                       fontFamily: 'HindRegular'
                              //                   ),
                              //                 ),
                              //               ],
                              //             ),
                              //             trailing: IconButton(
                              //               icon:  Icon(Icons.delete_outline),
                              //               onPressed: () {
                              //
                              //               },
                              //             ),
                              //
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //
                              //   ],
                              // ),

                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            )


          ],
        ),
      ),
    ));
  }
}
