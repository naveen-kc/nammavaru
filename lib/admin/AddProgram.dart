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
import '../widgets/loader.dart';
import 'package:http/http.dart' as http;
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


    setState((){
      loading=true;
    });
    var data =await AdminController().addProgram(imageFileList,'vidhyanidhi','this is vidhnidhi','28/02/2022','0TfGADHyf3Y,I0japj6Irfk,CXNtVQ_mJfM,Nnj2NS8r1zo');
    log("dataaaaa :"+data.toString());
    if(data['status']){
      setState((){
        loading=false;
      });
    }else{
      setState((){
        loading=false;
      });
    }

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: loading
                ? Loader()
                : SingleChildScrollView(
                    child:Expanded(
                      child:
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 5, 5),
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
                            SizedBox(height: 20,),
                            Expanded(child: Padding(
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
                    )))));
  }
}
