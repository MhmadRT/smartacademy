import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widgets/utils.dart';
import '../common/theme.dart' as T;
import '../services/http_services.dart';
import 'home_screen.dart';
import 'password_reset_screen.dart';

class Codereset extends StatefulWidget {
  final String email;

  Codereset(this.email);

  @override
  _CoderesetState createState() => _CoderesetState();
}

class _CoderesetState extends State<Codereset> {
  TextEditingController codeCtrl = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget scaffoldBody() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
          width: MediaQuery.of(context).size.width - 50,
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextField(
                controller: codeCtrl,
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
                  hintText: "ادخل الرمز المستلم",
                  hintStyle: TextStyle(color: dark, fontSize: 19.0),
                  focusedErrorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.transparent, width: 2.0)),
                  focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.transparent, width: 2.0)),
                ),
              ),
              RaisedButton(
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                color: pink,
                onPressed: () async {
                  setState(() {
                    isloading = true;
                  });
                 await HttpService()
                      .verifyCode(widget.email, codeCtrl.text).then((value) {
                   if (value) {
                     Navigator.of(context).push(MaterialPageRoute(
                         builder: (context) => PasswordReset(0)));
                   } else
                     _scaffoldKey.currentState.showSnackBar(
                         SnackBar(content: Text("الرمز غير صحيح")));
                 });

                  setState(() {
                    isloading = false;
                  });
                },
                child: isloading
                    ? Container(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        "إرسال",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.white),
                      ),
              )
            ],
          )),
    );
  }

  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    return Directionality(
      textDirection: rtl,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: mode.bgcolor,
        appBar: secondaryAppBar(mode.notificationIconColor, mode.bgcolor, context,
            "هل نسيت كلمة السر"),
        body: scaffoldBody(),
      ),
    );
  }
}
