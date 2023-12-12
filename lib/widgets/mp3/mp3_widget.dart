import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:gwc_customer_web/widgets/widgets.dart';

import '../constants.dart';
import 'playing_controls.dart';
import 'seek_widget_position.dart';



final url = "https://96.f.1ting.com/local_to_cube_202004121813/96kmp3/2021/04/16/16b_am/01.mp3";

class Mp3Widget extends StatefulWidget {
  final String url;
  final AssetsAudioPlayer? assetAudio;
  const Mp3Widget({Key? key, required this.url, this.assetAudio}) : super(key: key);

  @override
  State<Mp3Widget> createState() => _Mp3WidgetState();
}

class _Mp3WidgetState extends State<Mp3Widget> {


  late AssetsAudioPlayer _assetsAudioPlayer;
  final List<StreamSubscription> _subscriptions = [];

  @override
  void initState() {
    super.initState();
    _assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
    openPlayer();
    _subscriptions.add(_assetsAudioPlayer.playlistAudioFinished.listen((data) {
      print('playlistAudioFinished : $data');
    }));
    _subscriptions.add(_assetsAudioPlayer.audioSessionId.listen((sessionId) {
      print('audioSessionId : $sessionId');
    }));

  }

  bool showLoading = true;
  void openPlayer() async {
    _assetsAudioPlayer.open(
      Audio.network(
        Uri.parse(widget.url).toString(),
        metas: Metas(
          id: 'Online',
          title: 'Online',
          artist: '',
          album: 'DRT',
          // image: MetasImage.network('https://www.google.com')
          image: MetasImage.asset("assets/images/meal_placeholder.png"),
        ),
      ),
      showNotification: true,
      autoStart: true,
      notificationSettings: NotificationSettings(
        stopEnabled: false,
        prevEnabled: false,
        nextEnabled: false,
      )
    ).then((value) {
      setState(()=> showLoading = false);
    });
  }

  @override
  void dispose() {
    _assetsAudioPlayer.dispose();
    print('dispose');
    super.dispose();
  }

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: (showLoading) ? Center(child: buildCircularIndicator()) : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: buildAppBar((){
                Navigator.pop(context);
              },
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                child: StreamBuilder<Playing?>(
                    stream: _assetsAudioPlayer.current,
                    builder: (context, playing) {
                      if (playing.data != null) {
                        print(playing.data!.audio.assetAudioPath);
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: playing.data!.audio.audio.metas.image?.path == null
                                ? const SizedBox()
                                : playing.data!.audio.audio.metas.image?.type ==
                                ImageType.network
                                ? Image.network(
                              playing.data!.audio.audio.metas.image?.path ?? '',
                              height: 150,
                              width: 150,
                              fit: BoxFit.contain,
                            )
                                : Image.asset(
                              playing.data!.audio.audio.metas.image?.path ?? '',
                              height: 150,
                              width: 150,
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      }
                      return SizedBox.shrink();
                    }),
              ),
            ),
            _assetsAudioPlayer.builderCurrent(
                builder: (context, Playing? playing) {
                  return Expanded(
                    flex: 1,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: gBackgroundColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 5,
                              color: kLineColor,
                              offset: Offset(2,3)
                            ),
                          ]
                        ),
                        alignment: Alignment.bottomCenter,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              _assetsAudioPlayer.builderLoopMode(
                                builder: (context, loopMode) {
                                  return PlayerBuilder.isPlaying(
                                      player: _assetsAudioPlayer,
                                      builder: (context, isPlaying) {
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            CircleButton(
                                              onPressed: (){
                                                _assetsAudioPlayer.seekBy(Duration(seconds: -10));
                                              },
                                              child: Icon(
                                                Icons.replay_10,
                                                color: Colors.white,
                                                size: 32,
                                              ),),
                                            CircleButton(
                                              onPressed: (){
                                                _assetsAudioPlayer.playOrPause();
                                              },
                                              child: Icon(
                                                isPlaying
                                                    ? Icons.pause
                                                    : Icons.play_arrow,
                                                size: 32,
                                                color: Colors.white,
                                              ),),
                                            CircleButton(
                                              onPressed: (){
                                                _assetsAudioPlayer.seekBy(Duration(seconds: 10));
                                              },
                                              child: Icon(
                                                Icons.forward_10,
                                                size: 32,
                                                color: Colors.white,
                                              ),),
                                            // IconButton(onPressed: (){
                                            //   _assetsAudioPlayer.stop();
                                            //   Navigator.pop(context);
                                            // },
                                            //   icon: Icon(
                                            //     Icons.stop,
                                            //     size: 32,
                                            //   ),)
                                          ],
                                        );
                                        return PlayingControls(
                                          loopMode: loopMode,
                                          isPlaying: isPlaying,
                                          isPlaylist: true,
                                          onStop: () {
                                            _assetsAudioPlayer.stop();
                                          },
                                          onPlay: () {
                                            _assetsAudioPlayer.playOrPause();
                                          },
                                        );
                                      });
                                },
                              ),
                              _assetsAudioPlayer.builderRealtimePlayingInfos(
                                  builder: (context, RealtimePlayingInfos? infos) {
                                    if (infos == null) {
                                      return SizedBox();
                                    }
                                    //print('infos: $infos');
                                    return Column(
                                      children: [
                                        PositionSeekWidget(
                                          currentPosition: infos.currentPosition,
                                          duration: infos.duration,
                                          seekTo: (to) {
                                            _assetsAudioPlayer.seek(to);
                                          },
                                        ),
                                      ],
                                    );
                                  }),
                            ],
                          ),
                        ),
                      )
                  );
                }),
            SizedBox(
              height: 20,
            )
            // _assetsAudioPlayer.builderCurrent(
            //     builder: (BuildContext context, Playing? playing) {
            //       return SongsSelector(
            //         audios: audios,
            //         onPlaylistSelected: (myAudios) {
            //           _assetsAudioPlayer.open(
            //             Playlist(audios: myAudios),
            //             showNotification: true,
            //             headPhoneStrategy:
            //             HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
            //             audioFocusStrategy: AudioFocusStrategy.request(
            //                 resumeAfterInterruption: true),
            //           );
            //         },
            //         onSelected: (myAudio) async {
            //           try {
            //             await _assetsAudioPlayer.open(
            //               myAudio,
            //               autoStart: true,
            //               showNotification: true,
            //               playInBackground: PlayInBackground.enabled,
            //               audioFocusStrategy: AudioFocusStrategy.request(
            //                   resumeAfterInterruption: true,
            //                   resumeOthersPlayersAfterDone: true),
            //               headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
            //               notificationSettings: NotificationSettings(
            //                 //seekBarEnabled: false,
            //                 //stopEnabled: true,
            //                 //customStopAction: (player){
            //                 //  player.stop();
            //                 //}
            //                 //prevEnabled: false,
            //                 //customNextAction: (player) {
            //                 //  print('next');
            //                 //}
            //                 //customStopIcon: AndroidResDrawable(name: 'ic_stop_custom'),
            //                 //customPauseIcon: AndroidResDrawable(name:'ic_pause_custom'),
            //                 //customPlayIcon: AndroidResDrawable(name:'ic_play_custom'),
            //               ),
            //             );
            //           } catch (e) {
            //             print(e);
            //           }
            //         },
            //         playing: playing,
            //       );
            //     }),
          ],
        ),
      ),
    );
  }
}

class CircleButton extends StatelessWidget
{
  const CircleButton(
      {
        required this.onPressed,
        required this.child,
        this.size = 35,
        this.color = Colors.red,
      });

  final void Function()? onPressed;
  final Widget child;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context)
  {
    return SizedBox(
      height: size, width: size,
      child: ClipOval(
        child: Material(
            color: color,
            child: InkWell(
                canRequestFocus: false,
                onTap: onPressed,
                child: child
            )
        ),
      ),
    );
  }
}
