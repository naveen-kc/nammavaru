import 'package:flutter/material.dart';
import 'package:nammavaru/utils/constants.dart';

class ImageViewer extends StatefulWidget {

  String image;

  ImageViewer(
      {Key? key,
        required this.image,
      })
      : super(key: key);

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 0,
      backgroundColor:AppColors.white,
      child:Container(
        height: MediaQuery.of(context).size.height*0.8,
       child:Stack(
        children: [
        InteractiveViewer(
          panEnabled: true,
          child: Image.network(widget.image,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,),
        ),

          Align(
            alignment: Alignment.topRight,
            child: IconButton(onPressed: (){
              Navigator.pop(context,true);
            },
                icon: Icon(
                  Icons.cancel_outlined
                )),
          ),

        ],
      ),
    ));
  }
}
