
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eclass/Screens/home_screen.dart';
import 'package:eclass/Screens/password_reset_screen.dart';
import 'package:eclass/Widgets/utils.dart';
import 'package:eclass/common/apidata.dart';
import 'package:eclass/model/course.dart';
import 'package:eclass/model/course_with_progress.dart';
import 'package:eclass/provider/courses_provider.dart';
import 'package:eclass/provider/wish_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../common/theme.dart' as T;
import '../model/user_profile_model.dart';
import '../provider/user_profile.dart';
import '../provider/visible_provider.dart';
import '../services/http_services.dart';
import 'edit_profile.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  int n = 1;

  //Widget to render one support tile
  Widget supportTile(idx, icons, title, Color txtColor) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 43,
        decoration: BoxDecoration(
            color: Colors.grey[100], borderRadius: BorderRadius.circular(20)),
        alignment: Alignment.center,
        child: Icon(
          icons,
          size: 15,
          color: Color(0xffb4bac6),
        ),
      ),
      title: Text(
        title,
        maxLines: 2,
        style: TextStyle(
            fontSize: 18.3, fontWeight: FontWeight.w600, color: txtColor),
      ),
      trailing: IconButton(
          icon: Icon(Icons.keyboard_arrow_right),
          onPressed: () {
            if (idx == 0) {
              Navigator.pushNamed(context, "/becameInstructor");
            } else if (idx == 1) {
              Navigator.pushNamed(context, "/aboutUs");
            } else if (idx == 2) {
              Navigator.pushNamed(context, "/contactUs");
            } else if (idx == 3) {
              Navigator.pushNamed(context, "/userFaq");
            } else if (idx == 4) {
              Navigator.pushNamed(context, "/instructorFaq");
            }
          }),
    );
  }

  //Widget to render one personal Info tile
  Widget personalInfoTile(idx, icon, title, subTitle, Color txtColor) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.grey[100], borderRadius: BorderRadius.circular(20)),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 15,
          color: Color(0xffb4bac6),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
            fontSize: 18.3, fontWeight: FontWeight.w600, color: txtColor),
      ),
      subtitle: Text(
        subTitle == null || subTitle == "null" ? "N/A" : subTitle,
        style: TextStyle(color: txtColor),
      ),
    );
  }

  // Widget to render all personal info tiles
  Widget personalInfoSection(UserProfileModel user, Color txtClr) {
    return Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
        // height: 73 * 3.0,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Color(0x1c2464).withOpacity(0.30),
                blurRadius: 25.0,
                offset: Offset(0.0, 20.0),
                spreadRadius: -15.0)
          ],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            personalInfoTile(0, FontAwesomeIcons.user, "Name",
                user.fname.toString() + " " + user.lname.toString(), txtClr),
            personalInfoTile(
                1, Icons.mail, "Email", user.email.toString(), txtClr),
            personalInfoTile(3, FontAwesomeIcons.phone, "Mobile Number",
                user.mobile.toString(), txtClr),
          ],
        ));
  }

  // Widget to render all support tiles
  Widget supportSection(Color txtColor) {
    return Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
        padding: EdgeInsets.symmetric(vertical: 15),
        // height: 65.5 * 5.0,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Color(0x1c2464).withOpacity(0.30),
                blurRadius: 25.0,
                offset: Offset(0.0, 20.0),
                spreadRadius: -15.0)
          ],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            supportTile(0, FontAwesomeIcons.questionCircle,
                "Become an Instructor", txtColor),
            supportTile(1, FontAwesomeIcons.shieldVirus, "About Us", txtColor),
            supportTile(
                2, FontAwesomeIcons.facebookMessenger, "Contact Us", txtColor),
            supportTile(3, FontAwesomeIcons.handsHelping, "FAQ", txtColor),
            supportTile(
                4, FontAwesomeIcons.handsHelping, "Instructor FAQ", txtColor),
          ],
        ));
  }

  //Widget to render heading of sections
  Widget headingOfSection(String txt, Color clr, int type) {
    return Container(
      // height: 40,
      margin: EdgeInsets.only(bottom: type == 0 ? 12 : 0),
      padding: EdgeInsets.only(left: 22, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            txt,
            style: TextStyle(
                color: clr, fontSize: 19, fontWeight: FontWeight.w600),
          ),
          if (type == 1)
            IconButton(
                icon: Icon(
                  Icons.edit,
                  color: clr,
                  size: 20,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (contet) => EditProfile()));
                })
        ],
      ),
    );
  }

  bool logoutLoading = false;

  //logout of current session
  Widget logoutSection(Color headingColor) {
    return Container(
      child: FlatButton(
          onPressed: () async {
            setState(() {
              logoutLoading = true;
            });
            bool result = await HttpService().logout();
            setState(() {
              logoutLoading = false;
            });
            if (result) {
              Provider.of<Visible>(context, listen: false).toggleVisible(false);
              Navigator.of(context).pushNamed('/SignIn');
            } else {
              _scaffoldKey.currentState
                  .showSnackBar(SnackBar(content: Text("Logout failed!")));
            }
          },
          child: logoutLoading
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(headingColor),
                )
              : Text(
                  "LOG OUT",
                  style: TextStyle(
                      color: headingColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                )),
    );
  }

  //Widget to render a thick line at bottomest of screen
  Widget bottomLine() {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        height: 6,
        width: 120,
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(3)),
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    CoursesProvider courses = Provider.of<CoursesProvider>(context);
    List<Course> wishcourses =
        courses.getWishList(Provider.of<WishListProvider>(context).courseIds);
    UserProfileModel user = Provider.of<UserProfile>(context).profileInstance;
    List<Course> allCourses = courses.allCourses;
    List<CourseWithProgress> stud = courses.getStudyingCoursesOnly();
    T.Theme mode = Provider.of<T.Theme>(context);
    String time = TimeAgo.getTimeAgo(user.createdAt ?? DateTime.now());
    var wishLength = wishcourses.length / n;
    var stdLength = stud.length / n;
    return Directionality(
      textDirection: rtl,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: mode.bgcolor,
        body: Container(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [

                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
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
                                  offset: Offset(
                                      0, 1), // changes position of shadow
                                ),
                              ],
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/background_image.png'),
                                fit: BoxFit.cover,
                              )),
                        ),
                        // Container(
                        //   height: 150,
                        //   decoration: BoxDecoration(
                        //
                        //       borderRadius: BorderRadius.circular(20),
                        //     color: ice.withOpacity(0.2)
                        //       ),
                        // ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 130,
                            width: 130,
                            decoration: BoxDecoration(
                                color: ice,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    width: 4),
                                image: DecorationImage(
                                  image: user.userImg == null
                                      ? AssetImage(
                                          'assets/icons/user_avatar.png')
                                      : NetworkImage(
                                          "${APIData.userImage}${user.userImg}"),
                                  fit: BoxFit.cover,
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Opacity(opacity: 0.2, child: Text("انضم في $time")),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      user.userImg == null
                          ? Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                  color: ice,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/icons/user_avatar.png'),
                                    fit: BoxFit.cover,
                                  )),
                            )
                          : Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                  color: ice,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "${APIData.userImage}${user.userImg}"),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: dark),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 5),
                            child: Text(
                              user.fname + " " + user.lname,
                              maxLines: 1,
                              style: TextStyle(
                                  color: ice.withOpacity(0.7), fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditProfile()));
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration:
                              BoxDecoration(shape: BoxShape.circle, color: ice),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 2.0, left: 4),
                            child: Icon(
                              FontAwesomeIcons.solidEdit,
                              size: 17,
                              color: dark,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  user.email == null
                      ? Container()
                      : Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                    width: 90,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: dark),
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0, vertical: 8),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "البريد",
                                            style: TextStyle(
                                                color: ice.withOpacity(0.7),
                                                fontSize: 20),
                                          ),
                                        ))),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: ice.withOpacity(0.5)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 8),
                                      child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            user.email ?? "",
                                            maxLines: 1,
                                            style: TextStyle(
                                                color: Colors.black38,
                                                fontSize: 20),
                                          )),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                  if (!user.email.contains('appleuser'))
                    user.mobile == null
                        ? Container()
                        : Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                      width: 90,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: dark),
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0, vertical: 8),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "الهاتف",
                                              style: TextStyle(
                                                  color: ice.withOpacity(0.7),
                                                  fontSize: 20),
                                            ),
                                          ))),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: ice.withOpacity(0.5)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0, vertical: 8),
                                        child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              user.mobile ?? "",
                                              style: TextStyle(
                                                  color: Colors.black38,
                                                  fontSize: 20),
                                            )),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PasswordReset(1)));
                      },
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'تعديل كلمة االمرور',
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold),
                          ))),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                wish = true;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 5),
                              child: Text(
                                'دوراتي التعليمية',
                                style: TextStyle(
                                    color:  dark,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          // InkWell(
                          //   onTap: () {
                          //     setState(() {
                          //       wish = false;
                          //     });
                          //   },
                          //   child: Container(
                          //     decoration: BoxDecoration(
                          //         color: !wish ? pink : Colors.white,
                          //         borderRadius: BorderRadius.circular(100)),
                          //     child: Padding(
                          //       padding: const EdgeInsets.symmetric(
                          //           horizontal: 15.0, vertical: 5),
                          //       child: Text(
                          //         'المفضلة',
                          //         style: TextStyle(
                          //             color: !wish ? Colors.white : dark,
                          //             fontWeight: FontWeight.bold,
                          //             fontSize: 13),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  wish
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          child: stud.length < 1
                              ? Center(child: Text('لا يوجد دورات'))
                              : StaggeredGridView.countBuilder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  crossAxisCount: 3,
                                  itemCount: stdLength.toInt(),
                                  itemBuilder: (context, index) => InkWell(
                                    onTap: () {
                                      CoursesProvider coursePro =
                                          Provider.of<CoursesProvider>(context,
                                              listen: false);
                                      Navigator.of(context).pushNamed(
                                          "/courseDetails",
                                          arguments: DataSend(
                                              stud[index].userId,
                                              coursePro
                                                  .isPurchased(stud[index].id),
                                              stud[index].id,
                                              stud[index].categoryId,
                                              stud[index].detail));
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "${APIData.courseImages}${stud[index].previewImage}",
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                            width: 0.1
                                          ),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) => Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Container(
                                          child: Shimmer.fromColors(
                                            baseColor: Color(0xFFd3d7de),
                                            highlightColor: Color(0xFFe2e4e9),
                                            child: Card(
                                              elevation: 0.0,
                                              color: Color.fromRGBO(
                                                  45, 45, 45, 1.0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20),
                                                ),
                                              ),
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              child: Container(
                                                height: 130,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Container(
                                          child: Shimmer.fromColors(
                                            baseColor: Color(0xFFd3d7de),
                                            highlightColor: Color(0xFFe2e4e9),
                                            child: Card(
                                              elevation: 0.0,
                                              color: Color.fromRGBO(
                                                  45, 45, 45, 1.0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20),
                                                ),
                                              ),
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              child: Container(
                                                height: 130,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      height: 130,
                                    ),
                                  ),
                                  staggeredTileBuilder: (index) {
                                    return _staggeredTiles[index % 5];
                                  },
                                  mainAxisSpacing: 8.0,
                                  crossAxisSpacing: 8.0,
                                ),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          child: wishcourses.length < 1
                              ? Center(child: Text('لايوجد دورات مفضلة'))
                              : StaggeredGridView.countBuilder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  crossAxisCount: 3,
                                  itemCount: wishLength.toInt(),
                                  itemBuilder: (context, index) => InkWell(
                                    onTap: () {
                                      CoursesProvider coursePro =
                                          Provider.of<CoursesProvider>(context,
                                              listen: false);
                                      Navigator.of(context).pushNamed(
                                          "/courseDetails",
                                          arguments: DataSend(
                                              wishcourses[index].userId,
                                              coursePro.isPurchased(
                                                  wishcourses[index].id),
                                              wishcourses[index].id,
                                              wishcourses[index].categoryId,
                                              wishcourses[index].detail));
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "${APIData.courseImages}${wishcourses[index].previewImage}",
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) => Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Container(
                                          child: Shimmer.fromColors(
                                            baseColor: Color(0xFFd3d7de),
                                            highlightColor: Color(0xFFe2e4e9),
                                            child: Card(
                                              elevation: 0.0,
                                              color: Color.fromRGBO(
                                                  45, 45, 45, 1.0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20),
                                                ),
                                              ),
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              child: Container(
                                                height: 130,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Container(
                                          child: Shimmer.fromColors(
                                            baseColor: Color(0xFFd3d7de),
                                            highlightColor: Color(0xFFe2e4e9),
                                            child: Card(
                                              elevation: 0.0,
                                              color: Color.fromRGBO(
                                                  45, 45, 45, 1.0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20),
                                                ),
                                              ),
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              child: Container(
                                                height: 130,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      height: 130,
                                    ),
                                  ),
                                  staggeredTileBuilder: (index) {
                                    return _staggeredTiles[index % 7];
                                  },
                                  mainAxisSpacing: 8.0,
                                  crossAxisSpacing: 8.0,
                                ),
                        ),
                  SizedBox(
                    height: 30,
                  ),
                  if(stud.length>3)
                  InkWell(
                    onTap: () {
                      n = n > 1 ? 1 : 2;
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: dark)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5),
                        child: Text(
                          n == 1 ? "إخفاء" : 'مشاهدة الكل',
                          style: TextStyle(
                            color: dark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
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

  bool wish = true;
}
