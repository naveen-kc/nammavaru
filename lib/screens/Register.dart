
import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nammavaru/utils/constants.dart';
import 'package:nammavaru/utils/helpers.dart';

import '../utils/LocalStorage.dart';
import '../widgets/app_button.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController dobController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController VillageController = TextEditingController();

  double percentage = 0.1;
  bool imageSelected= false;
  String imageName="";
  late File photo;
  String name='';
  String dob='';
  String gender='';
  String address='';
  String Village='';
  String pincode='';
  String state='';
  bool loading=false;
  LocalStorage localStorage=LocalStorage();
  Helpers helpers=Helpers();

  @override
  void initState() {
    dobController.text = "";
    super.initState();
  }

  void selectDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: context, initialDate: DateTime.now(),
        firstDate: DateTime(1901), //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2050),
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
        dobController.text = formattedDate;//set output date to TextField value.
        dob=formattedDate;
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
      setState(()=>imageName= image.name.toString());
      //uploadImage(this.photo.path.toString());

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
      setState(()=>imageName=image.name.toString());
      //  uploadImage(this.photo.path.toString());
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
                        },
                        fontFamily: 'HindMedium',
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
                        fontFamily: 'HindMedium',
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(25),
                        textColor: Colors.white,
                        backgroundColor:  AppColors.soil,
                        text: 'Cancel',
                        fontSize: 18,
                        width: MediaQuery.of(context).size.width,
                        height: 20,
                        onPressed: () {
                          Navigator.pop(context,true);
                        },
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
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 5, 5),
                  child: Text(
                    'Personal Details',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 30.0,
                      fontFamily: 'HindBold',
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 20,right: 20),
                  child: Text(
                    'Add your details here.',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'HindRegular',
                    ),
                  ),
                ),

                SizedBox(
                  height: 20,
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
                      labelText: 'Name',
                      hintText: 'Name',
                      hintStyle: TextStyle(
                        fontFamily: 'HindRegular',
                      ),
                      labelStyle: TextStyle(
                          color: Colors.black,
                        fontFamily: 'HindRegular',
                      ),focusedBorder:OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black,
                      ),
                    ),
                    ),
                    onChanged: (value){
                      setState((){
                        percentage =  0.2;
                        name=nameController.text;
                      });
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: TextField(
                    readOnly: true,
                    onTap: selectDate,
                    controller: dobController,
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
                      labelText: 'Date of Birth',
                      hintText: 'Date of Birth',
                      hintStyle: TextStyle(
                        fontFamily: 'HindRegular',
                      ),
                      labelStyle: TextStyle(
                          color: Colors.black,
                        fontFamily: 'HindRegular',
                      ),focusedBorder:OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black,
                      ),
                    ),
                    ),
                    onChanged: (value){
                      setState((){
                        percentage =  0.3;
                        dob=dobController.text;
                      });
                    },

                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: TextField(
                    controller: genderController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey
                          )
                      ),
                      labelText: 'Gender',
                      hintText: 'Gender',
                      hintStyle: TextStyle(
                        fontFamily: 'HindRegular',
                      ),
                      labelStyle: TextStyle(
                          color: Colors.black,
                        fontFamily: 'HindRegular',
                      ),focusedBorder:OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black,
                      ),
                    ),
                    ),
                    onChanged: (value){
                      setState((){
                        percentage =  0.4;
                        gender=genderController.text;
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
                      labelText: 'Address',
                      hintText: 'Address',
                      hintStyle: TextStyle(
                        fontFamily: 'HindRegular',
                      ),
                      labelStyle: TextStyle(
                          color: Colors.black,
                        fontFamily: 'HindRegular',
                      ),focusedBorder:OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black,
                      ),
                    ),
                    ),
                    onChanged: (value){
                      setState((){
                        percentage =  0.5;
                        address=addressController.text;
                      });
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: TextField(
                    controller:VillageController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey
                          )
                      ),
                      labelText: 'Village',
                      hintText: 'Village',
                      hintStyle: TextStyle(
                        fontFamily: 'HindRegular',
                      ),
                      labelStyle: TextStyle(
                          color: Colors.black,
                        fontFamily: 'HindRegular',
                      ),focusedBorder:OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black,
                      ),
                    ),
                    ),
                    onChanged: (value){
                      setState((){
                        percentage =  0.6;
                        Village=VillageController.text;
                      });
                    },
                  ),
                ),





                Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text('Upload profile picture',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),)
                ),

                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    height: 180,
                    width: MediaQuery.of(context).size.width,
                    child: DottedBorder(
                      color: AppColors.soil ,
                      strokeWidth: 1,
                      borderType: BorderType.Rect,
                      dashPattern: [3,4],
                      child: Center(
                        child: imageSelected ? CircleAvatar(
                          radius: 60,
                          backgroundImage: FileImage(photo),
                        ):Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20,bottom: 20),
                              child: Center(
                                  child: GestureDetector(
                                    onTap: selectFrom,
                                        child: Icon(
                                          Icons.upload_outlined,
                                          size: 100,
                                          color: AppColors.soil,
                                        )

                                  )
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text('Browse to upload',
                                style: TextStyle(
                                    color: Color(0xFF455D2B) ,
                                    fontSize: 15

                                ),),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text(imageName,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),)
                ),



                SizedBox(
                  height: 30,
                ),

                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Button(
                        elevation: 0.0,
                        textColor: Colors.white,
                        backgroundColor: AppColors.soil,
                        text: 'Save',
                        width: 330,
                        height: 50,
                        fontSize: 18,
                        onPressed: () {
                          //storeBasic();
                        },
                        borderRadius: BorderRadius.circular(25), fontFamily: 'HindMedium',
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),

              ],
            ),
          )
      ),
    );
  }
}
