
import 'package:eclass/provider/home_data_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../model/bundle_courses_model.dart';
import '../model/cart_model.dart';

class BundleCourseProvider with ChangeNotifier {
  List<BundleCourses> bundleCourses = [];

  BundleCourses getBundleDetails(CartModel bundle) {
    BundleCourses ans;
    bundleCourses.forEach((element) {
      if (element.id.toString() == bundle.bundleId.toString()) ans = element;
    });

    return ans;
  }

  Future<List<BundleCourses>> getBundles(BuildContext context) async {
    HomeDataProvider homeData =
        Provider.of<HomeDataProvider>(context, listen: false);
    List<BundleCourses> courses = [];
    var json = (homeData.mainApi.bundleCourses.bundle);
    for (int i = 0; i < json.length; i++) {
      courses.add(BundleCourses(
        id: json[i]["id"],
        userId: json[i]["user"],
        courseId: List<String>.from(json[i]["course_id"].map((x) => x)),
        title: json[i]["title"],
        detail: json[i]["detail"],
        price: json[i]["price"],
        discountPrice: json[i]["discount_price"],
        type: json[i]["type"],
        slug: json[i]["slug"],
        status: json[i]["status"],
        featured: json[i]["featured"],
        previewImage: json[i]["preview_image"],
        createdAt: (json[i]["created_at"]),
        updatedAt: (json[i]["updated_at"]),
      ));
    }
    this.bundleCourses = courses;
    notifyListeners();
    print('GET BUNDLE');
    return courses;
  }
}
