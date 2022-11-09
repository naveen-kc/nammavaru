import 'package:flutter/material.dart';
import 'package:nammavaru/controller/UpdateController.dart';
import 'package:nammavaru/utils/Helpers.dart';

import '../utils/constants.dart';
import '../widgets/dialog_box.dart';
import '../widgets/loader.dart';

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
  
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loader()
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
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          color:AppColors.divider_line,
                                        ),
                                        height: 80,
                                        child: ListTile(
                                          leading: Padding(
                                            padding:
                                            const EdgeInsets.only(top: 0),
                                            child: SizedBox(
                                              height: 50,
                                              width: 50,
                                                child:Image.network('src')
                                            ),
                                          ),
                                          title:  Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                individualUpdates[index]
                                                [1],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                    fontFamily: 'HindBold'
                                                ),
                                              ),


                                              Text(
                                                "On "+individualUpdates[index]
                                                [3],
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: AppColors.grey,
                                                    fontFamily: 'HindRegular'
                                                ),
                                              ),
                                            ],
                                          ),
                                          trailing: IconButton(
                                            icon:  Icon(Icons.arrow_forward_rounded),
                                            onPressed: () {
                                              Navigator.pushNamed(context, '/detailedGallery',
                                                  arguments: {'program':individualUpdates[index]});
                                            },
                                          ),

                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),

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
    );
  }
}
