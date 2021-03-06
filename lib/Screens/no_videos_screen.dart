import 'package:eclass/Screens/home_screen.dart';
import 'package:flutter/material.dart';

class EmptyVideosPage extends StatelessWidget {
  Widget showImage() {
    return Center(
      child: Container(
        height: 180,
        width: 180,
        decoration: BoxDecoration(),
        child: Image.asset("assets/images/emptycourses.png"),
      ),
    );
  }

  Widget showDetails() {
    return Container(
      height: 75,
      margin: EdgeInsets.only(bottom: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "لا توجد مقاطع فيديو لعرضها",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          Container(
            width: 200,
            child: Text(
              "يبدو أن المسؤول لم يقم بإضافة مقاطع فيديو هنا",
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 15, color: Colors.black.withOpacity(0.7)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: pink
        ),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(bottom: 40),
          height: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              showImage(),
              showDetails(),
            ],
          ),
        ),
      ),
    );
  }
}
