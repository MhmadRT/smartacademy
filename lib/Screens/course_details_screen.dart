import 'dart:convert';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eclass/Screens/home_screen.dart';
import 'package:eclass/Widgets/comment_card.dart';
import 'package:eclass/provider/recent_course_provider.dart';
import 'package:eclass/widgets/class_video_eidget.dart';
import 'package:eclass/widgets/course_image_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Widgets/add_and_buy.dart';
import '../Widgets/course_detail_menu.dart';
import '../Widgets/html_text.dart';
import '../Widgets/instructorwidget.dart';
import '../Widgets/rating_star.dart';
import '../Widgets/resume_and_startbeg.dart';
import '../Widgets/utils.dart';
import '../common/apidata.dart';
import '../common/theme.dart' as T;
import '../model/course.dart';
import '../model/course_with_progress.dart';
import '../model/include.dart';
import '../model/instructor_model.dart';
import '../provider/courses_provider.dart';
import '../provider/full_course_detail.dart';
import '../provider/home_data_provider.dart';
import '../provider/wish_list_provider.dart';
import '../services/http_services.dart';

// ignore: must_be_immutable
class CourseDetailScreen extends StatefulWidget {
  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen>
    with TickerProviderStateMixin {
  int tabIndex = 0;
  var gUrl;
  double textSize = 15.0;
  double textSizeCol = 15.0;
  Color txtcolor;
  String playURL = '';
  String urlType = '';
  int reviewLength = 2;
  double videoValue = 0;

  Widget include(Include inc) {
    return Container(
      margin: EdgeInsets.fromLTRB(18, 10, 0, 10),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Image.asset(
              "assets/icons/requirements.png",
              width: 15.0,
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.17,
            child: Text(
              inc.detail,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: txtcolor, fontSize: 16.0),
            ),
          )
        ],
      ),
    );
  }

  Widget courseIncludes(List<Include> whatIncludes) {
    return Container(
      child: Column(
        children: whatIncludes.map((e) => include(e)).toList(),
      ),
    );
  }

  Widget overview(String overview, Color txtcolor, List<Include> whatIncludes) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headingTitle("Course Includes", txtcolor, 20),
          courseIncludes(whatIncludes),
          headingTitle("Description", txtcolor, 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: html(overview, txtcolor, 16),
          ),
        ],
      ),
    );
  }

  Future<FullCourse> getCourseDetails(int id) async {
    String url = "${APIData.courseDetail}${APIData.secretKey}";
    print(url + "{course_id:$id}");
    Response res = await post(url, body: {"course_id": id.toString()});
    FullCourse courseDetails;
    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      courseDetails = FullCourse.fromJson(body);
      // print('awsType : ${courseDetails.course.type}');
      // log('awsType ${res.body}');
    } else {
      throw "err";
    }
    return courseDetails;
  }

  var matchIFrameUrl;
  var detail;
  var betterPlayerConfiguration;

  int checkDatatype(dynamic x) {
    if (x is int)
      return 0;
    else
      return 1;
  }

  String getRating(List<Review> data) {
    double ans = 0.0;
    bool calcAsInt = true;
    if (data.length > 0)
      calcAsInt = checkDatatype(data[0].learn) == 0 ? true : false;

    data.forEach((element) {
      if (!calcAsInt)
        ans += (int.parse(element.price) +
                    int.parse(element.value) +
                    int.parse(element.learn))
                .toDouble() /
            3.0;
      else {
        ans += (element.price + element.value + element.learn) / 3.0;
      }
    });
    if (ans == 0.0) return 0.toString();
    return (ans / data.length).toStringAsPrecision(2);
  }

  Widget fun(String a, String b) {
    return Row(
      children: [
        Text(
          a + " : ",
          style: TextStyle(color: Colors.grey, fontSize: textSize),
        ),
        Text(
          b,
          style: TextStyle(fontSize: textSize),
        )
      ],
    );
  }

  Widget funcol(String a, String b) {
    return Column(
      children: [
        Text(
          a,
          style: TextStyle(color: Colors.grey, fontSize: textSizeCol),
        ),
        Container(
          alignment: Alignment.topCenter,
          width: 90.0,
          child: Text(
            b,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: textSizeCol,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }

  String youId = '';

  fetchURLType(String url) {
    try {
      var checkUrl = url.split(".").last;
      if (url.contains('zoom.us')) {
        urlType = 'ZOOM';
        playURL = url;
      } else if (url.substring(0, 18) == "https://vimeo.com/") {
        urlType = "VIMEO";
        playURL = url;
      } else if (url.substring(0, 23) == 'https://www.youtube.com') {
        youId = url.split("v=").last;
        urlType = "YOUTUBE";
      } else if (url.substring(0, 24) == 'https://drive.google.com') {
        urlType = "CUSTOM";
        // For playing google drive videos
        matchIFrameUrl = url.substring(0, 24);
        if (matchIFrameUrl == 'https://drive.google.com') {
          var ind = url.lastIndexOf('d/');
          var t = "$url".trim().substring(ind + 2);
          var rep = t.replaceAll('/preview', '');
          gUrl =
              "https://www.googleapis.com/drive/v3/files/$rep?alt=media&key=${APIData.googleDriveApi}";
        }
      } else if (checkUrl == "mp4" ||
          checkUrl == "mpd" ||
          checkUrl == "webm" ||
          checkUrl == "mkv" ||
          checkUrl == "m3u8" ||
          checkUrl == "ogg" ||
          checkUrl == "wav") {
        urlType = "CUSTOM";
      }
      print(urlType);
    } catch (e) {
      print(e);
    }
  }

  Future<Instructor> getinstdata(dynamic id) async {
    Instructor insdetail;
    String url = "${APIData.instructorProfile}${APIData.secretKey}";
    Response res = await post(url, body: {"instructor_id": "$id"});
    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      insdetail = Instructor.fromJson(body);
    } else {
      throw "${res.statusCode}err";
    }

    return insdetail;
  }

  var getinstdetails;

  void didChangeDependencies() {
    DataSend apiData = ModalRoute.of(context).settings.arguments;
    detail = getCourseDetails(apiData.id);
    getinstdetails = getinstdata(apiData.userId);
    super.didChangeDependencies();
  }

  Route _menuRoute(
      int id, bool isPurchased, FullCourse details, List<String> pro) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          CourseDetailMenuScreen(isPurchased, details, pro),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  int getLength(List<Review> revs) {
    if (revs == null)
      return 0;
    else
      return revs.length;
  }

  Widget purchasedCourseDetails(FullCourse details, double progress) {
    return Container(
      height: MediaQuery.of(context).size.height /
          (MediaQuery.of(context).orientation == Orientation.landscape
              ? 1
              : 2.15),
      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 15.0),
      margin: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0),
            child: Text(
              details.course.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                  color: Color(0xff404455)),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StarRating(
                rating: details.review == null
                    ? 0.0
                    : double.parse(getRating(details.review)),
                size: 15.0,
                color: Color(0xff0284a2),
              ),
              SizedBox(
                height: 4.0,
              ),
              Text(
                details.review == null
                    ? "0 Rating and 0 Review"
                    : "${getRating(details.review)} Rating and ${getLength(details.review)} Review",
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          cusprogressbar(MediaQuery.of(context).size.width / 1.38, progress),
          SizedBox(
            height: 10.0,
          ),
          Text(
            details.course.shortDetail,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: txtcolor, fontSize: 16),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            height: 75.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: fun(
                        "Course By",
                        "${details.course.user.fname}" +
                            " " +
                            "${details.course.user.lname}")),
                Expanded(
                    child: fun("Last Updated",
                        DateFormat.yMMMd().format(details.course.createdAt))),
                Expanded(
                    child: fun(
                        "Language",
                        details.course.language == null
                            ? "N/A"
                            : "${details.course.language.name}")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String tMonth(String x) {
    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sept",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[int.parse(x) - 1];
  }

  String convertDate(String x) {
    String ans = x.substring(0, 4);
    ans = x.substring(8, 10) + " " + tMonth(x.substring(5, 7)) + " " + ans;
    return ans;
  }

  Widget unPurchasedCourseDetails(FullCourse details, String currency) {
    return Container(
      height: MediaQuery.of(context).size.height /
          (MediaQuery.of(context).orientation == Orientation.landscape
              ? 1
              : 2.0),
      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 15.0),
      margin: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18.0),
          child: Text(
            details.course.title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
                color: Color(0xff404455)),
          ),
        ),

        // ignore: unrelated_type_equality_checks
        if (details.course.type == "1")
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("$currency ${details.course.discountPrice}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0,
                      color: Color(0xff404455))),
              SizedBox(
                width: 10.0,
              ),
              Text(
                "$currency ${details.course.price}",
                style: TextStyle(
                    color: Color(0xff943f4654),
                    fontSize: 16.0,
                    decoration: TextDecoration.lineThrough),
              )
            ],
          )
        else
          Text("Free",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 22.0,
                  color: Colors.red)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            details.course.shortDetail,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 4.0,
        ),
        Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(child: funcol("Course By", details.course.user.fname)),
              Expanded(
                  child: funcol("Last Updated",
                      DateFormat.yMMMd().format(details.course.createdAt))),
              Expanded(
                  child: funcol(
                      "Language",
                      details.course.language == null
                          ? "N/A"
                          : details.course.language.name)),
            ],
          ),
        ),
        Container(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                  child: func(0, "Students", 1, "assets/icons/studentsicon.png",
                      Color(0xff3f4654), 0)),
              Expanded(
                  child: func(
                      details.review == null ? "0" : getRating(details.review),
                      "Rating",
                      2,
                      "assets/icons/star_icon.png",
                      Color(0xff3f4654),
                      0)),
              Expanded(
                child: func(
                  details.course.courseclass.length.toDouble(),
                  "Lecture",
                  4,
                  "assets/icons/lecturesicon.png",
                  Color(0xff3f4654),
                  0,
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }

  SliverAppBar appB(String category, FullCourse details,
      List<String> markedChpIds, bool isPur) {
    return SliverAppBar(
      elevation: 0,
      backgroundColor: Color(0xff29303b),
      centerTitle: true,
      title: Text(
        "$category",
        style: TextStyle(fontSize: 16.0),
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.arrow_back_ios),
        iconSize: 18.0,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                _menuRoute(details.course.id, isPur, details, markedChpIds),
              );
            },
            child: Image.asset("assets/icons/coursedetailmenu.png", width: 17),
          ),
        ),
      ],
    );
  }

  Widget tabBar() {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(15.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                tabIndex = 0;
              });
            },
            child: Container(
                width: MediaQuery.of(context).size.width / 2 - 12,
                height: 50.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.0),
                        topLeft: Radius.circular(15.0))),
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "LESSON",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: tabIndex == 0
                            ? Color(0xfff44a4a)
                            : Colors.grey[600],
                      ),
                    ))),
          ),
          InkWell(
            onTap: () {
              setState(() {
                tabIndex = 1;
              });
            },
            child: Container(
                width: MediaQuery.of(context).size.width / 2 - 12,
                height: 50.0,
                decoration: BoxDecoration(
                    border: Border(left: BorderSide(color: Colors.grey[300]))),
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "OVERVIEW",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: tabIndex == 1
                              ? Color(0xfff44a4a)
                              : Colors.grey[600]),
                    ))),
          ),
        ],
      ),
    );
  }

  Widget scaffoldBody(
      String category,
      List<String> markedChpIds,
      bool purchased,
      String type,
      String currency,
      double progress,
      List<Course> relatedCourses,
      WishListProvider wish) {
    var recentCoursesList =
        Provider.of<RecentCourseProvider>(context).recentCourseList;
    return FutureBuilder(
      future: detail,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          FullCourse details = snapshot.data;
          print(details.course.type);
          print('PREVIEW url');
          if (details.course.url != null) fetchURLType(details.course.url);
          bool isFree = '${details.course.type}' == '${0.toString()}';
          print(isFree);
          if (details.course?.price == null || details.course?.price == '0')
            isFree = true;
          print(details.course.url ?? "");
          List<Widget> whatLearn = [];
          details.course.whatlearns.forEach((element) {
            whatLearn.add(Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: dark.withOpacity(0.3))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: Text(
                    '${element.detail}',
                    style: TextStyle(color: dark, fontSize: 12),
                  ),
                ),
              ),
            ));
          });
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              iconTheme: IconThemeData(color: pink),
              title: Text(
                details.course.title,
                style: TextStyle(
                  color: pink,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // GestureDetector(
                  //     onTap: () async {
                  //       await wish.toggle(details.course.id, true);
                  //     },
                  //     child: Icon(wish.courseIds.contains(details.course.id)
                  //         ? Icons.favorite
                  //         : Icons.favorite_border)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        // previewVideoPlayer(details.course.url),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    details.course.title,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: dark),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '${isFree ? '' : details.course.price + 'ريال'}',
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: pink,
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (details.review != null)
                                            StarRating(
                                              starCount: 5,
                                              rating: double.parse(
                                                  getRating(details.review)),
                                              size: 20,
                                              color: pink,
                                            ),
                                        ],
                                      ),
                                      if (details.review != null)
                                        Text(
                                          details.review == null
                                              ? "0 Rating and 0 Review"
                                              : "${getRating(details.review)} Rating and ${getLength(details.review)} Review",
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: dark,
                                              fontWeight: FontWeight.w100),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                        insetAnimationDuration:
                                            Duration(milliseconds: 300),
                                        insetAnimationCurve: Curves.bounceInOut,
                                        insetPadding: EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .scaffoldBackgroundColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Icon(Icons.clear),
                                                  )),
                                            ),
                                            Expanded(
                                              child: CourseImageScreen(
                                                image:
                                                    "${APIData.courseImages}${details.course.previewImage}",
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: CachedNetworkImage(
                                imageUrl:
                                    "${APIData.courseImages}${details.course.previewImage}",
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(width: 0.2),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => Image.asset(
                                  "assets/placeholder/featured.png",
//                        height: 80,
                                  fit: BoxFit.cover,
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  "assets/placeholder/featured.png",
//                        height: 80,
                                  fit: BoxFit.cover,
                                ),
                                height: 150,
                                width: 150,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'نظرة عامة',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 22,
                              color: dark),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Html(
                          customTextAlign: (elem) => TextAlign.start,
                          onLinkTap: (link) {
                            launch(link);
                          },
                          data: details.course?.detail ??
                              " \<h3\> لا يوجد شرح لهذه الدروة\</h3\>",
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            roundedContainer('مقدم الدورة', ice, dark, 13),
                            roundedContainer(
                                "${details.course.user.fname}  ${details.course.user.lname}",
                                dark,
                                ice,
                                13),
                          ],
                        ),
                        Row(
                          children: [
                            roundedContainer('أخر تحديث', ice, dark, 13),
                            roundedContainer(
                                details.course.updatedAt.month.toString() +
                                    "/" +
                                    details.course.updatedAt.day.toString() +
                                    "/" +
                                    details.course.updatedAt.year.toString(),
                                dark,
                                ice,
                                13),
                            roundedContainer('اللغة', ice, dark, 13),
                            roundedContainer(
                                details.course?.language?.name ?? "?",
                                dark,
                                ice,
                                13),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Divider(),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            roundedContainer('ماذا سوف تتعلم في هذه الدورة :',
                                yellow, Colors.white, 16),
                          ],
                        ),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          spacing: 0,
                          runSpacing: 0,
                          runAlignment: WrapAlignment.start,
                          alignment: WrapAlignment.start,
                          direction: Axis.horizontal,
                          children: whatLearn.length < 1 ? [] : whatLearn,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Divider(),
                        SizedBox(
                          height: 30,
                        ),
                        FutureBuilder(
                            future: getinstdetails,
                            builder: (context, snap) {
                              if (snap.hasData)
                                return InstructorWidget(snap.data);
                              else
                                return Center(
                                  child: CircularProgressIndicator(
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                            Colors.red),
                                  ),
                                );
                            }),
                        SizedBox(
                          height: 30,
                        ),
                        Divider(),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                  details.course.url != null
                      ? Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                'شاهد مقدمة الدورة الان مجاناً وقم بالتسجيل بالدورة لتحصل على شغف ${details.course.user.fname} ${details.course.user.lname}',
                                style: TextStyle(
                                    color: dark,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            // coursPreviewVedio(details.course.videoUrl)
                            ClassVideoWidget(details.course.url),
                          ],
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(children: [
                      SizedBox(
                        height: 30,
                      ),
                      if (!purchased && !isFree)
                        AddAndBuy(details.course.id, details.course.price,
                            _scaffoldKey)
                      else
                        ResumeAndStart(details, markedChpIds),
                      SizedBox(
                        height: 30,
                      ),
                      if (purchased || isFree)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: cusprogressbar(
                              MediaQuery.of(context).size.width - 50, progress),
                        ),
                      SizedBox(
                        height: 30,
                      ),
                      if (details.review != null) Divider(),
                      if (details.review != null)
                        SizedBox(
                          height: 30,
                        ),
                      if (details.review != null)
                        Text(
                          'تقيمات و مراجعات المشاركين',
                          style: TextStyle(
                              color: dark,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                      if (details.review != null)
                        SizedBox(
                          height: 10,
                        ),
                      if (details.review != null)
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: details.review.length > 2
                                ? reviewLength
                                : details.review.length,
                            itemBuilder: (context, index) {
                              return CommentCard(
                                image:
                                    "${details.review[index].imagepath}/${details.review[index].userimage}",
                                comment: details.review[index].reviews,
                                name: details.review[index].fname +
                                    "\t" +
                                    details.review[index].lname,
                                rate: details.review[index].value,
                              );
                            }),
                      SizedBox(
                        height: 10,
                      ),
                      if (details.review != null)
                        reviewLength != details.review.length
                            ? InkWell(
                                onTap: () {
                                  setState(() {
                                    reviewLength = details.review.length;
                                  });
                                },
                                child: Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(color: dark)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0,
                                          right: 20,
                                          bottom: 10,
                                          top: 5),
                                      child: Text(
                                        'مشاهدة الكل',
                                        style: TextStyle(
                                            color: dark,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'دورات مقترحة',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: dark),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 130,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: relatedCourses.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: InkWell(
                                      onTap: () {
                                        CoursesProvider coursePro =
                                            Provider.of<CoursesProvider>(
                                                context,
                                                listen: false);

                                        Navigator.of(context).pushNamed(
                                            "/courseDetails",
                                            arguments: DataSend(
                                              relatedCourses[index].userId,
                                              coursePro.isPurchased(
                                                  relatedCourses[index].id),
                                              relatedCourses[index].id,
                                              relatedCourses[index].categoryId,
                                              relatedCourses[index].detail,
                                            ));
                                      },
                                      child: Container(
                                        width: 130,
                                        height: 130,
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            Container(
                                              width: 130,
                                              height: 130,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          "${APIData.courseImages}${relatedCourses[index].previewImage}"),
                                                      fit: BoxFit.cover)),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    dark.withOpacity(0.01),
                                                    dark.withOpacity(0.1),
                                                    dark.withOpacity(0.2),
                                                    dark.withOpacity(0.5),
                                                    dark.withOpacity(0.7),
                                                  ],
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      relatedCourses[index]
                                                          .title,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                          color: ice,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            ' احدث الدورات',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: dark),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          StaggeredGridView.countBuilder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 3,
                            itemCount: recentCoursesList.length,
                            itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                CoursesProvider coursePro =
                                    Provider.of<CoursesProvider>(context,
                                        listen: false);
                                Navigator.of(context).pushNamed(
                                    "/courseDetails",
                                    arguments: DataSend(
                                        recentCoursesList[index].userId,
                                        coursePro.isPurchased(
                                            recentCoursesList[index].id),
                                        recentCoursesList[index].id,
                                        recentCoursesList[index].categoryId,
                                        recentCoursesList[index].detail));
                              },
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl:
                                        "${APIData.courseImages}${recentCoursesList[index].previewImage}",
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) => Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Container(
                                        child: Shimmer.fromColors(
                                          baseColor: Color(0xFFd3d7de),
                                          highlightColor: Color(0xFFe2e4e9),
                                          child: Card(
                                            elevation: 0.0,
                                            color:
                                                Color.fromRGBO(45, 45, 45, 1.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                            ),
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            child: Container(
                                              height: 130,
                                              width: 130,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Container(
                                        child: Shimmer.fromColors(
                                          baseColor: Color(0xFFd3d7de),
                                          highlightColor: Color(0xFFe2e4e9),
                                          child: Card(
                                            elevation: 0.0,
                                            color:
                                                Color.fromRGBO(45, 45, 45, 1.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                            ),
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            child: Container(
                                              height: 130,
                                              width: 130,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    height: 130,
                                    width: 130,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          dark.withOpacity(0.01),
                                          dark.withOpacity(0.1),
                                          dark.withOpacity(0.2),
                                          dark.withOpacity(0.5),
                                          dark.withOpacity(0.7),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            recentCoursesList[index].title,
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: ice,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            staggeredTileBuilder: (index) {
                              math.Random random = new math.Random();
                              int randomNumber = random.nextInt(3);
                              return _staggeredTiles[index % 5];
                            },
                            mainAxisSpacing: 8.0,
                            crossAxisSpacing: 8.0,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 100,
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          );
        } else
          return Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
          ));
      },
    );
  }

  Widget roundedContainer(String text, Color cColor, tColor, double size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: cColor,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12),
            child: Text(
              text,
              style: TextStyle(color: tColor, fontSize: size),
            ),
          ),
        ),
      ),
    );
  }



  final List<StaggeredTile> _staggeredTiles = const <StaggeredTile>[
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(2, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(2, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(2, 1),
    const StaggeredTile.count(2, 2),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(2, 1),
    const StaggeredTile.count(1, 2),
    const StaggeredTile.count(1, 1),
  ];

  Widget detailsSection(
      bool purchased, FullCourse details, String currency, double progress) {
    return SliverToBoxAdapter(
      child: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height / (5.5),
          color: Color(0xff29303b),
        ),
        '${detail.course.type}' == '0'
            ? unPurchasedCourseDetails(details, currency)
            : purchasedCourseDetails(details, progress),
      ]),
    );
  }

  final HttpService httpService = HttpService();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    String currency =
        Provider.of<HomeDataProvider>(context).homeModel.currency.currency;
    T.Theme mode = Provider.of<T.Theme>(context);
    txtcolor = mode.txtcolor;
    DataSend apiData = ModalRoute.of(context).settings.arguments;
    WishListProvider wish = Provider.of<WishListProvider>(context);
    CoursesProvider course = Provider.of<CoursesProvider>(context);
    bool useAsInt = false;
    if (apiData.categoryId is int) useAsInt = true;
    List<Course> allCategory = course.getCategoryCourses(
        useAsInt ? apiData.categoryId : int.parse(apiData.categoryId));
    var category = Provider.of<HomeDataProvider>(context).getCategoryName(
        !useAsInt ? apiData.categoryId : apiData.categoryId.toString());
    double progress = 0.0;
    Progress allProgress;
    bool isProgressEmpty = false;
    List<String> markedChpIds = [];
    if (apiData.purchased) {
      progress = course.getProgress(apiData.id);
      print('PROGRESS $progress');
      allProgress = course.getAllProgress(apiData.id);
      if (allProgress == null) {
        isProgressEmpty = true;
      }
      if (!isProgressEmpty) {
        markedChpIds = allProgress.markChapterId;
      } else {
        markedChpIds = [];
      }
    }
    return Directionality(
      textDirection: rtl,
      child: Scaffold(
        key: _scaffoldKey,
        body: scaffoldBody(
          category,
          markedChpIds,
          apiData.purchased,
          apiData.type.toString(),
          currency,
          progress,
          allCategory,
          wish,
        ),
      ),
    );
  }
}
