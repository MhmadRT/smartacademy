import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../common/apidata.dart';
import 'full_course_detail.dart';

class CourseDetailsProvider with ChangeNotifier {
  FullCourse courseDetails;

  Future<FullCourse> getCourseDetails(int id, context) async {
    String url = APIData.courseDetail + "${APIData.secretKey}";
    print(url);
    try {
      final res = await http.post(url, body: {"course_id": id.toString()});
      if (res.statusCode == 200) {
        courseDetails = FullCourse.fromJson(json.decode(res.body));
      } else {
        throw "حدث خطاء في اثناء جلب التفاصيل";
      }
    } catch(error){
      debugPrint(error.toString());
    }
    notifyListeners();
    return courseDetails;
  }

}
