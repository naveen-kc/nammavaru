import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../controller/HomeController.dart';
import '../utils/constants.dart';
import '../widgets/app_button.dart';
import '../widgets/loader.dart';


class AddUpdate extends StatefulWidget {
  const AddUpdate({Key? key}) : super(key: key);

  @override
  State<AddUpdate> createState() => _AddUpdateState();
}

class _AddUpdateState extends State<AddUpdate> {
  bool imageSelected= false;
  String imageName="";
  late File photo;
  bool loading=false;
  TextEditingController descriptionController =TextEditingController();


  void addUpdate()async{
    var data=await HomeController().updateNow(descriptionController.text,this.photo.path);
    if(data['status']){

    }else{

    }

  }
//for checking git
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
                      SizedBox(
                        height: 15.0,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          'Note :You can add only one image',
                          style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.red),
                        ),
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
      resizeToAvoidBottomInset : false,
      body: SafeArea(
          child:loading?Loader():
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 5, 5),
                  child: Text(
                    'Add an update ',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 30.0,
                        fontFamily: 'HindBold'
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 20,bottom: 10),
                  child: Text(
                    'So that our community will get to know about your family',
                    style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'HindRegular'
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    height: 180,
                    width: MediaQuery.of(context).size.width,
                    child: DottedBorder(
                      color: AppColors.grey ,
                      strokeWidth: 1,
                      borderType: BorderType.Rect,
                      dashPattern: [3,4],
                      child: Center(
                        child: imageSelected ? SizedBox(
                          child: Image.file(photo,
                          fit: BoxFit.fitWidth,),
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
                              child: Text('Browse to select',
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
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.lightGrey3, width: 2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: TextField(
                        controller: descriptionController,
                        onChanged: (value) {

                        },
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Write a caption or decription',
                        ),
                        style:
                        TextStyle(fontSize: 16, fontFamily: 'HindMedium'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Align(
                  alignment: Alignment.center,
                  child:
                  Button(
                    elevation: 0.0,
                    textColor: Colors.white,
                    backgroundColor: AppColors.soil,
                    text: 'Add',
                    width: 300,
                    height: 50,
                    fontSize: 18,
                    onPressed: () {
                      addUpdate();
                    },
                    borderRadius: BorderRadius.circular(25), fontFamily: 'HindBold',
                  ),
                ),

              ],
            ),
          )
      ),
    );
  }
}
