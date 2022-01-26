import 'package:circle_list/circle_list.dart';
import 'package:eclass/Screens/home_screen.dart';
import 'package:eclass/Screens/overview_page.dart';
import 'package:eclass/Screens/qa_screen.dart';
import 'package:eclass/Screens/quiz/home.dart';
import 'package:eclass/provider/content_provider.dart';
import 'package:eclass/provider/full_course_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'announcement_screen.dart';
import 'appoinment_screen.dart';
import 'assignment_screen.dart';

class MoreScreen extends StatefulWidget {
  MoreScreen(this.courseDetails,this.color);

  final FullCourse courseDetails;
  Color color;

  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  bool _visible = false;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    if (!_disposed) {
      setState(() {
        _visible = false;
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ContentProvider contentProvider =
          Provider.of<ContentProvider>(context, listen: false);
      await contentProvider.getContent(context, widget.courseDetails.course.id);
      if (!_disposed) {
        setState(() {
          _visible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CircleList(
      origin: Offset(0, 0),
      innerCircleRotateWithChildren: false,
      // outerCircleColor: Colors.greenAccent,
      initialAngle: 0,
      childrenPadding: 0,
      rotateMode: RotateMode.onlyChildrenRotate,
      showInitialAnimation: true,
      outerCircleColor: widget.color,
      children: [
        item(
          'ملخص',
          'paper.png',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OverviewPage(widget.courseDetails),
              ),
            );
          },
        ),
        item(
          "سؤال و جواب",
          'conversation.png',
          () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => QAScreen(widget.courseDetails)));
          },
        ),
        item(
          "إعلانات",
          'loudspeaker.png',
          () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AnnouncementScreen()));
          },
        ),
        item(
          "الإختبارات",
          'homework.png',
          () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
        item(
          "ألواجبات",
          'exam.png',
          () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AssignmentScreen(widget.courseDetails)));
          },
        ),
        item(
          "مواعيد",
          'calendar.png',
          () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AppointmentScreen(widget.courseDetails)));
          },
        ),
      ],
    );
  }

  Widget item(String name, icon, Function onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: pink),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/icons/${icon}',height: 30,),
              SizedBox(
                height: 5,
              ),
              Container(
                width: 60,
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold, color: ice),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _disposed = true;
  }
}
