import 'package:eclass/Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widgets/appbar.dart';
import '../services/http_services.dart';
import 'instructor_faq_view.dart';

// ignore: must_be_immutable
class InstructorFaqScreen extends StatelessWidget {
  HttpService httpService = new HttpService();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: rtl,
      child: FutureProvider(
        create: (context) => httpService.fetchInstructorFaq(context),
        catchError: (context, error) {},
        child: Scaffold(
          appBar: customAppBar(context, "الاسئلة الشائعة للمدربين"),
          body: InstructorFaqView(),
        ),
      ),
    );
  }
}
