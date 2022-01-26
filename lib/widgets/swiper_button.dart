import 'package:eclass/Screens/home_screen.dart';
import 'package:flutter/material.dart';

class SwiperButton extends StatefulWidget {
  final Color color;

  SwiperButton( this.color);

  @override
  _SwiperButtonState createState() => _SwiperButtonState();
}

class _SwiperButtonState extends State<SwiperButton> {
  @override
  void initState() {
    // TODO: implement initState
    swipe();
    super.initState();
  }

  swipe() {
    Future.delayed(Duration(milliseconds: 650)).then((value) {
      if(mounted)
      setState(() {
        top = !top;
      });
      swipe();
    });
  }

  bool top = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 250,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(child: Container(),top: 0,bottom: 0,left: 0,right: 0,),
            AnimatedPositioned(
                top: !top ? 15 : 10,
                left: 10,
                right: 10,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  height: top ? 23 : 18,
                  width: top ? 23 : 18,
                  decoration: BoxDecoration(
                    color: widget.color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      if (top)
                        BoxShadow(
                          color: widget.color.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                    ],
                  ),
                ),
                duration: Duration(milliseconds: 350)),
            AnimatedPositioned(
                bottom: !top ? 15 : 20,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 350),
                  opacity: top?1:0,
                  child: Text(
                    'انقر هنا',
                    style: TextStyle(color: widget.color),
                  ),
                ),
                duration: Duration(milliseconds: 350)),
          ],
        ),
      ),
    );
  }
}
