import 'package:cached_network_image/cached_network_image.dart';
import 'package:eclass/Screens/bottom_navigation_screen.dart';
import 'package:eclass/Screens/home_screen.dart';
import 'package:eclass/Widgets/utils.dart';
import 'package:eclass/common/apidata.dart';
import 'package:eclass/model/course.dart';
import 'package:eclass/model/home_model.dart';
import 'package:eclass/provider/courses_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:html/parser.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../common/theme.dart' as T;
import '../provider/home_data_provider.dart';

// ignore: must_be_immutable
class FeaturedCategoryList extends StatefulWidget {
  bool _visible;

  FeaturedCategoryList(this._visible);

  @override
  _FeaturedCategoryListState createState() => _FeaturedCategoryListState();
}

class _FeaturedCategoryListState extends State<FeaturedCategoryList> {
  Widget showImage(image) {
    return image == null
        ? Container(
            height: 92.0,
            width: 92.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(47.5),
                image: DecorationImage(
                    image: AssetImage(
                  "assets/images/background_image.png",
                ))),
          )
        : Container(
            height: 95.0,
            width: 95.0,
            child: CachedNetworkImage(
              imageUrl: "${APIData.categoryImages}$image",
              imageBuilder: (context, imageProvider) => Container(
                height: 95.0,
                width: 95.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(47.5),
                  border: Border.all(color: Colors.white, width: 3),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Color(0xFF3F4654).withOpacity(0.4),
                        BlendMode.colorBurn),
                  ),
                ),
              ),
              placeholder: (context, url) => Image.asset(
                "assets/images/background_image.png",
                height: 95,
                width: 95,
              ),
              errorWidget: (context, url, error) => Image.asset(
                "assets/images/background_image.png",
                height: 95,
                width: 95,
              ),
            ),
          );
  }

  Widget showTitle(String title, String image) {
    T.Theme mode = Provider.of<T.Theme>(context);
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: mode.fCatTextColor,
          fontSize: 16.0,
          fontWeight: FontWeight.w500),
    );
  }

  int index = 0;
  Color therd = Color(0xffF84B63);
  Color grey = Color(0xff383D48);

  @override
  void initState() {
    setState(() {
      index = 0;
    });
  }

  List<Course> courses = [Course(title: '', id: 231, detail: '')];
  var idx;

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    List<MyCategory> featuredCategoryList =
        Provider.of<HomeDataProvider>(context).homeModel.featuredCate;
    List<Widget> features = [];
    if (featuredCategoryList.length > 0 && idx == null) {
      idx = featuredCategoryList.first.id;
    }
    featuredCategoryList.forEach((element) {
      int i = featuredCategoryList.indexOf(element);
      features.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 4),
        child: GestureDetector(
          onTap: () {
            setState(() {
              courses.clear();
              print('IDD${element.id}');
              index = i;
              idx = element.id;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: index == i ? therd : ice,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
              child: Text(
                element.title,
                style: TextStyle(
                    color: index == i ? Colors.white : mode.titleTextColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ),
      ));
    });
    // features.add(Row(
    //   mainAxisAlignment: MainAxisAlignment.start,
    //   mainAxisSize: MainAxisSize.min,
    //   children: [
    //     GestureDetector(
    //       onTap: () {
    //         Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //                 builder: (context) => MyBottomNavigationBar(
    //                   pageInd: 2,
    //                 )));
    //       },
    //       child: Container(
    //         decoration: BoxDecoration(
    //           color: yellow,
    //           borderRadius: BorderRadius.circular(30),
    //         ),
    //         child: Padding(
    //           padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
    //           child: Center(
    //             child: Text(
    //               'مشاهدة الكل',
    //               style: TextStyle(
    //                   color: ice, fontSize: 17, fontWeight: FontWeight.w400),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //     Padding(
    //       padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 4),
    //       child: Container(
    //         width: 30,
    //         height: 30,
    //         decoration: BoxDecoration(color: yellow, shape: BoxShape.circle),
    //         child: Padding(
    //           padding: const EdgeInsets.all(5.0),
    //           child: SvgPicture.asset(
    //             'assets/icons/dots.svg',
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // ));
    courses = Provider.of<CoursesProvider>(context, listen: true)
        .getCategoryCourses(idx);

    return Column(
      children: [
        if (featuredCategoryList.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 15),
            child: widget._visible
                ? Row(
                    children: [
                      Text(
                        'أفضل الأقسام',
                        style: TextStyle(
                            color: T.Theme().shortTextColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                : Container(),
          ),
        Container(
          child: widget._visible == false
              ? Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 40.0,
                            width: 160.0,
                            child: Shimmer.fromColors(
                              baseColor: Color(0xFFd3d7de),
                              highlightColor: Color(0xFFe2e4e9),
                              child: Card(
                                elevation: 0.0,
                                color: Color.fromRGBO(45, 45, 45, 1.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(47.5),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                              ),
                            ),
                          ),
                          Container(
                            height: 40.0,
                            width: 150.0,
                            child: Shimmer.fromColors(
                              baseColor: Color(0xFFd3d7de),
                              highlightColor: Color(0xFFe2e4e9),
                              child: Card(
                                elevation: 0.0,
                                color: Color.fromRGBO(45, 45, 45, 1.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(47.5),
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
                            height: 40.0,
                            width: 100.0,
                            child: Shimmer.fromColors(
                              baseColor: Color(0xFFd3d7de),
                              highlightColor: Color(0xFFe2e4e9),
                              child: Card(
                                elevation: 0.0,
                                color: Color.fromRGBO(45, 45, 45, 1.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(47.5),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                              ),
                            ),
                          ),
                          Container(
                            height: 40.0,
                            width: 40.0,
                            child: Shimmer.fromColors(
                              baseColor: Color(0xFFd3d7de),
                              highlightColor: Color(0xFFe2e4e9),
                              child: Card(
                                elevation: 0.0,
                                color: Color.fromRGBO(45, 45, 45, 1.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(47.5),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : featuredCategoryList.isNotEmpty
                  ? Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Wrap(
                              runAlignment: WrapAlignment.start,
                              runSpacing: 0,
                              spacing: 0,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              children: features,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          courses.length < 1
                              ? Container(
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/images/emptycategory.png',
                                          height: 100,
                                        ),
                                        Text("لا يوجد دورات"),
                                      ],
                                    ),
                                  ),
                                )
                              : Text(
                                  '${featuredCategoryList[index].title}',
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: T.Theme().shortTextColor,
                                      fontWeight: FontWeight.bold),
                                ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: courses.length > 1
                                      ? Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                // bool isPurchased =
                                                // Provider.of<CoursesProvider>(context).isPurchased(courses[0].id);
                                                Course details = courses[0];
                                                Navigator.of(context).pushNamed(
                                                    "/courseDetails",
                                                    arguments: DataSend(
                                                        details.userId,
                                                        false,
                                                        details.id,
                                                        details.categoryId,
                                                        details.type));
                                              },
                                              child: Container(
                                                height: 110,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  color: grey,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    15.0,
                                                                vertical: 5),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Text(
                                                              '${featuredCategoryList[index].title}',
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                  color: therd,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              '${courses[0].title}',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                parse(courses[0]
                                                                        .detail)
                                                                    .body
                                                                    .text,
                                                                maxLines: 2,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          16),
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          16)),
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                '${courses[0]?.previewImage == "null" || courses[0]?.previewImage == null ? 'https://developers.google.com/maps/documentation/streetview/images/error-image-generic.png?hl=pl' : APIData.courseImages + courses[0]?.previewImage}'),
                                                            fit: BoxFit.cover,
                                                          )),
                                                      height: 110,
                                                      width: 110,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                // bool isPurchased =
                                                // Provider.of<CoursesProvider>(context).isPurchased(courses[0].id);
                                                Course details = courses[1];
                                                Navigator.of(context).pushNamed(
                                                    "/courseDetails",
                                                    arguments: DataSend(
                                                        details.userId,
                                                        false,
                                                        details.id,
                                                        details.categoryId,
                                                        details.type));
                                              },
                                              child: Container(
                                                height: 110,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  color: grey,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    15.0,
                                                                vertical: 5),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Text(
                                                              '${featuredCategoryList[index].title}',
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                  color: therd,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              '${courses[1].title}',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                parse(courses[1]
                                                                        .detail)
                                                                    .body
                                                                    .text,
                                                                maxLines: 2,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          16),
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          16)),
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                '${courses[1]?.previewImage == "null" || courses[1]?.previewImage == null ? 'https://developers.google.com/maps/documentation/streetview/images/error-image-generic.png?hl=pl' : APIData.courseImages + courses[1]?.previewImage}'),
                                                            fit: BoxFit.cover,
                                                          )),
                                                      height: 110,
                                                      width: 110,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      : courses.length == 1
                                          ? InkWell(
                                              onTap: () {
                                                // bool isPurchased =
                                                // Provider.of<CoursesProvider>(context).isPurchased(courses[0].id);
                                                Course details = courses[0];
                                                Navigator.of(context).pushNamed(
                                                    "/courseDetails",
                                                    arguments: DataSend(
                                                        details.userId,
                                                        false,
                                                        details.id,
                                                        details.categoryId,
                                                        details.type));
                                              },
                                              child: Container(
                                                height: 110,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  color: grey,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    15.0,
                                                                vertical: 5),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Text(
                                                              '${featuredCategoryList[index].title}',
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                  color: therd,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              '${courses[0].title}',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                parse(courses[0]
                                                                        .detail)
                                                                    .body
                                                                    .text,
                                                                maxLines: 2,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          16),
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          16)),
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                '${courses[0]?.previewImage == "null" || courses[0]?.previewImage == null ? 'https://developers.google.com/maps/documentation/streetview/images/error-image-generic.png?hl=pl' : APIData.courseImages + courses[0]?.previewImage}'),
                                                            fit: BoxFit.cover,
                                                          )),
                                                      height: 110,
                                                      width: 110,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Container()),
                              courses.length < 1
                                  ? Container()
                                  : SizedBox(
                                      width: 10,
                                    ),
                              courses.length < 1
                                  ? Container()
                                  : Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              '/category',
                                              arguments:
                                                  featuredCategoryList[index]);
                                        },
                                        child: Container(
                                          height:
                                              courses.length > 1 ? 230 : 110,
                                          child: Center(
                                              child: Container(
                                            decoration: BoxDecoration(
                                                color: ice,
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'مشاهدة \nالكــل',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    width: 30,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8),
                                                      color: dark
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: SvgPicture.asset(
                                                        'assets/icons/dots.svg',
                                                        width: 30,
                                                        height: 30,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )),
                                        ),
                                      ),
                                    ),
                            ],
                          )
                        ],
                      ),
                    )
                  : Container(),
        ),
      ],
    );
  }
}
