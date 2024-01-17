 import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gwc_customer_web/model/error_model.dart';
import 'package:gwc_customer_web/model/new_user_model/about_program_model/about_program_model.dart';
import 'package:gwc_customer_web/model/new_user_model/about_program_model/feedback_list_model.dart';
import 'package:gwc_customer_web/repository/api_service.dart';
import 'package:gwc_customer_web/repository/new_user_repository/about_program_repository.dart';
import 'package:gwc_customer_web/services/new_user_service/about_program_service.dart';
import 'package:gwc_customer_web/widgets/constants.dart';
import 'package:gwc_customer_web/widgets/vlc_player/vlc_player_with_controls.dart';
import 'package:gwc_customer_web/widgets/widgets.dart';
import 'package:flutter_sizer/flutter_sizer.dart';import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:visibility_detector/visibility_detector.dart';
 import 'package:wakelock_plus/wakelock_plus.dart';

import '../../widgets/video/normal_video.dart';
import 'package:video_player/video_player.dart';

class TestimonialListScreen extends StatefulWidget {
  const TestimonialListScreen({Key? key}) : super(key: key);

  @override
  State<TestimonialListScreen> createState() => _TestimonialListScreenState();

}

class _TestimonialListScreenState extends State<TestimonialListScreen> {

  List<TestimonilalDummy> dummyData = [
    TestimonilalDummy('Lorem Ipsum is simply dummy text of the print and typesetting industry. Lorem Ipsum '
  'has been the industry standard dummy text'
  'ever since the 1500s, when an unknown'
  'printer took a galley of type and scrambled it to make a type specimen book.'),
    TestimonilalDummy('Lorem Ipsum is simply dummy text of the print and typesetting industry.',
      image: 'http://dl.fujifilm-x.com/global/products/cameras/gfx100s/sample-images/gfx100s_sample_02_eibw.jpg?_ga=2.37751268.636017681.1669353692-1769152156.1669353692'
    ),
    TestimonilalDummy('Lorem Ipsum is simply dummy text of the print and typesetting industry. Lorem Ipsum '
        'has been the industry standard dummy text'
        'ever since the 1500s, when an unknown'
        'printer took a galley of type and scrambled it to make a type specimen book.'),
    TestimonilalDummy('Lorem Ipsum is simply dummy text of the print and typesetting industry.',
        image: 'http://dl.fujifilm-x.com/global/products/cameras/gfx100s/sample-images/gfx100s_sample_02_eibw.jpg?_ga=2.37751268.636017681.1669353692-1769152156.1669353692'
    ),
    TestimonilalDummy('Lorem Ipsum is simply dummy text of the print and typesetting industry. Lorem Ipsum '
        'has been the industry standard dummy text'
        'ever since the 1500s, when an unknown'
        'printer took a galley of type and scrambled it to make a type specimen book.'),
    TestimonilalDummy('Lorem Ipsum is simply dummy text of the print and typesetting industry.',
        image: 'http://dl.fujifilm-x.com/global/products/cameras/gfx100s/sample-images/gfx100s_sample_02_eibw.jpg?_ga=2.37751268.636017681.1669353692-1769152156.1669353692'
    ),

  ];

  late AboutProgramService _aboutProgramService;

  late Future _getTestimonialList;


  final AboutProgramRepository repository = AboutProgramRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _aboutProgramService = AboutProgramService(repository: repository);
    getFuture();
    wake();
  }
  wake() async{
    if(await WakelockPlus.enabled == false){
      WakelockPlus.enable();
    }
  }

  getFuture(){
    _getTestimonialList =  _aboutProgramService.serverAboutProgramService();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: 1.h),
          child: Column(
            children: [
              buildAppBar(() => null,
                isBackEnable: false
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: newUI(),
                )
              )
            ],
          ),
        ),
      ),
    );
  }

  oldUI(){
    return ListView.builder(
        itemCount: dummyData.length,
        itemBuilder: (_, index){
          return showCardViews(feedback:dummyData[index].mainText, imagePath: dummyData[index].image);
        }
    );
  }
  newUI(){
    return FutureBuilder(
      future: _getTestimonialList,
        builder: (_, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasData){
            if(snapshot.data.runtimeType == ErrorModel){
              var model = snapshot.data as ErrorModel;
              return Center(
                child: Text(model.message ?? '',
                  style: TextStyle(
                      fontFamily: kFontMedium,
                      fontSize: 10.sp
                  ),
                ),
              );
            }
            else{
              var model = snapshot.data as AboutProgramModel;
              List<FeedbackList> feedbackList = model.data?.feedbackList ?? [];
              if(feedbackList.isEmpty){
                return noData();
              }
              else{
                return ListView.builder(
                    itemCount: feedbackList.length,
                    itemBuilder: (_, index){
                      print("feedbackList[index].file: ${feedbackList[index].file.runtimeType}");
                      return showCardViews(
                        userProfile: feedbackList[index].addedBy?.profile ?? '',
                          feedbackTime: DateFormat('dd MMM yyyy , hh:mm a').format(DateTime.parse(feedbackList[index].addedBy?.createdAt ?? '').toLocal()),
                          feedbackUser: feedbackList[index].addedBy?.name ?? '',
                          feedback: feedbackList[index].feedback,
                          imagePath: (feedbackList[index].file == null) ? null : feedbackList[index].file?.first
                      );
                    }
                );
              }
            }
          }
          else if(snapshot.hasError){
            return Center(
              child: Text(snapshot.error.toString(),
                style: TextStyle(
                  fontFamily: kFontMedium,
                  fontSize: 10.sp
                ),
              ),
            );
          }
        }
        return Center(child: buildCircularIndicator(),);
        }
    );
  }

  noData(){
    return const Center(
      child: Image(
        image: AssetImage("assets/images/no_data_found.png"),
        fit: BoxFit.scaleDown,
      ),
    );
  }


  showCardViews({String? userProfile, String? feedbackUser, String? feedbackTime, String? feedback, String? imagePath}){
    final a = imagePath;
    print("testimonial url : $a");
    final file = a?.split(".").last;
    String format = file.toString();
    if (format == "mp4") {
      if(a != null) addUrlToVideoPlayerChewie(a);
    }
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7, horizontal: 5),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      decoration: BoxDecoration(
        color: gWhiteColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: gHintTextColor.withOpacity(0.35),
            // spreadRadius: 0.3,
            blurRadius: 5
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            minVerticalPadding: 0,
            dense: true,
            minLeadingWidth: 30,
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(userProfile ?? ''),
              onBackgroundImageError: (obj, _){
                print(obj.toString());
              },
              maxRadius: 14.sp,
            ),
            title: Text(feedbackUser ??'',
              style: TextStyle(
                fontSize: 11.sp,
                fontFamily: kFontBold
              ),
            ),
            subtitle: Text(feedbackTime ?? '',
              style: TextStyle(
                  fontSize: 9.5.sp,
                  fontFamily: kFontBook
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(feedback ?? '',
                // 'Lorem Ipsum is simply dummy text of the print and typesetting industry',
              style: TextStyle(
                  fontSize: 10.5.sp,
                  fontFamily: kFontMedium,
                height: 1.5
              ),
            ),
          ),
        SizedBox(height: 1.h,),
        if (format == "mp4") buildTestimonial(),
          Visibility(
            visible: imagePath != null && format != "mp4",
            child: Center(
              child: Container(
                width: 70.w,
                height: 30.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      imagePath ?? '',
                      errorListener: (message){
                        Image.asset('assets/images/placeholder.png');
                      },
                      // placeholder: (_, __){
                      //   return Image.asset('assets/images/top-view-indian-food-assortment.png');
                      // },
                    )
                  )
                ),
                // child: Card(
                //   child: CachedNetworkImage(
                //     imageUrl: imagePath ?? '',
                //     placeholder: (_, __){
                //       return Image.asset('assets/images/top-view-indian-food-assortment.png');
                //     },
                //   ),
                // ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  VideoPlayerController? videoPlayerController;
  ChewieController ? _chewieController;

  addUrlToVideoPlayerChewie(String url) {
    print("url" + url);
    videoPlayerController = VideoPlayerController.network(Uri.parse(url).toString());
    _chewieController = ChewieController(
        videoPlayerController: videoPlayerController!,
        aspectRatio: 16/9,
        autoInitialize: true,
        showOptions: false,
        autoPlay: false,
        // customControls: Center(
        //   child: FittedBox(
        //     child: Row(
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
        //       children: [
        //         IconButton(
        //           onPressed: () => _seekRelative(_seekStepBackward),
        //           color: Colors.white,
        //           iconSize: 16,
        //           icon: Icon(Icons.replay_10),
        //         ),
        //         IconButton(
        //           onPressed: (){
        //             if(videoPlayerController!.value.isPlaying){
        //               videoPlayerController!.pause();
        //             }
        //             else{
        //               videoPlayerController!.play();
        //             }
        //             setState(() {
        //
        //             });
        //           },
        //           color: Colors.white,
        //           iconSize: 16,
        //           icon: (videoPlayerController!.value.isPlaying) ? Icon(Icons.pause)  : Icon(Icons.play_arrow),
        //         ),
        //         IconButton(
        //           onPressed: () => _seekRelative(_seekStepForward),
        //           color: Colors.white,
        //           iconSize: 16,
        //           icon: Icon(Icons.forward_10),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        hideControlsTimer: Duration(seconds: 3),
        showControls: false

    );

  }

  // final _key = GlobalKey<VlcPlayerWithControlsState>();
  // VlcPlayerController? _videoPlayerController;
  // addUrlToVideoPlayer(String url) {
  //   print("url" + url);
  //   _videoPlayerController = VlcPlayerController.network(
  //     Uri.parse(url).toString(),
  //     // "https://gwc.disol.in/dist/img/GMG-Podcast-%20CMN.mp4",
  //     // 'http://samples.mplayerhq.hu/MPEG-4/embedded_subs/1Video_2Audio_2SUBs_timed_text_streams_.mp4',
  //     //'https://media.w3.org/2010/05/sintel/trailer.mp4',
  //     hwAcc: HwAcc.disabled,
  //     autoPlay: false,
  //     options: VlcPlayerOptions(
  //       advanced: VlcAdvancedOptions([
  //         VlcAdvancedOptions.networkCaching(2000),
  //       ]),
  //       subtitle: VlcSubtitleOptions([
  //         VlcSubtitleOptions.boldStyle(true),
  //         VlcSubtitleOptions.fontSize(30),
  //         VlcSubtitleOptions.outlineColor(VlcSubtitleColor.yellow),
  //         VlcSubtitleOptions.outlineThickness(VlcSubtitleThickness.normal),
  //         // works only on externally added subtitles
  //         VlcSubtitleOptions.color(VlcSubtitleColor.navy),
  //       ]),
  //       http: VlcHttpOptions([
  //         VlcHttpOptions.httpReconnect(true),
  //       ]),
  //       rtp: VlcRtpOptions([
  //         VlcRtpOptions.rtpOverRtsp(true),
  //       ]),
  //     ),
  //   );
  // }

  buildTestimonial() {
    if (_chewieController != null) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: gPrimaryColor, width: 1),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.3),
            //     blurRadius: 20,
            //     offset: const Offset(2, 10),
            //   ),
            // ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Center(
              child:  OverlayVideo(
                controller: _chewieController!,
                isControlsVisible: false,
              )
            ),
          ),
          // child: Stack(
          //   children: <Widget>[
          //     ClipRRect(
          //       borderRadius: BorderRadius.circular(5),
          //       child: Center(
          //         child: VlcPlayer(
          //           controller: _videoPlayerController!,
          //           aspectRatio: 16 / 9,
          //           virtualDisplay: false,
          //           placeholder: Center(child: CircularProgressIndicator()),
          //         ),
          //       ),
          //     ),
          //     ControlsOverlay(controller: _videoPlayerController,)
          //   ],
          // ),
        ),
      );
    }
    // else if (_videoPlayerController != null) {
    //   return AspectRatio(
    //     aspectRatio: 16 / 9,
    //     child: Container(
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(5),
    //         border: Border.all(color: gPrimaryColor, width: 1),
    //         // boxShadow: [
    //         //   BoxShadow(
    //         //     color: Colors.grey.withOpacity(0.3),
    //         //     blurRadius: 20,
    //         //     offset: const Offset(2, 10),
    //         //   ),
    //         // ],
    //       ),
    //       child: ClipRRect(
    //         borderRadius: BorderRadius.circular(5),
    //         child: Center(
    //           child: VlcPlayerWithControls(
    //             key: _key,
    //             controller: _videoPlayerController!,
    //             showVolume: false,
    //             showVideoProgress: false,
    //             seekButtonIconSize: 10.sp,
    //             playButtonIconSize: 14.sp,
    //             replayButtonSize: 10.sp,
    //           ),
    //           // child: VlcPlayer(
    //           //   controller: _videoPlayerController!,
    //           //   aspectRatio: 16 / 9,
    //           //   virtualDisplay: false,
    //           //   placeholder: Center(child: CircularProgressIndicator()),
    //           // ),
    //         ),
    //       ),
    //       // child: Stack(
    //       //   children: <Widget>[
    //       //     ClipRRect(
    //       //       borderRadius: BorderRadius.circular(5),
    //       //       child: Center(
    //       //         child: VlcPlayer(
    //       //           controller: _videoPlayerController!,
    //       //           aspectRatio: 16 / 9,
    //       //           virtualDisplay: false,
    //       //           placeholder: Center(child: CircularProgressIndicator()),
    //       //         ),
    //       //       ),
    //       //     ),
    //       //     ControlsOverlay(controller: _videoPlayerController,)
    //       //   ],
    //       // ),
    //     ),
    //   );
    // }
    else {
      return const SizedBox.shrink();
    }
  }


  @override
  void dispose() async {
    super.dispose();
    print('dispose testimonials');
    if(await WakelockPlus.enabled == true){
      WakelockPlus.disable();
    }
    if(_chewieController != null) _chewieController!.dispose();
    if(videoPlayerController != null) videoPlayerController!.dispose();
    // if(_videoPlayerController != null){
    //   await _videoPlayerController!.stop();
    //   await _videoPlayerController!.stopRendererScanning();
    //   await _videoPlayerController!.dispose();
    // }
  }
  loadAsset(String name)  {
    rootBundle.load('assets/images/$name').then((value) {
      if(value != null){
        return value.buffer.asUint8List();
      }
    });
  }


}

class TestimonilalDummy{
  String mainText;
  String? image;
  TestimonilalDummy(this.mainText, {this.image});
}