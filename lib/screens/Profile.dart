import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nammavaru/controller/ProfileController.dart';
import 'package:nammavaru/network/ApiEndpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/Helpers.dart';
import '../utils/LocalStorage.dart';
import '../utils/constants.dart';
import '../widgets/app_button.dart';
import '../widgets/dialog_box.dart';
import '../widgets/loader.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _LoginState();
}

class _LoginState extends State<Profile> {
  TextEditingController dateinput = TextEditingController();
   TextEditingController nameController = TextEditingController();
  // TextEditingController dobController = TextEditingController();
   TextEditingController villageController = TextEditingController();
   TextEditingController addressController = TextEditingController();
  List<dynamic> children = [
    {"name": "Navya K C"},
    {"name": "Chandru K"},
    {"name": "Jaya"},
  ];
  bool editProfile = false;
  bool imageSelected= false;
  late File photo;
  bool loading=false;
  String token='';
  LocalStorage localStorage=LocalStorage();
  String name='';
  String mobile='';
  String profile='';
  String dob='';

  String address='';
  String village='';
  String parentId='';


  @override
  void initState() {
    setState((){
      loading=true;
    });
    dateinput.text = "";
    getProfile();

    super.initState();
  }

  void getProfile()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();

    var data=await ProfileController().getProfile();
    if(data['status']){

      name=data['name'];
      mobile=data['mobile'];
      dob=data['dob'];
      address=data['address'];
      profile=data['image'];
      village=data['village'];
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

  void updateProfile()async{
    setState((){
      loading=true;
    });

    String updatedName='';
    if(nameController.text==''){
      updatedName=name;
    }else{
      updatedName=nameController.text;
    }
    String updatedDob='';
    if(dateinput.text==''){
      updatedDob=dob;
    }else{
      updatedDob=dateinput.text;
    }
    String updatedVillage='';
    if(villageController.text==''){
      updatedVillage=village;
    }else{
      updatedVillage=villageController.text;
    }
    String updatedAddress='';
    if(addressController.text==''){
      updatedAddress=address;
    }else{
      updatedAddress=addressController.text;
    }


    var data=await ProfileController().updateProfile(updatedName, updatedDob, updatedVillage, updatedAddress);

    if(data['status']){
      setState((){
        loading=false;
      });
      Navigator.pop(context,true);
      Navigator.pushNamed(context, '/profile');

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AppDialog(
              header: "Success",
              description: data['message'],
            );
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

  }


  void uploadImage(String file)async{
    setState((){
      loading=true;
    });

    var data=await ProfileController().changeImage(file);

    if(data['status']){
      setState((){
        loading=false;
      });
      Navigator.pop(context,true);
      Navigator.pushNamed(context, '/profile');

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AppDialog(
              header: "Success",
              description: data['message'],
            );
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

  }


  void selectDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: context, initialDate: DateTime.now(),
        firstDate: DateTime(1900), //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2101),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.black12,
                onPrimary: Colors.black,
                onSurface: Colors.black45,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Colors.black, // button text color
                ),
              ),
            ),
            child: child!,
          );
        }
    );


    if(pickedDate != null ){
      print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      print(formattedDate); //formatted date output using intl package =>  2021-03-16
      //you can implement different kind of Date Format here according to your requirement

      setState(() {
        dateinput.text = formattedDate; //set output date to TextField value.
      });
    }else{
      print("Date is not selected");
    }
  }


  Future pickFromCamera()async{
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if(image == null) return;
      final imageTemp = File(image.path);

      setState(() => this.photo = imageTemp);
      setState(()=> imageSelected = true);

      uploadImage(this.photo.path.toString());

    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickFromGallery()async{
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;
      final imageTemp = File(image.path);
      log(image.name.toString());

      setState(() => this.photo = imageTemp);
      setState(()=> imageSelected = true);
        uploadImage(this.photo.path.toString());
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }


  Future selectFrom() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            child: Stack(children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding:
                  const EdgeInsets.only(top: 20, bottom: 20, right: 20, left: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          'Select Image from',
                          style: TextStyle(

                              fontSize: 18.0,
                              color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),

                      SizedBox(
                        height: 30.0,
                      ),
                      Button(
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(25),
                        textColor: Colors.white,
                        backgroundColor: AppColors.soil,
                        text: 'Gallery',
                        fontSize: 18,
                        width: MediaQuery.of(context).size.width,
                        height: 20,
                        onPressed: () {
                          Navigator.pop(context,true);
                          pickFromGallery();
                        }, fontFamily: 'HindMedium',
                      ),

                      SizedBox(
                        height: 30.0,
                      ),
                      Button(
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(25),
                        textColor: Colors.white,
                        backgroundColor: AppColors.soil,
                        text: 'Camera',
                        fontSize: 18,
                        width: MediaQuery.of(context).size.width,
                        height: 20,
                        onPressed: () {
                          Navigator.pop(context,true);
                          pickFromCamera();
                        }, fontFamily: 'HindMedium',
                      ),

                      SizedBox(
                        height: 30.0,
                      ),
                      Button(
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(25),
                        textColor: Colors.white,
                        backgroundColor: AppColors.soil,
                        text: 'Cancel',
                        fontSize: 18,
                        width: MediaQuery.of(context).size.width,
                        height: 20,
                        onPressed: () {
                          Navigator.pop(context,true);
                        }, fontFamily: 'HindMedium',
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          );
        });

  }



  @override
  Widget build(BuildContext context) {
    var helpers = Helpers();
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: AppColors.soil,
              elevation: 1.0,
              centerTitle: true,
              title: Text(
                'Profile',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: <Color>[AppColors.soil, AppColors.darkSoil]),
                ),
              ),
            ),
            body:loading?Loader(): !editProfile
                ? SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Stack(
                        children: [
                          Container(
                            height: 95,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: <Color>[AppColors.soil, AppColors.darkSoil]),
                            ),

                          ),
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.black,
                                      radius: 55.0,
                                      backgroundImage: NetworkImage(
                                        ApiConstants.baseUrl+'/'+profile,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  name,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      fontFamily: 'HindMedium'),
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(top: 0, bottom: 10),
                                child: Text(
                                   mobile,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      fontFamily: 'HindMedium'),
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(top: 0, bottom: 10),
                                child: Text(
                                  village,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      fontFamily: 'HindMedium'),
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () {

                                    setState((){
                                      editProfile =true;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.black45,
                                      fixedSize: Size(110, 10),
                                      textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      )),
                                  child: Text(
                                    'Edit Profile',
                                    maxLines: 1,
                                    style: TextStyle(fontSize: 12),
                                  ))
                            ],
                          )
                        ],
                      ),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey[100],
                      height: 25,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Text(
                            'Family Members',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      color: Colors.white,
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: children.length,
                          itemBuilder: (context, index) {
                            return Column(children: <Widget>[
                              Container(
                                height: 60,
                                child: ListTile(
                                  title: Text(
                                    children[index]["name"],
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios_sharp,
                                    color: Colors.black,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      /*  _currentItem = index;
                                  card = children[_currentItem]['card'];
                                  number = children[_currentItem]['number'];
                                  image = children[_currentItem]['image'];
                                  label = children[_currentItem]['label'];
                                  date = children[_currentItem]['date'];
                                  isDefault = true;*/
                                    });
                                  },
                                ),
                              ),
                              Divider(
                                height: 1,
                                color: Colors.grey[200],
                                thickness: 2,
                              )
                            ]);
                          }),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 50,
                          width: 300,
                          child: ElevatedButton(
                            child: Text(
                              '+ Connect Family',
                              style: TextStyle(
                                color: AppColors.soil,
                                fontSize: 16.0,
                              ),
                            ),
                            onPressed: () async{


                              //Navigator.pushNamed(context, '/studentDetails');
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(25.0),
                                        side: BorderSide(
                                          color: AppColors.soil,
                                        )))),
                          ),
                        )),
                  ],
                ))
                : SingleChildScrollView(
              child: SafeArea(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width,
                            child: Stack(children: [
                              Container(
                                height: 115,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: <Color>[AppColors.soil, AppColors.darkSoil]),
                                ),
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child:CircleAvatar(
                                        radius:60.0,
                                        backgroundColor: Colors.white,
                                        child:imageSelected?
                                        CircleAvatar(
                                          backgroundColor: Colors.black,
                                          radius: 55.0,
                                          backgroundImage: FileImage(photo) ,
                                        ):CircleAvatar(
                                          backgroundColor: Colors.black,
                                          radius: 55.0,
                                          backgroundImage: NetworkImage(ApiConstants.baseUrl+'/'+profile),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: TextButton(
                                      child: Text('Change Picture',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14)),
                                      onPressed: () {
                                        selectFrom();
                                      },
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: TextField(
                                      controller: nameController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey
                                            )
                                        ),
                                        labelText: name,
                                        hintText: 'Name',
                                        labelStyle: TextStyle(
                                            color: Colors.black
                                        ),focusedBorder:OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.black,
                                        ),
                                      ),
                                      ),
                                      onChanged: (value){

                                      },
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: TextField(
                                      readOnly: true,
                                      onTap: selectDate,
                                      controller: dateinput,
                                      decoration: InputDecoration(
                                        suffixIcon: Icon(
                                          Icons.calendar_today_outlined,
                                          color: Colors.grey,
                                        ),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey
                                            )
                                        ),
                                        labelText: dob,
                                        hintText: 'Date of Birth',
                                        labelStyle: TextStyle(
                                            color: Colors.black
                                        ),focusedBorder:OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.black,
                                        ),
                                      ),
                                      ),
                                      onChanged: (value){
                                        setState((){

                                        });
                                      },

                                    ),
                                  ),



                                  Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: TextField(
                                      controller: addressController,
                                      keyboardType: TextInputType.streetAddress,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey
                                            )
                                        ),
                                        labelText: address,
                                        hintText: 'Address',
                                        labelStyle: TextStyle(
                                            color: Colors.black
                                        ),focusedBorder:OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.black,
                                        ),
                                      ),
                                      ),
                                      onChanged: (value){
                                        setState((){

                                        });
                                      },
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: TextField(
                                      controller: villageController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey
                                            )
                                        ),
                                        labelText: village,
                                        hintText: 'Village',
                                        labelStyle: TextStyle(
                                            color: Colors.black
                                        ),focusedBorder:OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.black,
                                        ),
                                      ),
                                      ),
                                      onChanged: (value){
                                        setState((){

                                        });
                                      },
                                    ),
                                  ),



                                  Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Button(
                                          elevation: 0.0,
                                          textColor: Colors.white,
                                          backgroundColor: AppColors.soil,
                                          text: 'Update',
                                          width: 330,
                                          height: 50,
                                          fontSize: 18,
                                          onPressed: () {
                                            updateProfile();
                                          },
                                          borderRadius: BorderRadius.circular(25), fontFamily: 'HindBold',
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                      ],
                                    ),
                                  ),



                                ],
                              )
                            ]))
                      ])),
            )));
  }

  Future<bool> _onWillPop() async {
    if(editProfile){
      setState((){
        editProfile =false;
      });
    }
    else{
      return true;
    }
    return false;
  }
}
