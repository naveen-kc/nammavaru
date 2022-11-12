import 'package:flutter/material.dart';
import 'package:nammavaru/admin/AdminController.dart';

import '../network/ApiEndpoints.dart';
import '../utils/Helpers.dart';
import '../utils/constants.dart';
import '../widgets/dialog_box.dart';
import '../widgets/loader.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({Key? key}) : super(key: key);

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  List<dynamic> users=[];
  Helpers helpers=Helpers();
  bool loading=false;

  @override
  void initState() {
    getUsers();
    super.initState();

  }

  void getUsers()async{
    setState((){
      loading=true;
    });
    var data=await AdminController().getUsers();
    if(data['status']){
      setState((){
        users=data['users'];
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
              buttonColor: AppColors.black,
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
      body:loading?Loader(): SafeArea(child:
      Container(
        color: AppColors.lightGrey2,
        child:  Column(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Text(
                  'All Users',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 30.0, fontFamily: 'HindBold'),
                )),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
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
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            height: 200,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                              color:AppColors.divider_line,
                                            ),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                                  child: SizedBox(
                                                    height: 80,
                                                    width: 80,
                                                    child: CircleAvatar(
                                                      radius: 60,
                                                      backgroundColor: Colors.white,
                                                      child: CircleAvatar(
                                                        backgroundColor: Colors.black,
                                                        radius: 55.0,
                                                        backgroundImage: NetworkImage(
                                                          ApiConstants.baseUrl+'/'+users[index]["image"],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      users[index]
                                                      ['name'],
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                          fontFamily: 'HindBold'
                                                      ),
                                                    ),
                                                    Text(
                                                      users[index]
                                                      ['mobile'],
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                          fontFamily: 'HindBold'
                                                      ),
                                                    ),
                                                    Text(
                                                      users[index]
                                                      ['dob'],
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                          fontFamily: 'HindBold'
                                                      ),
                                                    ),
                                                    Text(
                                                      users[index]
                                                      ['address'],
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                          fontFamily: 'HindBold'
                                                      ),
                                                    ),

                                                    Text(
                                                      users[index]
                                                      ['village'],
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: AppColors.grey,
                                                          fontFamily: 'HindMedium'
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                              ],
                                            )
                                        ),
                                      ),
                                    ),



                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),

      ),
    );
  }


}
