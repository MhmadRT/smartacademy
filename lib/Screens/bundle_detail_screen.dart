import 'package:eclass/Screens/home_screen.dart';
import 'package:eclass/common/apidata.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Widgets/add_and_buy_bundleCourses.dart';
import '../Widgets/course_tile_widget_list.dart';
import '../Widgets/html_text.dart';
import '../Widgets/utils.dart';
import '../common/theme.dart' as T;
import '../model/bundle_courses_model.dart';
import '../model/course.dart';
import '../provider/courses_provider.dart';
import '../provider/home_data_provider.dart';

class BundleDetailScreen extends StatefulWidget {
  @override
  _BundleDetailScreenState createState() => _BundleDetailScreenState();
}

class _BundleDetailScreenState extends State<BundleDetailScreen> {
  double textsize = 14.0;

  Widget fun(String a, String b) {
    return Row(
      children: [
        Text(
          a + " : ",
          style:
              TextStyle(color: dark, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Text(
          b,
          style: TextStyle(fontSize: 15, color: dark.withOpacity(.5)),
        )
      ],
    );
  }

  Widget bundleDetails(
      BundleCourses bundleDetail, bool purchased, String currency) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bundleDetail.title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0,
                          color: dark),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    if (!purchased)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("$currency" + "${bundleDetail.discountPrice}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: dark)),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "$currency" + "${bundleDetail.price}",
                            style: TextStyle(
                                color: dark.withOpacity(.5),
                                fontSize: 14.0,
                                decoration: TextDecoration.lineThrough),
                          )
                        ],
                      ),
                    fun(
                        "أخر تحديث",
                        bundleDetail.updatedAt == null
                            ? ""
                            : DateFormat.yMMMd().format(
                                DateTime.parse(bundleDetail.updatedAt))),
                    fun("عدد الدوارت", bundleDetail.courseId.length.toString()),
                  ],
                ),
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          image: NetworkImage(
                              "${APIData.bundleImages}${bundleDetail.previewImage}",),fit: BoxFit.cover)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget appBar(String title) {
    return SliverAppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: TextStyle(fontSize: 18.0, color: pink),
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.arrow_back_ios,color: pink,),
        iconSize: 18.0,
      ),
    );
  }

  Widget  bundleDescription(String desc) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: html(desc, dark.withOpacity(.7), 16),
      ),
    );
  }

  Widget headings(String title, Color clr) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:20.0),
        child: headingTitle(title, clr, 22),
      ),
    );
  }

  Widget bundleCoursesList(List<Course> courses) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(right:20.0),
        child: Container(
          height:210,
          child: ListView.builder(
            itemBuilder: (context, idx) => CourseListItem(courses[idx], true),
            scrollDirection: Axis.horizontal,
            itemCount: courses.length,
          ),
        ),
      ),
    );
  }

  Widget block() {
    return SliverToBoxAdapter(
      child: Container(
        height: 10.0,
        color: Colors.red,
      ),
    );
  }

  Widget scaffoldBody(BundleCourses bundleDetail, bool purchased,
      List<Course> courses, dynamic currency) {
    return Directionality(
      textDirection: rtl,
      child: Container(
          color: Colors.white,
          //padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: CustomScrollView(
            slivers: [
              appBar(bundleDetail.title),
              bundleDetails(bundleDetail, purchased, currency),
              AddAndBuyBundle(
                  bundleDetail.id, bundleDetail.discountPrice, _scaffoldKey),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 20,
                ),
              ),
              headings("التفاصيل", Color(0xff0083A4)),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 10,
                ),
              ),
              bundleDescription(bundleDetail.detail),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 20,
                ),
              ),
              headings("تشمل الحزمة", Color(0xff0083A4)),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 10,
                ),
              ),
              bundleCoursesList(courses),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 20,
                ),
              )
            ],
          )),
    );
  }

  Color txtcolor;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    BundleCourses bundleDetail = ModalRoute.of(context).settings.arguments;
    String currency =
        Provider.of<HomeDataProvider>(context).homeModel.currency.currency;
    var courses = Provider.of<CoursesProvider>(context);
    List<Course> bundleCourses = courses.getCourses(bundleDetail.courseId);

    bool purchased = courses.bundlePurchasedListIds.contains(bundleDetail.id);
    T.Theme mode = Provider.of<T.Theme>(context);
    txtcolor = mode.txtcolor;
    return Scaffold(
      key: _scaffoldKey,
      body: scaffoldBody(bundleDetail, purchased, bundleCourses, currency),
    );
  }
}
