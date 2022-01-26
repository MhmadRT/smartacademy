import '../provider/full_course_detail.dart';

class VideoClip {
  final String fileName;
  final String file;
  final String thumbName;
  final String title;
  final String parent;
  int runningTime;
  int id;

  VideoClip(this.title, this.fileName, this.thumbName, this.runningTime,
      this.parent, this.id, this.file,);

  String videoPath() {
    return "$parent/$fileName";
  }

  String thumbPath() {
    return "$parent/$thumbName";
  }
}

class Section {
  Chapter sectionDetails;
  List<VideoClip> sectionLessons;
  Section(this.sectionDetails, this.sectionLessons);
}
