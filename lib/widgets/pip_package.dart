import 'dart:developer';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/vlc_service/check_state.dart';
import '../utils/app_config.dart';

/// The main Picture-In-Picture Widget
class PIPStack extends StatefulWidget {
  /// The backgroundWidget houses the background page shown.
  /// In the context of video-playing apps this would display the list of videos.
  final Widget backgroundWidget;

  /// The pipWidget is the widget that is shrunk and displayed over the backgroundWidget.
  /// In context of video-playing apps, this would be the video player.
  /// NOTE: In the absence of a pipExpandedContent, this would fill the screen.
  final Widget pipWidget;

  /// This method is called when a pip close button is clicked.
  final VoidCallback onClosed;

  /// This method is called when a pip close button is clicked.
  final VoidCallback onPip;

  /// This bool value decides if the upper PIP layer is displayed.
  /// The value is false by default and needs to be set to true to start pip mode.
  final bool pipEnabled;

  /// This is the content below the pipWidget when the pipWidget is expanded.
  /// In context of video-playing apps, this would be video recommendations below the playing video.
  final Widget? pipExpandedContent;

  /// This is the height of the pipWidget when expanded.
  final double pipExpandedHeight;

  /// This is the width of the pipWidget when shrunk.
  final double pipShrinkWidth;

  /// This is the width of the pipWidget when shrunk.
  final double pipShrinkHeight;

  /// When the pipWidget is shrunk, shrinkAlignment decides the position of the widget.
  final Alignment shrinkAlignment;

  /// animationDuration gives the duration of the expand or shrink animation.
  final Duration animationDuration;

  /// When the pipWidget is shrunk, pipWindowPadding decides the padding around it.
  final double pipWindowPadding;

  PIPStack(
      {
        required this.backgroundWidget,
        required this.pipWidget,
        required this.onClosed,
        required this.onPip,
        required this.pipEnabled,
        this.pipExpandedContent,
        this.pipExpandedHeight = 200.0,
        this.pipShrinkWidth = 150.0,
        this.pipShrinkHeight = 100.0,
        this.shrinkAlignment = Alignment.bottomRight,
        this.animationDuration = const Duration(milliseconds: 300),
        this.pipWindowPadding = 8.0});

  @override
  _PIPStackState createState() => _PIPStackState();
}

class _PIPStackState extends State<PIPStack> with TickerProviderStateMixin {
  /// The alignment animation aligns the pipWindow from top-center to bottom-right.
  AnimationController? alignmentAnimationController;
  Animation? alignmentAnimation;

  /// The window size animation takes care of the size of the window when expanding or shrinking.
  AnimationController? pipWindowSizeController;
  Animation? pipWindowAnimation;

  var currentAlignment = Alignment.topCenter;

  var currentWindowHeight = 200.0;
  var currentWindowWidth = 200.0;

  /// Arbitrary values 250.0/200.0, will be reset in the layout builder.
  var maxWidth = 250.0;
  var maxHeight = 200.0;

  /// Stores if the pipWindow is shrunk or expanded.
  bool isInSmallMode = false;


  CheckState? _checkState;

  getInstance() async{
    _checkState = Provider.of<CheckState>(context, listen: false);
  }
  @override
  void initState() {
    getInstance();
    super.initState();

    alignmentAnimationController =
    AnimationController(vsync: this, duration: widget.animationDuration)
      ..addListener(() {
        setState(() {
          currentAlignment = alignmentAnimation!.value;
        });
      });
    alignmentAnimation =
        AlignmentTween(begin: Alignment.topCenter, end: widget.shrinkAlignment)
            .animate(CurvedAnimation(
            parent: alignmentAnimationController!,
            curve: Curves.fastOutSlowIn));

    pipWindowSizeController =
    AnimationController(vsync: this, duration: widget.animationDuration)
      ..addListener(() {
        setState(() {
          currentWindowWidth = (maxWidth * pipWindowAnimation!.value) +
              (widget.pipShrinkWidth * (1.0 - pipWindowAnimation!.value));
          currentWindowHeight = (maxHeight * pipWindowAnimation?.value) +
              (widget.pipShrinkHeight * (1.0 - pipWindowAnimation!.value));
        });
      });
    pipWindowAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(pipWindowSizeController!);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.backgroundWidget,
        LayoutBuilder(
          builder: (context, constraints) {
            maxWidth = constraints.biggest.width;

            if (widget.pipExpandedContent == null) {
              maxHeight = constraints.biggest.height;
            }

            if (!isInSmallMode) {
              currentWindowWidth = maxWidth;
              currentWindowHeight = maxHeight;
              /// this is for initial video progress display
              _checkState!.setValue(false);
            }
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                !isInSmallMode && !_checkState!.isChanged
                    ? Align(
                  alignment: currentAlignment,
                  child: GestureDetector(
                    child: SizedBox(
                      width: currentWindowWidth,
                      height: currentWindowHeight,
                      child: Stack(children: [
                        widget.pipWidget,
                        if(widget.pipEnabled) Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            child: Align(
                              child: Icon(
                                Icons.keyboard_arrow_down_outlined,
                                color: Colors.white,
                                size: 30.0,
                              ),
                              alignment: Alignment.topRight,
                            ),
                            onTap: () {
                              if(!isInSmallMode && !_checkState!.isChanged){
                                setState(() {
                                  widget.onPip();
                                  isInSmallMode = true;
                                  alignmentAnimationController?.forward();
                                  pipWindowSizeController?.forward();
                                  final _ori = MediaQuery.of(context).orientation;
                                  print(_ori.name);
                                  bool isPortrait = _ori == Orientation.portrait;
                                  if(!isPortrait){
                                    AutoOrientation.portraitUpMode();
                                  }
                                });
                                print('start --');
                                _checkState!.updateValue(isInSmallMode);
                              }
                            },
                          ),
                        ),
                      ]),
                    ),
                    // onVerticalDragEnd: (details) {
                    //   if (details.velocity.pixelsPerSecond.dy > 0) {
                    //     setState(() {
                    //       isInSmallMode = true;
                    //       alignmentAnimationController?.forward();
                    //       pipWindowSizeController?.forward();
                    //     });
                    //     print('start --');
                    //     _checkState!.updateValue(isInSmallMode);
                    //   } else if (details.velocity.pixelsPerSecond.dy <
                    //       0) {
                    //     setState(() {
                    //       alignmentAnimationController?.reverse();
                    //       pipWindowSizeController?.reverse().then((value) {
                    //         setState(() {
                    //           isInSmallMode = false;
                    //         });
                    //       });
                    //       _checkState!.updateValue(false);
                    //       print('start ++');
                    //     });
                    //   }
                    // },
                  ),
                )
                    : Expanded(
                  child: Align(
                    alignment: currentAlignment,
                    child: Padding(
                      padding: EdgeInsets.all(widget.pipWindowPadding),
                      child: GestureDetector(
                        child: SizedBox(
                          width: currentWindowWidth,
                          height: currentWindowHeight,
                          child: Stack(children: [
                            widget.pipWidget,
                            GestureDetector(
                              child: Align(
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 30.0,
                                ),
                                alignment: Alignment.topRight,
                              ),
                              onTap: () {
                                widget.onClosed();
                                isInSmallMode = false;
                                alignmentAnimationController?.reverse();
                                pipWindowSizeController?.reverse();
                              },
                            ),
                          ]),
                        ),
                        onVerticalDragEnd: (details) {
                          if (details.velocity.pixelsPerSecond.dy > 0) {
                            setState(() {
                              isInSmallMode = true;
                              alignmentAnimationController?.forward();
                              pipWindowSizeController?.forward();
                            });
                            _checkState!.updateValue(true);
                            print('start ==');

                          }
                          else if (details.velocity.pixelsPerSecond.dy < 0) {
                            setState(() {
                              alignmentAnimationController?.reverse();
                              pipWindowSizeController
                                  ?.reverse()
                                  .then((value) {
                                setState(() {
                                  isInSmallMode = false;
                                });
                              });
                            });
                            _checkState!.updateValue(false);
                            print('start ==>');

                          }
                        },
                      ),
                    ),
                  ),
                ),
                widget.pipEnabled
                    ? widget.pipExpandedContent != null
                    ? isInSmallMode
                    ? Container()
                    : Expanded(child: widget.pipExpandedContent ?? SizedBox())
                    : Container()
                    : Container(),
              ],
            );
          },
        ),
      ],
    );
  }
}
