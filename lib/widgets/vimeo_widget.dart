import 'dart:async';

import 'package:eclass/Screens/home_screen.dart';
import 'package:eclass/widgets/vimeo_src/fullscreen_player.dart';
import 'package:eclass/widgets/vimeo_src/quality_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

//Класс видео плеера
class VimeoPlayer extends StatefulWidget {
  final String id;
  final bool autoPlay;
  final bool looping;
  final int position;

  VimeoPlayer({
    @required this.id,
    this.autoPlay,
    this.looping,
    this.position,
    Key key,
  }) : super(key: key);

  @override
  _VimeoPlayerState createState() =>
      _VimeoPlayerState(id, autoPlay, looping, position);
}

class _VimeoPlayerState extends State<VimeoPlayer> {
  String _id;
  bool autoPlay = false;
  bool looping = false;
  bool _overlay = true;
  bool _replay = false;
  bool fullScreen = false;
  int position;

  _VimeoPlayerState(this._id, this.autoPlay, this.looping, this.position);

  //Custom controller
  VideoPlayerController _controller;
  Future<void> initFuture;

  //Quality Class
  QualityLinks _quality;
  Map _qualityValues;
  var _qualityValue;

  //Переменная перемотки
  bool _seek = false;

  //Переменные видео
  double videoHeight;
  double videoWidth;
  double videoMargin;

  //Переменные под зоны дабл-тапа
  double doubleTapRMargin = 36;
  double doubleTapRWidth = 400;
  double doubleTapRHeight = 160;
  double doubleTapLMargin = 10;
  double doubleTapLWidth = 400;
  double doubleTapLHeight = 160;
  bool isPublic = true;

  @override
  void initState() {
    //Create class
    _quality = QualityLinks(_id);

    //Инициализация контроллеров видео при получении данных из Vimeo
    _quality.getQualitiesSync().then((value) {
      _qualityValues = value;
      if (value != null)
        try {
          _qualityValue = value[value.lastKey()];
          setState(() {
            isPublic = true;
          });
          _controller = VideoPlayerController.network(_qualityValue);
          _controller.setLooping(looping);
          // if (autoPlay) _controller.play();
          initFuture = _controller.initialize();
          _controller.addListener(() {
            if (_controller.value.position == _controller.value.duration) {
              setReplay(true);
            } else {
              setReplay(false);
            }
          });

          //Обновление состояние приложения и перерисовка

        } on Exception catch (e) {
          print('Exception : $e');
          setState(() {
            isPublic = false;
          });
        }
      else {
        setState(() {
          isPublic = false;
        });
      }
    });
    setState(() {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    });
    //На странице видео преимущество за портретной ориентацией
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    super.initState();
  }

  setReplay(bool replayBool) {
    print('DDDDDD');
    setState(() {
      _replay = replayBool;
    });
  }

  //Отрисовываем элементы плеера
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        GestureDetector(
          child: FutureBuilder(
              future: initFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  //Управление шириной и высотой видео
                  double delta = MediaQuery.of(context).size.width -
                      MediaQuery.of(context).size.height *
                          _controller.value.aspectRatio;

                  if (MediaQuery.of(context).orientation ==
                          Orientation.portrait ||
                      delta < 0) {
                    videoHeight = MediaQuery.of(context).size.width /
                        _controller.value.aspectRatio;
                    videoWidth = MediaQuery.of(context).size.width;
                    videoMargin = 0;
                  } else {
                    videoHeight = MediaQuery.of(context).size.height;
                    videoWidth = videoHeight * _controller.value.aspectRatio;
                    videoMargin =
                        (MediaQuery.of(context).size.width - videoWidth) / 2;
                  }

                  //Начинаем с того же места, где и остановились при смене качества
                  if (_seek && _controller.value.duration.inSeconds > 2) {
                    _controller.seekTo(Duration(seconds: position));
                    _seek = false;
                  }

                  //Отрисовка элементов плеера
                  return Stack(
                    children: <Widget>[
                      Container(
                        height: videoHeight,
                        width: videoWidth,
                        margin: EdgeInsets.only(left: videoMargin),
                        child: VideoPlayer(_controller),
                      ),
                      _videoOverlay(),
                    ],
                  );
                }
                if (!isPublic) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: Center(
                      child: Center(
                        child: Text('يوجد خطأ بالفيديو او تم تحويله الى خاص',
                            style: TextStyle(color: pink)),
                      ),
                    ),
                  );
                } else {
                  return Center(
                      heightFactor: 6,
                      child: CircularProgressIndicator(
                        strokeWidth: 4,
                        valueColor: AlwaysStoppedAnimation<Color>(yellow),
                      ));
                }
              }),
          onTap: () {
            //Редактируем размер области дабл тапа при показе оверлея.
            // Сделано для открытия кнопок "Во весь экран" и "Качество"
            setState(() {
              _overlay = !_overlay;
              if (_overlay) {
                doubleTapRHeight = videoHeight - 36;
                doubleTapLHeight = videoHeight - 10;
                doubleTapRMargin = 36;
                doubleTapLMargin = 10;
              } else if (!_overlay) {
                doubleTapRHeight = videoHeight + 36;
                doubleTapLHeight = videoHeight + 16;
                doubleTapRMargin = 0;
                doubleTapLMargin = 0;
              }
            });
          },
        ),
        GestureDetector(
            //======= Перемотка назад =======//
            child: Container(
              width: doubleTapLWidth / 2 - 30,
              height: doubleTapLHeight - 100,
              margin: EdgeInsets.fromLTRB(
                  0, 10, doubleTapLWidth / 2 + 30, doubleTapLMargin + 20),
              decoration: BoxDecoration(
                  // color: Colors.red,
                  ),
            ),

            // Изменение размера блоков дабл тапа. Нужно для открытия кнопок
            // "Во весь экран" и "Качество" при включенном overlay
            onTap: () {
              setState(() {
                _overlay = !_overlay;
                if (_overlay) {
                  doubleTapRHeight = videoHeight - 36;
                  doubleTapLHeight = videoHeight - 10;
                  doubleTapRMargin = 36;
                  doubleTapLMargin = 10;
                } else if (!_overlay) {
                  doubleTapRHeight = videoHeight + 36;
                  doubleTapLHeight = videoHeight + 16;
                  doubleTapRMargin = 0;
                  doubleTapLMargin = 0;
                }
              });
            },
            onDoubleTap: () {
              setState(() {
                _controller.seekTo(Duration(
                    seconds: _controller.value.position.inSeconds - 10));
              });
            }),
        GestureDetector(
            child: Container(
              //======= Перемотка вперед =======//
              width: doubleTapRWidth / 2 - 45,
              height: doubleTapRHeight - 60,
              margin: EdgeInsets.fromLTRB(doubleTapRWidth / 2 + 45,
                  doubleTapRMargin, 0, doubleTapRMargin + 20),
              decoration: BoxDecoration(
                  // color: Colors.red,
                  ),
            ),
            // Изменение размера блоков дабл тапа. Нужно для открытия кнопок
            // "Во весь экран" и "Качество" при включенном overlay
            onTap: () {
              setState(() {
                _overlay = !_overlay;
                if (_overlay) {
                  doubleTapRHeight = videoHeight - 36;
                  doubleTapLHeight = videoHeight - 10;
                  doubleTapRMargin = 36;
                  doubleTapLMargin = 10;
                } else if (!_overlay) {
                  doubleTapRHeight = videoHeight + 36;
                  doubleTapLHeight = videoHeight + 16;
                  doubleTapRMargin = 0;
                  doubleTapLMargin = 0;
                }
              });
            },
            onDoubleTap: () {
              setState(() {
                _controller.seekTo(Duration(
                    seconds: _controller.value.position.inSeconds + 10));
              });
            }),
      ],
    ));
  }

  //================================ Quality ================================//
  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          //Формирования списка качества
          final children = <Widget>[];
          _qualityValues.forEach((elem, value) => (children.add(new ListTile(
              title: new Text(" ${elem.toString()} fps"),
              onTap: () => {
                    //Обновление состояние приложения и перерисовка
                    setState(() {
                      _controller.pause();
                      _qualityValue = value;
                      _controller =
                          VideoPlayerController.network(_qualityValue);
                      _controller.setLooping(true);
                      _seek = true;
                      initFuture = _controller.initialize();
                      _controller.play();
                    }),
                  }))));
          //Вывод элементов качество списком
          return Container(
            child: Wrap(
              children: children,
            ),
          );
        });
  }

  //================================ OVERLAY ================================//
  Widget _videoOverlay() {
    if (_overlay) {
      return Container(
        width: videoWidth,
        height: videoHeight,
        child: Stack(
          children: <Widget>[
            GestureDetector(
              child: Center(
                child: Container(
                  width: videoWidth,
                  height: videoHeight,
                  decoration: BoxDecoration(color: dark.withOpacity(0.5)),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ice.withOpacity(0.5),
                    ),
                    child: Center(
                      child: _replay
                          ? Icon(Icons.replay, size: 40.0)
                          : _controller.value.isPlaying
                              ? Icon(
                                  Icons.pause,
                                  size: 40.0,
                                  color: dark,
                                )
                              : Icon(
                                  Icons.play_arrow,
                                  size: 40.0,
                                  color: dark,
                                ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      if (_controller.value.position ==
                          _controller.value.duration) {
                        _controller.seekTo(Duration.zero);
                        _controller.play();
                      } else {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      }
                    });
                  }),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                        color: ice.withOpacity(0.5), shape: BoxShape.circle),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Icon(
                        Icons.fullscreen,
                        size: 20.0,
                        color: dark,
                      ),
                    ),
                  ),
                  onTap: () async {
                    setState(() {
                      _controller.pause();
                    });
                    //Создание новой страницы с плеером во весь экран,
                    // предача данных в плеер и возвращение позиции при
                    // возвращении обратно. Пока что мы не вернулись из
                    // фуллскрина - программа в ожидании
                    position = await Navigator.push(
                        context,
                        PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (BuildContext context, _, __) =>
                                FullscreenPlayer(
                                    id: _id,
                                    autoPlay: true,
                                    controller: _controller,
                                    position:
                                        _controller.value.position.inSeconds,
                                    initFuture: initFuture,
                                    qualityValue: _qualityValue),
                            transitionsBuilder: (___,
                                Animation<double> animation,
                                ____,
                                Widget child) {
                              return FadeTransition(
                                opacity: animation,
                                child: ScaleTransition(
                                    scale: animation, child: child),
                              );
                            }));
                    setState(() {
                      _controller.play();
                      _seek = true;
                    });
                  }),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                        color: ice.withOpacity(0.5), shape: BoxShape.circle),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Icon(
                        Icons.settings,
                        size: 20.0,
                        color: dark,
                      ),
                    ),
                  ),
                  onTap: () {
                    position = _controller.value.position.inSeconds;
                    _seek = true;
                    _settingModalBottomSheet(context);
                    setState(() {});
                  }),
            ),
            Container(
              //===== Ползунок =====//
              margin: EdgeInsets.only(
                  top: videoHeight - 26, left: videoMargin), //CHECK IT
              child: _videoOverlaySlider(),
            )
          ],
        ),
      );
    } else {
      return Directionality(
        textDirection: ltr,
        child: Center(
          child: Container(
            height: 5,
            width: videoWidth,
            margin: EdgeInsets.only(top: videoHeight - 5),
            child: VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
              colors: VideoProgressColors(
                playedColor: pink,
                backgroundColor: Colors.white,
                bufferedColor: pink.withOpacity(0.4),
              ),
              padding: EdgeInsets.only(top: 2),
            ),
          ),
        ),
      );
    }
  }

  //=================== ПОЛЗУНОК ===================//
  Widget _videoOverlaySlider() {
    return ValueListenableBuilder(
      valueListenable: _controller,
      builder: (context, VideoPlayerValue value, child) {
        if (!value.hasError && value.initialized) {
          return Row(
            textDirection: ltr,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  width: 46,
                  alignment: Alignment(0, 0),
                  child: Text(
                    _printDuration(value.position),
                    style: TextStyle(color: ice),
                  ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                flex: 3,
                child: Container(
                  height: 20,
                  child: Directionality(
                    textDirection: ltr,
                    child: VideoProgressIndicator(
                      _controller,
                      allowScrubbing: true,
                      colors: VideoProgressColors(
                        playedColor: pink,
                        backgroundColor: Colors.white,
                        bufferedColor: pink.withOpacity(0.4),
                      ),
                      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: 46,
                  alignment: Alignment(0, 0),
                  child: Text(_printDuration(value.duration),
                      style: TextStyle(color: ice)),
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    if (_controller != null) _controller.dispose();
    super.dispose();
  }
}
