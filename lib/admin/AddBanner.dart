import 'dart:developer';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../utils/constants.dart';
import '../widgets/app_button.dart';
import '../widgets/dialog_box.dart';
import '../widgets/lottie.dart';
import 'AdminController.dart';

class AddBanner extends StatefulWidget {
  const AddBanner({Key? key}) : super(key: key);

  @override
  State<AddBanner> createState() => _AddBannerState();
}

class _AddBannerState extends State<AddBanner> {

  bool imageSelected= false;
  String imageName="";
  late File photo;
  bool loading=false;
  TextEditingController nameController=TextEditingController();
  TextEditingController urlController=TextEditingController();



  void addBanner()async{
    if(nameController.text.isEmpty){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AppDialog(
              header: "Enter name field",
              description: 'Please write name of banner just for its identify.',
              buttonColor: AppColors.black,
            );
          });
    }
    else if(imageName.isEmpty){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AppDialog(
              header: "Select Image",
              description: 'Please select one image for banner and make sure it is in size of banner only',
              buttonColor: AppColors.black,
            );
          });
    }else{
      setState((){
        loading=true;
      });
      var data=await AdminController().addBanner(nameController.text,urlController.text,this.photo.path);
      if(data['status']){
        Navigator.pop(context,true);
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AppDialog(
                header: "Success",
                description: data['message'],
                buttonColor: AppColors.black,
              );
            });
        setState((){
          loading=false;
        });
      }else{
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
        setState((){
          loading=false;
        });
      }
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
                        backgroundColor: AppColors.black,

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
                        backgroundColor: AppColors.black,
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
                        backgroundColor:  AppColors.black,
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
        resizeToAvoidBottomInset: true,
        body: SafeArea(
            child:loading
                ? LottiePage()
                : SingleChildScrollView(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 30),
                              child: Text(
                                'Add Banner',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 30.0, fontFamily: 'HindBold'),
                              )),
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                            child: TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey
                                    )
                                ),
                                labelText: 'Banner Name',
                                hintText: 'Banner Name',
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

                                });
                              },
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                            child: TextField(
                              keyboardType: TextInputType.text,
                              controller: urlController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey
                                    )
                                ),
                                labelText: 'Url of banner',
                                hintText: 'You can keep it empty, if url not there',
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

                                });
                              },
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
                                                  color: AppColors.black,
                                                )

                                            )
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 10),
                                        child: Text('Browse to select',
                                          style: TextStyle(
                                              color: AppColors.black ,
                                              fontSize: 15,
                                              fontFamily: 'HindRegular'

                                          ),),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Button(
                              elevation: 0.0,
                              textColor: Colors.white,
                              backgroundColor: AppColors.black,
                              text: 'Upload',
                              width: 330,
                              height: 50,
                              fontSize: 18,
                              onPressed: () {
                                addBanner();
                              },
                              borderRadius: BorderRadius.circular(10), fontFamily: 'HindBold',
                            ),
                          ),

                        ])))));
  }
}