
import 'package:eclass/model/blog_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_data_provider.dart';

class BlogProvider extends ChangeNotifier{
  BlogModel blogModel;

  Future<BlogModel> fetchBlogList(context) async {
    HomeDataProvider homeData =
    Provider.of<HomeDataProvider>(context, listen: false);
    // String url = "${APIData.blog}${APIData.secretKey}";
    // http.Response res = await http.get(url,
    //     headers: {
    //   "Accept": "application/json",
    //   "Authorization": "Bearer $authToken",
    // }
    // );
    // print(res.statusCode);
    // print(res.body);
    // if(res.statusCode == 200){
      blogModel = BlogModel.fromJson((homeData.mainApi.blog.toJson()));
    // }else{
    //   throw "حدث خطأ اثناء جلب المدونات";
    // }
    return blogModel;
  }
}