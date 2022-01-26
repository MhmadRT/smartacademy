
import 'package:eclass/Screens/home_screen.dart';
import 'package:eclass/Widgets/image_place_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../common/theme.dart' as T;
import '../model/home_model.dart';
import '../provider/home_data_provider.dart';

Color subCategoryColor = pink;

class AllCategoryScreen extends StatefulWidget {
  @override
  _AllCategoryScreenState createState() => _AllCategoryScreenState();
}

class _AllCategoryScreenState extends State<AllCategoryScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  List<bool> expanded = [false, false, false, false, false];
  var category, subCategory, childCategory;
  int selected = -1;

  List<Widget> childCatItemList(
      int subCatId, String catId, List<ChildCategory> ccList) {
    List<Widget> ccWidgetList = [];
    ccList.forEach((element) {
      if (element.subcategoryId.toString() == subCatId.toString() &&
          element.categoryId.toString() == catId.toString())
        ccWidgetList.add(Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: ListTile(
            title: Material(
              color: Colors.transparent,
              child: InkWell(
                child: Padding(
                  padding: EdgeInsets.only(left: 30, top: 15, bottom: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          element.title,
                          maxLines: 1,
                          style: TextStyle(
                            color: Color(0xFF3F4654),
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed('/childCategory', arguments: element);
                },
              ),
            ),
          ),
        ));
    });
    return ccWidgetList;
  }

  List<Widget> subCategoryItemList(
      int id, List<SubCategory> scList, Color clr) {
    var homeData = Provider.of<HomeDataProvider>(context, listen: false);
    List<Widget> scItems = [];
    scList.forEach((element) {
      if (element.categoryId == id.toString()) {
        scItems.add(ExpansionTile(
          trailing: InkWell(
            onTap: () {
              Navigator.of(context)
                  .pushNamed('/subCategory', arguments: element);
            },
            child: Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                    color: Color(0xFF3F4654).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25.00)),
                child: Center(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Color(0xFF3F4654).withOpacity(0.6),
                  ),
                )),
          ),
          title: Padding(
            padding: const EdgeInsets.only(left: 54.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    element.title,
                    maxLines: 1,
                    style: TextStyle(
                      color: Color(0xFF3F4654),
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          children: childCatItemList(
              element.id, element.categoryId, homeData.childCategoryList),
        ));
      }
    });
    return scItems;
  }

  Widget parentTile(HomeDataProvider homeData, int idx, Color bgColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color(0x1c2464).withOpacity(0.30),
              blurRadius: 8.0,
              offset: Offset(0.0, 10.0),
              spreadRadius: -15.0)
        ],
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.only(bottom: 10.0),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        onExpansionChanged: ((newState) {
          if (newState)
            setState(() {
              selected = idx;
            });
          else
            setState(() {
              selected = -1;
            });
        }),
        trailing: InkWell(
          onTap: () {
            Navigator.of(context)
                .pushNamed('/category', arguments: homeData.categoryList[idx]);
          },
          child: Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                  color: Color(0xFF3F4654).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25.00)),
              child: Center(
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Color(0xFF3F4654).withOpacity(0.6),
                ),
              )),
        ),
        initiallyExpanded: idx == selected ? true : false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            placeholder(40.0, 40.0),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: Text(
                homeData.categoryList[idx].title,
                style: TextStyle(
                  color: Color(0xFF3F4654),
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
        children: subCategoryItemList(
            homeData.categoryList[idx].id, homeData.subCategoryList, bgColor),
      ),
    );
  }

  Widget scaffoldView(homeData, mode) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
              height: MediaQuery.of(context).size.height - 144,
              child: ListView.builder(
                  key: Key('builder ${selected.toString()}'),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.symmetric(horizontal: 18.0),
                  itemBuilder: (context, idx) {
                    return parentTile(homeData, idx, mode.bgcolor);
                  },
                  itemCount: homeData.categoryList.length)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<StaggeredTile> _staggeredTiles = const <StaggeredTile>[
      const StaggeredTile.count(1, 1),
      const StaggeredTile.count(2, 1),
      const StaggeredTile.count(1, 2),
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
    T.Theme mode = Provider.of<T.Theme>(context, listen: false);
    var homeData = Provider.of<HomeDataProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: mode.bgcolor,
      key: scaffoldKey,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: homeData.categoryList.isEmpty
              ? Container(
                  // color: Colors.white,
                  margin: EdgeInsets.only(bottom: 40),
                  height: 350,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          height: 180,
                          width: 180,
                          child: Image.asset("assets/images/emptycourses.png"),
                        ),
                      ),
                      Container(
                        height: 75,
                        margin: EdgeInsets.only(bottom: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "لا يوجد اقسام",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            Container(
                              width: 200,
                              child: Text(
                                "",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 19.0),
                      child: StaggeredGridView.countBuilder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(top: 40.0),
                        crossAxisCount: 3,
                        itemCount: homeData.categoryList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {
                                subCategoryColor = index % 2 == 0
                                    ? pink
                                    : index % 3 == 0
                                        ? dark
                                        : yellow;
                                Navigator.of(context).pushNamed('/category',
                                    arguments: homeData.categoryList[index]);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: index % 2 == 0
                                        ? pink
                                        : index % 3 == 0
                                            ? dark
                                            : yellow),
                                child: Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      homeData.categoryList[index].title,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 20,
                                      ),
                                      textAlign: TextAlign.center,
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
                                        color: index % 2 == 0
                                            ? pink
                                            : index % 3 == 0
                                                ? dark
                                                : yellow,
                                      ),
                                    )
                                  ],
                                )),
                              ));
                        },
                        staggeredTileBuilder: (index) {
                          return _staggeredTiles[index % 5];
                        },
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                      ),
                    ),
                    // Column(
                    //   children: [
                    //     Padding(
                    //         padding: const EdgeInsets.symmetric(
                    //             horizontal: 20.0, vertical: 10),
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Text(
                    //               'مدربين أبعاد المعرفة',
                    //               style: TextStyle(
                    //                   color: T.Theme().shortTextColor),
                    //             ),
                    //             InkWell(
                    //               onTap: () {
                    //                 Navigator.push(
                    //                     context,
                    //                     MaterialPageRoute(
                    //                         builder: (context) =>
                    //                             AllInstructor()));
                    //               },
                    //               child: Text(
                    //                 'مشاهدة الكل',
                    //                 style: TextStyle(
                    //                     color: T.Theme().shortTextColor),
                    //               ),
                    //             ),
                    //           ],
                    //         )),
                    //     InstructorList(),
                    //   ],
                    // ),
                    SizedBox(
                      height: 70,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
