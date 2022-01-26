import 'dart:io';
import 'package:eclass/Screens/introduction_animation/introduction_animation_screen.dart';
import 'package:eclass/services/helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'common/global.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  authToken = await storage.read(key: "token");
  if (Platform.isIOS)
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  Helper().NotificationConfig();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  _firebaseMessaging.getToken().then((value) {
    print('deviceToken: $value');
  });

  runApp(MyApp(authToken));
}
