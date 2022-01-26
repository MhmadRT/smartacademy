import 'package:flutter/material.dart';

import '../../home_screen.dart';

class WelcomeView extends StatelessWidget {
  final AnimationController animationController;
  const WelcomeView({Key key,  this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _firstHalfAnimation =
        Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(
          0.6,
          0.8,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
    final _secondHalfAnimation =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(-1, 0)).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(
          0.8,
          1.0,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    final _welcomeFirstHalfAnimation =
        Tween<Offset>(begin: Offset(2, 0), end: Offset(0, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(
        0.6,
        0.8,
        curve: Curves.fastOutSlowIn,
      ),
    ));

    final _welcomeImageAnimation =
        Tween<Offset>(begin: Offset(4, 0), end: Offset(0, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(
        0.6,
        0.8,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    return SlideTransition(
      position: _firstHalfAnimation,
      child: SlideTransition(
        position: _secondHalfAnimation,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideTransition(
                position: _welcomeImageAnimation,
                child: Container(
                  constraints: BoxConstraints(maxWidth: 350, maxHeight: 350),
                  child: Image.asset(
                    'assets/images/logo@3x.png',
                    width: MediaQuery.of(context).size.width/2,
                  ),
                ),
              ),
              SizedBox(height: 30,),
              SlideTransition(
                position: _welcomeFirstHalfAnimation,
                child: Text(
                  "أكاديمية أبعاد المعرفة",
                  style: TextStyle(
                      fontSize: 25.0, fontWeight: FontWeight.bold, color: dark),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 64, right: 64, top: 16, bottom: 16),
                child: Text(
                  " منصة تعليمية للتعليم عن بعد أونلاين، والتي تحتوي على العديد من الدورات المباشرة والمسجلة في مختلف المجالات من خلال مدربين مميزين وعلى قدرة عالية في إيصال المعلومات بالطريقة الصحيحة.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: dark),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
