import 'dart:async';

import 'package:eclass/Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String url;

  VideoPlayerScreen(this.url);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller;
  var player;
  bool show = true;
  bool isInitial = false;

  void initializePlayer(String url) {
    _controller = VideoPlayerController.network(
      widget.url,
    );
    setState(() {
      isInitial = true;
    });
    _controller.initialize().catchError((error) {
      // print(error);
      setState(() {
        isInitial = false;
      });
    });
    setState(() {});
  }
  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
        _controller.pause();
        break;
      case AppLifecycleState.resumed:
        _controller.pause();
        break;
      case AppLifecycleState.paused:
        _controller.pause();
        break;
      case AppLifecycleState.detached:
        _controller.dispose();
        break;
    }
  }

  @override
  void initState() {
    initializePlayer(widget.url);
    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller?.dispose();

    super.dispose();
  }

  Widget playView() {
    if (isInitial)
      return ValueListenableBuilder(
          valueListenable: _controller,
          builder: (context, VideoPlayerValue value, child) {
            //Do Something with the value.
            if (value.initialized) if (value.position.inSeconds >=
                value.duration.inSeconds) {
              _controller.seekTo(Duration(seconds: 0));
              _controller.play();
            }
            return value.initialized
                ? Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          show = !show;
                          setState(() {});
                        },
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(
                            _controller,
                          ),
                        ),
                      ),
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 300),
                        bottom: show ? 10 : -180,
                        left: 10,
                        right: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _controller.seekTo(Duration(
                                            seconds:
                                                value.position.inSeconds - 5));
                                      });
                                    },
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: 47.0,
                                        height: 47.0,
                                        //alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(32.0),
                                            color: Theme.of(context).hintColor),
                                        child: Icon(
                                          Icons.skip_next,
                                          color: Colors.white,
                                          size: 20.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        {
                                          if (_controller.value.isPlaying) {
                                            _controller.pause();
                                          } else {
                                            _controller.play();
                                          }
                                        }
                                      });
                                    },
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                          width: 70.0,
                                          height: 70.0,
                                          //alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                Theme.of(context).accentColor,
                                          ),
                                          child: _controller.value.isPlaying
                                              ? Icon(
                                                  Icons.pause,
                                                  color: Colors.white,
                                                  size: 30.0,
                                                )
                                              : Icon(
                                                  Icons.play_arrow,
                                                  color: Colors.white,
                                                  size: 30.0,
                                                )),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      int x = value.duration.inSeconds -
                                          value.position.inSeconds;
                                      if (value.position.inSeconds <
                                              value.duration.inSeconds &&
                                          x > 5) {
                                        setState(() {
                                          _controller.seekTo(Duration(
                                              seconds:
                                                  value.position.inSeconds +
                                                      5));
                                        });
                                      } else if (x < 5) {
                                        setState(() {
                                          _controller.seekTo(Duration(
                                              seconds:
                                                  value.position.inSeconds +
                                                      x));
                                        });
                                      }
                                    },
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: 47.0,
                                        height: 47.0,
                                        //alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(32.0),
                                            color: Theme.of(context).hintColor),
                                        child: Icon(
                                          Icons.skip_previous,
                                          color: Colors.white,
                                          size: 20.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Slider(
                                activeColor: Theme.of(context).accentColor,
                                inactiveColor: Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.6),
                                label:_printDuration(value.position),
                                divisions: value.duration.inMilliseconds,
                                value: double.parse(
                                    value.position.inMilliseconds.toString()),
                                onChanged: (v) {
                                  _controller.seekTo(
                                      Duration(milliseconds: v.toInt()));
                                },
                                max: double.parse(
                                    value.duration.inMilliseconds.toString()),
                                min: 0.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : value.hasError
                    ? Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(
                            'صيغة الفيديو غير مدعومة',
                            style: TextStyle(color: pink),
                          ),
                        ),
                      )
                    : CircularProgressIndicator();
          });
    else
      return Container(
        height: 100,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Text(
            'صيغة الفيديو غير مدعومة',
            style: TextStyle(color: pink),
          ),
        ),
      );
  }

  Color val = Color(0xff0083A4);

  @override
  Widget build(BuildContext context) {
    return playView();
  }
}

/*
onPressed: () {
                  // Wrap the play or pause in a call to `setState`. This ensures the
                  // correct icon is shown.
                  setState(() {
                    // If the video is playing, pause it.
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                    } else {
                      // If the video is paused, play it.
                      _controller.play();
                    }
                  });
                }, */
