import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nammavaru/admin/AdminController.dart';

import '../network/ApiEndpoints.dart';
import '../utils/constants.dart';
import '../widgets/app_button.dart';
import '../widgets/dialog_box.dart';
import '../widgets/loader.dart';
import 'package:http/http.dart' as http;

import '../widgets/lottie.dart';
class AddProgram extends StatefulWidget {
  const AddProgram({Key? key}) : super(key: key);

  @override
  State<AddProgram> createState() => _AddProgramState();
}

class _AddProgramState extends State<AddProgram> {
  bool loading = false;
  final ImagePicker imagePicker=ImagePicker();
  List<XFile>? imageFileList=[];
  List<dynamic> images=[];
  TextEditingController detailsController =TextEditingController();
  TextEditingController nameController =TextEditingController();
  TextEditingController dateController =TextEditingController();
  TextEditingController videoController =TextEditingController();


  void selectImages()async{
    final List<XFile>? selectedImages= await imagePicker.pickMultiImage();
    if(selectedImages!.isNotEmpty){
      imageFileList!.addAll(selectedImages);
      log("Imaghessss :"+imageFileList![0].path.toString());
    }
    setState((){
      imageFileList=selectedImages;
    });

  }



  void uploadProgram() async {

    if(imageFileList!.isEmpty){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AppDialog(
              header: "Select Photos",
              description: 'Please select images of program.',
              buttonColor: AppColors.black,
            );
          });
    }else if(detailsController.text.isEmpty||nameController.text.isEmpty||dateController.text.isEmpty||videoController.text.isEmpty){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AppDialog(
              header: "You missed some fields",
              description: 'Please enter all the fields, all fields needed to add a program',
              buttonColor: AppColors.black,
            );
          });
    }

    else{
      setState((){
        loading=true;
      });
      var data =await AdminController().addProgram(imageFileList,nameController.text,detailsController.text,dateController.text,videoController.text);
      log("dataaaaa :"+data.toString());
      if(data['status']){
        Navigator.pop(context,true);
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AppDialog(
                header: "Success",
                description: 'Program added successfully',
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
                header: "Failure",
                description: 'Failed to add program',
                buttonColor: AppColors.black,
              );
            });
        setState((){
          loading=false;
        });
      }
    }

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
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: Text(
                                'Add Program',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 30.0, fontFamily: 'HindBold'),
                              ),
                            ),
                              TextButton(
                                onPressed: () {
                                  selectImages();
                                },
                                child: Text('Select photos of program',
                                  style: TextStyle(
                                      color: AppColors.darkBlue
                                  ),),

                              ),

                              imageFileList!.isEmpty?Text('No photos selected',
                              style: TextStyle(
                                color: AppColors.red,
                                fontFamily: 'HindRegular'
                              ),):Expanded(child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: GridView.builder(
                                      itemCount: imageFileList!.length,
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 2,
                                          mainAxisSpacing: 2

                                      ),
                                      itemBuilder: (BuildContext context,int index){

                                        return Image.file(File(imageFileList![index].path),
                                          fit: BoxFit.cover ,);
                                      }),
                                )
                                ),

                              Padding(
                                padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                child: TextField(
                                  controller: videoController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey
                                        )
                                    ),
                                    labelText: 'Video Ids',
                                    hintText: 'Put comma after every video id, Eg:hjdfgd,gssgh,sggss',
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
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey
                                        )
                                    ),
                                    labelText: 'Program Name',
                                    hintText: 'Program Name',
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
                                  keyboardType: TextInputType.datetime,
                                  controller: dateController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey
                                        )
                                    ),
                                    labelText: 'Enter Date',
                                    hintText: 'Enter Date',
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
                                padding: EdgeInsets.fromLTRB(15, 5, 15, 0),
                                child: Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.black, width: 0.5),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                    child: TextField(
                                      controller: detailsController,
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
                                    uploadProgram();
                                  },
                                  borderRadius: BorderRadius.circular(10), fontFamily: 'HindBold',
                                ),
                              ),


                          ]),
                      ),
                    )));
  }
}
