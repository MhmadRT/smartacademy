import 'dart:convert';
import 'package:eclass/Screens/home_screen.dart' as di;
import 'package:eclass/Screens/more_screen.dart';
import 'package:eclass/common/apidata.dart';
import 'package:eclass/common/global.dart';
import 'package:eclass/model/course_with_progress.dart';
import 'package:eclass/model/recieved_progress.dart';
import 'package:eclass/player/clips.dart';
import 'package:eclass/provider/courses_provider.dart';
import 'package:eclass/provider/full_course_detail.dart';
import 'package:eclass/widgets/class_video_eidget.dart';
import 'package:eclass/widgets/pdf_view.dart';
import 'package:eclass/widgets/swiper_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

class PlayListScreen extends StatefulWidget {
  PlayListScreen(
      {Key key,
      this.clips,
      this.sections,
      this.markedSec,
      this.defaultIndex,
      this.courseDetails})
      : super(key: key);

  final List<Section> sections;
  final List<VideoClip> clips;
  final List<String> markedSec;
  final int defaultIndex;
  final FullCourse courseDetails;

  @override
  _PlayListScreenState createState() => _PlayListScreenState();
}

class _PlayListScreenState extends State<PlayListScreen>
    with TickerProviderStateMixin {
  bool showBottomNavigation = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Future<RecievedProgress> updateProgress(List<String> checked) async {
    String url = "${APIData.updateProgress}${APIData.secretKey}";
    Response res = await post(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    }, body: {
      "course_id": widget.sections[0].sectionDetails.courseId,
      "checked": checked.toString()
    });

    if (res.statusCode == 200) {
      return RecievedProgress.fromJson(jsonDecode(res.body));
    } else {
      return null;
    }
  }

  Future<bool> updateProgressBool(List<String> checked) async {
    String url = "${APIData.updateProgress}${APIData.secretKey}";
    Response res = await post(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    }, body: {
      "course_id": widget.sections[0].sectionDetails.courseId,
      "checked": getStringFromList(checked)
    });
    return res.statusCode == 200;
  }

  String getStringFromList(List<String> checked) {
    String res = "[";
    for (int i = 0; i < checked.length; i++) {
      res += "\"${checked[i]}\"";
      if (i != checked.length - 1) {
        res += ",";
      }
    }
    res += "]";
    return res;
  }

  @override
  void initState() {
    super.initState();
    if (widget.sections.length > 0) {
      if (widget.sections.first.sectionLessons.length > 0) {
        videoPlayerWidget =
            ClassVideoWidget(widget.sections[0].sectionLessons.first.parent);
        emptyClass = false;
        superIndex = 0;
        subIndex = 0;
      } else {
        emptyClass = true;
      }
    } else {
      emptyClass = true;
    }
  }

  Color ice = Color(0xffF3F5F8);

  // Color yellow = Color(0xffFDBF2F);
  Color dark = Color(0xFF3F4654);
  Color pink = Color(0xffF84B63);
  Widget videoPlayerWidget = Container(
    height: 200,
    width: double.infinity,
    color: di.pink.withOpacity(0.05),
    child: Icon(
      Icons.play_circle_fill,
      size: 90,
      color: di.pink,
    ),
  );
  var _isFullScreen = false;
  bool isLoadingMark = false;
  List<String> selectedSecs = [];
  bool showMoreScreen = false;
  bool emptyClass = true;
  String videoUrl = '';
  int superIndex;
  int subIndex;
  bool darkMode = true;

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    bool firstTime = Provider.of<CoursesProvider>(context, listen: false)
        .checkPurchaedProgressStatus(
            widget.sections[0].sectionDetails.courseId);

    print(widget.sections[0].sectionLessons[0].fileName);
    Progress allProgress = Provider.of<CoursesProvider>(context, listen: false)
        .getAllProgress(widget.courseDetails.course.id);
    selectedSecs = allProgress.markChapterId;
    return Directionality(
      textDirection: di.rtl,
      child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
          floatingActionButton: _isFullScreen
              ? SizedBox.shrink()
              : showBottomNavigation
                  ? FloatingActionButton.extended(
                      backgroundColor: pink,
                      onPressed: () async {
                        setState(() {
                          isLoadingMark = true;
                        });
                        List<String> fChecked = [...selectedSecs];
                        RecievedProgress x;
                        bool res = false;
                        if (firstTime)
                          x = await updateProgress(fChecked);
                        else
                          res = await updateProgressBool(fChecked);

                        if (x != null || res) {
                          Provider.of<CoursesProvider>(context, listen: false)
                              .setProgress(
                                  int.parse(widget
                                      .sections[0].sectionDetails.courseId),
                                  fChecked,
                                  x);
                          _scaffoldKey.currentState.showSnackBar(
                              SnackBar(content: Text("تم التعين")));
                        } else {
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text("حدث مشكلة"),
                            ),
                          );
                        }
                        setState(() {
                          isLoadingMark = false;
                          showBottomNavigation = false;
                        });
                      },
                      label: Text(
                        "وضع علامة مكتمل",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )
                  : SizedBox.shrink(),
          key: _scaffoldKey,
          backgroundColor: dark,
          appBar: AppBar(
            actions: [
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      darkMode = !darkMode;
                      if (!darkMode) {
                        dark = di.ice;
                        ice = di.dark;
                      } else {
                        dark = di.dark;
                        ice = di.ice;
                      }
                    });
                  },
                  child: Container(
                    child: Icon(
                        !darkMode ? Icons.lightbulb_outline : Icons.lightbulb),
                  )),
              SizedBox(
                width: 10,
              ),
            ],
            backgroundColor: dark,
            elevation: 0.0,
            iconTheme: IconThemeData(color: ice.withOpacity(1)),
            centerTitle: true,
            title: Text(
              "قائمة الدورات",
              style: TextStyle(color: ice.withOpacity(1)),
            ),
          ),
          body: GestureDetector(
            onTap: () {
              setState(() {
                showMoreScreen = false;
              });
            },
            child: Stack(
              children: [
                Column(
                  children: [
                    AnimatedSwitcher(
                        switchInCurve: Curves.easeInBack,
                        duration: Duration(milliseconds: 400),
                        child: videoPlayerWidget),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              ListView.builder(
                                itemCount: widget.sections.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return ExpansionTile(
                                    childrenPadding: EdgeInsets.all(20),
                                    leading: GestureDetector(
                                        onTap: () async {
                                          setState(() {
                                            if (!selectedSecs.contains(widget
                                                .sections[index]
                                                .sectionDetails
                                                .id
                                                .toString())) {
                                              selectedSecs.add(widget
                                                  .sections[index]
                                                  .sectionDetails
                                                  .id
                                                  .toString());
                                              if (selectedSecs.length == 1 ||
                                                  selectedSecs.length > 0) {
                                                setState(() {
                                                  showBottomNavigation = true;
                                                });
                                              }
                                            } else {
                                              selectedSecs.remove(widget
                                                  .sections[index]
                                                  .sectionDetails
                                                  .id
                                                  .toString());
                                              if (selectedSecs.length > 0) {
                                                setState(() {
                                                  showBottomNavigation = true;
                                                });
                                              }
                                              if (selectedSecs.length == 0) {
                                                setState(() {
                                                  showBottomNavigation = false;
                                                });
                                              }
                                            }
                                          });
                                        },
                                        child: allProgress == null
                                            ? Container(
                                                width: 15,
                                                height: 15,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 0.5,
                                                ))
                                            : selectedSecs.contains(widget
                                                    .sections[index]
                                                    .sectionDetails
                                                    .id
                                                    .toString())
                                                ? Container(
                                                    height: 20,
                                                    width: 20,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: pink),
                                                        shape: BoxShape.circle),
                                                    child: Icon(
                                                      Icons.check,
                                                      size: 15.0,
                                                      color: pink,
                                                    ),
                                                  )
                                                : Container(
                                                    height: 20,
                                                    width: 20,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: pink),
                                                        shape: BoxShape.circle),
                                                  )),
                                    title: Text(
                                      widget.sections[index].sectionDetails
                                          .chapterName,
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: ice.withOpacity(1),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    trailing: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: ice.withOpacity(0.7),
                                    ),
                                    children: [
                                      ListView.builder(
                                        itemCount: widget.sections[index]
                                            .sectionLessons.length,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, i) {
                                          print(widget.sections[index]
                                              .sectionLessons[i].parent);
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (i > 0) Divider(),
                                              Text(
                                                "${i + 1} - " +
                                                    widget
                                                        .sections[index]
                                                        .sectionLessons[i]
                                                        .title,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: ice.withOpacity(1),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              if (widget.sections[index]
                                                  .sectionLessons[i].file
                                                  .contains('pdf'))
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => PDFView(
                                                                APIData.filesLink +
                                                                    widget
                                                                        .sections[
                                                                            index]
                                                                        .sectionLessons[
                                                                            i]
                                                                        .file,
                                                                '${widget.sections[index].sectionLessons[i].title}')));
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 15.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'ملفات الدرس رقم ${i + 1} ',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                ice.withOpacity(
                                                                    0.7),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Image.asset(
                                                          'assets/images/pdf.png',
                                                          height: 22,
                                                          color: ice
                                                              .withOpacity(0.7),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              GestureDetector(
                                                onTap: () async {
                                                  setState(() {
                                                    superIndex = index;
                                                    subIndex = i;
                                                    videoPlayerWidget =
                                                        Container(
                                                      height: 200,
                                                      child: Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                    );
                                                  });
                                                  await Future.delayed(
                                                          Duration(seconds: 2))
                                                      .then((value) {
                                                    setState(() {
                                                      videoPlayerWidget =
                                                          ClassVideoWidget(
                                                        // 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'
                                                        '${widget.sections[index].sectionLessons[i].parent}',
                                                      );
                                                    });
                                                  });
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 15.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        ' القسم رقم ${index + 1} المحاضرة رقم ${i + 1} ',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: ice
                                                              .withOpacity(0.7),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Icon(
                                                        Icons.play_circle_fill,
                                                        color: superIndex ==
                                                                    index &&
                                                                subIndex == i
                                                            ? pink
                                                            : ice.withOpacity(
                                                                0.7),
                                                        size: 22,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              )
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ),
                              SizedBox(
                                height: 150,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                AnimatedPositioned(
                  duration: Duration(milliseconds: 300),
                  bottom: showMoreScreen ? -200 : -500,
                  child: MoreScreen(widget.courseDetails, ice.withOpacity(0.1)),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          showMoreScreen = !showMoreScreen;
                        });
                      },
                      child: Container(
                        width: 300,
                        color: Colors.transparent,
                        child: showMoreScreen
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 15.0),
                                    child: Icon(
                                      Icons.clear,
                                      color: ice,
                                    ),
                                  ),
                                  Text(
                                    'اغلق',
                                    style: TextStyle(color: ice),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  )
                                ],
                              )
                            : Container(child: SwiperButton(ice)),
                      )),
                ),
              ],
            ),
          )),
    );
  }
}
