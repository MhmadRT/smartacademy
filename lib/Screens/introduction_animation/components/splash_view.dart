import 'package:eclass/Screens/home_screen.dart';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  final AnimationController animationController;

  const SplashView({Key key, this.animationController}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  Widget build(BuildContext context) {
    final _introductionanimation =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(0.0, -1.0))
            .animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Interval(
        0.0,
        0.2,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    return SlideTransition(
      position: _introductionanimation,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(height: 30,),
          SizedBox(
            width: MediaQuery.of(context).size.width/2,
            child: Image.asset(
              'assets/images/logo@3x.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Text(
                  "أكاديمية أبعاد المعرفة",
                  style: TextStyle(
                      fontSize: 25.0, fontWeight: FontWeight.bold, color: dark),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 64, right: 64),
                child: Text(
                  " منصة تعليمية للتعليم عن بعد أونلاين، والتي تحتوي على العديد من الدورات المباشرة والمسجلة في مختلف المجالات من خلال مدربين مميزين وعلى قدرة عالية في إيصال المعلومات بالطريقة الصحيحة.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: dark),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 16),
            child: InkWell(
              onTap: () {
                widget.animationController.animateTo(0.2);
              },
              child: Container(
                height: 45,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(38.0),
                  color: dark,
                ),
                child: Center(
                  child: Text(
                    "ابدأ",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
