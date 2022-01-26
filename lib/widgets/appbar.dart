import 'package:eclass/Screens/home_screen.dart';
import 'package:eclass/Screens/notifications_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/theme.dart' as T;

String titles(int index) {
  switch (index) {
    case 0:
      return 'الرئيسية';
      break;
    case 1:
      return 'الدورات';
      break;
    case 2:
      return 'الاقسام';
      break;
    case 3:
      return 'السلة';
      break;
    case 4:
      return 'الملف الشخصي';
      break;
  }
}

AppBar appBar(Color clr, BuildContext context, scaffoldKey, int index) {
  T.Theme mode = Provider.of<T.Theme>(context);
  return AppBar(
    title: Text(
      titles(index),
      style: TextStyle(color: pink),
    ),
    iconTheme: IconThemeData(color:dark),
    leading: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17.0),
      child: InkWell(
          onTap: () {
            scaffoldKey.currentState.openDrawer();
          },
          child: Icon(Icons.menu)),
    ),
    backgroundColor: clr,
    brightness: Brightness.light,
    elevation: 0.0,
    titleSpacing: 1.0,
    actions: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.notifications,
              color: mode.notificationIconColor,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen(),)
              );
            }),
      ),
    ],
  );
}

AppBar customAppBar(BuildContext context, String title) {
  T.Theme mode = Provider.of<T.Theme>(context);
  return AppBar(
    iconTheme: IconThemeData(color: dark),
    elevation: 0.0,
    centerTitle: true,
    automaticallyImplyLeading: true,
    backgroundColor: const Color(0xFFFFFFFF),
    brightness: Brightness.light,
    title: Text(
      title,
      style:
          TextStyle(fontSize: 18.0, color: dark, fontWeight: FontWeight.w600),
    ),
  );
}
