import 'package:eclass/player/youtube_player_screen.dart';
import 'package:eclass/widgets/videoplayer.dart';
import 'package:eclass/widgets/vimeo_widget.dart';
import 'package:flutter/material.dart';

class ClassVideoWidget extends StatefulWidget {
  const ClassVideoWidget(this.url);
  final String url;

  @override
  _ClassVideoWidgetState createState() => _ClassVideoWidgetState();
}

class _ClassVideoWidgetState extends State<ClassVideoWidget> {
  Widget checkURLType1() {
    // String urlTest=null??'';
    String urlTest=widget.url??'';
    print("URL: ${urlTest}");
    var checkUrl = urlTest
        .split(".")
        .last;
    print('Url Type: $checkUrl');
    if (checkUrl == 'mp4') {
      print('Mp4');
      return VideoPlayerScreen(urlTest);
    }
    else if (urlTest.contains('vimeo')) {
      print('vimeo');
      try {
        return VimeoPlayer(
          autoPlay: true,
          id: '${urlTest.split('com/')[1]}',

          // autoPlay: true,
        );
      } on Exception catch (e) {
        return Container(height: 100,width: 100,color: Colors.red,);
      }
    } else if (urlTest.contains('youtube') ) {
      print('youtube');
      return YoutubePlayerDemoApp(
        url: urlTest.split("v=").last,
      );
    }
    else if ( urlTest.contains('youtu.be')) {
      print('youtube');
      return YoutubePlayerDemoApp(
        url: urlTest.split("be/").last,
      );
    } else {
      print('else');
      return VideoPlayerScreen(urlTest);
    }
  }
  @override
  Widget build(BuildContext context) {
    return checkURLType1();
  }
}
