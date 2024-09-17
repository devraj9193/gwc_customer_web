import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:just_audio/just_audio.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';

class YogaAudioScreen extends StatefulWidget {
  final String videoUrl;
  final String heading;
  const YogaAudioScreen(
      {Key? key, required this.videoUrl, required this.heading})
      : super(key: key);

  @override
  State<YogaAudioScreen> createState() => _YogaAudioScreenState();
}

class _YogaAudioScreenState extends State<YogaAudioScreen> {
  AudioHandler? _audioHandler;

  @override
  void initState() {
    super.initState();
    _initAudioService();
  }

  Future<void> _initAudioService() async {
    _audioHandler = await AudioService.init(
      builder: () => AudioPlayerHandler(widget.videoUrl),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.example.myapp.channel.audio',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationOngoing: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: buildAppBar(
          () {
            // audioPlayer.stop();
            Navigator.pop(context);
          },
          showLogo: false,
          showChild: true,
          child: Text(
            widget.heading,
            style: TextStyle(
                fontFamily: eUser().mainHeadingFont,
                color: eUser().mainHeadingColor,
                fontSize: eUser().mainHeadingFontSize),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 12.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/images/yoga_placeholder.png',
                fit: BoxFit.fill,
                height: 30.h,
              ),
            ),
            SizedBox(height: 3.h),
            StreamBuilder<PlaybackState>(
              stream: _audioHandler?.playbackState,
              builder: (context, snapshot) {
                final playbackState = snapshot.data;
                final playing = playbackState?.playing ?? false;
                // final processingState = playbackState?.processingState;
                return Column(
                  children: [
                    StreamBuilder<Duration>(
                      stream: _audioHandler?.playbackState.map((state) => state.updatePosition).distinct(),
                      builder: (context, snapshot) {
                        final position = snapshot.data ?? Duration.zero;
                        return StreamBuilder<MediaItem?>(
                          stream: _audioHandler?.mediaItem,
                          builder: (context, snapshot) {
                            final duration = snapshot.data?.duration ?? Duration.zero;
                            return Slider(
                              value: position.inSeconds.toDouble(),
                              max: duration.inSeconds.toDouble(),
                              onChanged: (value) {
                                _audioHandler?.seek(Duration(seconds: value.toInt()));
                              },
                            );
                          },
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.replay_10),
                          onPressed: _audioHandler?.rewind,
                        ),
                        IconButton(
                          icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                          iconSize: 64.0,
                          onPressed: playing ? _audioHandler?.pause : _audioHandler?.play,
                        ),
                        IconButton(
                          icon: Icon(Icons.forward_10),
                          onPressed: _audioHandler?.fastForward,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),

            // StreamBuilder<Duration>(
            //   stream: audioPlayer.positionStream,
            //   builder: (context, snapshot) {
            //     final position = snapshot.data ?? Duration.zero;
            //     final duration = audioPlayer.duration ?? Duration.zero;
            //
            //     return Column(
            //       children: [
            //         Padding(
            //           padding: EdgeInsets.only(top: 5.h, left: 5.w, right: 5.w),
            //           child: Slider(
            //             value: position.inSeconds.toDouble(),
            //             max: duration.inSeconds.toDouble(),
            //             activeColor: gsecondaryColor,
            //             inactiveColor: gsecondaryColor.withOpacity(0.2),
            //             thumbColor: gsecondaryColor,
            //             onChanged: (value) {
            //               setState(() {
            //                 audioPlayer.seek(Duration(seconds: value.toInt()));
            //               });
            //             },
            //           ),
            //         ),
            //         Padding(
            //           padding:
            //               EdgeInsets.only(bottom: 5.h, left: 7.w, right: 7.w),
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Text(
            //                 position.toString().split('.').first,
            //               ),
            //               Text(
            //                 duration.toString().split('.').first,
            //               ),
            //             ],
            //           ),
            //         ),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             IconButton(
            //               icon: Icon(
            //                 Icons.replay_10,
            //                 size: 5.h,
            //                 color: gGreyColor,
            //               ),
            //               onPressed: () {
            //                 audioPlayer.seek(
            //                   audioPlayer.position -
            //                       const Duration(seconds: 10),
            //                 );
            //               },
            //             ),
            //             Container(
            //               padding: const EdgeInsets.all(5),
            //               margin: EdgeInsets.symmetric(horizontal : 5.w),
            //               decoration: const BoxDecoration(
            //                   color: gsecondaryColor, shape: BoxShape.circle),
            //               child: StreamBuilder<PlayerState>(
            //                 stream: audioPlayer.playerStateStream,
            //                 builder: (context, snapshot) {
            //                   final playerState = snapshot.data;
            //                   final processingState =
            //                       playerState?.processingState;
            //                   final playing = playerState?.playing;
            //                   if (processingState == ProcessingState.loading ||
            //                       processingState ==
            //                           ProcessingState.buffering) {
            //                     return const CircularProgressIndicator(
            //                       color: gWhiteColor,
            //                     );
            //                   } else if (playing != true) {
            //                     return GestureDetector(
            //                       child: Icon(
            //                         Icons.play_arrow,
            //                         color: gWhiteColor,
            //                         size: 5.h,
            //                       ),
            //                       onTap: audioPlayer.play,
            //                     );
            //                   } else if (processingState !=
            //                       ProcessingState.completed) {
            //                     return GestureDetector(
            //                       child: Icon(
            //                         Icons.pause,
            //                         color: gWhiteColor,
            //                         size: 5.h,
            //                       ),
            //                       onTap: audioPlayer.pause,
            //                     );
            //                   } else {
            //                     return GestureDetector(
            //                       child: Icon(
            //                         Icons.replay,
            //                         color: gWhiteColor,
            //                         size: 5.h,
            //                       ),
            //                       onTap: () => audioPlayer.seek(Duration.zero),
            //                     );
            //                   }
            //                 },
            //               ),
            //             ),
            //             IconButton(
            //               icon: Icon(
            //                 Icons.forward_10,
            //                 size: 5.h,
            //                 color: gGreyColor,
            //               ),
            //               onPressed: () {
            //                 audioPlayer.seek(
            //                   audioPlayer.position +
            //                       const Duration(seconds: 10),
            //                 );
            //               },
            //             ),
            //           ],
            //         ),
            //       ],
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}

class AudioPlayerHandler extends BaseAudioHandler {
  final AudioPlayer _player = AudioPlayer();

  AudioPlayerHandler(String url) {
    _init(url);
  }

  Future<void> _init(String url) async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    _player.playbackEventStream.listen((event) {
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.rewind,
          _player.playing ? MediaControl.pause : MediaControl.play,
          MediaControl.fastForward,
        ],
        playing: _player.playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        processingState: {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
      ));
    });
    _player.setUrl(url);
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> fastForward() => _player.seek(_player.position + const Duration(seconds: 10));

  @override
  Future<void> rewind() => _player.seek(_player.position - const Duration(seconds: 10));
}

