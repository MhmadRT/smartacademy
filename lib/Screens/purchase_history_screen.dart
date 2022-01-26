import 'package:eclass/Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widgets/appbar.dart';
import '../services/http_services.dart';
import 'history_items_list.dart';

// ignore: must_be_immutable
class PurchaseHistoryScreen extends StatelessWidget {
  HttpService httpService = new HttpService();

  @override
  Widget build(BuildContext context) {
    return FutureProvider(
      create: (context) => httpService.fetchPurchaseHistory(),
      catchError: (context, error) {},
      child: Directionality(
        textDirection: rtl,
        child: Scaffold(
          appBar: customAppBar(context, "سجل المشتريات"),
          backgroundColor: Color(0xFFF1F3F8),
          body: HistoryItemsList(),
        ),
      ),
    );
  }
}
