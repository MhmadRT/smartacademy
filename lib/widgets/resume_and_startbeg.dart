import 'dart:convert';
import 'dart:io';

import 'package:eclass/Screens/home_screen.dart';
import 'package:eclass/player/playlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../Screens/no_videos_screen.dart';
import '../Widgets/triangle.dart';
import '../common/apidata.dart';
import '../common/global.dart';
import '../model/course_with_progress.dart';
import '../player/clips.dart';
import '../provider/courses_provider.dart';
import '../provider/full_course_detail.dart';

class ResumeAndStart extends StatefulWidget {
  final FullCourse details;
  final List<String> progress;

  ResumeAndStart(this.details, this.progress);

  @override
  _ResumeAndStartState createState() => _ResumeAndStartState();
}

class _ResumeAndStartState extends State<ResumeAndStart> {
  bool isloading = false;

  Future<bool> resetProgress() async {
    String url = "${APIData.updateProgress}${APIData.secretKey}";
    http.Response res = await http.post(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    }, body: {
      "course_id": widget.details.course.id.toString(),
      "checked": "[]"
    });
    if (res.statusCode == 200) {
      return true;
    } else {
      // throw "unable to fetch";
      return false;
    }
  }

  Future<List<String>> getProgress(int id) async {
    String url = "${APIData.courseProgress}${APIData.secretKey}";
    http.Response res = await http.post(url, headers: {
      "Accept": "application/json",
      HttpHeaders.authorizationHeader: "Bearer $authToken",
    }, body: {
      "course_id": id.toString()
    });
    if (res.statusCode == 200) {
      var body = jsonDecode(res.body)["progress"];
      if (body == null) return [];
      Progress pro = Progress.fromJson(body);
      return pro.markChapterId;
    } else {
      return [];
    }
  }

  List<VideoClip> _allClips = [];

  List<VideoClip> getClips(List<CourseClass> allLessons) {
    List<VideoClip> clips = [];
    allLessons.forEach((element) {
      if (element.type == "video") {
        if (element.url != null) {
          clips.add(VideoClip(element.title, "lecture",
              "images/ForBiggerFun.jpg", 100, element.url, element.id,element.file??''));
        } else {
          if (element.iframeUrl != null) {
            clips.add(VideoClip(element.title, "lecture",
                "images/ForBiggerFun.jpg", 100, element.iframeUrl, element.id,element.file??''));
          } else {
            clips.add(VideoClip(
                element.title,
                "lecture",
                "images/ForBiggerFun.jpg",
                100,
                APIData.videoLink + element.video,
                element.id,element.file??''));
          }
        }
      }
    });
    return clips;
  }

  List<VideoClip> getLessons(Chapter chap, List<CourseClass> allLessons) {
    List<CourseClass> less = [];
    allLessons.forEach((element) {
      if (chap.id.toString() == element.coursechapterId &&
          element.url != null) {
        less.add(element);
      } else if (chap.id.toString() == element.coursechapterId &&
          element.video != null) {
        less.add(element);
      } else if (chap.id.toString() == element.coursechapterId &&
          element.iframeUrl != null) {
        less.add(element);
      }
    });
    if (less.length == 0) return [];
    return getClips(less);
  }

  int findIndToResume(List<Section> sections, List<String> markedSecs) {
    int idx = 0;
    for (int i = 0; i < sections.length; i++) {
      if (markedSecs.contains(sections[i].sectionDetails.id.toString())) {
        idx += sections[i].sectionLessons.length;
      } else {
        break;
      }
    }
    return idx;
  }

  List<Section> generateSections(
      List<Chapter> sections, List<CourseClass> allLessons) {
    List<Section> sectionList = [];

    sections.forEach((element) {
      List<VideoClip> lessons = getLessons(element, allLessons);
      if (lessons.length > 0) {
        sectionList.add(Section(element, lessons));
        _allClips.addAll(lessons);
      }
    });
    if (sectionList.length == 0) return [];
    return sectionList;
  }

  bool strtBeginLoad = false;

  @override
  Widget build(BuildContext context) {
    bool canUseProgress = true;
    if (widget.progress == null) {
      canUseProgress = false;
    }
    _allClips.clear();
    CoursesProvider courses = Provider.of<CoursesProvider>(context);
    List<Section> sections = generateSections(
        widget.details.course.chapter, widget.details.course.courseclass);
    return Container(
      child: Column(
        children: [
          CustomPaint(
            painter: TrianglePainter(
              strokeColor: Colors.white,
              strokeWidth: 4,
              paintingStyle: PaintingStyle.fill,
            ),
            child: Container(
              height: 20,
              //width: 20,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(1000.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Material(
                  borderRadius: BorderRadius.circular(1000),
                  color: pink,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(1000),
                    onTap: () {

                      List<String> marksSecs =
                          widget.progress == null ? [] : widget.progress;
                      int defaultIdx = findIndToResume(sections, marksSecs);
                      defaultIdx = defaultIdx > _allClips.length - 1 ? 0 : defaultIdx;
//                    Resume course or start course
                      if ((_allClips != null && _allClips.length > 0)) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PlayListScreen(
                                  markedSec: marksSecs,
                                  clips: _allClips,
                                  sections: sections,
                                  defaultIndex: defaultIdx,
                                  courseDetails: widget.details,
                                )));
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EmptyVideosPage()));
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          border:
                              Border.all(width: 1.0, color: Colors.transparent),
                          borderRadius: BorderRadius.circular(1000.0)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5),
                        child: Row(
                          children: [
                            Text(
                              canUseProgress
                                  ? widget.progress.length > 0
                                      ? "متابعة"
                                      : "أبدأ الدورة"
                                  : "أبدأ الدورة",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            RotatedBox(
                                quarterTurns: 2,
                                child: Icon(
                                  Icons.play_circle_fill,
                                  color: Colors.white,
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Material(
                  borderRadius: BorderRadius.circular(1000),
                  color: Colors.white,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(1000),
                    onTap: () async {
                      List<String> marksSecs = [];
                      setState(() {
                        strtBeginLoad = true;
                      });
                      bool x = await resetProgress();
                      setState(() {
                        strtBeginLoad = false;
                      });

                      if (x)
                        courses.setProgress(widget.details.course.id, [], null);
                      if (_allClips != null && _allClips.length > 0) {

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PlayListScreen(
                                  markedSec: marksSecs,
                                  clips: _allClips,
                                  sections: sections,
                              courseDetails: widget.details,
                                  defaultIndex: 0,
                                )));
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EmptyVideosPage()));
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        // color: Colors.white,
                        border: Border.all(width: 1.0, color: dark),
                        borderRadius: BorderRadius.circular(1000.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5),
                        child: Row(
                          children: [
                            Center(
                              child: strtBeginLoad
                                  ? CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.black),
                                    )
                                  : Text(
                                      "العودة الى البداية",
                                      style: TextStyle(
                                        color: dark,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.redo,
                              color: dark,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
