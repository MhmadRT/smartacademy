import 'package:cached_network_image/cached_network_image.dart';
import 'package:eclass/Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:provider/provider.dart';

import '../Widgets/utils.dart';
import '../common/apidata.dart';
import '../model/course.dart';
import '../provider/courses_provider.dart';

class Search extends SearchDelegate {

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(
          Icons.close,
          color: Color(0xFF3F4654),
        ),
        onPressed: () {
          if(query==null||query=='')
            Navigator.pop(context);
          else
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: Color(0xFF3F4654),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Widget whenSearchResultEmpty() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            height: 180,
            width: 180,
            decoration: BoxDecoration(),
            child: Image.asset("assets/images/emptySearch.png"),
          ),
        ),
        Container(
          height: 75,
          margin: EdgeInsets.only(bottom: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "عذرا لم يتم العثور على نتائج",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Container(
                width: 250,
                child: Text(
                  "ما بحثت عنه للأسف غير موجود",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15, color: Colors.black.withOpacity(0.7)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Course> searchcou =Provider.of<CoursesProvider>(context).searchResults(query);

    return Directionality(
      textDirection: rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: searchcou.length == 0
            ? whenSearchResultEmpty()
            : ListView.builder(
                itemCount: searchcou.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: dark,
                          borderRadius: BorderRadius.circular(15.0)),
                      height: 80,
                      child: InkWell(
                        onTap: () {
                          bool isPurchased = Provider.of<CoursesProvider>(
                                  context,
                                  listen: false)
                              .isPurchased(searchcou[index].id);
                          Course details = searchcou[index];
                          Navigator.of(context).pushNamed("/courseDetails",
                              arguments: DataSend(
                                  details.userId,
                                  isPurchased,
                                  details.id,
                                  details.categoryId,
                                  details.type));
                        },
                        child: Row(
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15)),
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: searchcou[index].previewImage ==
                                              null
                                          ? AssetImage(
                                              "assets/placeholder/searchplaceholder.png")
                                          : CachedNetworkImageProvider(
                                              "${APIData.courseImages}" +
                                                  searchcou[index]
                                                      .previewImage))),
                            ),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                searchcou[index].title,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  final List<String> listExample;

  Search(this.listExample);

  List<Course> recentList = [];

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Course> searchcou = Provider.of<CoursesProvider>(context).searchResults(query);
    return Directionality(
      textDirection: rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: searchcou.length == 0
            ? whenSearchResultEmpty()
            : ListView.builder(
                itemCount: searchcou.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: dark,
                          borderRadius: BorderRadius.circular(15.0)),
                      height: 110,
                      child: InkWell(
                        onTap: () {
                          bool isPurchased = Provider.of<CoursesProvider>(
                                  context,
                                  listen: false)
                              .isPurchased(searchcou[index].id);
                          Course details = searchcou[index];
                          Navigator.of(context).pushNamed("/courseDetails",
                              arguments: DataSend(
                                  details.userId,
                                  isPurchased,
                                  details.id,
                                  details.categoryId,
                                  details.type));
                        },
                        child: Row(
                          children: [
                            Container(
                              height: 110,
                              width: 110,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15)),
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: searchcou[index].previewImage ==
                                              null
                                          ? AssetImage(
                                              "assets/placeholder/searchplaceholder.png")
                                          : CachedNetworkImageProvider(
                                              "${APIData.courseImages}" +
                                                  searchcou[index]
                                                      .previewImage))),
                            ),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    searchcou[index].title,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: pink,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Expanded(
                                      child: Text(
                                    parse(searchcou[index].detail).body.text,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,

                                  )),
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
