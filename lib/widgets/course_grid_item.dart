import 'package:cached_network_image/cached_network_image.dart';
import 'package:eclass/Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:provider/provider.dart';

import './utils.dart';
import '../Widgets/rating_star.dart';
import '../common/apidata.dart';
import '../common/theme.dart' as T;
import '../model/course.dart';
import '../model/review.dart';
import '../provider/courses_provider.dart';
import '../provider/home_data_provider.dart';

// ignore: must_be_immutable
class CourseGridItem extends StatelessWidget {
  Course courseDetail;
  int idx;

  CourseGridItem(this.courseDetail, this.idx);

  EdgeInsets edgeInsets;

  int checkDatatype(dynamic x) {
    if (x is int)
      return 0;
    else
      return 1;
  }

  String getRating(List<Review> data) {
    double ans = 0.0;
    bool calcAsInt = true;
    if (data.length > 0)
      calcAsInt = checkDatatype(data[0].learn) == 0 ? true : false;

    data.forEach((element) {
      if (!calcAsInt)
        ans += (int.parse(element.price) +
                    int.parse(element.value) +
                    int.parse(element.learn))
                .toDouble() /
            3.0;
      else {
        ans += (element.price + element.value + element.learn) / 3.0;
      }
    });
    if (ans == 0.0) return 0.toString();
    return (ans / data.length).toStringAsPrecision(2);
  }

  Widget itemDetails(BuildContext context, bool isPurchased, String currency,
      String rating, String category) {
    return Material(
        child: InkWell(
      onTap: () {
        Course details = courseDetail;
        Navigator.of(context).pushNamed("/courseDetails",
            arguments: DataSend(details.userId, isPurchased, details.id,
                details.categoryId, details.type));
      },
      child: Container(
        height: 150,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(0.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: 150,
              child: courseDetail.previewImage == null
                  ? Image.asset(
                      "assets/placeholder/featured.png",
                      fit: BoxFit.cover,
                    )
                  : CachedNetworkImage(
                      imageUrl:
                          "${APIData.courseImages}${courseDetail.previewImage}",
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              topLeft: Radius.circular(15)),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Image.asset(
                        "assets/placeholder/featured.png",
//                        height: 80,
                        fit: BoxFit.cover,
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        "assets/placeholder/featured.png",
//                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 70,
                            child: Text(
                              category,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                foreground: Paint()..shader = linearGradient,
                              ),
                            ),
                          ),
                          if (courseDetail.discountPrice != null.toString() &&
                              courseDetail.discountPrice != null)
                            Text(
                              "${courseDetail.discountPrice} $currency",
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold),
                            )
                          else
                            SizedBox.shrink(),
                        ],
                      ),
                      if (courseDetail.price != null.toString() &&
                          courseDetail.price != null)
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "${courseDetail.price} $currency",
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 13.0,
                                color: Colors.grey),
                          ),
                        )
                      else
                        SizedBox(
                          height: 15,
                        ),
                      SizedBox(
                        height: 3.0,
                      ),
                      Text(
                        courseDetail.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        courseDetail.shortDetail,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14.0),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "by admin",
                            style:
                                TextStyle(fontSize: 15.0, color: Colors.grey),
                          ),
                          StarRating(
                            rating: double.parse(rating),
                            size: 11.0,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  Widget item(BuildContext context, bool isPurchased, String currency,
      String rating, String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed("/courseDetails",
              arguments: DataSend(courseDetail.userId, isPurchased,
                  courseDetail.id, courseDetail.categoryId, courseDetail.type));
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 170,
          decoration: BoxDecoration(
              color: dark, borderRadius: BorderRadius.circular(15)),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()..shader = linearGradient,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        courseDetail.title,
                        style: TextStyle(color: Colors.white, fontSize: 17),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        parse(courseDetail.detail).body.text,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w300),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 170,
                width: 170,
                child: courseDetail.previewImage == null
                    ? Image.asset(
                        "assets/placeholder/featured.png",
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        imageUrl:
                            "${APIData.courseImages}${courseDetail.previewImage}",
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                topLeft: Radius.circular(15)),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Image.asset(
                          "assets/placeholder/featured.png",
//                        height: 80,
                          fit: BoxFit.cover,
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          "assets/placeholder/featured.png",
//                        height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String currency =
        Provider.of<HomeDataProvider>(context).homeModel.currency.currency;
    String category = Provider.of<HomeDataProvider>(context)
        .getCategoryName(courseDetail.categoryId);
    if (category == null) category = "N/A";
    bool isPurchased =
        Provider.of<CoursesProvider>(context).isPurchased(courseDetail.id);
    T.Theme mode = Provider.of<T.Theme>(context);
    if (idx % 2 == 0)
      edgeInsets = EdgeInsets.only(left: 12.0);
    else
      edgeInsets = EdgeInsets.only(right: 12.0);
    String rating = getRating(courseDetail.review);
    return Directionality(
      textDirection: rtl,
      child: Container(
          decoration: BoxDecoration(
            color: mode.tilecolor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: item(context, isPurchased, currency, rating, category)),
    );
  }
}

final Shader linearGradient = LinearGradient(
  colors: <Color>[Color(0xff790055), Color(0xffF81D46), Color(0xffFA4E62)],
).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
