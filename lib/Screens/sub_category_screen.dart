import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widgets/appbar.dart';
import '../Widgets/course_grid_item.dart';
import '../common/theme.dart' as T;
import '../model/course.dart';
import '../model/home_model.dart';
import '../provider/categories.dart';
import '../provider/courses_provider.dart';
import '../provider/home_data_provider.dart';
import 'home_screen.dart';

class SubCategoryScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    List<String> img = ["assets/images/cate1.png", "assets/images/cate2.png"];
    SubCategory subCategory = ModalRoute.of(context).settings.arguments;
    Color spcl = Color(0xff655586);
    T.Theme mode = Provider.of<T.Theme>(context);
    List<Course> courses = Provider.of<CoursesProvider>(context)
        .getsubcatecourses(subCategory.id, subCategory.categoryId);
    var homeData = Provider.of<HomeDataProvider>(context).childCategoryList;
    return Directionality(
      textDirection: rtl,
      child: Scaffold(
        backgroundColor: mode.bgcolor,
        appBar: customAppBar(context, subCategory.title),
        body: Container(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:20.0),
                child: FutureBuilder(
                    future: CategoryList().childcate(subCategory.id.toString(),
                        subCategory.categoryId, homeData),
                    builder: (context, snap) {
                      if (snap.hasData){
                        return  Container(
                          height: 130,
                          child: ListView.builder(
                              itemCount: snap.data.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, idx) {
                               return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        '/childCategory',
                                        arguments: snap.data[idx]);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(16),
                                            color: idx % 2 == 0
                                                ? pink
                                                : idx % 3 == 0
                                                ? dark
                                                : yellow),
                                        child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(15.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    snap.data[idx].title,
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle),
                                                    child: Icon(

                                                      Icons.keyboard_arrow_down,
                                                      size: 18,
                                                      color: idx % 2 == 0
                                                          ? pink
                                                          : idx % 3 == 0
                                                          ? dark
                                                          : yellow,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )),
                                      ),
                                    ),
                                  ),
                                );

                              }),
                        );}
                      else
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );

                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("الدورات", style: TextStyle(color: dark,fontSize: 20,fontWeight: FontWeight.bold),),
              ),
              courses.length==0?
              Center(
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
                        margin: EdgeInsets.only(bottom: 20),
                        height: 100,
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
              ) :Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView.builder(
                  shrinkWrap: true,
                 physics: NeverScrollableScrollPhysics(),
                 itemBuilder:  (context, idx) => CourseGridItem(courses[idx], idx),
                    itemCount: courses.length,

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
