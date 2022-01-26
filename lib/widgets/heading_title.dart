import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../Widgets/utils.dart';

// ignore: must_be_immutable
class HeadingTitle extends StatelessWidget {
  final String title;
  bool _visible;
   HeadingTitle(this.title, this._visible);
  Color second = Color(0xFF3F4654);
  Widget showShimmer(BuildContext context) {
    return Container(
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
            height: 25,
            width: MediaQuery.of(context).size.width,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _visible == true
        ? headingTitle(title, second, 16)
        : showShimmer(context);
  }
}
