import 'package:eclass/Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widgets/first_screen.dart';
import '../Widgets/utils.dart';
import '../common/theme.dart' as T;
import '../model/course.dart';
import '../model/course_with_progress.dart';
import '../provider/courses_provider.dart';
import '../provider/wish_list_provider.dart';

class CoursesScreen extends StatefulWidget {
  @override
  _CoursesScreenState createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  int _selectedIndex = 0;
  String daysfilter = "الكل";
  String typecoursefil = "1";
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  DropdownButton _daysfilter(Color txtColor) => DropdownButton<String>(
      elevation: 0,
      underline: Container(),
      icon: Container(
        child: Icon(
          Icons.keyboard_arrow_down,
          color: txtColor,
        ),
      ),
      iconEnabledColor: Colors.red,
      isDense: true,
      isExpanded: true,
      items: [
        DropdownMenuItem<String>(
          value: "1",
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.horizontal(
                    start: Radius.circular(5.0))),
            child: Text(
              "الكل",
              style: TextStyle(color: txtColor),
            ),
          ),
        ),
        DropdownMenuItem<String>(
          value: "2",
          child: Container(
            child: Text(
              "أخر سبع أيام",
              style: TextStyle(color: txtColor),
            ),
          ),
        ),
        DropdownMenuItem<String>(
          value: "3",
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.horizontal(
                    end: Radius.circular(5.0))),
            child: Text(
              "أخر شهر",
              style: TextStyle(color: txtColor),
            ),
          ),
        ),
      ],
      onChanged: (value) {
        setState(() {
          if (value == "1") {
            daysfilter = "الكل";
            typecoursefil = "1";
          } else if (value == "2") {
            daysfilter = "أخر سبع أيام";
            typecoursefil = "2";
          } else if (value == "3") {
            daysfilter = "أخر شهر";
            typecoursefil = "3";
          }
        });
      },
      hint: Container(
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              Icon(
                Icons.calendar_today,
                color: Color(0xFF3f4654),
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                daysfilter,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3f4654),
                ),
              ),
            ],
          )));

  Widget tabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        decoration: BoxDecoration(
            color: ice, borderRadius: BorderRadius.circular(100.0)),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                    _pageController.animateToPage(0,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease);
                  },
                  child: Container(
                    height: 35,
                    decoration: BoxDecoration(
                        color: _selectedIndex == 0
                            ? Theme.of(context).accentColor
                            : Theme.of(context).hintColor,
                        borderRadius: BorderRadius.circular(100)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "الكل",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: _selectedIndex == 0
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: ice),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                    _pageController.animateToPage(1,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease);
                  },
                  child: Container(
                    height: 35,
                    decoration: BoxDecoration(
                        color: _selectedIndex == 1
                            ? Theme.of(context).accentColor
                            : Theme.of(context).hintColor,
                        borderRadius: BorderRadius.circular(100)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "السابقة",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: _selectedIndex == 1
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: ice),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),

            ],
          ),
        ),
      ),
    );
  }

// filter container
  Widget filterBar(T.Theme mode) {
    return Container(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Container(
              padding: EdgeInsets.only(
                  left: 15.0, right: 10.0, top: 10.0, bottom: 10.0),
              decoration: BoxDecoration(
                  color: ice,
                  // border: Border.all(color: Color(0xFFb4bac6), width: 2.0),
                  borderRadius: BorderRadius.circular(13.0)),
              child: _daysfilter(mode.txtcolor),
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Container(
            width: 47.0,
            height: 47,
            decoration: BoxDecoration(
              color: ice,
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {
                Navigator.of(context).pushNamed("/filterScreen").then((value) {
                  setState(() {});
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget getCourses(List<Course> allCourses, List<CourseWithProgress> stud,
      List<Course> wishcourses,var mode) {
    return Expanded(
      flex: 44,
      child: Column(
        children: [
          filterBar(mode),
          SizedBox(
            height: 5.0,
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (value) {
                setState(() {
                  _selectedIndex = value;
                });
              },
              children: [
                Screen(allCourses, typecoursefil, _selectedIndex),
                Screen(convertToSimple(stud), typecoursefil, _selectedIndex),
                // Screen(wishcourses, typecoursefil, _selectedIndex),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CoursesProvider courses = Provider.of<CoursesProvider>(context);
    List<Course> allCourses = courses.allCourses;
    List<CourseWithProgress> stud = courses.getStudyingCoursesOnly();
    List<Course> wishcourses = courses.getWishList(Provider.of<WishListProvider>(context).courseIds);
    T.Theme mode = Provider.of<T.Theme>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: DefaultTabController(
          length: 2,
          child: Container(
            child: Center(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  tabBar(),
                  SizedBox(
                    height: 30,
                  ),

                  getCourses(allCourses, stud, wishcourses,mode),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
