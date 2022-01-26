import 'package:eclass/Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widgets/appbar.dart';
import '../common/theme.dart' as T;
import '../services/http_services.dart';
import 'about_us_view.dart';

// ignore: must_be_immutable
class AboutUsScreen extends StatelessWidget {
  HttpService httpService = new HttpService();
  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    return Directionality(
      textDirection: rtl,
      child: FutureProvider(
        create: (context) => httpService.fetchAboutUs(context),
        catchError: (context, error) {},
        child: Scaffold(
          appBar: customAppBar(context, "من نحن"),
          body: AboutUsView(),
        ),
      ),
    );
  }
}
