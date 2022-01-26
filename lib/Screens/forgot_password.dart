import 'package:flutter/material.dart';

import '../Widgets/appbar.dart';
import '../services/http_services.dart';
import 'forgotpasscode.dart';
import 'home_screen.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailCtrl = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isloading = false;
  HttpService http = new HttpService();

  Widget scaffoldBody() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Image.asset('assets/icons/foreget.png',height: 170,),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50.0),
                child: Text(
                  'قم بأدخال بريدك الإلكتروني لإرسال رمز إعادة تعيين كلمة المرور',
                  style: TextStyle(color: dark),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              TextField(
                controller: emailCtrl,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: ice,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  hintText: "البريد الإلكتروني",
                  hintStyle: TextStyle(color: dark, fontSize: 15.0),
                  errorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      )),
                  focusedErrorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 2.0)),
                  focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 2.0)),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () async {
                  setState(() {
                    isloading = true;
                  });
                  bool x = await http.forgotEmailReq(emailCtrl.text);
                  if (x)
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Codereset(emailCtrl.text)));
                  else
                    _scaffoldKey.currentState
                        .showSnackBar(SnackBar(content: Text("Invalid details")));
                  setState(() {
                    isloading = false;
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: pink.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 40,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ], color: pink, borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 5),
                      child: isloading
                          ? Container(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                            )
                          : Text(
                              "تاكيد",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 18),
                            ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: rtl,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: customAppBar(context, "اعادة تعين كلمة المرور"),
        body: scaffoldBody(),
      ),
    );
  }
}
