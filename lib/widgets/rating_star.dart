import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final Color color;
  final double size;

  StarRating({this.starCount = 5, this.rating = .0, this.color, this.size});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = new Icon(
        Icons.star_border,
        color: color ?? Color(0xff0083A4),
        size: size,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = new Icon(
        Icons.star_half,
        color: color ?? Color(0xff0083A4),
        size: size,
      );
    } else {
      icon = new Icon(
        Icons.star,
        color: color ?? Color(0xff0083A4),
        size: size,
      );
    }
    return new InkResponse(
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            new List.generate(starCount, (index) => buildStar2(context, index)));
  }
  Widget buildStar2(BuildContext context, int index) {
    var icon;
    if (index >= rating) {
      icon = Image.asset('assets/icons/emptyStar.png',width: size,height: size,);
    } else if (index > rating - 1 && index < rating) {
      icon = Image.asset('assets/icons/halfStar.png',width: size,height: size,);
    } else {
      icon = Image.asset('assets/icons/fullStar.png',width: size,height: size,);
    }
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: new InkResponse(
        child: icon,
      ),
    );
  }

}
