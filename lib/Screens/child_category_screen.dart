import 'package:eclass/Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widgets/course_grid_item.dart';
import '../Widgets/utils.dart';
import '../common/theme.dart' as T;
import '../model/course.dart';
import '../model/home_model.dart';
import '../provider/courses_provider.dart';

class ChildCategoryScreen extends StatelessWidget {

  Widget whenEmpty() {
    return Center(
      child: Container(
        height: 300,
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
                    "لايوجد دورات حالياً في هاذ القسم..!",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Container(
                    width: 200,
                    child: Text(
                      "لم يقم المسؤول بتحميل الدورات التدريبية لهذه الفئة الفرعية",
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

  Widget scaffoldView(courses){
    return Container(
      child: courses.length == 0
          ? whenEmpty()
          : Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Text("الدورات", style: TextStyle(color: dark,fontWeight: FontWeight.bold,fontSize: 20),),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder:
                      (context, idx) => CourseGridItem(courses[idx], idx),
                  itemCount: courses.length,

              ),
            ),
            SizedBox(
              height: 20,
            )
        ],
      ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ChildCategory childCategory = ModalRoute.of(context).settings.arguments;
    T.Theme mode = Provider.of<T.Theme>(context);
    List<Course> courses = Provider.of<CoursesProvider>(context).getchildcatecourses(
            childCategory.id,
            childCategory.subcategoryId.toString(),
            childCategory.categoryId.toString());
    return Directionality(
      textDirection: rtl,
      child: Scaffold(
        backgroundColor: mode.bgcolor,
        appBar: secondaryAppBar(
            Colors.black, mode.bgcolor, context, childCategory.title),
        body: scaffoldView(courses)
      ),
    );
  }
}
