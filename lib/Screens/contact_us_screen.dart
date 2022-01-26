import 'package:eclass/Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../Widgets/utils.dart';
import '../common/apidata.dart';
import '../common/theme.dart' as T;
import '../provider/home_data_provider.dart';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  TextStyle _labelStyle = TextStyle(
      fontSize: 17, fontWeight: FontWeight.w600, color: Colors.grey[500]);

  TextStyle _mainStyle(Color clr) {
    return TextStyle(color: clr, fontSize: 17);
  }

  UnderlineInputBorder enborder(Color borderClr) {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        color: borderClr,
        width: 1.0,
      ),
    );
  }

  UnderlineInputBorder foborder(Color borderClr) {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        color: borderClr,
        width: 2.0,
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  String name = "", email = "", phone = "", message = "";

  Widget heading(String txt) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.fromLTRB(0.0, 10.0, 15.0, 15.0),
      child: Text(
        txt,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
    );
  }

  Future<bool> sendContactDetails(
      String name, String email, String mob, String message) async {
    Response res = await post(
      "${APIData.contactUs}${APIData.secretKey}",
      headers: {"Accept": "application/json"},
      body: {"fname": "${name}", "email": "${email}", "mobile": "${mob}", "message": "${message}"},
    );
    print(res.body);
    return res.statusCode == 200 ? true : false;
  }

  bool isLoading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget submitButton(Color clr) {
    return InkWell(
      onTap: () async {
        if (_formKey.currentState.validate()) {
          setState(() {
            isLoading = true;
          });
          print('email $email \n phone $phone  \n name $name \n  message $message');
          bool isPassed = await sendContactDetails(name, email, phone, message);
          setState(() {
            isLoading = false;
          });
          if (isPassed) {
            SnackBar snackBar =
                SnackBar(content: Text("تم الإرسال بنجاح"));
            _scaffoldKey.currentState.showSnackBar(snackBar);
          } else if (!isPassed) {
            SnackBar snackBar =
                SnackBar(content: Text("فشل إرسال النموذج"));
            _scaffoldKey.currentState.showSnackBar(snackBar);
          }
        }
      },
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: pink,
            boxShadow: [
              BoxShadow(
                color: pink.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 40,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Container(
              alignment: Alignment.center,
              width: 200,
              height: 50,
              child: isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Text(
                      "إرسال",
                      // textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ))),
    );
  }

  Widget inputField(String label, int idx, Color borderclr) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        enabled: true,
        validator: (value) {
          if (value == "") {
            return "لا يمكن ترك هذا الحقل فارغا!";
          }
          return null;
        },
        maxLines: idx == 3 ? 1 : 1,
        onChanged: (value) {
          if (idx == 0) {
            setState(() {
              this.name = value;
            });
          } else if (idx == 1) {
            setState(() {
              this.email = value;
            });
          } else if (idx == 2) {
            setState(() {
              this.phone = value;
            });
          } else if (idx == 3) {
            setState(() {
              this.message = value;
            });
          }
        },
        cursorColor: Colors.black,
        style: _mainStyle(txtColor),
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
          hintText: label,
          hintStyle: TextStyle(color: dark, fontSize: 19.0),
          focusedErrorBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.transparent, width: 2.0)),
          focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.transparent, width: 2.0)),
        ),
      ),
    );
  }

  Widget form(Color borderClr) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: TextFormField(
              enabled: true,
              validator: (value) {
                if (value == "") {
                  return "لا يمكن ترك هذا الحقل فارغا!";
                }
                return null;
              },
              maxLines: 1,
              onChanged: (value) {
                  setState(() {
                    this.name = value;
                  });
              },
              cursorColor: Colors.black,
              style: _mainStyle(txtColor),
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
                hintText: 'الاسم',
                hintStyle: TextStyle(color: dark, fontSize: 19.0),
                focusedErrorBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.transparent, width: 2.0)),
                focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.transparent, width: 2.0)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: TextFormField(
              enabled: true,
              validator: (value) {
                Pattern pattern =
                    r'(^(?:[+0]9)?[0-9]{8,12}$)';
                RegExp regex = new RegExp(pattern);
                if (value == "")
                  return "لا يمكن ترك هذا الحقل فارغا!";
                else if (!regex.hasMatch(value)) return "رقم غير صحيح";
                return null;
              },
              maxLines: 1,
              onChanged: (value) {
                setState(() {
                  this.phone = value;
                });
              },
              cursorColor: Colors.black,
              style: _mainStyle(txtColor),
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
                hintText: 'رقم الهاتف',
                hintStyle: TextStyle(color: dark, fontSize: 19.0),
                focusedErrorBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.transparent, width: 2.0)),
                focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.transparent, width: 2.0)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: TextFormField(
              enabled: true,
              validator: (value) {
                if (value == "")
                  return "لا يمكن ترك هذا الحقل فارغا!";
                else if (!value.contains("@")) return "يجب ان يحتوي على @";
                return null;
              },
              maxLines: 1,
              onChanged: (value) {
                setState(() {
                  this.email = value;
                });
              },
              cursorColor: Colors.black,
              style: _mainStyle(txtColor),
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
                hintText: 'البريد الإلكتروني',
                hintStyle: TextStyle(color: dark, fontSize: 19.0),
                focusedErrorBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.transparent, width: 2.0)),
                focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.transparent, width: 2.0)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: TextFormField(
              enabled: true,
              validator: (value) {
                if (value == "") {
                  return "لا يمكن ترك هذا الحقل فارغا!";
                }
                return null;
              },
              maxLines: 1,
              onChanged: (value) {
                setState(() {
                  this.message = value;
                });
              },
              cursorColor: Colors.black,
              style: _mainStyle(txtColor),
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
                hintText: 'ملاحظات',
                hintStyle: TextStyle(color: dark, fontSize: 19.0),
                focusedErrorBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.transparent, width: 2.0)),
                focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.transparent, width: 2.0)),
              ),
            ),
          ),
          SizedBox(height: 50,),
          submitButton(Color(0xffF44A4A))
        ],
      ),
    );
  }

  Widget leadingOfDetails(IconData icon) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: pink.withOpacity(0.2)),
      height: 40,
      width: 40,
      child: Icon(
        icon,
        color: dark.withOpacity(0.8),
      ),
    );
  }

  Widget boxContainer(
      String desc, String title, IconData icon, Color descColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 3),
      child: Container(
        decoration:
            BoxDecoration( borderRadius: BorderRadius.circular(25),border: Border.all(color: dark)),
        child: ListTile(
          leading: leadingOfDetails(icon),
          title: Text(
            title,
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.w600, color: pink),
          ),
          subtitle: Text(
            desc,
            style: TextStyle(fontSize: 15, color: dark),
          ),
        ),
      ),
    );
  }

  Widget companyDetails(Color descColor) {
    var homeData =
        Provider.of<HomeDataProvider>(context, listen: false).homeModel;
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        boxContainer(homeData.settings.defaultAddress, "العنوان",Icons.location_on, descColor),
        boxContainer(homeData.settings.welEmail, "البريد الإلكتروني", Icons.mail, descColor),
        boxContainer(homeData.settings.defaultPhone, "رقم الهاتف", Icons.phone, descColor),
      ],
    );
  }

  Widget scaffoldBody(Color notificationIconColor) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal:30.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            companyDetails(notificationIconColor),
            SizedBox(
              height: 30,
            ),
            Text(
              'ابق على اتصال معنا',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: dark),
            ),
            SizedBox(height: 20,),
            form(notificationIconColor),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Color txtColor;

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    txtColor = mode.txtcolor;
    return Directionality(
      textDirection: rtl,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: secondaryAppBar(
            mode.notificationIconColor, mode.bgcolor, context, "اتصل بنا"),
        body: scaffoldBody(mode.notificationIconColor),
      ),
    );
  }
}
