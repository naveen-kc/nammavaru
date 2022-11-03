import 'package:flutter/material.dart';
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
              return Column(
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
                             setState((){
                               vIndex++;
                             });

                             _controller.pause();
                            _controller.load(videoIds[vIndex]);
                            _controller.play();
                           },
                          child: Text('Next',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 18,
                            fontFamily: 'HindMedium'
                          ),),
                        ),
                      ],
                    ),
                  )
                  //some other widgets
                ],
              );
            }
        )
    );
  }

}
