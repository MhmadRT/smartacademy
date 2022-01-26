import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CourseImageScreen extends StatefulWidget {
  final String image;

  const CourseImageScreen({this.image});

  @override
  _CourseImageScreenState createState() => _CourseImageScreenState();
}

class _CourseImageScreenState extends State<CourseImageScreen> with SingleTickerProviderStateMixin{

  Widget build(BuildContext context) {
    return  CachedNetworkImage(
      imageUrl:
      widget.image,
      imageBuilder: (context, imageProvider) =>
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.contain,
              ),
            ),
          ),
      placeholder: (context, url) => Image.asset(
        "assets/placeholder/featured.png",
//                        height: 80,
        fit: BoxFit.fill,
      ),
      errorWidget: (context, url, error) => Image.asset(
        "assets/placeholder/featured.png",
//                        height: 80,
        fit: BoxFit.fill,
      ),
      width: MediaQuery.of(context).size.width,
    );
  }
}
