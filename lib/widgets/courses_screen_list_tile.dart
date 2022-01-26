import 'package:cached_network_image/cached_network_image.dart';
import 'package:eclass/Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:provider/provider.dart';

import '../Widgets/utils.dart';
import '../common/apidata.dart';
import '../model/course.dart';
import '../provider/courses_provider.dart';
import '../provider/home_data_provider.dart';

class ExpCoursesListItem extends StatelessWidget {
  final Color txtColor;
  final Course courseDetail, nextCourse;
  final bool isPurchased;

  ExpCoursesListItem(
      this.courseDetail, this.isPurchased, this.txtColor, this.nextCourse);

  Widget showImage(String img) {
    return Expanded(
      flex: 1,
      child: Container(
        child: new ClipRRect(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10.0),
              topRight: Radius.circular(10.0)),
          child: img == "null" || img == null
              ? Image.asset(
                  "assets/placeholder/exp_course_placeholder.png",
                  height: 140.0,
                  width: 220.0,
                  fit: BoxFit.cover,
                )
              : CachedNetworkImage(
                  fit: BoxFit.cover,
                  height: 140,
                  imageUrl: "${APIData.courseImages}$img",
                  placeholder: (context, x) => Image.asset(
                      "assets/placeholder/exp_course_placeholder.png"),
                ),
        ),
      ),
    );
  }

  Widget showDetails(BuildContext context, String category) {
    var currency = Provider.of<HomeDataProvider>(context, listen: false)
        .homeModel
        .currency
        .currency;
    double progress;
    if (isPurchased) {
      progress = Provider.of<CoursesProvider>(context)
                  .getProgress(courseDetail.id) !=
              double.nan
          ? 0.3
          : Provider.of<CoursesProvider>(context).getProgress(courseDetail.id);
    }
    var courseDurationType;
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 15.0,
          ),
          Text(
            courseDetail.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              fontSize: 18.0,
              color: pink,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 4.0),
          Text(
            courseDetail.shortDetail,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              fontSize: 16.0,
              color: dark,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 15.0),
          if (isPurchased)
            SizedBox.shrink()
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                courseDetail.duration == null
                    ? Text(
                        "Full Time Access",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Color(0xFF3f4654),
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600),
                      )
                    : Text(
                        courseDetail.durationType == "m"
                            ? courseDetail.duration.toString() + ' Months'
                            : courseDetail.duration.toString() + ' Days',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Color(0xFF3f4654),
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600),
                      ),
                Text(
                  courseDetail.type == "0"
                      ? "Free"
                      : "${courseDetail.discountPrice} $currency",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: Color(0xFF3f4654),
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          SizedBox(
            height: 8.0,
          ),
          if (isPurchased)
            cusprogressbar(MediaQuery.of(context).size.width - 180, progress)
          else
            SizedBox.shrink(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String category = Provider.of<HomeDataProvider>(context)
        .getCategoryName(courseDetail.categoryId);
    if (category == null) category = "N/A";
    var currency = Provider.of<HomeDataProvider>(context, listen: false)
        .homeModel
        .currency
        .currency;
    double progress;
    if (isPurchased) {
      progress = Provider.of<CoursesProvider>(context)
          .getProgress(courseDetail.id) !=
          double.nan
          ? 0.3
          : Provider.of<CoursesProvider>(context).getProgress(courseDetail.id);
    }
    if (courseDetail.id % 3 == 0) {
      return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: InkWell(
              onTap: () {
                Course details = courseDetail;
                Navigator.of(context).pushNamed("/courseDetails",
                    arguments: DataSend(details.userId, isPurchased, details.id,
                        details.categoryId, details.type));
              },
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
                // width: MediaQuery.of(context).size.width,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: CachedNetworkImage(
                          imageUrl: "${APIData.courseImages}" +
                                  "${courseDetail?.previewImage}" ??
                              "",
                          imageBuilder: (context, imageProvider) => Container(
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  bottomRight: Radius.circular(15)),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    bottomLeft: Radius.circular(15)),
                                image: DecorationImage(
                                  image: AssetImage('assets/images/loading.gif'),
                                  fit: BoxFit.contain,
                                ),
                              )),
                          errorWidget: (context, url, error) => Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                  color: ice,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(15))),
                              child: Icon(
                                Icons.error,
                                color: dark,
                              )),
                        ),
                      ),
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                            color: ice,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('$category',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: pink,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 5,
                              ),
                              Text('${courseDetail.title}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: dark,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 5,
                              ),
                              Text('${parse(courseDetail.detail).body.text}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: dark.withOpacity(1),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400)),
                              SizedBox(
                                height: 8.0,
                              ),
                              if (isPurchased)
                                cusprogressbar(120, progress)
                              else
                                SizedBox.shrink(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
    } else {
      return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: InkWell(
              onTap: () {
                Course details = courseDetail;
                Navigator.of(context).pushNamed("/courseDetails",
                    arguments: DataSend(details.userId, isPurchased, details.id,
                        details.categoryId, details.type));
              },
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
                // width: MediaQuery.of(context).size.width,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                              color: dark,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(12),
                                  bottomRight: Radius.circular(12))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('$category',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: pink,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                Text('${courseDetail.title}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    parse(courseDetail.detail).body.text,
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white,
                                        fontSize: 12),
                                  ),
                                ),
                                if (isPurchased)
                                  cusprogressbar(120, progress)
                                else
                                  SizedBox.shrink(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      CachedNetworkImage(
                        imageUrl: "${APIData.courseImages}" +
                                "${courseDetail?.previewImage}" ??
                            "",
                        imageBuilder: (context, imageProvider) => Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                bottomLeft: Radius.circular(15)),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  bottomLeft: Radius.circular(15)),
                              image: DecorationImage(
                                image: AssetImage('assets/images/loading.gif'),
                                fit: BoxFit.contain,
                              ),
                            )),
                        errorWidget: (context, url, error) => Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                                color: ice,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    bottomLeft: Radius.circular(15))),
                            child: Icon(
                              Icons.error,
                              color: dark,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
    }
  }
}
/*
InkWell(
            onTap: () {
              Course details = courseDetail;
              Navigator.of(context).pushNamed("/courseDetails",
                  arguments: DataSend(details.userId, isPurchased, details.id,
                      details.categoryId, details.type));
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(width: 0.2)),
                child: Row(
                  children: [
                    Expanded(
                      child: CachedNetworkImage(
                        imageUrl: "${APIData.courseImages}" +
                                "${courseDetail?.previewImage}" ??
                            "",
                        imageBuilder: (context, imageProvider) => Container(
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(16),
                                bottomRight: Radius.circular(16)),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Container(
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: AssetImage('assets/images/loading.gif'),
                                fit: BoxFit.contain,
                              ),
                            )),
                        errorWidget: (context, url, error) => Container(
                            height: 150,
                            decoration: BoxDecoration(
                              color: ice,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.error,
                              color: dark,
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 140,
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('$category',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: pink,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 10,
                            ),
                            Text('${courseDetail.title}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: dark,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 10,
                            ),
                            Text('${parse(courseDetail.detail).body.text}',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: dark.withOpacity(0.9),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w300)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
 */
