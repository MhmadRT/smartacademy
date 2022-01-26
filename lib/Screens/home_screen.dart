import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eclass/Screens/all_instructor.dart';
import 'package:eclass/Widgets/instructor_list.dart';
import 'package:eclass/Widgets/studying_list.dart';
import 'package:eclass/Widgets/utils.dart';
import 'package:eclass/common/apidata.dart';
import 'package:eclass/provider/cart_provider.dart';
import 'package:eclass/provider/home_data_provider.dart';
import 'package:eclass/provider/instructor_provider.dart';
import 'package:eclass/provider/recent_course_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../Widgets/bundle_courses_list.dart';
import '../Widgets/featured_category_list.dart';
import '../common/theme.dart' as T;
import '../model/bundle_courses_model.dart';
import '../model/course.dart';
import '../provider/bundle_course.dart';
import '../provider/courses_provider.dart';
import '../provider/user_profile.dart';
import '../provider/visible_provider.dart';
import '../services/http_services.dart';
import 'image_swiper.dart';
import 'search_result_screen.dart';

Color ice = Color(0xffF3F5F8);
Color yellow = Color(0xffFDBF2F);
Color dark = Color(0xFF3F4654);
Color pink = Color(0xffF84B63);
TextDirection rtl = TextDirection.rtl;
TextDirection ltr = TextDirection.ltr;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

ValueNotifier<int> cartLength = ValueNotifier(0);

class _HomeScreenState extends State<HomeScreen> {
  HttpService httpService = HttpService();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _visible;
  Color second = Color(0xFF3F4654);
  Color therd = Color(0xffF84B63);

  Widget welcomeText(String name, String imageUrl, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: ice, borderRadius: BorderRadius.circular(100)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 7,
                  ),
                  child: Center(
                    child: Text(
                      "مرحباً بك مجدداً",
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).hintColor),
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  width: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Theme.of(context).hintColor),
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: name == null || name == ''
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1,
                                  )),
                            )
                          : Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: ice),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).accentColor.withOpacity(0.5),
                  spreadRadius: 0.5,
                  blurRadius: 12,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: AssetImage('assets/icons/user_avatar.png'))),
        ),
      ],
    );
  }

  List<String> list = List.generate(10, (index) => "Text $index");

  Widget searchBar(BuildContext context) {
    return _visible == true
        ? Container(
            decoration: BoxDecoration(
              color: second,
              boxShadow: [
                BoxShadow(
                    color: Color(0x1c2464).withOpacity(0.30),
                    blurRadius: 25.0,
                    offset: Offset(0.0, 20.0),
                    spreadRadius: -15.0)
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "ماذا تود ان تتعلم؟",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontFamily:
                                  'alfont_com_AlFont_com_din-next-lt-w23',
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      onTap: () {
                        showSearch(context: context, delegate: Search(list));
                      },
                    ),
                  ),
                  Image.asset(
                    'assets/images/search.png',
                    height: 20,
                  )
                ],
              ),
            ),
          )
        : Container(
            height: 40,
            child: Shimmer.fromColors(
              baseColor: Color(0xFFd3d7de),
              highlightColor: Color(0xFFe2e4e9),
              child: Card(
                elevation: 0.0,
                color: Color.fromRGBO(45, 45, 45, 1.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Container(
                  height: MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ? 70
                      : MediaQuery.of(context).size.height / 11,
                ),
              ),
            ),
          );
  }

  final List<StaggeredTile> _staggeredTiles = const <StaggeredTile>[
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(2, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(3, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 2),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 1),
    const StaggeredTile.count(1, 2),
    const StaggeredTile.count(1, 1),
  ];

  Widget scaffoldView(UserProfile user, course, mode, bundleCourses,
      InstructorProvider instructorProvider) {
    Visible visiblePro = Provider.of<Visible>(context, listen: false);
    List<Course> featuredCoursesList = course.getFeaturedCourses();
    var zoomMeetingList =
        Provider.of<HomeDataProvider>(context).zoomMeetingList;
    var testimonialList =
        Provider.of<HomeDataProvider>(context).testimonialList;
    var trustedList = Provider.of<HomeDataProvider>(context).trustedList;
    var factSliderList = Provider.of<HomeDataProvider>(context).sliderFactList;
    var sliderList = Provider.of<HomeDataProvider>(context).sliderList;
    var instructor = Provider.of<InstructorProvider>(context).instructor;
    var newCourses =
        Provider.of<RecentCourseProvider>(context).recentCourseList;
    // factSliderList.forEach((cur) {});
    // dev.log('tokokok $authToken');

    return Container(
      child: ListView(shrinkWrap: true, children: [
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
          child: welcomeText(user.profileInstance.fname,
              user.profileInstance.userImg, context),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
          child: searchBar(context),
        ),
        sliderList.length == 0
            ? SizedBox.shrink()
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                child: ImageSwiper(_visible),
              ),
        SizedBox(
          height: 20,
        ),

        if (newCourses.isNotEmpty)
          _visible
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                  child: Text(
                    'أحدث الدورات',
                    style: TextStyle(
                        color: T.Theme().shortTextColor,
                        fontWeight: FontWeight.bold),
                  ),
                )
              : Container(),

        if (newCourses.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: StaggeredGridView.countBuilder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              itemCount: _visible
                  ? (newCourses.length > 5 ? 5 : newCourses.length)
                  : 5,
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  CoursesProvider coursePro =
                      Provider.of<CoursesProvider>(context, listen: false);
                  Navigator.of(context).pushNamed("/courseDetails",
                      arguments: DataSend(
                          newCourses[index].userId,
                          coursePro.isPurchased(newCourses[index].id),
                          newCourses[index].id,
                          newCourses[index].categoryId,
                          newCourses[index].detail));
                },
                child: _visible
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl:
                                "${APIData.courseImages}${newCourses[index].previewImage}",
                            imageBuilder: (context, imageProvider) => Container(
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
                                    color: Color.fromRGBO(45, 45, 45, 1.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: Container(
                                      height: 130,
                                      width: 130,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                child: Shimmer.fromColors(
                                  baseColor: Color(0xFFd3d7de),
                                  highlightColor: Color(0xFFe2e4e9),
                                  child: Card(
                                    elevation: 0.0,
                                    color: Color.fromRGBO(45, 45, 45, 1.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: Container(
                                      height: 130,
                                      width: 130,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            height: 130,
                          ),
                          Container(
                            height: 130,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                 Colors.transparent,
                                  dark.withOpacity(.3),
                                  dark.withOpacity(1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    newCourses[index].title,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    : Container(
                        height: 40,
                        child: Shimmer.fromColors(
                          baseColor: Color(0xFFd3d7de),
                          highlightColor: Color(0xFFe2e4e9),
                          child: Card(
                            elevation: 0.0,
                            margin: EdgeInsets.only(top: 8),
                            color: Color.fromRGBO(45, 45, 45, 1.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              ),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * .7,
                              height: 28,
                            ),
                          ),
                        ),
                      ),
              ),
              staggeredTileBuilder: (index) {
                Random random = Random();
                int randomNumber = random.nextInt(3);
                return _staggeredTiles[index];
              },
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            ),
          ),
        if (factSliderList.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
            child: FeaturedCategoryList(_visible),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
          child: _visible == true
              ? Row(
                  children: [
                    Container(
                      height: 70,
                      decoration: BoxDecoration(
                          color: therd,
                          borderRadius: BorderRadius.circular(100)),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Center(
                          child: Text(
                            'الأرقام تخبرك عنا \n بشكـــل أكبر',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ice,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Center(
                            child: Text.rich(
                              TextSpan(text: '', children: [
                                TextSpan(
                                    text: '40951\n',
                                    style: TextStyle(
                                        color: therd,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500)),
                                TextSpan(
                                  text: 'باحث وطالب\n',
                                ),
                                TextSpan(
                                  text: 'شغف',
                                ),
                              ]),
                              style: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 9),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // borderRadius: BorderRadius.circular(100),
                          color: ice,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Center(
                            child: Text.rich(
                              TextSpan(text: '', children: [
                                TextSpan(
                                    text: '1898\n',
                                    style: TextStyle(
                                        color: therd,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500)),
                                TextSpan(
                                  text: 'تعليق وتقيم\n',
                                ),
                                TextSpan(
                                  text: 'من طلابنا',
                                ),
                              ]),
                              style: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 9),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // borderRadius: BorderRadius.circular(100),
                          color: ice,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Center(
                            child: Text.rich(
                              TextSpan(text: '', children: [
                                TextSpan(
                                    text: '405\n',
                                    style: TextStyle(
                                        color: therd,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500)),
                                TextSpan(
                                  text: ' مقدم للخبرات\n',
                                ),
                                TextSpan(
                                  text: '',
                                ),
                              ]),
                              style: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 9),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Container(
                      height: 70,
                      width: 140,
                      child: Shimmer.fromColors(
                        baseColor: Color(0xFFd3d7de),
                        highlightColor: Color(0xFFe2e4e9),
                        child: Card(
                          elevation: 0.0,
                          color: Color.fromRGBO(45, 45, 45, 1.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12000),
                            ),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Container(
                            height: 50,
                            width: 100,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 70,
                        child: Shimmer.fromColors(
                          baseColor: Color(0xFFd3d7de),
                          highlightColor: Color(0xFFe2e4e9),
                          child: Card(
                            elevation: 0.0,
                            color: Color.fromRGBO(45, 45, 45, 1.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12000),
                              ),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Container(
                              height: 50,
                              width: 50,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 70,
                        child: Shimmer.fromColors(
                          baseColor: Color(0xFFd3d7de),
                          highlightColor: Color(0xFFe2e4e9),
                          child: Card(
                            elevation: 0.0,
                            color: Color.fromRGBO(45, 45, 45, 1.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12000),
                              ),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Container(
                              height: 50,
                              width: 50,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 70,
                        child: Shimmer.fromColors(
                          baseColor: Color(0xFFd3d7de),
                          highlightColor: Color(0xFFe2e4e9),
                          child: Card(
                            elevation: 0.0,
                            color: Color.fromRGBO(45, 45, 45, 1.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12000),
                              ),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Container(
                              height: 50,
                              width: 50,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
        bundleCourses.length == 0
            ? Container()
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                child: _visible
                    ? Text(
                        "الحزم",
                        style: TextStyle(
                            color: T.Theme().shortTextColor,
                            fontWeight: FontWeight.bold),
                      )
                    : Container(),
              ),

        bundleCourses.length == 0
            ? Container()
            : BundleCoursesList(bundleCourses, _visible),
        if (instructor != null)
          if (instructor.instructors != null)
            if (instructor.instructors.isNotEmpty)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                child: _visible
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'مدربين أبعاد المعرفة',
                            style: TextStyle(
                                color: T.Theme().shortTextColor,
                                fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AllInstructor()));
                            },
                            child: Text(
                              'مشاهدة الكل',
                              style: TextStyle(
                                  color: T.Theme().shortTextColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
              ),
        if (instructor != null)
          if (instructor.instructors != null)
            if (instructor.instructors.isNotEmpty)
              _visible
                  ? InstructorList(
                      instructor: instructorProvider.instructor,
                    )
                  : Container(),
        course.studyingList.length == 0
            ? SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    StudyingList(_visible),
                  ],
                ),
              ),
        SizedBox(
          height: 70,
        ),
      ]),
    );
  }

  Widget loadingWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: ListView(
        children: [
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 100,
                  child: Shimmer.fromColors(
                    baseColor: Color(0xFFd3d7de),
                    highlightColor: Color(0xFFe2e4e9),
                    child: Card(
                      elevation: 0.0,
                      color: Color.fromRGBO(45, 45, 45, 1.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(1000),
                        ),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                    ),
                  ),
                ),
                Container(
                  child: Shimmer.fromColors(
                    baseColor: Color(0xFFd3d7de),
                    highlightColor: Color(0xFFe2e4e9),
                    child: Card(
                      elevation: 0.0,
                      color: Color.fromRGBO(45, 45, 45, 1.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(1000),
                        ),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Container(
                        height: 50,
                        width: 50,
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
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: Shimmer.fromColors(
              baseColor: Color(0xFFd3d7de),
              highlightColor: Color(0xFFe2e4e9),
              child: Card(
                elevation: 0.0,
                color: Color.fromRGBO(45, 45, 45, 1.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 130,
            width: MediaQuery.of(context).size.width,
            child: Shimmer.fromColors(
              baseColor: Color(0xFFd3d7de),
              highlightColor: Color(0xFFe2e4e9),
              child: Card(
                elevation: 0.0,
                color: Color.fromRGBO(45, 45, 45, 1.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                height: 100,
                width: MediaQuery.of(context).size.width / 3,
                child: Shimmer.fromColors(
                  baseColor: Color(0xFFd3d7de),
                  highlightColor: Color(0xFFe2e4e9),
                  child: Card(
                    elevation: 0.0,
                    color: Color.fromRGBO(45, 45, 45, 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                  ),
                ),
              ),
              Container(
                height: 100,
                width: MediaQuery.of(context).size.width / 1.5 - 40,
                child: Shimmer.fromColors(
                  baseColor: Color(0xFFd3d7de),
                  highlightColor: Color(0xFFe2e4e9),
                  child: Card(
                    elevation: 0.0,
                    color: Color.fromRGBO(45, 45, 45, 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                height: 100,
                width: (MediaQuery.of(context).size.width - 40) / 3,
                child: Shimmer.fromColors(
                  baseColor: Color(0xFFd3d7de),
                  highlightColor: Color(0xFFe2e4e9),
                  child: Card(
                    elevation: 0.0,
                    color: Color.fromRGBO(45, 45, 45, 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                  ),
                ),
              ),
              Container(
                height: 100,
                width: (MediaQuery.of(context).size.width - 40) / 3,
                child: Shimmer.fromColors(
                  baseColor: Color(0xFFd3d7de),
                  highlightColor: Color(0xFFe2e4e9),
                  child: Card(
                    elevation: 0.0,
                    color: Color.fromRGBO(45, 45, 45, 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                  ),
                ),
              ),
              Container(
                height: 100,
                width: (MediaQuery.of(context).size.width - 40) / 3,
                child: Shimmer.fromColors(
                  baseColor: Color(0xFFd3d7de),
                  highlightColor: Color(0xFFe2e4e9),
                  child: Card(
                    elevation: 0.0,
                    color: Color.fromRGBO(45, 45, 45, 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                height: 100,
                width: MediaQuery.of(context).size.width / 1.5 - 40,
                child: Shimmer.fromColors(
                  baseColor: Color(0xFFd3d7de),
                  highlightColor: Color(0xFFe2e4e9),
                  child: Card(
                    elevation: 0.0,
                    color: Color.fromRGBO(45, 45, 45, 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                  ),
                ),
              ),
              Container(
                height: 100,
                width: MediaQuery.of(context).size.width / 3,
                child: Shimmer.fromColors(
                  baseColor: Color(0xFFd3d7de),
                  highlightColor: Color(0xFFe2e4e9),
                  child: Card(
                    elevation: 0.0,
                    color: Color.fromRGBO(45, 45, 45, 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                height: 40,
                width: 140,
                child: Shimmer.fromColors(
                  baseColor: Color(0xFFd3d7de),
                  highlightColor: Color(0xFFe2e4e9),
                  child: Card(
                    elevation: 0.0,
                    color: Color.fromRGBO(45, 45, 45, 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(1000),
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                  ),
                ),
              ),
              Container(
                height: 40,
                width: 180,
                child: Shimmer.fromColors(
                  baseColor: Color(0xFFd3d7de),
                  highlightColor: Color(0xFFe2e4e9),
                  child: Card(
                    elevation: 0.0,
                    color: Color.fromRGBO(45, 45, 45, 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(1000),
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                height: 40,
                width: 160,
                child: Shimmer.fromColors(
                  baseColor: Color(0xFFd3d7de),
                  highlightColor: Color(0xFFe2e4e9),
                  child: Card(
                    elevation: 0.0,
                    color: Color.fromRGBO(45, 45, 45, 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(1000),
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                  ),
                ),
              ),
              Container(
                height: 40,
                width: 40,
                child: Shimmer.fromColors(
                  baseColor: Color(0xFFd3d7de),
                  highlightColor: Color(0xFFe2e4e9),
                  child: Card(
                    elevation: 0.0,
                    color: Color.fromRGBO(45, 45, 45, 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(1000),
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 130,
            width: MediaQuery.of(context).size.width,
            child: Shimmer.fromColors(
              baseColor: Color(0xFFd3d7de),
              highlightColor: Color(0xFFe2e4e9),
              child: Card(
                elevation: 0.0,
                color: Color.fromRGBO(45, 45, 45, 1.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 70,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                  height: 70,
                  width: 150,
                  child: Shimmer.fromColors(
                    baseColor: Color(0xFFd3d7de),
                    highlightColor: Color(0xFFe2e4e9),
                    child: Card(
                      elevation: 0.0,
                      color: Color.fromRGBO(45, 45, 45, 1.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(1000),
                        ),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                    ),
                  ),
                ),
                Container(
                  height: 70,
                  width: 70,
                  child: Shimmer.fromColors(
                    baseColor: Color(0xFFd3d7de),
                    highlightColor: Color(0xFFe2e4e9),
                    child: Card(
                      elevation: 0.0,
                      color: Color.fromRGBO(45, 45, 45, 1.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(1000),
                        ),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                    ),
                  ),
                ),
                Container(
                  height: 70,
                  width: 70,
                  child: Shimmer.fromColors(
                    baseColor: Color(0xFFd3d7de),
                    highlightColor: Color(0xFFe2e4e9),
                    child: Card(
                      elevation: 0.0,
                      color: Color.fromRGBO(45, 45, 45, 1.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(1000),
                        ),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 90,
            width: MediaQuery.of(context).size.width,
            child: Shimmer.fromColors(
              baseColor: Color(0xFFd3d7de),
              highlightColor: Color(0xFFe2e4e9),
              child: Card(
                elevation: 0.0,
                color: Color.fromRGBO(45, 45, 45, 1.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
              ),
            ),
          ),
          Container(
            height: 90,
            width: MediaQuery.of(context).size.width,
            child: Shimmer.fromColors(
              baseColor: Color(0xFFd3d7de),
              highlightColor: Color(0xFFe2e4e9),
              child: Card(
                elevation: 0.0,
                color: Color.fromRGBO(45, 45, 45, 1.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
              ),
            ),
          ),
          Container(
            height: 90,
            width: MediaQuery.of(context).size.width,
            child: Shimmer.fromColors(
              baseColor: Color(0xFFd3d7de),
              highlightColor: Color(0xFFe2e4e9),
              child: Card(
                elevation: 0.0,
                color: Color.fromRGBO(45, 45, 45, 1.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
              ),
            ),
          ),
          Container(
            height: 90,
            width: MediaQuery.of(context).size.width,
            child: Shimmer.fromColors(
              baseColor: Color(0xFFd3d7de),
              highlightColor: Color(0xFFe2e4e9),
              child: Card(
                elevation: 0.0,
                color: Color.fromRGBO(45, 45, 45, 1.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
              ),
            ),
          ),
          Container(
            height: 90,
            width: MediaQuery.of(context).size.width,
            child: Shimmer.fromColors(
              baseColor: Color(0xFFd3d7de),
              highlightColor: Color(0xFFe2e4e9),
              child: Card(
                elevation: 0.0,
                color: Color.fromRGBO(45, 45, 45, 1.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
              ),
            ),
          ),
          Container(
            height: 90,
            width: MediaQuery.of(context).size.width,
            child: Shimmer.fromColors(
              baseColor: Color(0xFFd3d7de),
              highlightColor: Color(0xFFe2e4e9),
              child: Card(
                elevation: 0.0,
                color: Color.fromRGBO(45, 45, 45, 1.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

  Future<Null> getHomePageData() async {
    SharedPreferences ref = await SharedPreferences.getInstance();
    ref.clear();
    print('Start Get Data');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Visible visiblePro = Provider.of<Visible>(context, listen: false);
      Timer(Duration(milliseconds: 0), () {
        visiblePro.toggleVisible(false);
      });
      CoursesProvider coursesProvider =
          Provider.of<CoursesProvider>(context, listen: false);
      RecentCourseProvider recentCourseProvider =
          Provider.of<RecentCourseProvider>(context, listen: false);
      BundleCourseProvider bundleCourseProvider =
          Provider.of<BundleCourseProvider>(context, listen: false);
      InstructorProvider instructorProvider =
          Provider.of<InstructorProvider>(context, listen: false);
      UserProfile userProfile =
          Provider.of<UserProfile>(context, listen: false);
      coursesProvider.getAllCourse(context);
      bundleCourseProvider.getBundles(context);
      instructorProvider.getInstructors(context);
      recentCourseProvider.fetchRecentCourse(context);
      Timer(Duration(milliseconds: 1), () {
        visiblePro.toggleVisible(true);
      });
      await userProfile.fetchUserProfile();
      await coursesProvider.initPurchasedCourses(context);
      Timer(Duration(milliseconds: 500), () {
        visiblePro.toggleVisible(true);
        print('sdfghjkl;lkjgfdfghjkl;lkjflkjfhjkl;kgfdhjkl;kjhgfd');
      });
    });
    setState(() {});
  }

  bool instFirst = true;

  @override
  Widget build(BuildContext context) {
    Visible visiblePro = Provider.of<Visible>(context, listen: false);
    T.Theme mode = Provider.of<T.Theme>(context, listen: false);
    UserProfile user = Provider.of<UserProfile>(context, listen: false);
    CoursesProvider course =
        Provider.of<CoursesProvider>(context, listen: false);
    InstructorProvider instructorProvider =
        Provider.of<InstructorProvider>(context, listen: false);
    List<BundleCourses> bundleCourses =
        Provider.of<BundleCourseProvider>(context, listen: false).bundleCourses;
    _visible = Provider.of<Visible>(context).globalVisible;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      CartProvider cartProvider =
          Provider.of<CartProvider>(context, listen: false);
      if (instFirst) {
        instFirst = false;
        setState(() {});
      }
    });

    // _visible = false;
    return visiblePro.globalVisible
        ? Directionality(
            textDirection: TextDirection.rtl,
            child: RefreshIndicator(
              child: Scaffold(
                key: UniqueKey(),
                backgroundColor: Colors.white,
                body: scaffoldView(
                    user, course, mode, bundleCourses, instructorProvider),
              ),
              onRefresh: getHomePageData,
            ),
          )
        : loadingWidget();
  }
}

final Shader linearGradient = LinearGradient(
  colors: <Color>[
    Color(0xff790055),
    Color(0xffF81D46),
    Color(0xffF81D46),
    Color(0xffFA4E62)
  ],
).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
