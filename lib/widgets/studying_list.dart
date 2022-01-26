import 'package:eclass/Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/courses_provider.dart';
import 'study_list_item.dart';

// ignore: must_be_immutable
class StudyingList extends StatefulWidget {
  bool _visible;

  StudyingList(this._visible);

  @override
  _StudyingListState createState() => _StudyingListState();
}

class _StudyingListState extends State<StudyingList> {
  @override
  Widget build(BuildContext context) {
    CoursesProvider course = Provider.of<CoursesProvider>(context);
    return widget._visible? Directionality(
      textDirection: rtl,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 20),
              child: Text(
                'دوراتي',
                style: TextStyle(color: dark,fontWeight: FontWeight.bold),
              )),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, idx) => StudyListItem(
                course.studyingList[idx],
                idx,
                course.studyingList.length,
                widget._visible),
            itemCount: course.studyingList.length,
          ),
        ],
      ),
    ):Container();
  }
}
