
import 'package:eclass/model/instructor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_data_provider.dart';

class InstructorProvider with ChangeNotifier {
  InstructorModelList instructor = new InstructorModelList();

  InstructorModelList getInstructors(BuildContext context) {
    HomeDataProvider homeData =
        Provider.of<HomeDataProvider>(context, listen: false);
    instructor =
        InstructorModelList.fromJson(homeData.mainApi.instructor.toJson());
    print('GET INSTRUCTORS');
    return instructor;
  }
}
