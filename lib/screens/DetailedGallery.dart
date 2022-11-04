import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nammavaru/utils/Helpers.dart';
import 'package:nammavaru/widgets/image_viewer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../utils/constants.dart';

class DetailedGallery extends StatefulWidget {
  const DetailedGallery({Key? key}) : super(key: key);

  @override
  State<DetailedGallery> createState() => _DetailedGalleryState();
}

class _DetailedGalleryState extends State<DetailedGallery> {

  late YoutubePlayerController _controller;
 // String videoId="CXNtVQ_mJfM";
  int vIndex=0;
  List<dynamic> videoIds=['0TfGADHyf3Y','I0japj6Irfk','CXNtVQ_mJfM','Nnj2NS8r1zo'];
   List<dynamic> photos = [
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80',
     'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
      'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  ];

   Helpers helpers=Helpers();


  @override
  void initState() {

    //final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    _controller = YoutubePlayerController(
        initialVideoId:videoIds[vIndex],
        flags: YoutubePlayerFlags(
            autoPlay: false,
          hideThumbnail: true,
          enableCaption: false,
        ));

    super.initState();
  }

  void showToastMessage(BuildContext context,String msg){
     Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.lightGrey2,
        textColor: AppColors.darkSoil,
        fontSize: 16.0
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: AppColors.soil,
            iconTheme: IconThemeData(
              color: AppColors.black,
            ),
            elevation: 0,
            title: Text(
              "Vidhya nidhi",
              style: TextStyle(fontFamily: 'HindBold',
                  color: AppColors.black),
            )),
        body: YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: AppColors.soil,
              progressColors: ProgressBarColors(
                backgroundColor: AppColors.grey,
                playedColor: AppColors.soil,
                handleColor: AppColors.soil
              ),
              onReady: () {

              },

            ),
            builder: (context, player) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                          'This is the video of our cultural program of Vidhyanidhi program.',
                        style: TextStyle(
                          fontFamily: 'HindRegular',
                          fontSize: 16,
                          color: AppColors.darkSoil
                        ),
                      ),
                    ),
                    player,
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          if(vIndex!=0)
                          TextButton(
                            onPressed: () {
                              setState((){
                                vIndex--;
                              });
                              _controller.pause();
                              _controller.load(videoIds[vIndex]);
                              _controller.play();

                            },
                            child: Text('Previous',
                              style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 18,
                                  fontFamily: 'HindMedium'
                              ),),
                          ),
                           Spacer(),
                          if(videoIds.length>1) TextButton(
                             onPressed: () {
                               if(vIndex==videoIds.length-1){
                                 log("No videos");
                                 showToastMessage(context,"No more videos");

                               }else{
                                 setState((){
                                   vIndex++;
                                 });
                                 _controller.pause();
                                 _controller.load(videoIds[vIndex]);
                                 _controller.play();

                               }

                             },
                            child: Text('Next',
                            style: TextStyle(
                              color: AppColors.soil,
                              fontSize: 18,
                              fontFamily: 'HindMedium'
                            ),),
                          ),
                        ],
                      ),
                    ),
                    Text('Photos',
                      style: TextStyle(
                          color: AppColors.darkSoil,
                          fontSize: 18,
                          fontFamily: 'HindMedium'
                      ),),
                    Column(
                      children: [
                        Container(
                            height: MediaQuery.of(context).size.height*0.4,
                            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: Scrollbar(
                              child: GridView.builder(
                                itemCount: photos.length,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 2.0,
                                    mainAxisSpacing: 2.0
                                ),
                                itemBuilder: (BuildContext context, int index){
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap:(){
                                            showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (BuildContext context) {
                                                  return ImageViewer(
                                                   image: photos[index],
                                                  );
                                                });
                                          },
                                          child: Container(
                                            height:120,
                                            width: MediaQuery.of(context).size.width*0.4,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: AppColors.black,
                                                    spreadRadius: 0.5),
                                              ],
                                            ),
                                            child: Image.network(photos[index],
                                            fit: BoxFit.contain,),
                                          ),
                                        ),

                                      ],
                                    ),
                                  );
                                },
                              ),
                            )),

                      ],
                    ),

                  ],
                ),
              );
            }
        )
    );
  }

}
