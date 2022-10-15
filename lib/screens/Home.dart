import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nammavaru/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    const Page5(),
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
                    pageIndex = 4;
                    appBarName = "Banking";
                  });
                },
                icon: pageIndex == 4
                    ? const Icon(
                  Icons.credit_card_sharp,
                  color: AppColors.soil,
                  size: 30,
                )
                    : const Icon(
                  Icons.credit_card_outlined,
                  color: Colors.black,
                  size: 30,
                ),
              ),
              Text(
                "Banking",
                style: TextStyle(
                    color: pageIndex == 4 ? AppColors.soil : Colors.black,
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
          child: Icon(Icons.notifications, color: Colors.white),
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

  bool loading =false;

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
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Container(
            padding: EdgeInsets.only(bottom: 10),
            height: MediaQuery.of(context).size.height*0.2,
            color: Colors.amber,
            child: Center(
              child: Text(
                'Home Page'
              ),
            ),

          ),
        ]),
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(238, 240, 234, 1),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.tealAccent,
            height: 100,
            padding: const EdgeInsets.only(top: 5),

          ),
        ),
      ),
    );
  }
}

class Page5 extends StatefulWidget {
  const Page5({Key? key}) : super(key: key);

  @override
  State<Page5> createState() => _Page5State();
}

class _Page5State extends State<Page5> {


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.white,

              ),
            ],
          ),
        ),
      ),
    );
  }
}
