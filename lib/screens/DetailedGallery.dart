import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nammavaru/network/ApiEndpoints.dart';
import 'package:nammavaru/utils/Helpers.dart';
import 'package:nammavaru/widgets/image_viewer.dart';
import 'package:nammavaru/widgets/loader.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../utils/constants.dart';
import '../widgets/lottie.dart';

class DetailedGallery extends StatefulWidget {
  const DetailedGallery({Key? key}) : super(key: key);

  @override
  State<DetailedGallery> createState() => _DetailedGalleryState();
}

class _DetailedGalleryState extends State<DetailedGallery> {

  late YoutubePlayerController _controller;
 // String videoId="CXNtVQ_mJfM";
  int vIndex=0;
  List<dynamic> videoIds=[];
   List<dynamic> photos = [];

   List<dynamic> program=[];
   String name='';
   String description='';
   bool loading=false;

   Helpers helpers=Helpers();


  @override
  void initState() {

    setState((){
      loading=true;
    });

    //final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    Future.delayed(Duration(seconds: 1), () {
      _controller = YoutubePlayerController(
          initialVideoId:videoIds[vIndex],
          flags: YoutubePlayerFlags(
            autoPlay: false,
            hideThumbnail: true,
            enableCaption: false,
          ));

      setState((){
        loading=false;
      });
    });



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
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    setState(() {
      program = args['program'];
    });
    setState((){
      videoIds = program[4].split(",");
      //videoIds=program[4].cast<String>().toList();
      photos=program[5].split(",");
      name=program[1].toString();
      description=program[2].toString();

    });

    log("PROGRAANMNNNN :"+program.toString());


    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: AppColors.soil,
            iconTheme: IconThemeData(
              color: AppColors.black,
            ),
            elevation: 0,
            title: Text(
              name,
              style: TextStyle(fontFamily: 'HindBold',
                  color: AppColors.black),
            )),
        body: loading?LottiePage(): YoutubePlayerBuilder(
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
                      child: Text(
                          description,
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
                                                   image: ApiConstants.baseUrl+'/photos/'+photos[index],
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
                                            child: Image.network(ApiConstants.baseUrl+'/photos/'+photos[index],
                                            fit: BoxFit.contain,
                                             // fit: BoxFit.fill,
                                              loadingBuilder: (BuildContext context, Widget child,
                                                  ImageChunkEvent? loadingProgress) {
                                                if (loadingProgress == null) return child;
                                                return Center(
                                                  child: CircularProgressIndicator(
                                                    color: AppColors.soil,
                                                    value: loadingProgress.expectedTotalBytes != null
                                                        ? loadingProgress.cumulativeBytesLoaded /
                                                        loadingProgress.expectedTotalBytes!
                                                        : null,
                                                  ),
                                                );
                                              },
                                            ),
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
