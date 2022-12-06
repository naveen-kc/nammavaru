import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';


import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentcomponents/cfpaymentcomponent.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/api/cftheme/cftheme.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:lottie/lottie.dart';
import 'package:nammavaru/controller/HomeController.dart';
import 'package:nammavaru/network/ApiEndpoints.dart';
import 'package:nammavaru/utils/constants.dart';
import 'package:nammavaru/widgets/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../controller/PaymentController.dart';
import '../controller/ProfileController.dart';
import '../utils/Helpers.dart';
import '../utils/LocalStorage.dart';
import '../widgets/alert_box.dart';
import '../widgets/app_button.dart';
import '../widgets/dialog_box.dart';
import '../widgets/loader.dart';
import '../widgets/no_internet.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}


class _HomeState extends State<Home> {
  int pageIndex = 0;
  String appBarName = "Home";
  var ctime;
  LocalStorage localStorage = LocalStorage();
  bool isInternet = false;
  Helpers helpers = Helpers();
  String profile='';
  String name ='';



  final pages = [
    const Page1(),
    const Page5(),
    const Page2(),
    const Page3(),
    const Page4(),

  ];

  @override
  void initState() {
    super.initState();
    checkConnection();
  }



  void checkConnection() async {

    isInternet = await Helpers().isInternet();

    if (isInternet) {
      getProfile();
      // SharedPreferences prefs= await SharedPreferences.getInstance();
      // profile=prefs.getString('image')!;
      // name=prefs.getString('name')!;
      // dev.log('prrororororo '+profile);

    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return NoInternet(
              header: "No Internet",
              description:
              "Please check your data connectivity or try again in some time.",
              move: '/home',
            );
          });
    }
  }

  void getProfile()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();

    var data=await ProfileController().getProfile();
    if(data['status']){
      localStorage.putName(data['name']);
      localStorage.putProfile(data['image']);


    }
  }


  void logout()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    prefs.clear();

    Navigator.popUntil(context, (route) => route.settings.name=='/login');
    Navigator.pushNamed(context, '/login');

  }

  void checkAdmin()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();

    if(prefs.getString("mobile")=='8660305451' ||prefs.getString("mobile")=='7975792908'){
      Navigator.pop(context,true);
      Navigator.pushNamed(context, '/adminHome');
    }
  }

  Future<bool> _onWillPop() async {
    DateTime now = DateTime.now();
    if (ctime == null || now.difference(ctime) > Duration(seconds: 2)) {
      //add duration of press gap
      ctime = now;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Press Back Button Again to Exit'))); //scaffold message, you can show Toast message too.
      return Future.value(false);
    }

    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        onDrawerChanged: (val) async {
          SharedPreferences preferences =
          await SharedPreferences.getInstance();
          if (val) {
            setState(() {
              profile = preferences.getString("image")!;
              name = preferences.getString("name")!;
            });
          } else {
            setState(() {
              profile = preferences.getString("image")!;
              name = preferences.getString("name")!;
            });
          }
        },

        resizeToAvoidBottomInset: false,
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
               DrawerHeader(
                decoration: BoxDecoration(
                  color: AppColors.soil,
                ),
                child: GestureDetector(
                  onTap: (){
                    checkAdmin();
                  },
                  child: Container(child: Row(
                    children: [
                      SizedBox(
                        width:60,
                        height: 60,
                        child: CircleAvatar(backgroundImage:
                        NetworkImage(
                         ApiConstants.baseUrl+'/'+profile
                        ),
                        backgroundColor: AppColors.white,),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: SizedBox(
                          width: 180,
                          child: Text(name,
                          maxLines: 2,
                          style: TextStyle(
                            fontFamily: 'HindBold',
                          ),),
                        ),
                      ),
                    ],
                  )),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.person_outline,
                ),
                title: const Text('Profile',
                   ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/profile');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.post_add,
                ),
                title: const Text('My Updates',
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/updates');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.notification_important_outlined,
                ),
                title: const Text('Notification'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.lightbulb_outlined,
                ),
                title: const Text('Our Vision'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context,'/vision');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.privacy_tip_outlined,
                ),
                title: const Text('Privacy Policy'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/privacy');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.logout,
                ),
                title: const Text('Logout'),
                onTap: () {

                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertBox(
                          header: "Logout",
                          description: "Do you really want to logout?",
                          okay: () {
                           logout();
                          },
                        );
                      });

                },
              ),


            ],
          ),
        ),
        appBar: appBar(),
        bottomNavigationBar: buildMyNavBar(context),
        body: pages[pageIndex],
      ),
    );
  }

  Container buildMyNavBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              IconButton(
                enableFeedback: false,
                onPressed: () {
                  setState(() {
                    pageIndex = 0;
                    appBarName = "Home";
                  });
                },
                icon: pageIndex == 0
                    ? const Icon(
                  Icons.home_filled,
                  color: AppColors.soil,
                  size: 30,
                )
                    : const Icon(
                  Icons.home_outlined,
                  color: Colors.black,
                  size: 30,
                ),
              ),
              Text(
                "Home",
                style: TextStyle(
                    color: pageIndex == 0 ? AppColors.soil : Colors.black,
                    fontSize: 10),
              )
            ],
          ),
          Column(
            children: [
              IconButton(
                enableFeedback: false,
                onPressed: () {
                  setState(() {
                    pageIndex = 1;
                    appBarName = "Gallery";
                  });
                },
                icon: pageIndex == 1
                    ? const Icon(
                  Icons.image,
                  color: AppColors.soil,
                  size: 30,
                )
                    : const Icon(
                  Icons.image_outlined,
                  color: Colors.black,
                  size: 30,
                ),
              ),
              Text(
                "Gallery",
                style: TextStyle(
                    color: pageIndex == 1 ? AppColors.soil : Colors.black,
                    fontSize: 10),
              )
            ],
          ),
          Column(
            children: [
              IconButton(
                enableFeedback: false,
                onPressed: () {
                  setState(() {
                    pageIndex = 2;
                    appBarName = "Donate";
                  });
                },
                icon: pageIndex == 2
                    ? const Icon(
                  Icons.payments,
                  color: AppColors.soil,
                  size: 30,
                )
                    : const Icon(
                  Icons.payments_outlined,
                  color: Colors.black,
                  size: 30,
                ),
              ),
              Text(
                "Donate",
                style: TextStyle(
                    color: pageIndex == 2 ? AppColors.soil : Colors.black,
                    fontSize: 10),
              )
            ],
          ),
          Column(
            children: [
              IconButton(
                enableFeedback: false,
                onPressed: () {
                  setState(() {
                    pageIndex = 3;
                    appBarName = "Achievers";
                  });
                },
                icon: pageIndex == 3
                    ? const Icon(
                  Icons.school_rounded,
                  color: AppColors.soil,
                  size: 30,
                )
                    : const Icon(
                  Icons.school_outlined,
                  color: Colors.black,
                  size: 30,
                ),
              ),
              Text(
                "Achievers",
                style: TextStyle(
                    color: pageIndex == 3 ? AppColors.soil : Colors.black,
                    fontSize: 10),
              )
            ],
          ),

          Column(
            children: [
              IconButton(
                enableFeedback: false,
                onPressed: () {
                  setState(() {
                    pageIndex = 4;
                    appBarName = "Payment History";
                  });
                },

    icon: pageIndex == 4
    ? const Icon(
    Icons.library_books,
    color: AppColors.soil,
    size: 30,
    )
        : const Icon(
    Icons.my_library_books_outlined,
    color: Colors.black,
    size: 30,
    ),
    ),


              Text(
                "Payment History",
                style: TextStyle(
                    color: pageIndex == 4 ? AppColors.soil : Colors.black,
                    fontSize: 10),
              )
            ],
          ),

        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      title: Text(
        appBarName,
        style: TextStyle(color: Colors.white,),
      ),
      backgroundColor: AppColors.soil,
      actions: [
       if(pageIndex==0)
         IconButton(
           onPressed: () {
             Navigator.pushNamed(context, '/addUpdate');
         },
           icon: Icon( Icons.add_photo_alternate_rounded,
         color: AppColors.white,),),

      ],
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[AppColors.darkSoil, AppColors.soil]),
        ),
      ),
    );
  }
}

//Home
class Page1 extends StatefulWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  State<Page1> createState() => _Page1State();
}
class _Page1State extends State<Page1> {
  List<dynamic> imageList = [];

  List<dynamic> updates=[];

  bool loading =false;
  Helpers helpers=Helpers();
  bool isInternet = false;
  String profile='';
  String name='';

  @override
  void initState() {
    getBanners();
    getUpdates();
    super.initState();

  }

  void checkConnection() async {

    isInternet = await Helpers().isInternet();

    if (isInternet) {
      SharedPreferences prefs= await SharedPreferences.getInstance();
      profile=prefs.getString('image')!;
      name=prefs.getString('name')!;
      dev.log('prrororororo '+profile);

    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return NoInternet(
              header: "No Internet",
              description:
              "Please check your data connectivity or try again in some time.",
              move: '/home',
            );
          });
    }
  }


  void  getBanners()async{
    setState((){
      loading=true;
    });
    var data=await HomeController().getBanners();
    if(data['status']){
      setState((){
        imageList=data['banners'];
      });
      setState((){
        loading=false;
      });
    }else{
      setState((){
        loading=false;
      });
      getBanners();
    }



  }

  void getUpdates()async{
    setState((){
      loading=true;
    });
    var data=await HomeController().getUpdates();
    if(data['status']){
      setState((){
        updates=data['updates'];
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



  Future<void> _pullRefresh() async {
    var data=await HomeController().getUpdates();
    if(data['status']){
      setState((){
        updates=data['updates'];
      });
      setState((){
        loading=false;
      });
    }

}


  @override
  Widget build(BuildContext context) {
    return loading
        ? LottiePage()
        : SafeArea(
      child: Container(
        color: AppColors.white,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CarouselSlider.builder(
                itemCount: imageList.length,
                options: CarouselOptions(
                  viewportFraction: 0.93,
                  enlargeCenterPage: false,
                  height: 150,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 4),
                  reverse: false,
                  aspectRatio: 5,
                ),
                itemBuilder: (context, i, id) {
                  //for onTap to redirect to another screen
                  return GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.transparent,
                            )),
                        //ClipRRect for image border radius
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            ApiConstants.baseUrl+'/'+imageList[i]['image'],
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    onTap: ()async {
                      var url = imageList[i]['url'];
                      if (await canLaunch(url)) {
                      await launch(url);
                      } else {
                      throw 'Could not launch $url';
                      }
                      print(url.toString());
                    },
                  );
                },
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 0, 5),
                  child: Text(
                    'UPDATES OF OUR COMMUNITY',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
             /* Column(
                children: [
                  Container(
                    margin: EdgeInsets.zero,
                    height: 90.0,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: updates.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  5, 0, 10, 0),
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                        10, 0, 10, 0),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(
                                          10),
                                      border: Border.all(
                                        color: Color.fromRGBO(
                                            120, 155, 63, 1),
                                      ),
                                      color:  Color.fromRGBO(
                                          120, 155, 63, 0.12),
                                    ),
                                    width: 180,
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 25,
                                          backgroundImage:
                                          AssetImage(
                                              helpers.person),
                                        ),
                                        Spacer(),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets
                                                  .fromLTRB(
                                                  0, 5, 0, 5),
                                              child: SizedBox(
                                                width: 90,
                                                child: Text(
                                                  updates[
                                                  index]
                                                  ["name"],
                                                  maxLines: 1,
                                                  overflow:
                                                  TextOverflow
                                                      .ellipsis,
                                                  style: TextStyle(
                                                      color:  Colors.black,
                                                      fontSize:
                                                      14.0,
                                                      fontWeight:  FontWeight
                                                          .normal),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              updates[
                                              index]
                                              ["village"],
                                              style: TextStyle(
                                                  color:  Colors
                                                      .black,
                                                  fontSize: 14.0,
                                                  fontWeight:  FontWeight.normal),
                                            )
                                          ],
                                        ),
                                      ],
                                    )),
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              ),*/


              Expanded(
                child:RefreshIndicator(
                  color: AppColors.soil,
                    onRefresh: _pullRefresh,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: updates.length,
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
                                          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
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
                                                    child: CircleAvatar(
                                                      radius: 60,
                                                      backgroundColor: Colors.white,
                                                      child: CircleAvatar(
                                                        backgroundColor: Colors.black,
                                                        radius: 55.0,
                                                        backgroundImage: NetworkImage(
                                                          ApiConstants.baseUrl+'/'+updates[index]
                                                          ['profile'],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                title:  Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        updates[index]
                                                        ['name'],
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                          fontFamily: 'HindBold'
                                                        ),
                                                      ),

                                                      Text(
                                                        updates[index]
                                                        ['village'],
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: AppColors.grey,
                                                            fontFamily: 'HindMedium'
                                                        ),
                                                      ),
                                                      Text(
                                                        updates[index]
                                                        ['time'],
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: AppColors.grey,
                                                            fontFamily: 'HindRegular'
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 5, 15, 0),
                                          child: Padding(
                                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                              child: Text(updates[index]["description"],
                                                  style: TextStyle(
                                                    color: AppColors.black,
                                                    fontFamily: 'HindMedium',
                                                    fontSize: 15
                                                  ),

                                              )
                                          ),

                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 5, 15, 0),
                                          child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Image.network(ApiConstants.baseUrl+'/'+updates[index]["image"],
                                            fit: BoxFit.fill,
                                            loadingBuilder: (BuildContext context, Widget child,
                                                ImageChunkEvent? loadingProgress) {
                                              if (loadingProgress == null) return child;
                                              return Center(
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 1,
                                                  color: AppColors.soil,
                                                  value: loadingProgress.expectedTotalBytes != null
                                                      ? loadingProgress.cumulativeBytesLoaded /
                                                      loadingProgress.expectedTotalBytes!
                                                      : null,
                                                ),
                                              );
                                            },

                                          )
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
              )



        ],
        ),
      ),
    );
  }
}

//Gallery
class Page5 extends StatefulWidget {
  const Page5({Key? key}) : super(key: key);

  @override
  State<Page5> createState() => _Page5State();
}

class _Page5State extends State<Page5> {

  bool loading =false;
  Helpers helpers=Helpers();
  List<dynamic> programs=[];

  @override
  void initState(){
    super.initState();

    getPrograms();
  }

  void getPrograms()async{
    setState((){
      loading=true;
    });
    var data=await HomeController().getPrograms();
    if(data['status']){
      setState((){
        programs=data['data'];
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
        ? LottiePage()
        : SafeArea(
      child:programs.length==0?Column(
        children: [
          Lottie.asset(
            helpers.artist,
            repeat: true,
            reverse: true,
            animate: true,
          ),
          Center(
            child: Text(
              "No programs has been added",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontFamily: 'HindMedium'),
            ),
          ),
        ],
      ): Container(
        color: AppColors.white,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: programs.length,
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
                                                child: CircleAvatar(
                                                  radius: 60,
                                                  backgroundColor: Colors.white,
                                                  child: CircleAvatar(
                                                    backgroundColor: Colors.black,
                                                    radius: 55.0,
                                                    backgroundImage: AssetImage(
                                                      helpers.pottering,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            title:  Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  programs[index]
                                                  [1],
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                      fontFamily: 'HindBold'
                                                  ),
                                                ),


                                                Text(
                                                  "On "+programs[index]
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
                                                      arguments: {'program':programs[index]});
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


//Donate
class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  State<Page2> createState() => _Page2State();
}
class _Page2State extends State<Page2> {
  var cfPaymentGatewayService = CFPaymentGatewayService();
  Helpers helpers=Helpers();
  bool loading=false;
  List<dynamic> amountList=[{"amt":"50"},{"amt":"100"},{"amt":"250"},{"amt":"500"},{"amt":"1000"},{"amt":"2000"}];
  TextEditingController amountController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  int selectedAmt=1;
  bool called=false;

   String reason='';
   String amount='';
   Map<dynamic,dynamic> tokenData={};
   List<dynamic> tData=[];



  String orderId = "";
  String orderToken = "";
  String cf_order_id="";
  CFEnvironment environment = CFEnvironment.SANDBOX;





 /* Future launchUpi()async {
    if(amount.isEmpty){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AppDialog(
              header: "Enter Amount",
              description: "Please enter the amount you want pay",
            );
          });
    }else if(reason.isEmpty){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AppDialog(
              header: "Enter Reason",
              description: "Please specify why you are making this payment.",
            );
          });

    }
    else {

      payeeAddress = "9334129833@paytm";
      payeeName = "Nammavara Sangha";
      currencyUnit = "INR";

      uri = Uri.parse("upi://pay?pa=" +
          payeeAddress +
          "&pn=" +
          payeeName +
          "&tn=" +
          reason +
          "&am=" +
          amount +
          "&cu=" +
          currencyUnit);


      try {
        final String result = await platform.invokeMethod(
            'launchUpi', <String, dynamic>{"url": uri.toString()});
        log("Result from android :"+result);
        while((result.isNotEmpty||result!=null)&&!called){
          storeDetails(context);
        }


      } on PlatformException catch (e) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AppDialog(
                header: "Error",
                description: e.message.toString(),
              );
            });
        debugPrint(e.toString());
      }
    }
  }*/


  @override
  void initState(){
    super.initState();
    cfPaymentGatewayService.setCallback(verifyPayment, onError);
  }

  void verifyPayment(String orderId)async {
    setState(() {
      loading=true;
    });
    var data=await PaymentController().addPayment(amount, reason, "Success", orderId, cf_order_id, orderToken);

    if(data["status"]){
      setState(() {
        loading=false;

      });
      reasonController.text='';
      reason='';
      amount='';
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AppDialog(
              header: "Payment Success",
              description: data['message']+" You can check details in Payment history page",
            );
          });
    }else{
      setState(() {
        loading=false;
      });

    }
  }

  void onError(CFErrorResponse errorResponse, String orderId)async {
    setState(() {
      loading=true;
    });
    var data=await PaymentController().addPayment(amount, reason, "Failed", orderId, cf_order_id, orderToken);

    if(data["status"]){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AppDialog(
              header: "Payment Failed",
              description: data['message']+" Error while making payment",
            );
          });
      setState(() {
        loading=false;
      });
    }else{
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AppDialog(
              header: "Payment Failed",
              description: data['message']+" Error while making payment",
            );
          });
      setState(() {
        loading=false;
      });

    }
  }




  CFSession? createSession() {
    try {
      var session = CFSessionBuilder().setEnvironment(environment).setOrderId(orderId).setOrderToken(orderToken).build();
      return session;
    } on CFException catch (e) {
      print(e.message);
    }
    return null;
  }

  pay() async {
    try {
      var session = createSession();
      List<CFPaymentModes> components = <CFPaymentModes>[];
      components.add(CFPaymentModes.UPI);
     // components.add(CFPaymentModes.CARD);
      //components.add(CFPaymentModes.WALLET);
      var paymentComponent = CFPaymentComponentBuilder().setComponents(components).build();

      var theme = CFThemeBuilder().setNavigationBarBackgroundColorColor("#9B7653").setPrimaryFont("Menlo").setSecondaryFont("Futura").build();

      var cfDropCheckoutPayment = CFDropCheckoutPaymentBuilder().setSession(session!).setPaymentComponent(paymentComponent).setTheme(theme).build();

      cfPaymentGatewayService.doPayment(cfDropCheckoutPayment);


    } on CFException catch (e) {
      print(e.message);
    }

  }





  void getPaymentToken()async{

    if(amount.isEmpty){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AppDialog(
              header: "Enter Amount",
              description: "Please enter the amount you want pay",
            );
          });
    }else if(reason.isEmpty){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AppDialog(
              header: "Enter Reason",
              description: "Please specify why you are making this payment.",
            );
          });

    }
    else {


      setState(() {

        loading=true;
      });
      var data = await PaymentController().getToken(amount, reason);

      if (data['status']) {


        tData=data['data'];
        log('tData :' + tData.toString());

        Map valueMap = jsonDecode(tData[0]);


        orderId=valueMap['order_id'].toString();
        orderToken=valueMap['order_token'].toString();
        cf_order_id=valueMap['cf_order_id'].toString();
        log('tokennnnn :' + orderToken.toString());

        setState(() {

          loading=false;
        });
       pay();


      }
    }
  }


  void openAmountDialog()async{
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Center(
                child: Text(
                  'Enter amount in rupees',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              content: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 15, 5, 15),
                        child: SizedBox(
                          height: 50,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: amountController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey
                                  )
                              ),
                              labelText: 'Amount',
                              hintText: 'Amount',
                              labelStyle: TextStyle(
                                  color: Colors.black
                              ),focusedBorder:OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black,
                              ),
                            ),
                            ),
                            onChanged: (value){
                              setState((){
                                amount=amountController.text;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Button(
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(10),
                        textColor: Colors.white,
                        backgroundColor: AppColors.soil,
                        text: 'Okay',
                        width: MediaQuery.of(context).size.width,
                        height: 20,
                        onPressed: () {
                          setState((){
                            amount=amountController.text;
                          });
                          Navigator.pop(context,true);
                          amountController.text='';

                        }, fontFamily: 'HindBold',
                      ),
                      SizedBox(
                        height: 10,
                      ),

                    ],
                  ),
                ),
              ),
            );
          });
        });
  }


  void sendPayment() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String name=prefs.getString('name')!;
    /*String url = 'upi://pay?pa=8904102726@ybl&pn=Rakesh&am=1&tn=Test Payment&cu=INR';
     // String url='8660305451';
      Uri upiurl = Uri( path: url);

      if (await canLaunchUrl(upiurl)) {
        await launchUrl(upiurl);
      } else {
        throw 'Sorry! can\'t able call $upiurl';
      }*/

    if(amount.isEmpty){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AppDialog(
              header: "Enter Amount",
              description: "Please enter the amount you want pay",
            );
          });
    }else if(reason.isEmpty){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AppDialog(
              header: "Enter Reason",
              description: "Please specify why you are making this payment.",
            );
          });

   }
    else{
      String _url='upi://pay?pa=sk841967@ybl&pn='+name+'&am='+amount+'&tn='+reason+'&cu=INR';
      var result = await launch(_url);
      debugPrint(result.toString());
      if (result ==true) {
        print("Done");
      } else if (result ==false){
        print("Fail");
      }
    }




  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(238, 240, 234, 1),
        body:loading?LottiePage():Scrollbar(
        child:SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: AppColors.lightGrey2, spreadRadius: 1),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Note: Whatever the amount you are paying will directly debit into the registered bank account of our community and all the transaction you have made will be listed in our system',
                    style: TextStyle(
                     color: AppColors.red,
                      fontSize:16,
                      fontFamily: 'HindMedium'
                    ),),
                  ),
                ),
              ),


              Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height*0.3,
                      padding: EdgeInsets.all(20.0),
                      child: Scrollbar(
                        child: GridView.builder(
                          itemCount: amountList.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 20.0,
                              mainAxisSpacing: 5.0
                          ),
                          itemBuilder: (BuildContext context, int index){
                            return Padding(
                              padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap:(){
                                      setState((){
                                        selectedAmt=index;
                                      });
                                      setState((){
                                        amount=amountList[selectedAmt]['amt'];
                                      });

                                },
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        width: MediaQuery.of(context).size.width*0.3,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: AppColors.white,
                                          boxShadow: [
                                            BoxShadow(
                                                color:selectedAmt==index?AppColors.black: AppColors.divider_line,
                                                spreadRadius:selectedAmt==index?2: 1),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            SizedBox(height: 5,),
                                            SizedBox(
                                              height:20,
                                                width:20,
                                                child: Image.asset(helpers.rupee)),

                                            Text(
                                                amountList[index]['amt'],
                                              style: TextStyle(
                                                color: AppColors.black,
                                                fontFamily: 'HindBold',
                                                fontSize: 20
                                              ),
                                            ),
                                          ],
                                        ),
                                    ),
                                  ),



                                ],
                              ),
                            );
                          },
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                      child:
                          Row(
                            children: [
                              Text(
                                '₹ '+ amount,
                                style: TextStyle(
                                    color: AppColors.darkSoil,
                                    fontSize: 30,
                                    fontFamily: 'HindRegular'
                                ),

                                ),
                              Spacer(),
                              TextButton(onPressed: () {
                                openAmountDialog();
                              }, child:  Text(
                                'Enter Amount Manually',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'HindRegular'
                                ),
                              ),),
                            ],
                          )

                      /*Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: AppColors.lightGrey2, spreadRadius: 3),
                          ],
                        ),
                        child: Center(
                            child: Text(
                            'Enter Amount Manually',
                              style: TextStyle(
                                color: AppColors.darkSoil
                              ),
                          ),
                        )
                      ),*/
                    ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                child: TextField(
                  controller: reasonController,
                  keyboardType: TextInputType.text,
                  onChanged: (value){
                    reason=reasonController.text;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey
                        )
                    ),
                    hintText: 'Enter reason or note',
                    hintStyle: TextStyle(
                        fontFamily: 'HindRegular'
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontFamily: 'HindRegular',
                    ),focusedBorder:OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black,
                    ),
                  ),
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.all(20),
                child:Align(
                  alignment: Alignment.center,
                  child: Button(
                    elevation: 0.0,
                    textColor: Colors.white,
                    backgroundColor: AppColors.soil,
                    text: 'Pay',
                    width: MediaQuery.of(context).size.width*0.8,
                    height: 50,
                    fontSize: 18,
                    onPressed: () {
                      getPaymentToken();
                     // sendPayment();
                    },
                    borderRadius: BorderRadius.circular(25),
                    fontFamily: 'HindMedium',
                  ),
                ),
              ),
            ],
          ),
        ),
        )
      ),
    );
  }
}


//Achievers
class Page3 extends StatefulWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  State<Page3> createState() => _Page3State();
}
class _Page3State extends State<Page3> {

  List<dynamic> achievers=[];
  Helpers helpers=Helpers();
  bool loading=false;




  @override
  void initState() {
    getAchievers();
    super.initState();

  }

  void getAchievers()async{
    setState((){
      loading=true;
    });
    var data=await HomeController().getAchievers();
    if(data['status']){
      setState((){
        achievers=data['achievers'];
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
      body:loading?LottiePage(): SafeArea(child:
      achievers.length==0? Column(
        children: [
          Lottie.asset(
            helpers.artist,
            repeat: true,
            reverse: true,
            animate: true,
          ),
          Center(
            child: Text(
              "No achievers has been added",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontFamily: 'HindMedium'),
            ),
          ),
        ],
      ): Container(
        color: AppColors.grey,
        child:  Column(
          children: [
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: achievers.length,
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
                                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: MediaQuery.of(context).size.width,
                                          height: 100,
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
                                                        ApiConstants.baseUrl+'/'+achievers[index]["image"],

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
                                                    achievers[index]
                                                    ['name'],
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                      fontFamily: 'HindBold'
                                                    ),
                                                  ),

                                                  Text(
                                                    achievers[index]
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
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 5, 15, 15),
                                      child: Padding(
                                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                          child: Text(achievers[index]["achievement"],
                                            style: TextStyle(
                                                color: AppColors.black,
                                                fontFamily: 'HindMedium',
                                                fontSize: 15
                                            ),

                                          )
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



//Payment History
class Page4 extends StatefulWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  Helpers helpers=Helpers();

  List<dynamic> paymentList = [];

  bool loading=false;


  @override
  void initState(){
    super.initState();
    getAllPayments();
  }

  void getAllPayments()async{
    setState(() {
      loading=true;
    });

    var data=await PaymentController().getPayments();
    if(data['status']){
      setState((){
        paymentList=data['payments'];
      });
      setState(() {
        loading=false;
      });
    }

  }


  @override
  Widget build(BuildContext context) {
    return  SafeArea(
        child:loading?LottiePage(): SingleChildScrollView(
          child:paymentList.length==0? Column(
            children: [
              Lottie.asset(
                helpers.artist,
                repeat: true,
                reverse: true,
                animate: true,
              ),
              Center(
                child: Text(
                  "You have not done any payments",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontFamily: 'HindMedium'),
                ),
              ),
            ],
          ): Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: paymentList.length,
                    itemBuilder: (context, index) {
                      return Column(children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 8, 8),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Container(
                                    width: 40,
                                    height: 40,
                                    child: CircleAvatar(
                                      backgroundColor:AppColors.soil,
                                      child: Icon(
                                        Icons.arrow_circle_up,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                                  title: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Paid for",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                        fontFamily: 'HindMedium'),
                                      ),
                                      Text(paymentList[index]['reason'],
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54,
                                              fontFamily: 'HindMedium'))
                                    ],
                                  ),
                                  trailing: Padding(
                                    padding: const EdgeInsets.only(bottom: 35),
                                    child: Text(
                                        '₹ ' + paymentList[index]['amount'],
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black,
                                            fontFamily: 'HindMedium')),
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(10, 15, 5, 0),
                                  child: Row(
                                    children: [
                                      Text(
                                        paymentList[index]['date'],
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey,
                                            fontFamily: 'HindRegular'),
                                      ),
                                      Spacer(),
                                      Icon(
                                        paymentList[index]['status'] == 'Success'
                                            ? Icons.check_circle
                                            : paymentList[index]['status'] ==
                                            'Failed'
                                            ? Icons.dangerous_rounded
                                            : Icons.info,
                                        color: paymentList[index]['status'] ==
                                            'Success'
                                            ? Colors.green
                                            : paymentList[index]['status'] ==
                                            'Success'
                                            ? Colors.red
                                            : Colors.orange,
                                        size: 18,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text(
                                          paymentList[index]['status'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                              fontFamily: 'HindRegular'
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )),
                        Divider(
                          height: 1,
                          color: Colors.grey[200],
                          thickness: 2,
                        )
                      ]);
                    }),
              ),
            ],
          ),

        ),


    );
  }


}










