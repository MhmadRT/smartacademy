import 'package:cached_network_image/cached_network_image.dart';
import 'package:eclass/Screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/apidata.dart';
import '../common/theme.dart' as T;
import '../model/bundle_courses_model.dart';
import '../provider/courses_provider.dart';
import '../provider/home_data_provider.dart';

// ignore: must_be_immutable
class BundleCourseItem extends StatelessWidget {
  bool _visible;
  BundleCourses bundleCoursesDetail;

  BundleCourseItem(this.bundleCoursesDetail, this._visible);

  Widget showImage() {
    return bundleCoursesDetail.previewImage == null
        ? Container(
            decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
            image: DecorationImage(
              image: AssetImage("assets/placeholder/bundle_place_holder.png"),
              fit: BoxFit.cover,
            ),
          ))
        : CachedNetworkImage(
            imageUrl:
                "${APIData.bundleImages}${bundleCoursesDetail.previewImage}",
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => Container(
                decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              image: DecorationImage(
                image: AssetImage('assets/images/loading.gif'),
                fit: BoxFit.cover,
              ),
            )),
            errorWidget: (context, url, error) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                image: DecorationImage(
                  image:
                      AssetImage("assets/placeholder/bundle_place_holder.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
  }

  Widget tileDetails(BuildContext context, T.Theme mode, String category,
      String currency, bool purchased) {
    return Padding(
      padding: const EdgeInsets.only(left:10.0),
      child: Container(
        width:  170,
        decoration: BoxDecoration(),
        child: Material(
          color: dark,
          borderRadius: BorderRadius.circular(10.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  child: showImage(),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: pink),
                            ),
                            Column(children: [
                              if (bundleCoursesDetail.discountPrice != null &&
                                  !purchased)
                                Text(
                                  "${bundleCoursesDetail.discountPrice} $currency",
                                  style: TextStyle(
                                      color:Colors.white,
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.bold),
                                ),

                              if (bundleCoursesDetail.price != null && !purchased)
                                Text(
                                  "${bundleCoursesDetail.price} $currency",
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 11.0,
                                    color:Colors.white60,
                                  ),
                                ),
                            ],),

                          ],
                        ),
                        Text(
                          bundleCoursesDetail.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          "${bundleCoursesDetail.detail}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.white70,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            onTap: () {
              Navigator.of(context).pushNamed("/bundleCourseDetail",
                  arguments: bundleCoursesDetail);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool purchased = Provider.of<CoursesProvider>(context)
        .isBundlePurchased(bundleCoursesDetail.id);
    String category = Provider.of<HomeDataProvider>(context)
        .getCategoryName(bundleCoursesDetail.courseId[0]);
    if (category == null) category = "";
    String currency =
        Provider.of<HomeDataProvider>(context).homeModel.currency.currency;
    T.Theme mode = Provider.of<T.Theme>(context);
    return tileDetails(context, mode, category, currency, purchased);
  }
}

final Shader linearGradient = LinearGradient(
  colors: <Color>[Color(0xff790055), Color(0xffF81D46), Color(0xffFA4E62)],
).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
