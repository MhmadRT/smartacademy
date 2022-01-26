import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../common/apidata.dart';
import '../provider/home_data_provider.dart';

// ignore: must_be_immutable
class ImageSwiper extends StatelessWidget {
  bool _visible;

  ImageSwiper(this._visible);

  Color therd = Color(0xffF84B63);
  Color second = Color(0xFF3F4654);

  Widget detailsOnImage(String heading, String subHeading) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 15,
          ),
          Flexible(
            child: Text(
              heading,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: therd, fontSize: 20.0, fontWeight: FontWeight.w800),
            ),
          ),
          Flexible(
            child: Text(
              subHeading,
              overflow: TextOverflow.fade,
              maxLines: 3,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17.0,
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget showShimmer(BuildContext context) {
    return Container(
      height: 150,
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
            height: MediaQuery.of(context).orientation == Orientation.landscape
                ? 70
                : MediaQuery.of(context).size.height / 11,
          ),
        ),
      ),
    );
  }

  Widget showImage(Orientation orientation, String image) {
    return CachedNetworkImage(
      imageUrl: APIData.sliderImages + image,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
          decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
        image: DecorationImage(
          image: AssetImage('assets/images/loading.gif'),
          fit: BoxFit.contain,
        ),
      )),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  Widget showSlider(Orientation orientation, HomeDataProvider slider) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Swiper(
        duration: 800,
        autoplayDelay: 10000,
        autoplayDisableOnInteraction: true,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal:5.0,vertical: 5),
            child: showImage(orientation, slider.sliderList[index].image),
          );
        },
        indicatorLayout: PageIndicatorLayout.COLOR,
        autoplay: true,
        itemCount: slider.sliderList.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var slider = Provider.of<HomeDataProvider>(context);
    Orientation orientation = MediaQuery.of(context).orientation;
    return _visible == true
        ? showSlider(orientation, slider)
        : showShimmer(context);
  }
}
