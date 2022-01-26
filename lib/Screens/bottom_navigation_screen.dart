import 'dart:async';

import 'package:eclass/common/global.dart';
import 'package:eclass/provider/home_data_provider.dart';
import 'package:eclass/provider/instructor_provider.dart';
import 'package:eclass/provider/recent_course_provider.dart';
import 'package:eclass/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

import '../Widgets/appbar.dart';
import '../Widgets/appbar.dart'as appBar;
import '../Widgets/custom_drawer.dart';
import '../common/theme.dart' as T;
import '../provider/bundle_course.dart';
import '../provider/courses_provider.dart';
import '../provider/user_profile.dart';
import '../provider/visible_provider.dart';
import 'all_category_screen.dart';
import 'cart_screen.dart';
import 'courses_screen.dart';
import 'home_screen.dart';
import 'home_screen.dart' as home;
import 'settings_screen.dart';

class MyBottomNavigationBar extends StatefulWidget {
  MyBottomNavigationBar({this.pageInd});

  final pageInd;

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

final GlobalKey<ScaffoldState> mainscaffoldKey = new GlobalKey<ScaffoldState>();

class HomeIndex {
  int index;

  HomeIndex(this.index);
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    CoursesScreen(),
    AllCategoryScreen(),
    CartScreen(),
    SettingScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  initState() {
    if (widget.pageInd != null) _selectedIndex = widget.pageInd;
    super.initState();
    Visible visiblePro = Provider.of<Visible>(context, listen: false);
    Timer(Duration(milliseconds: 0), () {
      visiblePro.toggleVisible(false);
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var token = await storage.read(key: "token");
      authToken = token;
      HomeDataProvider homeData =
          Provider.of<HomeDataProvider>(context, listen: false);
      await homeData.getMainApi();
      homeData.getHomeDetails(context);
      setState(() {
        authToken = token;
      });
      CoursesProvider coursesProvider =
          Provider.of<CoursesProvider>(context, listen: false);
      RecentCourseProvider recentCourseProvider =
          Provider.of<RecentCourseProvider>(context, listen: false);
      BundleCourseProvider bundleCourseProvider =
          Provider.of<BundleCourseProvider>(context, listen: false);
      UserProfile userProfile =
          Provider.of<UserProfile>(context, listen: false);
      InstructorProvider instructorProvider =
          Provider.of<InstructorProvider>(context, listen: false);
      bundleCourseProvider.getBundles(context);
      coursesProvider.getAllCourse(context);
      recentCourseProvider.fetchRecentCourse(context);
      instructorProvider.instructor =
          instructorProvider.getInstructors(context);
      setState(() {
        visiblePro.toggleVisible(true);
      });
      await coursesProvider.initPurchasedCourses(context);
      await userProfile.fetchUserProfile();
      setState(() {
        visiblePro.toggleVisible(true);
      });
    });
  }

  Future<bool> onBackPressed() {
    bool value;
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: rtl,
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          title: Text(
            'تأكيد الخروج',
            style: TextStyle(fontWeight: FontWeight.w700, color: dark),
          ),
          content: Text(
            'هل انت متأكد من الخروج',
            style: TextStyle(color: dark),
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "الغاء".toUpperCase(),
                  style: TextStyle(color: dark, fontWeight: FontWeight.w600),
                )),
            SizedBox(height: 16),
            FlatButton(
                onPressed: () {
                  SystemNavigator.pop();
                  Navigator.pop(context);
                },
                child: Text(
                  "متأكد".toUpperCase(),
                  style: TextStyle(color: dark, fontWeight: FontWeight.w600),
                )),
          ],
        ),
      ),
    );
    return new Future.value(value);
  }

  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: WillPopScope(
        child: Scaffold(
            key: scaffoldKey,
            appBar: appBar.appBar(mode.bgcolor, context, scaffoldKey ?? "",
                _selectedIndex ?? 0),
            drawer: CustomDrawer(),
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: _widgetOptions.elementAt(_selectedIndex ?? 0),
                ),
                Positioned(
                  bottom: 23,
                  left: 23,
                  right: 23,
                  child: Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: pink.withOpacity(0.08),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ], borderRadius: BorderRadius.circular(230), color: ice),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 10),
                      child: GNav(
                          gap: 4,
                          tabBackgroundColor: Theme.of(context).accentColor,
                          iconSize: 30,
                          duration: Duration(milliseconds: 400),
                          activeColor: Colors.white,
                          color: Theme.of(context).hintColor,
                          tabs: [
                            GButton(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              text: 'الرئيسية',
                              leading: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      _selectedIndex == 0 ? pink : Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: SvgPicture.asset(
                                    'assets/icons/home.svg',
                                    height: 23,
                                    width: 23,
                                    color: _selectedIndex == 0
                                        ? Colors.white
                                        : dark,
                                  ),
                                ),
                              ),
                            ),
                            GButton(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              leading: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      _selectedIndex == 1 ? pink : Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: SvgPicture.asset(
                                    'assets/icons/bbook.svg',
                                    height: 23,
                                    width: 23,
                                    color: _selectedIndex == 1
                                        ? Colors.white
                                        : dark,
                                  ),
                                ),
                              ),
                              text: 'الدورات',
                            ),
                            GButton(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              leading: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      _selectedIndex == 2 ? pink : Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: SvgPicture.asset(
                                    'assets/icons/category.svg',
                                    height: 23,
                                    width: 23,
                                    color: _selectedIndex == 2
                                        ? Colors.white
                                        : dark,
                                  ),
                                ),
                              ),
                              text: 'الاقسام',
                            ),
                            GButton(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              leading: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _selectedIndex == 3
                                          ? pink
                                          : Colors.white,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: SvgPicture.asset(
                                        'assets/icons/cart.svg',
                                        height: 23,
                                        width: 23,
                                        color: _selectedIndex == 3
                                            ? Colors.white
                                            : dark,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 18,
                                    width: 18,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle),
                                    child: Center(
                                        child: Text(
                                      '${home.cartLength.value}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold
                                      ),
                                    )),
                                  )
                                ],
                              ),
                              text: 'السلة',
                            ),
                            GButton(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              leading: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      _selectedIndex == 4 ? pink : Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: SvgPicture.asset(
                                    'assets/icons/person.svg',
                                    height: 23,
                                    width: 23,
                                    color: _selectedIndex == 4
                                        ? Colors.white
                                        : dark,
                                  ),
                                ),
                              ),
                              text: 'الملف الشخصي',
                            ),
                          ],
                          selectedIndex: _selectedIndex,
                          onTabChange: (index) {
                            setState(() {
                              _selectedIndex = index;
                            });
                          }),
                    ),
                  ),
                ),
              ],
            )),
        onWillPop: onBackPressed,
      ),
    );
  }
}
