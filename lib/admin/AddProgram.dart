import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../network/ApiEndpoints.dart';
import '../utils/constants.dart';
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



  Future<Future<bool?>?> uploadImages() async {
    // create multipart request
    var request = http.MultipartRequest('POST', Uri.parse(ApiConstants.baseUrl));


    if (imageFileList!.length > 0) {
      for (var i = 0; i < imageFileList!.length; i++) {
        request.files.add(http.MultipartFile('picture',
            File(imageFileList![i].path).readAsBytes().asStream(), File(imageFileList![i].path).lengthSync(),
            filename: imageFileList![i].path.split("/").last));
      }

      // send
      var response = await request.send();


      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        debugPrint(value);

      });
    }
    else{
      return Fluttertoast.showToast(
          msg: "Please Select at least one image",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
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
                            child: Text('Add',
                              style: TextStyle(
                                  color: AppColors.black
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
                          )

                      ]))));
  }
}
