import 'package:eclass/model/main_api.dart' as main;
import 'package:eclass/model/zoom_meeting.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../model/home_model.dart';

class HomeDataProvider with ChangeNotifier {
  HomeModel homeModel;
  List<SliderFact> sliderFactList = [];
  List<MySlider> sliderList = [];
  List<Testimonial> testimonialList = [];
  List<Trusted> trustedList = [];
  List<MyCategory> featuredCategoryList = [];
  List<SubCategory> subCategoryList = [];
  List<MyCategory> categoryList = [];
  List<ChildCategory> childCategoryList = [];
  List<ZoomMeeting> zoomMeetingList = [];
  Map categoryMap = {};
  main.MainApi mainApi;

  Future<main.MainApi> getMainApi() async {
    // try {
    var headers = {
      'Cookie':
          'akadymyabaaadalmaarf_session=eyJpdiI6InpLY3RkckhaZUVuSHV6N2NSM01tVGc9PSIsInZhbHVlIjoiMkxyQ0phcmFNVmIyclRac1RXM3cxTENpUk1KbnNDckZ4ZEZRejh3d1ZoVk81aXdhWEh0L1FDUHkwWC9reU1lSUNkUWJaMU1yRHdYUk8wWnVDKzgvc0EzRFVyRE1OdVd5YVlOK1ZwSEJUTFRCcW5rci9ZRW9vWW05dDJzZE9BOXAiLCJtYWMiOiJhNTcyMjg3YmQ0NjgxMWQzNTE3OTk0MDYxMDYxYjEzY2MwZjQyM2QyMzMxNjM2OWMzODdiZTRkNjU3YTllYTRiIn0%3D'
    };
    print('https://eclass.smartmediajo.com/results.json');
    var request = Request(
        'GET', Uri.parse('https://eclass.smartmediajo.com/results.json'));

    request.headers.addAll(headers);

    StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      mainApi = main.mainApiFromJson(await response.stream.bytesToString());
      print('NEWWWW DATA');
      print(mainApi.homeDetails.toJson());
      setData();
    } else {}
    // print(mainApi.toJson());
    return mainApi;
    // } catch (e) {
    //   print(e);
    //   return mainApi;
    // }
  }

  setData() {}

  void generateLists(HomeModel homeData) {
    generateSliderFactList(homeData.sliderfacts);
    generateSliderList(homeData.slider);
    generateTestimonialList(homeData);
    generateTrustedList(homeData);
    generateFeaturedCategoryList(homeData);
    generateCategoryList(homeData);
    generateSubCateList(homeData);
    generateChildCateList(homeData);
    generateMeetingList(homeData.zoomMeeting);
  }

  HomeModel getHomeDetails(context) {
    if (mainApi != null) {
      homeModel = HomeModel.fromJson(mainApi.homeDetails.toJson());
      generateLists(homeModel);
      notifyListeners();
      return homeModel;
    }
  }

  void generateMeetingList(List<ZoomMeeting> zoomMeeting) {
    zoomMeetingList = List.generate(
        zoomMeeting.length,
        (index) => ZoomMeeting(
              id: zoomMeeting[index].id,
              courseId: zoomMeeting[index].courseId,
              meetingId: zoomMeeting[index].meetingId,
              meetingTitle: zoomMeeting[index].meetingTitle,
              startTime: zoomMeeting[index].startTime,
              zoomUrl: zoomMeeting[index].zoomUrl,
              userId: zoomMeeting[index].userId,
              agenda: zoomMeeting[index].agenda,
              createdAt: zoomMeeting[index].createdAt,
              updatedAt: zoomMeeting[index].updatedAt,
              type: zoomMeeting[index].type,
              linkBy: zoomMeeting[index].linkBy,
              ownerId: zoomMeeting[index].ownerId,
            ));
  }

  void generateSliderFactList(List<SliderFact> sliderfacts) {
    sliderFactList = List.generate(
        sliderfacts.length,
        (index) => SliderFact(
              id: sliderfacts[index].id,
              icon: sliderfacts[index].icon,
              heading: sliderfacts[index].heading,
              subHeading: sliderfacts[index].subHeading,
              createdAt: sliderfacts[index].createdAt,
              updatedAt: sliderfacts[index].updatedAt,
            ));
  }

  void generateSliderList(List<MySlider> slider) {
    sliderList = List.generate(slider == null ? 0 : slider.length, (index) {
      return MySlider(
        id: slider[index].id,
        image: slider[index].image,
        heading: slider[index].heading,
        subHeading: slider[index].subHeading,
        detail: slider[index].detail,
        searchText: slider[index].searchText,
        position: slider[index].position,
        status: slider[index].status,
        createdAt: slider[index].createdAt,
        updatedAt: slider[index].updatedAt,
      );
    });
  }

  void generateTestimonialList(HomeModel homeModels) {
    testimonialList = List.generate(
        homeModel.testimonial.length,
        (index) => Testimonial(
              id: homeModels.testimonial[index].id,
              clientName: homeModels.testimonial[index].clientName,
              image: homeModels.testimonial[index].image,
              status: homeModels.testimonial[index].status,
              details: homeModels.testimonial[index].details,
              createdAt: homeModels.testimonial[index].createdAt,
              updatedAt: homeModels.testimonial[index].updatedAt,
            ));
    testimonialList.removeWhere((element) => element.status == "0");
  }

  void generateTrustedList(HomeModel homeModels) {
    trustedList = List.generate(
        homeModel.trusted.length,
        (index) => Trusted(
              id: homeModels.trusted[index].id,
              url: homeModels.trusted[index].url,
              image: homeModels.trusted[index].image,
              status: homeModels.trusted[index].status,
              createdAt: homeModels.trusted[index].createdAt,
              updatedAt: homeModels.trusted[index].updatedAt,
            ));
  }

  void generateFeaturedCategoryList(HomeModel homeModels) {
    featuredCategoryList = List.generate(
      homeModel.featuredCate.length,
      (index) => MyCategory(
        id: homeModels.featuredCate[index].id,
        slug: homeModels.featuredCate[index].slug,
        icon: homeModels.featuredCate[index].icon,
        title: homeModels.featuredCate[index].title,
        status: homeModels.featuredCate[index].status,
        featured: homeModels.featuredCate[index].featured,
        position: homeModels.featuredCate[index].position,
        updatedAt: homeModels.featuredCate[index].updatedAt,
        createdAt: homeModels.featuredCate[index].createdAt,
        catImage: homeModels.featuredCate[index].catImage,
      ),
    );
    featuredCategoryList.removeWhere((element) => element.status == "0");
  }

  void generateCategoryList(HomeModel homeModels) {
    categoryList = List.generate(
        homeModel.category.length,
        (index) => MyCategory(
              id: homeModels.category[index].id,
              title: homeModels.category[index].title,
              icon: homeModels.category[index].icon,
              slug: homeModels.category[index].slug,
              featured: homeModels.category[index].featured,
              status: homeModels.category[index].status,
              position: homeModels.category[index].position,
              createdAt: homeModels.category[index].createdAt,
              updatedAt: homeModels.category[index].updatedAt,
            ));
    categoryList.removeWhere((element) => element.status == "0");
  }

  void generateSubCateList(HomeModel homeModels) {
    subCategoryList = List.generate(
        homeModel.subcategory.length,
        (index) => SubCategory(
              id: homeModels.subcategory[index].id,
              icon: homeModels.subcategory[index].icon,
              categoryId: homeModels.subcategory[index].categoryId,
              status: homeModels.subcategory[index].status,
              slug: homeModels.subcategory[index].slug,
              title: homeModels.subcategory[index].title,
              createdAt: homeModels.subcategory[index].createdAt,
              updatedAt: homeModels.subcategory[index].updatedAt,
            ));
    subCategoryList.removeWhere((element) => element.status == "0");
  }

  void generateChildCateList(HomeModel homeModels) {
    childCategoryList = List.generate(
        homeModel.childcategory.length,
        (index) => ChildCategory(
              id: homeModels.childcategory[index].id,
              status: homeModels.childcategory[index].status,
              title: homeModels.childcategory[index].title,
              slug: homeModels.childcategory[index].slug,
              icon: homeModels.childcategory[index].icon,
              subcategoryId: homeModels.childcategory[index].subcategoryId,
              categoryId: homeModels.childcategory[index].categoryId,
              createdAt: homeModels.childcategory[index].createdAt,
              updatedAt: homeModels.childcategory[index].updatedAt,
            ));
    childCategoryList.removeWhere((element) => element.status == "0");
  }

  String getCategoryName(String id) {
    return categoryMap[int.parse(id)];
  }
}
