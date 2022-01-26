// To parse this JSON data, do
//
//     final mainApi = mainApiFromJson(jsonString);

import 'dart:convert';

MainApi mainApiFromJson(String str) => MainApi.fromJson(json.decode(str));

String mainApiToJson(MainApi data) => json.encode(data.toJson());

class MainApi {
  MainApi({
    this.bundleCourses,
    this.recentCourses,
    this.homeDetails,
    this.instructor,
    this.courses,
    this.userFaq,
    this.instructorFaq,
    this.coupons,
    this.aboutus,
    this.blog,
    this.blogDetail,
  });

  BundleCourses bundleCourses;
  Courses recentCourses;
  HomeDetails homeDetails;
  Instructor instructor;
  Courses courses;
  RFaq userFaq;
  RFaq instructorFaq;
  Coupons coupons;
  Aboutus aboutus;
  MainApiBlog blog;
  dynamic blogDetail;

  factory MainApi.fromJson(Map<String, dynamic> json) => MainApi(
    bundleCourses: json["Bundle_Courses"] == null ? null : BundleCourses.fromJson(json["Bundle_Courses"]),
    recentCourses: json["Recent_courses"] == null ? null : Courses.fromJson(json["Recent_courses"]),
    homeDetails: json["Home_Details"] == null ? null : HomeDetails.fromJson(json["Home_Details"]),
    instructor: json["instructor"] == null ? null : Instructor.fromJson(json["instructor"]),
    courses: json["courses"] == null ? null : Courses.fromJson(json["courses"]),
    userFaq: json["user_faq"] == null ? null : RFaq.fromJson(json["user_faq"]),
    instructorFaq: json["instructor_faq"] == null ? null : RFaq.fromJson(json["instructor_faq"]),
    coupons: json["coupons"] == null ? null : Coupons.fromJson(json["coupons"]),
    aboutus: json["aboutus"] == null ? null : Aboutus.fromJson(json["aboutus"]),
    blog: json["blog"] == null ? null : MainApiBlog.fromJson(json["blog"]),
    blogDetail: json["blog_detail"],
  );

  Map<String, dynamic> toJson() => {
    "Bundle_Courses": bundleCourses == null ? null : bundleCourses.toJson(),
    "Recent_courses": recentCourses == null ? null : recentCourses.toJson(),
    "Home_Details": homeDetails == null ? null : homeDetails.toJson(),
    "instructor": instructor == null ? null : instructor.toJson(),
    "courses": courses == null ? null : courses.toJson(),
    "user_faq": userFaq == null ? null : userFaq.toJson(),
    "instructor_faq": instructorFaq == null ? null : instructorFaq.toJson(),
    "coupons": coupons == null ? null : coupons.toJson(),
    "aboutus": aboutus == null ? null : aboutus.toJson(),
    "blog": blog == null ? null : blog.toJson(),
    "blog_detail": blogDetail,
  };
}

class Aboutus {
  Aboutus({
    this.about,
  });

  List<About> about;

  factory Aboutus.fromJson(Map<String, dynamic> json) => Aboutus(
    about: json["about"] == null ? null : List<About>.from(json["about"].map((x) => About.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "about": about == null ? null : List<dynamic>.from(about.map((x) => x.toJson())),
  };
}

class About {
  About({
    this.id,
    this.oneEnable,
    this.oneHeading,
    this.oneImage,
    this.oneText,
    this.twoEnable,
    this.twoHeading,
    this.twoText,
    this.twoImageone,
    this.twoImagetwo,
    this.twoImagethree,
    this.twoImagefour,
    this.twoTxtone,
    this.twoTxttwo,
    this.twoTxtthree,
    this.twoTxtfour,
    this.twoImagetext,
    this.threeEnable,
    this.threeHeading,
    this.threeText,
    this.threeCountone,
    this.threeCounttwo,
    this.threeCountthree,
    this.threeCountfour,
    this.threeCountfive,
    this.threeCountsix,
    this.threeTxtone,
    this.threeTxttwo,
    this.threeTxtthree,
    this.threeTxtfour,
    this.threeTxtfive,
    this.threeTxtsix,
    this.fourEnable,
    this.fourHeading,
    this.fourText,
    this.fourBtntext,
    this.fourImageone,
    this.fourImagetwo,
    this.fourTxtone,
    this.fourTxttwo,
    this.fourIcon,
    this.fiveEnable,
    this.fiveHeading,
    this.fiveText,
    this.fiveBtntext,
    this.fiveImageone,
    this.fiveImagetwo,
    this.fiveImagethree,
    this.sixEnable,
    this.sixHeading,
    this.sixTxtone,
    this.sixTxttwo,
    this.sixTxtthree,
    this.sixDeatilone,
    this.sixDeatiltwo,
    this.sixDeatilthree,
    this.textOne,
    this.textTwo,
    this.textThree,
    this.linkOne,
    this.linkTwo,
    this.linkThree,
    this.linkFour,
    this.createdAt,
    this.updatedAt,
    this.linkedin,
    this.twitter,
  });

  int id;
  String oneEnable;
  String oneHeading;
  String oneImage;
  String oneText;
  String twoEnable;
  String twoHeading;
  String twoText;
  String twoImageone;
  String twoImagetwo;
  String twoImagethree;
  String twoImagefour;
  String twoTxtone;
  String twoTxttwo;
  String twoTxtthree;
  String twoTxtfour;
  String twoImagetext;
  String threeEnable;
  String threeHeading;
  String threeText;
  String threeCountone;
  String threeCounttwo;
  String threeCountthree;
  String threeCountfour;
  String threeCountfive;
  String threeCountsix;
  String threeTxtone;
  String threeTxttwo;
  String threeTxtthree;
  String threeTxtfour;
  String threeTxtfive;
  String threeTxtsix;
  String fourEnable;
  String fourHeading;
  String fourText;
  String fourBtntext;
  String fourImageone;
  String fourImagetwo;
  String fourTxtone;
  String fourTxttwo;
  String fourIcon;
  String fiveEnable;
  String fiveHeading;
  String fiveText;
  String fiveBtntext;
  String fiveImageone;
  String fiveImagetwo;
  String fiveImagethree;
  String sixEnable;
  String sixHeading;
  String sixTxtone;
  String sixTxttwo;
  String sixTxtthree;
  String sixDeatilone;
  String sixDeatiltwo;
  String sixDeatilthree;
  String textOne;
  String textTwo;
  String textThree;
  dynamic linkOne;
  dynamic linkTwo;
  dynamic linkThree;
  String linkFour;
  dynamic createdAt;
  DateTime updatedAt;
  dynamic linkedin;
  dynamic twitter;

  factory About.fromJson(Map<String, dynamic> json) => About(
    id: json["id"] == null ? null : json["id"],
    oneEnable: json["one_enable"] == null ? null : json["one_enable"],
    oneHeading: json["one_heading"] == null ? null : json["one_heading"],
    oneImage: json["one_image"] == null ? null : json["one_image"],
    oneText: json["one_text"] == null ? null : json["one_text"],
    twoEnable: json["two_enable"] == null ? null : json["two_enable"],
    twoHeading: json["two_heading"] == null ? null : json["two_heading"],
    twoText: json["two_text"] == null ? null : json["two_text"],
    twoImageone: json["two_imageone"] == null ? null : json["two_imageone"],
    twoImagetwo: json["two_imagetwo"] == null ? null : json["two_imagetwo"],
    twoImagethree: json["two_imagethree"] == null ? null : json["two_imagethree"],
    twoImagefour: json["two_imagefour"] == null ? null : json["two_imagefour"],
    twoTxtone: json["two_txtone"] == null ? null : json["two_txtone"],
    twoTxttwo: json["two_txttwo"] == null ? null : json["two_txttwo"],
    twoTxtthree: json["two_txtthree"] == null ? null : json["two_txtthree"],
    twoTxtfour: json["two_txtfour"] == null ? null : json["two_txtfour"],
    twoImagetext: json["two_imagetext"] == null ? null : json["two_imagetext"],
    threeEnable: json["three_enable"] == null ? null : json["three_enable"],
    threeHeading: json["three_heading"] == null ? null : json["three_heading"],
    threeText: json["three_text"] == null ? null : json["three_text"],
    threeCountone: json["three_countone"] == null ? null : json["three_countone"],
    threeCounttwo: json["three_counttwo"] == null ? null : json["three_counttwo"],
    threeCountthree: json["three_countthree"] == null ? null : json["three_countthree"],
    threeCountfour: json["three_countfour"] == null ? null : json["three_countfour"],
    threeCountfive: json["three_countfive"] == null ? null : json["three_countfive"],
    threeCountsix: json["three_countsix"] == null ? null : json["three_countsix"],
    threeTxtone: json["three_txtone"] == null ? null : json["three_txtone"],
    threeTxttwo: json["three_txttwo"] == null ? null : json["three_txttwo"],
    threeTxtthree: json["three_txtthree"] == null ? null : json["three_txtthree"],
    threeTxtfour: json["three_txtfour"] == null ? null : json["three_txtfour"],
    threeTxtfive: json["three_txtfive"] == null ? null : json["three_txtfive"],
    threeTxtsix: json["three_txtsix"] == null ? null : json["three_txtsix"],
    fourEnable: json["four_enable"] == null ? null : json["four_enable"],
    fourHeading: json["four_heading"] == null ? null : json["four_heading"],
    fourText: json["four_text"] == null ? null : json["four_text"],
    fourBtntext: json["four_btntext"] == null ? null : json["four_btntext"],
    fourImageone: json["four_imageone"] == null ? null : json["four_imageone"],
    fourImagetwo: json["four_imagetwo"] == null ? null : json["four_imagetwo"],
    fourTxtone: json["four_txtone"] == null ? null : json["four_txtone"],
    fourTxttwo: json["four_txttwo"] == null ? null : json["four_txttwo"],
    fourIcon: json["four_icon"] == null ? null : json["four_icon"],
    fiveEnable: json["five_enable"] == null ? null : json["five_enable"],
    fiveHeading: json["five_heading"] == null ? null : json["five_heading"],
    fiveText: json["five_text"] == null ? null : json["five_text"],
    fiveBtntext: json["five_btntext"] == null ? null : json["five_btntext"],
    fiveImageone: json["five_imageone"] == null ? null : json["five_imageone"],
    fiveImagetwo: json["five_imagetwo"] == null ? null : json["five_imagetwo"],
    fiveImagethree: json["five_imagethree"] == null ? null : json["five_imagethree"],
    sixEnable: json["six_enable"] == null ? null : json["six_enable"],
    sixHeading: json["six_heading"] == null ? null : json["six_heading"],
    sixTxtone: json["six_txtone"] == null ? null : json["six_txtone"],
    sixTxttwo: json["six_txttwo"] == null ? null : json["six_txttwo"],
    sixTxtthree: json["six_txtthree"] == null ? null : json["six_txtthree"],
    sixDeatilone: json["six_deatilone"] == null ? null : json["six_deatilone"],
    sixDeatiltwo: json["six_deatiltwo"] == null ? null : json["six_deatiltwo"],
    sixDeatilthree: json["six_deatilthree"] == null ? null : json["six_deatilthree"],
    textOne: json["text_one"] == null ? null : json["text_one"],
    textTwo: json["text_two"] == null ? null : json["text_two"],
    textThree: json["text_three"] == null ? null : json["text_three"],
    linkOne: json["link_one"],
    linkTwo: json["link_two"],
    linkThree: json["link_three"],
    linkFour: json["link_four"] == null ? null : json["link_four"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    linkedin: json["linkedin"],
    twitter: json["twitter"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "one_enable": oneEnable == null ? null : oneEnable,
    "one_heading": oneHeading == null ? null : oneHeading,
    "one_image": oneImage == null ? null : oneImage,
    "one_text": oneText == null ? null : oneText,
    "two_enable": twoEnable == null ? null : twoEnable,
    "two_heading": twoHeading == null ? null : twoHeading,
    "two_text": twoText == null ? null : twoText,
    "two_imageone": twoImageone == null ? null : twoImageone,
    "two_imagetwo": twoImagetwo == null ? null : twoImagetwo,
    "two_imagethree": twoImagethree == null ? null : twoImagethree,
    "two_imagefour": twoImagefour == null ? null : twoImagefour,
    "two_txtone": twoTxtone == null ? null : twoTxtone,
    "two_txttwo": twoTxttwo == null ? null : twoTxttwo,
    "two_txtthree": twoTxtthree == null ? null : twoTxtthree,
    "two_txtfour": twoTxtfour == null ? null : twoTxtfour,
    "two_imagetext": twoImagetext == null ? null : twoImagetext,
    "three_enable": threeEnable == null ? null : threeEnable,
    "three_heading": threeHeading == null ? null : threeHeading,
    "three_text": threeText == null ? null : threeText,
    "three_countone": threeCountone == null ? null : threeCountone,
    "three_counttwo": threeCounttwo == null ? null : threeCounttwo,
    "three_countthree": threeCountthree == null ? null : threeCountthree,
    "three_countfour": threeCountfour == null ? null : threeCountfour,
    "three_countfive": threeCountfive == null ? null : threeCountfive,
    "three_countsix": threeCountsix == null ? null : threeCountsix,
    "three_txtone": threeTxtone == null ? null : threeTxtone,
    "three_txttwo": threeTxttwo == null ? null : threeTxttwo,
    "three_txtthree": threeTxtthree == null ? null : threeTxtthree,
    "three_txtfour": threeTxtfour == null ? null : threeTxtfour,
    "three_txtfive": threeTxtfive == null ? null : threeTxtfive,
    "three_txtsix": threeTxtsix == null ? null : threeTxtsix,
    "four_enable": fourEnable == null ? null : fourEnable,
    "four_heading": fourHeading == null ? null : fourHeading,
    "four_text": fourText == null ? null : fourText,
    "four_btntext": fourBtntext == null ? null : fourBtntext,
    "four_imageone": fourImageone == null ? null : fourImageone,
    "four_imagetwo": fourImagetwo == null ? null : fourImagetwo,
    "four_txtone": fourTxtone == null ? null : fourTxtone,
    "four_txttwo": fourTxttwo == null ? null : fourTxttwo,
    "four_icon": fourIcon == null ? null : fourIcon,
    "five_enable": fiveEnable == null ? null : fiveEnable,
    "five_heading": fiveHeading == null ? null : fiveHeading,
    "five_text": fiveText == null ? null : fiveText,
    "five_btntext": fiveBtntext == null ? null : fiveBtntext,
    "five_imageone": fiveImageone == null ? null : fiveImageone,
    "five_imagetwo": fiveImagetwo == null ? null : fiveImagetwo,
    "five_imagethree": fiveImagethree == null ? null : fiveImagethree,
    "six_enable": sixEnable == null ? null : sixEnable,
    "six_heading": sixHeading == null ? null : sixHeading,
    "six_txtone": sixTxtone == null ? null : sixTxtone,
    "six_txttwo": sixTxttwo == null ? null : sixTxttwo,
    "six_txtthree": sixTxtthree == null ? null : sixTxtthree,
    "six_deatilone": sixDeatilone == null ? null : sixDeatilone,
    "six_deatiltwo": sixDeatiltwo == null ? null : sixDeatiltwo,
    "six_deatilthree": sixDeatilthree == null ? null : sixDeatilthree,
    "text_one": textOne == null ? null : textOne,
    "text_two": textTwo == null ? null : textTwo,
    "text_three": textThree == null ? null : textThree,
    "link_one": linkOne,
    "link_two": linkTwo,
    "link_three": linkThree,
    "link_four": linkFour == null ? null : linkFour,
    "created_at": createdAt,
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    "linkedin": linkedin,
    "twitter": twitter,
  };
}

class MainApiBlog {
  MainApiBlog({
    this.blog,
  });

  List<BlogElement> blog;

  factory MainApiBlog.fromJson(Map<String, dynamic> json) => MainApiBlog(
    blog: json["blog"] == null ? null : List<BlogElement>.from(json["blog"].map((x) => BlogElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "blog": blog == null ? null : List<dynamic>.from(blog.map((x) => x.toJson())),
  };
}

class BlogElement {
  BlogElement({
    this.id,
    this.userId,
    this.date,
    this.image,
    this.heading,
    this.detail,
    this.text,
    this.approved,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String userId;
  DateTime date;
  String image;
  String heading;
  String detail;
  String text;
  String approved;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  factory BlogElement.fromJson(Map<String, dynamic> json) => BlogElement(
    id: json["id"] == null ? null : json["id"],
    userId: json["user_id"] == null ? null : json["user_id"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    image: json["image"] == null ? null : json["image"],
    heading: json["heading"] == null ? null : json["heading"],
    detail: json["detail"] == null ? null : json["detail"],
    text: json["text"] == null ? null : json["text"],
    approved: json["approved"] == null ? null : json["approved"],
    status: json["status"] == null ? null : json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "user_id": userId == null ? null : userId,
    "date": date == null ? null : "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "image": image == null ? null : image,
    "heading": heading == null ? null : heading,
    "detail": detail == null ? null : detail,
    "text": text == null ? null : text,
    "approved": approved == null ? null : approved,
    "status": status == null ? null : status,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
  };
}

class BundleCourses {
  BundleCourses({
    this.bundle,
  });

  List<dynamic> bundle;

  factory BundleCourses.fromJson(Map<String, dynamic> json) => BundleCourses(
    bundle: json["bundle"] == null ? null : List<dynamic>.from(json["bundle"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "bundle": bundle == null ? null : List<dynamic>.from(bundle.map((x) => x)),
  };
}

class Coupons {
  Coupons({
    this.coupon,
  });

  List<Coupon> coupon;

  factory Coupons.fromJson(Map<String, dynamic> json) => Coupons(
    coupon: json["coupon"] == null ? null : List<Coupon>.from(json["coupon"].map((x) => Coupon.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "coupon": coupon == null ? null : List<dynamic>.from(coupon.map((x) => x.toJson())),
  };
}

class Coupon {
  Coupon({
    this.id,
    this.code,
    this.distype,
    this.amount,
    this.linkBy,
    this.courseId,
    this.categoryId,
    this.maxusage,
    this.minamount,
    this.expirydate,
    this.createdAt,
    this.updatedAt,
    this.bundleId,
    this.stripeCouponId,
    this.showToUsers,
  });

  int id;
  String code;
  String distype;
  String amount;
  String linkBy;
  dynamic courseId;
  dynamic categoryId;
  String maxusage;
  String minamount;
  DateTime expirydate;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic bundleId;
  dynamic stripeCouponId;
  String showToUsers;

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
    id: json["id"] == null ? null : json["id"],
    code: json["code"] == null ? null : json["code"],
    distype: json["distype"] == null ? null : json["distype"],
    amount: json["amount"] == null ? null : json["amount"],
    linkBy: json["link_by"] == null ? null : json["link_by"],
    courseId: json["course_id"],
    categoryId: json["category_id"],
    maxusage: json["maxusage"] == null ? null : json["maxusage"],
    minamount: json["minamount"] == null ? null : json["minamount"],
    expirydate: json["expirydate"] == null ? null : DateTime.parse(json["expirydate"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    bundleId: json["bundle_id"],
    stripeCouponId: json["stripe_coupon_id"],
    showToUsers: json["show_to_users"] == null ? null : json["show_to_users"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "code": code == null ? null : code,
    "distype": distype == null ? null : distype,
    "amount": amount == null ? null : amount,
    "link_by": linkBy == null ? null : linkBy,
    "course_id": courseId,
    "category_id": categoryId,
    "maxusage": maxusage == null ? null : maxusage,
    "minamount": minamount == null ? null : minamount,
    "expirydate": expirydate == null ? null : expirydate.toIso8601String(),
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    "bundle_id": bundleId,
    "stripe_coupon_id": stripeCouponId,
    "show_to_users": showToUsers == null ? null : showToUsers,
  };
}

class Courses {
  Courses({
    this.course,
  });

  List<Course> course;

  factory Courses.fromJson(Map<String, dynamic> json) => Courses(
    course: json["course"] == null ? null : List<Course>.from(json["course"].map((x) => Course.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "course": course == null ? null : List<dynamic>.from(course.map((x) => x.toJson())),
  };
}

class Course {
  Course({
    this.id,
    this.userId,
    this.categoryId,
    this.subcategoryId,
    this.childcategoryId,
    this.languageId,
    this.title,
    this.shortDetail,
    this.detail,
    this.requirement,
    this.price,
    this.discountPrice,
    this.day,
    this.video,
    this.url,
    this.featured,
    this.slug,
    this.status,
    this.previewImage,
    this.videoUrl,
    this.previewType,
    this.type,
    this.duration,
    this.createdAt,
    this.updatedAt,
    this.durationType,
    this.instructorRevenue,
    this.involvementRequest,
    this.refundPolicyId,
    this.levelTags,
    this.assignmentEnable,
    this.appointmentEnable,
    this.certificateEnable,
    this.courseTags,
    this.rejectTxt,
    this.include,
    this.whatlearns,
    this.review,
  });

  int id;
  String userId;
  String categoryId;
  String subcategoryId;
  String childcategoryId;
  String languageId;
  String title;
  String shortDetail;
  String detail;
  String requirement;
  String price;
  String discountPrice;
  dynamic day;
  dynamic video;
  String url;
  String featured;
  String slug;
  String status;
  String previewImage;
  dynamic videoUrl;
  String previewType;
  String type;
  String duration;
  DateTime createdAt;
  DateTime updatedAt;
  String durationType;
  String instructorRevenue;
  String involvementRequest;
  dynamic refundPolicyId;
  String levelTags;
  String assignmentEnable;
  String appointmentEnable;
  String certificateEnable;
  List<String> courseTags;
  dynamic rejectTxt;
  List<Include> include;
  List<Include> whatlearns;
  List<dynamic> review;

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    id: json["id"] == null ? null : json["id"],
    userId: json["user_id"] == null ? null : json["user_id"],
    categoryId: json["category_id"] == null ? null : json["category_id"],
    subcategoryId: json["subcategory_id"] == null ? null : json["subcategory_id"],
    childcategoryId: json["childcategory_id"] == null ? null : json["childcategory_id"],
    languageId: json["language_id"] == null ? null : json["language_id"],
    title: json["title"] == null ? null : json["title"],
    shortDetail: json["short_detail"] == null ? null : json["short_detail"],
    detail: json["detail"] == null ? null : json["detail"],
    requirement: json["requirement"] == null ? null : json["requirement"],
    price: json["price"] == null ? null : json["price"],
    discountPrice: json["discount_price"] == null ? null : json["discount_price"],
    day: json["day"],
    video: json["video"],
    url: json["url"] == null ? null : json["url"],
    featured: json["featured"] == null ? null : json["featured"],
    slug: json["slug"] == null ? null : json["slug"],
    status: json["status"] == null ? null : json["status"],
    previewImage: json["preview_image"] == null ? null : json["preview_image"],
    videoUrl: json["video_url"],
    previewType: json["preview_type"] == null ? null : json["preview_type"],
    type: json["type"] == null ? null : json["type"],
    duration: json["duration"] == null ? null : json["duration"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    durationType: json["duration_type"] == null ? null : json["duration_type"],
    instructorRevenue: json["instructor_revenue"] == null ? null : json["instructor_revenue"],
    involvementRequest: json["involvement_request"] == null ? null : json["involvement_request"],
    refundPolicyId: json["refund_policy_id"],
    levelTags: json["level_tags"] == null ? null : json["level_tags"],
    assignmentEnable: json["assignment_enable"] == null ? null : json["assignment_enable"],
    appointmentEnable: json["appointment_enable"] == null ? null : json["appointment_enable"],
    certificateEnable: json["certificate_enable"] == null ? null : json["certificate_enable"],
    courseTags: json["course_tags"] == null ? null : List<String>.from(json["course_tags"].map((x) => x == null ? null : x)),
    rejectTxt: json["reject_txt"],
    include: json["include"] == null ? null : List<Include>.from(json["include"].map((x) => Include.fromJson(x))),
    whatlearns: json["whatlearns"] == null ? null : List<Include>.from(json["whatlearns"].map((x) => Include.fromJson(x))),
    review: json["review"] == null ? null : List<dynamic>.from(json["review"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "user_id": userId == null ? null : userId,
    "category_id": categoryId == null ? null : categoryId,
    "subcategory_id": subcategoryId == null ? null : subcategoryId,
    "childcategory_id": childcategoryId == null ? null : childcategoryId,
    "language_id": languageId == null ? null : languageId,
    "title": title == null ? null : title,
    "short_detail": shortDetail == null ? null : shortDetail,
    "detail": detail == null ? null : detail,
    "requirement": requirement == null ? null : requirement,
    "price": price == null ? null : price,
    "discount_price": discountPrice == null ? null : discountPrice,
    "day": day,
    "video": video,
    "url": url == null ? null : url,
    "featured": featured == null ? null : featured,
    "slug": slug == null ? null : slug,
    "status": status == null ? null : status,
    "preview_image": previewImage == null ? null : previewImage,
    "video_url": videoUrl,
    "preview_type": previewType == null ? null : previewType,
    "type": type == null ? null : type,
    "duration": duration == null ? null : duration,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    "duration_type": durationType == null ? null : durationType,
    "instructor_revenue": instructorRevenue == null ? null : instructorRevenue,
    "involvement_request": involvementRequest == null ? null : involvementRequest,
    "refund_policy_id": refundPolicyId,
    "level_tags": levelTags == null ? null : levelTags,
    "assignment_enable": assignmentEnable == null ? null : assignmentEnable,
    "appointment_enable": appointmentEnable == null ? null : appointmentEnable,
    "certificate_enable": certificateEnable == null ? null : certificateEnable,
    "course_tags": courseTags == null ? null : List<dynamic>.from(courseTags.map((x) => x == null ? null : x)),
    "reject_txt": rejectTxt,
    "include": include == null ? null : List<dynamic>.from(include.map((x) => x.toJson())),
    "whatlearns": whatlearns == null ? null : List<dynamic>.from(whatlearns.map((x) => x.toJson())),
    "review": review == null ? null : List<dynamic>.from(review.map((x) => x)),
  };
}

class Include {
  Include({
    this.id,
    this.courseId,
    this.item,
    this.icon,
    this.detail,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String courseId;
  dynamic item;
  String icon;
  String detail;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  factory Include.fromJson(Map<String, dynamic> json) => Include(
    id: json["id"] == null ? null : json["id"],
    courseId: json["course_id"] == null ? null : json["course_id"],
    item: json["item"],
    icon: json["icon"] == null ? null : json["icon"],
    detail: json["detail"] == null ? null : json["detail"],
    status: json["status"] == null ? null : json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "course_id": courseId == null ? null : courseId,
    "item": item,
    "icon": icon == null ? null : icon,
    "detail": detail == null ? null : detail,
    "status": status == null ? null : status,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
  };
}

class HomeDetails {
  HomeDetails({
    this.settings,
    this.adsense,
    this.currency,
    this.slider,
    this.sliderfacts,
    this.trusted,
    this.testimonial,
    this.category,
    this.subcategory,
    this.childcategory,
    this.featuredCate,
    this.meeting,
  });

  Settings settings;
  dynamic adsense;
  Currency currency;
  List<Slider> slider;
  List<Sliderfact> sliderfacts;
  List<Trusted> trusted;
  List<Testimonial> testimonial;
  List<Category> category;
  List<Subcategory> subcategory;
  List<dynamic> childcategory;
  List<Category> featuredCate;
  List<dynamic> meeting;

  factory HomeDetails.fromJson(Map<String, dynamic> json) => HomeDetails(
    settings: json["settings"] == null ? null : Settings.fromJson(json["settings"]),
    adsense: json["adsense"],
    currency: json["currency"] == null ? null : Currency.fromJson(json["currency"]),
    slider: json["slider"] == null ? null : List<Slider>.from(json["slider"].map((x) => Slider.fromJson(x))),
    sliderfacts: json["sliderfacts"] == null ? null : List<Sliderfact>.from(json["sliderfacts"].map((x) => Sliderfact.fromJson(x))),
    trusted: json["trusted"] == null ? null : List<Trusted>.from(json["trusted"].map((x) => Trusted.fromJson(x))),
    testimonial: json["testimonial"] == null ? null : List<Testimonial>.from(json["testimonial"].map((x) => Testimonial.fromJson(x))),
    category: json["category"] == null ? null : List<Category>.from(json["category"].map((x) => Category.fromJson(x))),
    subcategory: json["subcategory"] == null ? null : List<Subcategory>.from(json["subcategory"].map((x) => Subcategory.fromJson(x))),
    childcategory: json["childcategory"] == null ? null : List<dynamic>.from(json["childcategory"].map((x) => x)),
    featuredCate: json["featured_cate"] == null ? null : List<Category>.from(json["featured_cate"].map((x) => Category.fromJson(x))),
    meeting: json["meeting"] == null ? null : List<dynamic>.from(json["meeting"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "settings": settings == null ? null : settings.toJson(),
    "adsense": adsense,
    "currency": currency == null ? null : currency.toJson(),
    "slider": slider == null ? null : List<dynamic>.from(slider.map((x) => x.toJson())),
    "sliderfacts": sliderfacts == null ? null : List<dynamic>.from(sliderfacts.map((x) => x.toJson())),
    "trusted": trusted == null ? null : List<dynamic>.from(trusted.map((x) => x.toJson())),
    "testimonial": testimonial == null ? null : List<dynamic>.from(testimonial.map((x) => x.toJson())),
    "category": category == null ? null : List<dynamic>.from(category.map((x) => x.toJson())),
    "subcategory": subcategory == null ? null : List<dynamic>.from(subcategory.map((x) => x.toJson())),
    "childcategory": childcategory == null ? null : List<dynamic>.from(childcategory.map((x) => x)),
    "featured_cate": featuredCate == null ? null : List<dynamic>.from(featuredCate.map((x) => x.toJson())),
    "meeting": meeting == null ? null : List<dynamic>.from(meeting.map((x) => x)),
  };
}

class Category {
  Category({
    this.id,
    this.title,
    this.icon,
    this.slug,
    this.featured,
    this.status,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.catImage,
  });

  int id;
  String title;
  String icon;
  String slug;
  String featured;
  String status;
  String position;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic catImage;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"] == null ? null : json["id"],
    title: json["title"] == null ? null : json["title"],
    icon: json["icon"] == null ? null : json["icon"],
    slug: json["slug"] == null ? null : json["slug"],
    featured: json["featured"] == null ? null : json["featured"],
    status: json["status"] == null ? null : json["status"],
    position: json["position"] == null ? null : json["position"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    catImage: json["cat_image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "title": title == null ? null : title,
    "icon": icon == null ? null : icon,
    "slug": slug == null ? null : slug,
    "featured": featured == null ? null : featured,
    "status": status == null ? null : status,
    "position": position == null ? null : position,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    "cat_image": catImage,
  };
}

class Currency {
  Currency({
    this.id,
    this.icon,
    this.currency,
    this.currencyDefault,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String icon;
  String currency;
  String currencyDefault;
  DateTime createdAt;
  DateTime updatedAt;

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
    id: json["id"] == null ? null : json["id"],
    icon: json["icon"] == null ? null : json["icon"],
    currency: json["currency"] == null ? null : json["currency"],
    currencyDefault: json["default"] == null ? null : json["default"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "icon": icon == null ? null : icon,
    "currency": currency == null ? null : currency,
    "default": currencyDefault == null ? null : currencyDefault,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
  };
}

class Settings {
  Settings({
    this.id,
    this.projectTitle,
    this.logo,
    this.favicon,
    this.cpyTxt,
    this.logoType,
    this.rightclick,
    this.inspect,
    this.metaDataDesc,
    this.metaDataKeyword,
    this.googleAna,
    this.fbPixel,
    this.fbLoginEnable,
    this.googleLoginEnable,
    this.gitlabLoginEnable,
    this.stripeEnable,
    this.instamojoEnable,
    this.paypalEnable,
    this.paytmEnable,
    this.braintreeEnable,
    this.razorpayEnable,
    this.paystackEnable,
    this.wEmailEnable,
    this.verifyEnable,
    this.welEmail,
    this.defaultAddress,
    this.defaultPhone,
    this.instructorEnable,
    this.debugEnable,
    this.catEnable,
    this.featureAmount,
    this.preloaderEnable,
    this.zoomEnable,
    this.amazonEnable,
    this.captchaEnable,
    this.bblEnable,
    this.mapLat,
    this.mapLong,
    this.mapEnable,
    this.contactImage,
    this.mobileEnable,
    this.promoEnable,
    this.promoText,
    this.promoLink,
    this.linkedinEnable,
    this.mapApi,
    this.twitterEnable,
    this.awsEnable,
    this.certificateEnable,
    this.deviceControl,
    this.ipblockEnable,
    this.ipblock,
    this.assignmentEnable,
    this.appointmentEnable,
    this.createdAt,
    this.updatedAt,
    this.hideIdentity,
    this.footerLogo,
    this.enableOmise,
    this.enablePayu,
    this.enableMoli,
    this.enableCashfree,
    this.enableSkrill,
    this.enableRave,
    this.preloaderLogo,
    this.chatBubble,
    this.wappPhone,
    this.wappPopupMsg,
    this.wappTitle,
    this.wappPosition,
    this.wappColor,
    this.wappEnable,
    this.enablePayhere,
    this.appDownload,
    this.appLink,
    this.playDownload,
    this.playLink,
    this.iyzicoEnable,
    this.courseHover,
    this.sslEnable,
    this.currencySwipe,
    this.attandanceEnable,
    this.youtubeEnable,
    this.vimeoEnable,
    this.aamarpayEnable,
    this.activityEnable,
    this.twilioEnable,
    this.planEnable,
    this.googlemeetEnable,
    this.cookieEnable,
    this.jitsimeetEnable,
    this.payflexiEnable,
  });

  int id;
  String projectTitle;
  String logo;
  String favicon;
  String cpyTxt;
  String logoType;
  String rightclick;
  String inspect;
  dynamic metaDataDesc;
  dynamic metaDataKeyword;
  dynamic googleAna;
  dynamic fbPixel;
  String fbLoginEnable;
  String googleLoginEnable;
  String gitlabLoginEnable;
  String stripeEnable;
  String instamojoEnable;
  String paypalEnable;
  String paytmEnable;
  String braintreeEnable;
  String razorpayEnable;
  String paystackEnable;
  String wEmailEnable;
  String verifyEnable;
  String welEmail;
  String defaultAddress;
  String defaultPhone;
  String instructorEnable;
  String debugEnable;
  String catEnable;
  dynamic featureAmount;
  String preloaderEnable;
  String zoomEnable;
  String amazonEnable;
  String captchaEnable;
  String bblEnable;
  dynamic mapLat;
  dynamic mapLong;
  String mapEnable;
  dynamic contactImage;
  String mobileEnable;
  String promoEnable;
  String promoText;
  String promoLink;
  String linkedinEnable;
  dynamic mapApi;
  String twitterEnable;
  String awsEnable;
  String certificateEnable;
  String deviceControl;
  String ipblockEnable;
  dynamic ipblock;
  String assignmentEnable;
  String appointmentEnable;
  dynamic createdAt;
  DateTime updatedAt;
  String hideIdentity;
  dynamic footerLogo;
  String enableOmise;
  String enablePayu;
  String enableMoli;
  String enableCashfree;
  String enableSkrill;
  String enableRave;
  dynamic preloaderLogo;
  dynamic chatBubble;
  String wappPhone;
  String wappPopupMsg;
  String wappTitle;
  String wappPosition;
  String wappColor;
  String wappEnable;
  String enablePayhere;
  String appDownload;
  String appLink;
  String playDownload;
  String playLink;
  String iyzicoEnable;
  String courseHover;
  String sslEnable;
  String currencySwipe;
  String attandanceEnable;
  String youtubeEnable;
  String vimeoEnable;
  String aamarpayEnable;
  String activityEnable;
  String twilioEnable;
  String planEnable;
  String googlemeetEnable;
  String cookieEnable;
  String jitsimeetEnable;
  String payflexiEnable;

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    id: json["id"] == null ? null : json["id"],
    projectTitle: json["project_title"] == null ? null : json["project_title"],
    logo: json["logo"] == null ? null : json["logo"],
    favicon: json["favicon"] == null ? null : json["favicon"],
    cpyTxt: json["cpy_txt"] == null ? null : json["cpy_txt"],
    logoType: json["logo_type"] == null ? null : json["logo_type"],
    rightclick: json["rightclick"] == null ? null : json["rightclick"],
    inspect: json["inspect"] == null ? null : json["inspect"],
    metaDataDesc: json["meta_data_desc"],
    metaDataKeyword: json["meta_data_keyword"],
    googleAna: json["google_ana"],
    fbPixel: json["fb_pixel"],
    fbLoginEnable: json["fb_login_enable"] == null ? null : json["fb_login_enable"],
    googleLoginEnable: json["google_login_enable"] == null ? null : json["google_login_enable"],
    gitlabLoginEnable: json["gitlab_login_enable"] == null ? null : json["gitlab_login_enable"],
    stripeEnable: json["stripe_enable"] == null ? null : json["stripe_enable"],
    instamojoEnable: json["instamojo_enable"] == null ? null : json["instamojo_enable"],
    paypalEnable: json["paypal_enable"] == null ? null : json["paypal_enable"],
    paytmEnable: json["paytm_enable"] == null ? null : json["paytm_enable"],
    braintreeEnable: json["braintree_enable"] == null ? null : json["braintree_enable"],
    razorpayEnable: json["razorpay_enable"] == null ? null : json["razorpay_enable"],
    paystackEnable: json["paystack_enable"] == null ? null : json["paystack_enable"],
    wEmailEnable: json["w_email_enable"] == null ? null : json["w_email_enable"],
    verifyEnable: json["verify_enable"] == null ? null : json["verify_enable"],
    welEmail: json["wel_email"] == null ? null : json["wel_email"],
    defaultAddress: json["default_address"] == null ? null : json["default_address"],
    defaultPhone: json["default_phone"] == null ? null : json["default_phone"],
    instructorEnable: json["instructor_enable"] == null ? null : json["instructor_enable"],
    debugEnable: json["debug_enable"] == null ? null : json["debug_enable"],
    catEnable: json["cat_enable"] == null ? null : json["cat_enable"],
    featureAmount: json["feature_amount"],
    preloaderEnable: json["preloader_enable"] == null ? null : json["preloader_enable"],
    zoomEnable: json["zoom_enable"] == null ? null : json["zoom_enable"],
    amazonEnable: json["amazon_enable"] == null ? null : json["amazon_enable"],
    captchaEnable: json["captcha_enable"] == null ? null : json["captcha_enable"],
    bblEnable: json["bbl_enable"] == null ? null : json["bbl_enable"],
    mapLat: json["map_lat"],
    mapLong: json["map_long"],
    mapEnable: json["map_enable"] == null ? null : json["map_enable"],
    contactImage: json["contact_image"],
    mobileEnable: json["mobile_enable"] == null ? null : json["mobile_enable"],
    promoEnable: json["promo_enable"] == null ? null : json["promo_enable"],
    promoText: json["promo_text"] == null ? null : json["promo_text"],
    promoLink: json["promo_link"] == null ? null : json["promo_link"],
    linkedinEnable: json["linkedin_enable"] == null ? null : json["linkedin_enable"],
    mapApi: json["map_api"],
    twitterEnable: json["twitter_enable"] == null ? null : json["twitter_enable"],
    awsEnable: json["aws_enable"] == null ? null : json["aws_enable"],
    certificateEnable: json["certificate_enable"] == null ? null : json["certificate_enable"],
    deviceControl: json["device_control"] == null ? null : json["device_control"],
    ipblockEnable: json["ipblock_enable"] == null ? null : json["ipblock_enable"],
    ipblock: json["ipblock"],
    assignmentEnable: json["assignment_enable"] == null ? null : json["assignment_enable"],
    appointmentEnable: json["appointment_enable"] == null ? null : json["appointment_enable"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    hideIdentity: json["hide_identity"] == null ? null : json["hide_identity"],
    footerLogo: json["footer_logo"],
    enableOmise: json["enable_omise"] == null ? null : json["enable_omise"],
    enablePayu: json["enable_payu"] == null ? null : json["enable_payu"],
    enableMoli: json["enable_moli"] == null ? null : json["enable_moli"],
    enableCashfree: json["enable_cashfree"] == null ? null : json["enable_cashfree"],
    enableSkrill: json["enable_skrill"] == null ? null : json["enable_skrill"],
    enableRave: json["enable_rave"] == null ? null : json["enable_rave"],
    preloaderLogo: json["preloader_logo"],
    chatBubble: json["chat_bubble"],
    wappPhone: json["wapp_phone"] == null ? null : json["wapp_phone"],
    wappPopupMsg: json["wapp_popup_msg"] == null ? null : json["wapp_popup_msg"],
    wappTitle: json["wapp_title"] == null ? null : json["wapp_title"],
    wappPosition: json["wapp_position"] == null ? null : json["wapp_position"],
    wappColor: json["wapp_color"] == null ? null : json["wapp_color"],
    wappEnable: json["wapp_enable"] == null ? null : json["wapp_enable"],
    enablePayhere: json["enable_payhere"] == null ? null : json["enable_payhere"],
    appDownload: json["app_download"] == null ? null : json["app_download"],
    appLink: json["app_link"] == null ? null : json["app_link"],
    playDownload: json["play_download"] == null ? null : json["play_download"],
    playLink: json["play_link"] == null ? null : json["play_link"],
    iyzicoEnable: json["iyzico_enable"] == null ? null : json["iyzico_enable"],
    courseHover: json["course_hover"] == null ? null : json["course_hover"],
    sslEnable: json["ssl_enable"] == null ? null : json["ssl_enable"],
    currencySwipe: json["currency_swipe"] == null ? null : json["currency_swipe"],
    attandanceEnable: json["attandance_enable"] == null ? null : json["attandance_enable"],
    youtubeEnable: json["youtube_enable"] == null ? null : json["youtube_enable"],
    vimeoEnable: json["vimeo_enable"] == null ? null : json["vimeo_enable"],
    aamarpayEnable: json["aamarpay_enable"] == null ? null : json["aamarpay_enable"],
    activityEnable: json["activity_enable"] == null ? null : json["activity_enable"],
    twilioEnable: json["twilio_enable"] == null ? null : json["twilio_enable"],
    planEnable: json["plan_enable"] == null ? null : json["plan_enable"],
    googlemeetEnable: json["googlemeet_enable"] == null ? null : json["googlemeet_enable"],
    cookieEnable: json["cookie_enable"] == null ? null : json["cookie_enable"],
    jitsimeetEnable: json["jitsimeet_enable"] == null ? null : json["jitsimeet_enable"],
    payflexiEnable: json["payflexi_enable"] == null ? null : json["payflexi_enable"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "project_title": projectTitle == null ? null : projectTitle,
    "logo": logo == null ? null : logo,
    "favicon": favicon == null ? null : favicon,
    "cpy_txt": cpyTxt == null ? null : cpyTxt,
    "logo_type": logoType == null ? null : logoType,
    "rightclick": rightclick == null ? null : rightclick,
    "inspect": inspect == null ? null : inspect,
    "meta_data_desc": metaDataDesc,
    "meta_data_keyword": metaDataKeyword,
    "google_ana": googleAna,
    "fb_pixel": fbPixel,
    "fb_login_enable": fbLoginEnable == null ? null : fbLoginEnable,
    "google_login_enable": googleLoginEnable == null ? null : googleLoginEnable,
    "gitlab_login_enable": gitlabLoginEnable == null ? null : gitlabLoginEnable,
    "stripe_enable": stripeEnable == null ? null : stripeEnable,
    "instamojo_enable": instamojoEnable == null ? null : instamojoEnable,
    "paypal_enable": paypalEnable == null ? null : paypalEnable,
    "paytm_enable": paytmEnable == null ? null : paytmEnable,
    "braintree_enable": braintreeEnable == null ? null : braintreeEnable,
    "razorpay_enable": razorpayEnable == null ? null : razorpayEnable,
    "paystack_enable": paystackEnable == null ? null : paystackEnable,
    "w_email_enable": wEmailEnable == null ? null : wEmailEnable,
    "verify_enable": verifyEnable == null ? null : verifyEnable,
    "wel_email": welEmail == null ? null : welEmail,
    "default_address": defaultAddress == null ? null : defaultAddress,
    "default_phone": defaultPhone == null ? null : defaultPhone,
    "instructor_enable": instructorEnable == null ? null : instructorEnable,
    "debug_enable": debugEnable == null ? null : debugEnable,
    "cat_enable": catEnable == null ? null : catEnable,
    "feature_amount": featureAmount,
    "preloader_enable": preloaderEnable == null ? null : preloaderEnable,
    "zoom_enable": zoomEnable == null ? null : zoomEnable,
    "amazon_enable": amazonEnable == null ? null : amazonEnable,
    "captcha_enable": captchaEnable == null ? null : captchaEnable,
    "bbl_enable": bblEnable == null ? null : bblEnable,
    "map_lat": mapLat,
    "map_long": mapLong,
    "map_enable": mapEnable == null ? null : mapEnable,
    "contact_image": contactImage,
    "mobile_enable": mobileEnable == null ? null : mobileEnable,
    "promo_enable": promoEnable == null ? null : promoEnable,
    "promo_text": promoText == null ? null : promoText,
    "promo_link": promoLink == null ? null : promoLink,
    "linkedin_enable": linkedinEnable == null ? null : linkedinEnable,
    "map_api": mapApi,
    "twitter_enable": twitterEnable == null ? null : twitterEnable,
    "aws_enable": awsEnable == null ? null : awsEnable,
    "certificate_enable": certificateEnable == null ? null : certificateEnable,
    "device_control": deviceControl == null ? null : deviceControl,
    "ipblock_enable": ipblockEnable == null ? null : ipblockEnable,
    "ipblock": ipblock,
    "assignment_enable": assignmentEnable == null ? null : assignmentEnable,
    "appointment_enable": appointmentEnable == null ? null : appointmentEnable,
    "created_at": createdAt,
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    "hide_identity": hideIdentity == null ? null : hideIdentity,
    "footer_logo": footerLogo,
    "enable_omise": enableOmise == null ? null : enableOmise,
    "enable_payu": enablePayu == null ? null : enablePayu,
    "enable_moli": enableMoli == null ? null : enableMoli,
    "enable_cashfree": enableCashfree == null ? null : enableCashfree,
    "enable_skrill": enableSkrill == null ? null : enableSkrill,
    "enable_rave": enableRave == null ? null : enableRave,
    "preloader_logo": preloaderLogo,
    "chat_bubble": chatBubble,
    "wapp_phone": wappPhone == null ? null : wappPhone,
    "wapp_popup_msg": wappPopupMsg == null ? null : wappPopupMsg,
    "wapp_title": wappTitle == null ? null : wappTitle,
    "wapp_position": wappPosition == null ? null : wappPosition,
    "wapp_color": wappColor == null ? null : wappColor,
    "wapp_enable": wappEnable == null ? null : wappEnable,
    "enable_payhere": enablePayhere == null ? null : enablePayhere,
    "app_download": appDownload == null ? null : appDownload,
    "app_link": appLink == null ? null : appLink,
    "play_download": playDownload == null ? null : playDownload,
    "play_link": playLink == null ? null : playLink,
    "iyzico_enable": iyzicoEnable == null ? null : iyzicoEnable,
    "course_hover": courseHover == null ? null : courseHover,
    "ssl_enable": sslEnable == null ? null : sslEnable,
    "currency_swipe": currencySwipe == null ? null : currencySwipe,
    "attandance_enable": attandanceEnable == null ? null : attandanceEnable,
    "youtube_enable": youtubeEnable == null ? null : youtubeEnable,
    "vimeo_enable": vimeoEnable == null ? null : vimeoEnable,
    "aamarpay_enable": aamarpayEnable == null ? null : aamarpayEnable,
    "activity_enable": activityEnable == null ? null : activityEnable,
    "twilio_enable": twilioEnable == null ? null : twilioEnable,
    "plan_enable": planEnable == null ? null : planEnable,
    "googlemeet_enable": googlemeetEnable == null ? null : googlemeetEnable,
    "cookie_enable": cookieEnable == null ? null : cookieEnable,
    "jitsimeet_enable": jitsimeetEnable == null ? null : jitsimeetEnable,
    "payflexi_enable": payflexiEnable == null ? null : payflexiEnable,
  };
}

class Slider {
  Slider({
    this.id,
    this.heading,
    this.subHeading,
    this.searchText,
    this.detail,
    this.status,
    this.image,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.left,
    this.searchEnable,
  });

  int id;
  String heading;
  String subHeading;
  String searchText;
  String detail;
  String status;
  String image;
  String position;
  DateTime createdAt;
  DateTime updatedAt;
  String left;
  String searchEnable;

  factory Slider.fromJson(Map<String, dynamic> json) => Slider(
    id: json["id"] == null ? null : json["id"],
    heading: json["heading"] == null ? null : json["heading"],
    subHeading: json["sub_heading"] == null ? null : json["sub_heading"],
    searchText: json["search_text"] == null ? null : json["search_text"],
    detail: json["detail"] == null ? null : json["detail"],
    status: json["status"] == null ? null : json["status"],
    image: json["image"] == null ? null : json["image"],
    position: json["position"] == null ? null : json["position"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    left: json["left"] == null ? null : json["left"],
    searchEnable: json["search_enable"] == null ? null : json["search_enable"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "heading": heading == null ? null : heading,
    "sub_heading": subHeading == null ? null : subHeading,
    "search_text": searchText == null ? null : searchText,
    "detail": detail == null ? null : detail,
    "status": status == null ? null : status,
    "image": image == null ? null : image,
    "position": position == null ? null : position,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    "left": left == null ? null : left,
    "search_enable": searchEnable == null ? null : searchEnable,
  };
}

class Sliderfact {
  Sliderfact({
    this.id,
    this.icon,
    this.heading,
    this.subHeading,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String icon;
  String heading;
  String subHeading;
  DateTime createdAt;
  DateTime updatedAt;

  factory Sliderfact.fromJson(Map<String, dynamic> json) => Sliderfact(
    id: json["id"] == null ? null : json["id"],
    icon: json["icon"] == null ? null : json["icon"],
    heading: json["heading"] == null ? null : json["heading"],
    subHeading: json["sub_heading"] == null ? null : json["sub_heading"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "icon": icon == null ? null : icon,
    "heading": heading == null ? null : heading,
    "sub_heading": subHeading == null ? null : subHeading,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
  };
}

class Subcategory {
  Subcategory({
    this.id,
    this.categoryId,
    this.title,
    this.icon,
    this.slug,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.details,
  });

  int id;
  String categoryId;
  String title;
  String icon;
  String slug;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  String details;

  factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(
    id: json["id"] == null ? null : json["id"],
    categoryId: json["category_id"] == null ? null : json["category_id"],
    title: json["title"] == null ? null : json["title"],
    icon: json["icon"] == null ? null : json["icon"],
    slug: json["slug"] == null ? null : json["slug"],
    status: json["status"] == null ? null : json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    details: json["details"] == null ? null : json["details"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "category_id": categoryId == null ? null : categoryId,
    "title": title == null ? null : title,
    "icon": icon == null ? null : icon,
    "slug": slug == null ? null : slug,
    "status": status == null ? null : status,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    "details": details == null ? null : details,
  };
}

class Testimonial {
  Testimonial({
    this.id,
    this.clientName,
    this.details,
    this.status,
    this.image,
    this.imagepath,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String clientName;
  String details;
  String status;
  String image;
  String imagepath;
  dynamic createdAt;
  dynamic updatedAt;

  factory Testimonial.fromJson(Map<String, dynamic> json) => Testimonial(
    id: json["id"] == null ? null : json["id"],
    clientName: json["client_name"] == null ? null : json["client_name"],
    details: json["details"] == null ? null : json["details"],
    status: json["status"] == null ? null : json["status"],
    image: json["image"] == null ? null : json["image"],
    imagepath: json["imagepath"] == null ? null : json["imagepath"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "client_name": clientName == null ? null : clientName,
    "details": details == null ? null : details,
    "status": status == null ? null : status,
    "image": image == null ? null : image,
    "imagepath": imagepath == null ? null : imagepath,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

class Trusted {
  Trusted({
    this.id,
    this.url,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String url;
  String image;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  factory Trusted.fromJson(Map<String, dynamic> json) => Trusted(
    id: json["id"] == null ? null : json["id"],
    url: json["url"] == null ? null : json["url"],
    image: json["image"] == null ? null : json["image"],
    status: json["status"] == null ? null : json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "url": url == null ? null : url,
    "image": image == null ? null : image,
    "status": status == null ? null : status,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
  };
}

class Instructor {
  Instructor({
    this.instructor,
  });

  List<dynamic> instructor;

  factory Instructor.fromJson(Map<String, dynamic> json) => Instructor(
    instructor: json["instructor"] == null ? null : List<dynamic>.from(json["instructor"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "instructor": instructor == null ? null : List<dynamic>.from(instructor.map((x) => x)),
  };
}

class RFaq {
  RFaq({
    this.faq,
  });

  List<Subcategory> faq;

  factory RFaq.fromJson(Map<String, dynamic> json) => RFaq(
    faq: json["faq"] == null ? null : List<Subcategory>.from(json["faq"].map((x) => Subcategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "faq": faq == null ? null : List<dynamic>.from(faq.map((x) => x.toJson())),
  };
}
