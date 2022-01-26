// To parse this JSON data, do
//
//     final instructorModel = instructorModelFromJson(jsonString);

import 'dart:convert';

InstructorModelList instructorModelFromJson(String str) => InstructorModelList.fromJson(json.decode(str));

String instructorModelToJson(InstructorModelList data) => json.encode(data.toJson());

class InstructorModelList {
  InstructorModelList({
    this.instructors,
  });

  List<InstructorModel> instructors=[];

  factory InstructorModelList.fromJson(Map<String, dynamic> json) => InstructorModelList(
    instructors: json["instructor"] == null ? null : List<InstructorModel>.from(json["instructor"].map((x) => InstructorModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "instructor": instructors == null ? null : List<dynamic>.from(instructors.map((x) => x.toJson())),
  };
}

class InstructorModel {
  InstructorModel({
    this.id,
    this.fname,
    this.lname,
    this.countryId,
    this.gender,
    this.userImg,
    this.userCover,
    this.detail,
    this.fbUrl,
    this.braintreeId,
    this.twitterUrl,
    this.youtubeUrl,
    this.linkedinUrl,
  });

  int id;
  String fname;
  String lname;
  String countryId;
  dynamic gender;
  String userImg;
  dynamic userCover;
  String detail;
  String fbUrl;
  String braintreeId;
  dynamic twitterUrl;
  dynamic youtubeUrl;
  dynamic linkedinUrl;

  factory InstructorModel.fromJson(Map<String, dynamic> json) => InstructorModel(
    id: json["id"] == null ? null : json["id"],
    fname: json["fname"] == null ? null : json["fname"],
    lname: json["lname"] == null ? null : json["lname"],
    countryId: json["country_id"] == null ? null : json["country_id"],
    gender: json["gender"],
    userImg: json["user_img"] == null ? null : json["user_img"],
    userCover: json["user_cover"],
    detail: json["detail"] == null ? null : json["detail"],
    fbUrl: json["fb_url"] == null ? null : json["fb_url"],
    braintreeId: json["braintree_id"] == null ? null : json["braintree_id"],
    twitterUrl: json["twitter_url"],
    youtubeUrl: json["youtube_url"],
    linkedinUrl: json["linkedin_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "fname": fname == null ? null : fname,
    "lname": lname == null ? null : lname,
    "country_id": countryId == null ? null : countryId,
    "gender": gender,
    "user_img": userImg == null ? null : userImg,
    "user_cover": userCover,
    "detail": detail == null ? null : detail,
    "fb_url": fbUrl == null ? null : fbUrl,
    "braintree_id": braintreeId == null ? null : braintreeId,
    "twitter_url": twitterUrl,
    "youtube_url": youtubeUrl,
    "linkedin_url": linkedinUrl,
  };
}
