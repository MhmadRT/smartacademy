import 'package:eclass/Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../Screens/bottom_navigation_screen.dart';
import '../model/course.dart';
import '../model/course_with_progress.dart';

List<Course> convertToSimple(List<CourseWithProgress> stud) {
  List<Course> retVal = [];
  stud.forEach((element) {
    retVal.add(Course(
        id: element.id,
        userId: element.userId,
        categoryId: element.categoryId,
        subcategoryId: element.subcategoryId,
        childcategoryId: element.childcategoryId,
        languageId: element.languageId,
        title: element.title,
        shortDetail: element.shortDetail,
        detail: element.detail,
        requirement: element.requirement,
        price: element.price,
        discountPrice: element.discountPrice,
        day: element.day,
        video: element.video,
        url: element.url,
        featured: element.featured,
        slug: element.slug,
        status: element.status,
        previewImage: element.previewImage,
        videoUrl: element.videoUrl,
        previewType: element.previewType,
        type: element.type,
        duration: element.duration,
        lastActive: element.lastActive,
        createdAt: element.createdAt,
        updatedAt: element.updatedAt,
        include: element.include,
        whatlearns: element.whatlearns,
        review: []
    ));
  });
  return retVal;
}

Widget whenEmptyWishlist(BuildContext context) {
  return Center(
    child: Container(
      margin: EdgeInsets.only(bottom: 40),
      height: 370,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: 180,
              width: 180,
              decoration: BoxDecoration(),
              child: Image.asset("assets/images/emptyWishlist.png"),
            ),
          ),
          Container(
            height: 75,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "قائمة المفضل فارغة",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Container(
                  width: 200,
                  child: Text(
                    "يبدو أنك لم تستعرض الدورات التدريبية",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15, color: Colors.black.withOpacity(0.7)),
                  ),
                ),
              ],
            ),
          ),
          FlatButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyBottomNavigationBar(
                              pageInd: 0,
                            )));
              },
              child: Container(
                  width: 170,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: pink,
                      boxShadow: [
                        BoxShadow(
                            color: pink.withOpacity(0.30),
                            blurRadius: 15.0,
                            spreadRadius: 1.0)
                      ]),
                  child: Center(
                      child: Text(
                    "تصفح الدورات",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ))))
        ],
      ),
    ),
  );
}

Widget whenEmptyAllCourses(BuildContext context) {
  return Center(
    child: Container(
      margin: EdgeInsets.only(bottom: 40),
      height: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: 180,
              width: 180,
              decoration: BoxDecoration(),
              child: Image.asset("assets/images/emptycourses.png"),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 30),
            height: 75,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "لا توجد دورات متاحة!",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Container(
                  width: 200,
                  child: Text(
                    "لم يقم المسؤول بتحميل الدورات التدريبية على الخوادم",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15, color: Colors.black.withOpacity(0.7)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget whenEmptyStudying(BuildContext context) {
  return Center(
    child: Container(
      margin: EdgeInsets.only(bottom: 40),
      height: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: 180,
              width: 180,
              decoration: BoxDecoration(),
              child: Image.asset("assets/images/emptycourses.png"),
            ),
          ),
          Container(
            height: 75,
            margin: EdgeInsets.only(bottom: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "لم تشتري أي دورة",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Container(
                  width: 200,
                  child: Text(
                    "يبدو أنك لم تستعرض الدورات التدريبية",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15, color: Colors.black.withOpacity(0.7)),
                  ),
                ),
              ],
            ),
          ),
          FlatButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyBottomNavigationBar(
                              pageInd: 0,
                            )));
              },
              child: Container(
                  width: 170,
                  height: 50,
                  decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(100),
                      color: pink,
                      boxShadow: [
                        BoxShadow(
                            color: pink.withOpacity(0.5),
                            blurRadius: 15.0,
                            spreadRadius: 1.0)
                      ]),
                  child: Center(
                      child: Text(
                    "تصفح الدورات",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ))))
        ],
      ),
    ),
  );
}

Widget cusDivider(Color clr) {
  return new Center(
    child: new Container(
      margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
      height: 1.0,
      color: clr,
    ),
  );
}

AppBar secondaryAppBar(
    Color textclr, Color bgcolor, BuildContext context, String title) {
  return AppBar(
    elevation: 0.0,
    backgroundColor: bgcolor,
    leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: pink,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        }),
    centerTitle: true,
    title: Text(
      title,
      style: TextStyle(color: pink),
    ),
  );
}

Widget func(var num, String tag, int a, String x, Color clr, int ch) {
  var n;
  Color c = ch == 1 ? Color(0xffb4bac6) : Color(0x993f4654);
  if (a != 2) {
    n = num.toInt();
    if (n > 999) {
      num /= 1000;
      n = num.toString() + "k";
    }
  } else {
    n = num == null ? "N/A" : num;
  }
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      if (a == 3)
        Icon(Icons.favorite_border, color: clr)
      else
        Image.asset(
          x,
          color: clr,
          height: 20.0,
        ),
      Text(
        n.toString(),
        style:
            TextStyle(fontSize: 18.0, color: clr, fontWeight: FontWeight.bold),
      ),
      Text(
        tag,
        style: TextStyle(
            color: clr,
            fontWeight: ch == 1 ? FontWeight.bold : FontWeight.normal),
      ),
      SizedBox(
        height: 5.0,
      )
    ],
  );
}

Widget headingTitle(String x, Color clr, double size) {
  return Text(
    x,
    textAlign: TextAlign.start,
    style: TextStyle(color: dark, fontSize: 20, fontWeight: FontWeight.bold),
  );
}

Widget cusprogressbar(double width, double progress) {
  return LinearPercentIndicator(
    width: width - 20,
    lineHeight: 5.0,
    percent: progress==0.0?0.001:progress,
    linearStrokeCap: LinearStrokeCap.roundAll,
    backgroundColor: pink.withOpacity(0.2),
    progressColor: pink,
  );
}

class DataSend {
  bool purchased;
  int id;
  dynamic categoryId;
  dynamic type;
  dynamic userId;
  DataSend(this.userId, this.purchased, this.id, this.categoryId, this.type);
}
