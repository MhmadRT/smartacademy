import 'dart:convert';

import 'package:eclass/Screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';

import '../Widgets/instructor_courses.dart';
import '../common/apidata.dart';
import '../model/instructor_model.dart';

class CourseInstructorScreen extends StatefulWidget {
  final String imageUrl = "assets/placeholder/avatar.png";

  @override
  _CourseInstructorScreenState createState() => _CourseInstructorScreenState();
}

class _CourseInstructorScreenState extends State<CourseInstructorScreen> {
  int instructorId;

  Future<Instructor> getinstdata(int instructorId) async {
    Instructor insdetail;
    String url = "${APIData.instructorProfile}${APIData.secretKey}";
    Response res = await post(url, body: {"instructor_id": "$instructorId"});
    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      insdetail = Instructor.fromJson(body);
    } else {
      throw "${res.statusCode}err";
    }

    return insdetail;
  }

  Widget detailsSection(Instructor details) {
    int exp = (DateTime.now().year - details.user.createdAt.year);
    return SliverToBoxAdapter(
      child: Container(
        // color: Color(0xff292C3F),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 230,
              child: Stack(
                children: [
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: dark.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ],
                        image: DecorationImage(
                          image:
                              AssetImage('assets/images/background_image.png'),
                          fit: BoxFit.cover,
                        )),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Expanded(
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //         color: pink,
                        //         borderRadius: BorderRadius.circular(100)),
                        //     child: Padding(
                        //       padding: const EdgeInsets.symmetric(
                        //           horizontal: 20.0, vertical: 3),
                        //       child: Text(details.courseCount
                        //               .toDouble()
                        //               .toString() +
                        //           " الدورات "),
                        //     ),
                        //   ),
                        // ),
                        Container(
                          height: 120,
                          width: 120,
                          margin: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: ice,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  width: 4),
                              image: DecorationImage(
                                image: NetworkImage(
                                    "${APIData.userImage}${details.user.userImg}"),
                                fit: BoxFit.contain,
                              )),
                        ),
                        // Expanded(
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.end,
                        //     children: [
                        //       Container(
                        //         decoration: BoxDecoration(
                        //             color: pink, borderRadius: BorderRadius.circular(100)),
                        //         child: Padding(
                        //           padding: const EdgeInsets.symmetric(
                        //               horizontal: 20.0, vertical: 3),                                  child: Text(details.enrolledUser.toDouble().toString()+
                        //               " طلاب ",),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: pink,
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                              })),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            Text(
              details.user.address == null ? '' : details.user.address,
              style: TextStyle(color: val),
            ),
            SizedBox(
              height: 12.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: ice,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                            "${APIData.userImage}${details.user.userImg}"),
                        fit: BoxFit.contain,
                      )),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: dark,
                      borderRadius: BorderRadius.circular(200),
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          details.user.fname + " " + details.user.lname,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12.0,
            ),
            Container(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 40,
                    width: 130,
                    decoration: BoxDecoration(
                      color: dark,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Text(
                          'سنوات الخبرة',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: ice,
                        borderRadius: BorderRadius.circular(200),
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            exp == 0
                                ? "اقل من سنة"
                                : exp.toString() + " سنوات خبرة ",
                            style: TextStyle(
                                color: dark,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 10.0,
            )
          ],
        ),
      ),
    );
  }

  Widget aboutTheInstructor(Instructor details) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("معلومات عن المحاضر",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: dark)),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Directionality(
              textDirection: rtl,
              child: Html(
                data: details.user.detail ?? "",
                customTextAlign: (elem) => TextAlign.start,
                defaultTextStyle: TextStyle(
                    color: dark,
                    fontSize: 13,
                    fontFamily: 'alfont_com_AlFont_com_din-next-lt-w23'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget allCoursesHeading(int noOfCourses) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("دورات المحاضر",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold, color: dark)),
            Container(
              padding: EdgeInsets.only(top: 2.0),
              decoration: BoxDecoration(
                border: Border.all(color: pink),
                borderRadius: BorderRadius.circular(100.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'عدد الدورات: ${noOfCourses.toString()}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: pink, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Color val = Color(0xffB5B8C7);

  @override
  Widget build(BuildContext context) {
    instructorId = ModalRoute.of(context).settings.arguments;
    return FutureBuilder<Instructor>(
        future: getinstdata(instructorId),
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return Directionality(
              textDirection: rtl,
              child: Scaffold(
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    // color: Color(0xffE5E5EF),
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Container(
                            // color: Color(0xff292C3F),
                            height: MediaQuery.of(context).padding.top,
                          ),
                        ),
                        detailsSection(snapshot.data),
                        aboutTheInstructor(snapshot.data),
                        allCoursesHeading(snapshot.data.courseCount),
                        snapshot.data.course.isNotEmpty
                            ? SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (context, idx) => InstructCourses(
                                        snapshot.data.course[idx]),
                                    childCount: snapshot.data.course.length))
                            : SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/images/error404.png',
                                  width:
                                  MediaQuery.of(context).size.width * .5,
                                ),
                                Text('لا يوجد دورات'),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          else {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Scaffold(
                body: Center(
                    child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                )),
              );
            else
              return Scaffold(
                body: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/error404.png',
                      width: MediaQuery.of(context).size.width * .5,
                    ),
                    Text('حدث خطأ حاول مجددا'),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: pink,
                      onPressed: () {
                        setState(() {});
                      },
                      child: Text('اعد التحميل'),
                      textColor: Colors.white,
                    )
                  ],
                )),
              );
          }
        });
  }
}

List<String> data = [
  "assets/icons/lecturesicon.png",
  "assets/icons/studentsicon.png",
  "assets/icons/star_icon.png",
  ""
];
