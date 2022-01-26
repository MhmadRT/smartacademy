import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widgets/course_grid_item.dart';
import '../Widgets/custom_drawer.dart';
import '../Widgets/utils.dart';
import '../common/theme.dart' as T;
import '../model/course.dart';
import '../model/home_model.dart';
import '../provider/categories.dart';
import '../provider/courses_provider.dart';
import '../provider/home_data_provider.dart';
import 'all_category_screen.dart';
import 'home_screen.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  Widget gridView(List<Course> courses) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, idx) => CourseGridItem(courses[idx], idx),
        itemCount: courses.length);
  }

  Widget subCategoriesList(int cateId, homeData) {
    return FutureBuilder(
      future: CategoryList().subcate(cateId, homeData),
      builder: (context, snap) {
        if (snap.hasData)
          return Container(
            height: snap.data.length>0?100:0,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
                itemCount: snap.data.length,
                padding: EdgeInsets.only(left: 18.0),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, idx) => GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/subCategory',
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
                                color: subCategoryColor),
                            child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
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
                                      color:subCategoryColor,
                                    ),
                                  )
                              ],
                            ),
                                )),
                          ),
                        ),
                      ),
                    )),
          );
        else
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    MyCategory cate = ModalRoute.of(context).settings.arguments;
    T.Theme mode = Provider.of<T.Theme>(context);
    List<Course> courses =
        Provider.of<CoursesProvider>(context).getCategoryCourses(cate.id);
    var homeData =
        Provider.of<HomeDataProvider>(context, listen: false).subCategoryList;
    return Directionality(
      textDirection: rtl,
      child: Scaffold(
        backgroundColor: mode.bgcolor,
        appBar: secondaryAppBar(Colors.black, mode.bgcolor, context, cate.title),
        drawer: CustomDrawer(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal:10.0),
          child: ListView(
            children: [
              subCategoriesList(cate.id, homeData),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    courses.length == 0
                        ?Container(
                      child: Center(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/emptycategory.png',
                              height: 200,
                            ),
                            Text("لا يوجد دورات"),
                          ],
                        ),
                      ),
                    )
                        : Text('الدورات',style: TextStyle(fontWeight: FontWeight.bold,color: dark,fontSize: 20),),
                    SizedBox(
                      height: 30,
                    ),
                    gridView(courses),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
