import 'dart:developer';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nammavaru/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/Helpers.dart';
import '../utils/LocalStorage.dart';
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

  final pages = [
    const Page1(),
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
      //Need to call first method here

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
                child: Container(child: Row(
                  children: [
                    SizedBox(
                      width:60,
                      height: 60,
                      child: CircleAvatar(child: Icon(
                        Icons.person,
                        color: AppColors.black,
                        size: 50,
                      ),
                      backgroundColor: AppColors.white,),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: SizedBox(
                        width: 180,
                        child: Text('Naveen K C',
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: 'HindBold',
                        ),),
                      ),
                    ),
                  ],
                )),
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
                  Navigator.pop(context);
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
                    appBarName = "Donate";
                  });
                },
                icon: pageIndex == 1
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
                    appBarName = "Achievers";
                  });
                },
                icon: pageIndex == 2
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
                    appBarName = "Payment History";
                  });
                },

    icon: pageIndex == 3
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
                    color: pageIndex == 3 ? AppColors.soil : Colors.black,
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
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Icon(Icons.add_photo_alternate_rounded, color: Colors.white),
        ),
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

class Page1 extends StatefulWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  final List<String> imageList = [
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];
  
  List<dynamic> updates=[
    {"name":"Navee K C","village":"Kalkatte","image":"https://www.shutterstock.com/image-photo/pair-young-people-test-drive-600w-2034171992.jpg","time":"10:30PM 22/10/2022","description":"Happy to share that we bought a new electric scooter"},
    {"name":"Gowtham Kulal","village":"Kalkatte","image":"https://www.shutterstock.com/image-photo/tasikmalaya-west-java-indonesia-november-600w-2081072653.jpg","time":"02:10PM 22/09/2022","description":"Started cultivation at our grassland as the rainy season starts"},
    {"name":"Chandrashekar","village":"Menase","image":"https://img.traveltriangle.com/blog/wp-content/uploads/2017/05/Assamese-women-and-men-dancing-during-Bihu-festival-ss22052017.jpg","time":"10:05PM 22/11/2022","description":"I like to inform that we participated in state dance competition and got second prize and would like to improve and show case our culture to the world , I like to inform that we participated in state dance competition and got second prize and would like to improve and show case our culture to the world , I like to inform that we participated in state dance competition and got second prize and would like to improve and show case our culture to the world , I like to inform that we participated in state dance competition and got second prize and would like to improve and show case our culture to the world. I like to inform that we participated in state dance competition and got second prize and would like to improve and show case our culture to the world ,I like to inform that we participated in state dance competition and got second prize and would like to improve and show case our culture to the world, I like to inform that we participated in state dance competition and got second prize and would like to improve and show case our culture to the world"},
    {"name":"Uday","village":"Menase","image":"https://lostwithpurpose.com/wp-content/uploads/2016/11/DSC_1625.jpg","time":"11:30PM 08/10/2022","description":"Celebrated deepavali in our village with all our community people makes so happy"}
  ];

  bool loading =false;
  Helpers helpers=Helpers();

  @override
  void initState() {
    super.initState();

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
                            imageList[i],
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      var url = imageList[i];
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
                                              color:AppColors.lineGrey,
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
                                              title: Padding(
                                                padding:
                                                const EdgeInsets.only(top: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      updates[index]
                                                      ['name'],
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                      ),
                                                    ),

                                                    Text(
                                                      updates[index]
                                                      ['village'],
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: AppColors.grey,
                                                      ),
                                                    ),
                                                    Text(
                                                      updates[index]
                                                      ['time'],
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: AppColors.grey
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
                                        child: Image.network(updates[index]["image"],
                                          fit: BoxFit.fill,

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
              )


        ],
        ),
      ),
    );
  }
}

class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  Helpers helpers=Helpers();
  List<dynamic> amountList=[{"amt":"50"},{"amt":"100"},{"amt":"250"},{"amt":"500"},{"amt":"1000"},{"amt":"2000"},];

  @override
  void initState() {
    super.initState();


  }


  void sendPayment() async {
    /*String url = 'upi://pay?pa=8904102726@ybl&pn=Rakesh&am=1&tn=Test Payment&cu=INR';
     // String url='8660305451';
      Uri upiurl = Uri( path: url);

      if (await canLaunchUrl(upiurl)) {
        await launchUrl(upiurl);
      } else {
        throw 'Sorry! can\'t able call $upiurl';
      }*/

    String _url='upi://pay?pa=9482759828@ybl&pn=Rakesh&am=1&tn=Test Payment&cu=INR';
    var result = await launch(_url);
    debugPrint(result.toString());
    if (result ==true) {
      print("Done");
    } else if (result ==false){
      print("Fail");
    }


  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(238, 240, 234, 1),
        body: SingleChildScrollView(
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


              Container(
                height: MediaQuery.of(context).size.height*0.4,
                  padding: EdgeInsets.all(20.0),
                  child: GridView.builder(
                    itemCount: amountList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 2.0,
                        mainAxisSpacing: 2.0
                    ),
                    itemBuilder: (BuildContext context, int index){
                      return Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Container(
                              height:110,
                                width: MediaQuery.of(context).size.width*0.3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(color: AppColors.lightGrey2, spreadRadius: 1),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 20,),
                                    SizedBox(
                                      height:50,
                                        width:50,
                                        child: Image.asset(helpers.rupee)),
                                    Text(
                                        amountList[index]['amt'],
                                      style: TextStyle(
                                        color: AppColors.black,
                                        fontFamily: 'HindBold'
                                      ),
                                    ),
                                  ],
                                ),
                            ),


                          ],
                        ),
                      );
                    },
                  )),

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
                      sendPayment();
                    },
                    borderRadius: BorderRadius.circular(25),
                    fontFamily: 'HindMedium',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }





}


class Page3 extends StatefulWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(child: Container(
        color: AppColors.grey,
      ),

      ),
    );
  }


}

class Page4 extends StatefulWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Container(
          color: Colors.green,
        ),

      ),
    );
  }

  Future<bool> _onWillPop() async {

    return false;
  }








}


