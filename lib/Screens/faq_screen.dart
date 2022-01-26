import 'package:eclass/Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widgets/appbar.dart';
import '../services/http_services.dart';
import 'faq_view.dart';

// ignore: must_be_immutable
class FaqScreen extends StatefulWidget {
  @override
  _FaqScreenState createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  HttpService httpService = new HttpService();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: rtl,
      child: FutureProvider(
        create: (context) => httpService.fetchUserFaq(context),
        catchError: (context, error) {},
        child: Scaffold(
          appBar: customAppBar(context, "الأسئلة الشائعة"),
          body: FaqView(),
        ),
      ),
    );
  }
}
