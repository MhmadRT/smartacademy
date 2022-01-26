import 'dart:convert';
import 'dart:convert' as convert;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../common/apidata.dart';
import '../common/global.dart';
import '../model/about_us_model.dart';
import '../model/coupon_model.dart';
import '../model/faq_model.dart';
import '../model/purchase_history_model.dart';
import '../provider/home_data_provider.dart';

class Access with ChangeNotifier {
  String accessToken = '';
  String secretKey = '';

  void updateAt(String at) {
    this.accessToken = at;
  }

  void updateSk(String sk) {
    this.secretKey = sk;
  }
}

class HttpService {

  Future<List<FaqElement>> fetchUserFaq(BuildContext context) async {
    HomeDataProvider homeData =
    Provider.of<HomeDataProvider>(context, listen: false);
    // var response = await http.get("${APIData.instructorFaq}${APIData.secretKey}");
    var jsonResponse = (homeData.mainApi.userFaq.toJson()['faq']) as List;
    return jsonResponse.map((faq) => FaqElement.fromJson(faq)).toList();
  }

  Future<List<FaqElement>> fetchInstructorFaq(BuildContext context) async {
    HomeDataProvider homeData =
    Provider.of<HomeDataProvider>(context, listen: false);
    // var response = await http.get("${APIData.instructorFaq}${APIData.secretKey}");
    var jsonResponse = (homeData.mainApi.instructorFaq.toJson()['faq']) as List;
    return jsonResponse.map((faq) => FaqElement.fromJson(faq)).toList();
  }

  Future<bool> resetPassword(String newPass, String email) async {
    String url = APIData.restPassword;

    http.Response res = await http.post(url, body: {
      "email": email,
      "password": newPass
    }, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    });

    return res.statusCode == 200;
  }

  Future<bool> forgotEmailReq(String _email) async {
    String url = APIData.forgotPassword;
    http.Response res = await http.post(url, body: {"email": _email});
    // return true;
    if (res.statusCode == 200)
      return true;
    else
      return false;
  }

  Future<bool> verifyCode(String email, String code) async {
    String url = APIData.verifyCode;

    http.Response res =
        await http.post(url, body: {"email": email, "code": code});
    // return true;
    print('resetPAss: ${res.body}');
    if (res.body.toString().toLowerCase() == "\"ok\"")
      return true;
    else
      return false;
  }


  Future<bool> login(String email, String pass, BuildContext context, _scaffoldKey) async {
    http.Response res = await http
        .post(APIData.login, body: {"email": email, "password": pass});
    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      authToken = body["access_token"];
      var refreshToken = body["access_token"];
      await storage.write(key: "token", value: "$authToken");
      await storage.write(key: "refreshToken", value: "$refreshToken");
      authToken = await storage.read(key: "token");
      HomeDataProvider homeData = Provider.of<HomeDataProvider>(context, listen: false);
      await homeData.getHomeDetails(context);
    }
    if (res.statusCode == 200){
      return true;
    }
    else {
      if(res.statusCode == 402){
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("تحقق من البريد الإلكتروني للمتابعة."),
          action: SnackBarAction(
              label: "تم",
              onPressed: () {
              }),
        ));
        return false;
      }else{
        print('${res.statusCode}');
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("فشل عملية الدخول!"),
          action: SnackBarAction(
              label: "تم",
              onPressed: () {
              }),
        ));
        return false;
      }
    }
  }

  Future<bool> signUp(String name, String email, String password, BuildContext context, _scaffoldKey) async {
    print(name);
    print(email);
    print(password);
    var body={"name": name, "email": email, "password": password};
    http.Response res = await http.post(APIData.register, body: {"name": name, "email": email, "password": password},
    headers: {
      "Accept" : "application/json"
    });
    print('${APIData.register}');
    print('$body');

    if (res.statusCode == 200){
      var body = jsonDecode(res.body);
      authToken = body["access_token"];
      var refreshToken = body["access_token"];
      await storage.write(key: "token", value: "$authToken");
      await storage.write(key: "refreshToken", value: "$refreshToken");
      authToken = await storage.read(key: "token");
      HomeDataProvider homeData = Provider.of<HomeDataProvider>(context, listen: false);
      await homeData.getHomeDetails(context);
      return true;
    }
    else {
      if(res.statusCode == 402){
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("تم إرسال بريد للتحقق ."),
          action: SnackBarAction(
              label: "ok",
              onPressed: () {
                Navigator.of(context).pushNamed('/SignIn');
              }),
        ));
        return false;
      }
      else{
        Fluttertoast.showToast(msg: "حدث خطاء ما ..!  ${res.statusCode}");
        return false;
      }
    }
  }

  Future<List<About>> fetchAboutUs(BuildContext context) async {
    HomeDataProvider homeData =
    Provider.of<HomeDataProvider>(context, listen: false);
    // var response = await http.get(APIData.aboutUs + "${APIData.secretKey}");
    var jsonResponse = (homeData.mainApi.aboutus.toJson()['about']) as List;
    return jsonResponse.map((employee) => About.fromJson(employee)).toList();
  }

  Future<bool> logout() async {
    String url = APIData.logOut;
    http.Response res = await http.post(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    });
    if (res.statusCode == 200) {
      authToken = null;
      await storage.deleteAll();
      return true;
    } else
      return false;
  }

  Future<List<CouponModel>> getCartCouponData(BuildContext context) async {
    HomeDataProvider homeData =
    Provider.of<HomeDataProvider>(context, listen: false);
    // String url = APIData.coupon + APIData.secretKey;
    //
    // http.Response res = await http.get(url);
    List<CouponModel> couponList = [];
    // if (res.statusCode == 200) {
      var body = homeData.mainApi.coupons.toJson()["coupon"] as List;
      couponList = body.map((e) => CouponModel.fromJson(e)).toList();
    // } else {
    //   throw "err";
    // }
    return couponList;
  }

  Future<List<Orderhistory>> fetchPurchaseHistory() async {
    var response =
        await http.get(APIData.purchaseHistory + "${APIData.secretKey}", headers: {
      HttpHeaders.authorizationHeader: "Bearer $authToken",
      HttpHeaders.acceptHeader: "application/json"
    });
    if (response.statusCode != 200) {
      return [];
    }
    PurchaseHistory jsonResponse =
        PurchaseHistory.fromJson(convert.jsonDecode(response.body));

    return jsonResponse.orderhistory;
  }
}
