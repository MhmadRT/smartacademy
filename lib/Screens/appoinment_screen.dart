import 'dart:convert';
import 'dart:io';

import 'package:eclass/Screens/home_screen.dart';
import 'package:eclass/Widgets/appbar.dart';
import 'package:eclass/common/apidata.dart';
import 'package:eclass/common/global.dart';
import 'package:eclass/common/theme.dart' as T;
import 'package:eclass/model/content_model.dart';
import 'package:eclass/provider/content_provider.dart';
import 'package:eclass/provider/full_course_detail.dart';
import 'package:eclass/provider/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AppointmentScreen extends StatefulWidget {
  AppointmentScreen(this.courseDetail);

  final FullCourse courseDetail;

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  TextEditingController requestController = new TextEditingController();

  requestAppointment(courseId, title, List<Appointment> appointment) async {
    var userDetails =
        Provider.of<UserProfile>(context, listen: false).profileInstance;
    String url = "${APIData.requestAppointment}${APIData.secretKey}";
    final res = await http.post(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer $authToken",
      "Accept": "application/json"
    }, body: {
      "course_id": "$courseId",
      "title": "$title"
    });
    print("Res: ${res.statusCode} ${res.body}");
    if (res.statusCode == 200) {
      var response = json.decode(res.body);
      var newAppointment;
      setState(() {
        newAppointment = response['appointment'];
      });
      appointment.add(Appointment(
        id: newAppointment[''],
        user: userDetails.fname,
        courseId: newAppointment[''],
        instructor: newAppointment[''],
        title: newAppointment['title'],
        detail: newAppointment['detail'],
        accept: "${newAppointment['accept']}",
        reply: null,
        status: "1",
        createdAt: DateTime.parse(newAppointment['created_at']),
        updatedAt: DateTime.parse(newAppointment['updated_at']),
      ));

      Fluttertoast.showToast(msg: "تم الطلب بنجاح");
      setState(() {
        requestController.text = '';
      });
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: "هناك خطأ ما");
      requestController.text = '';
    }
  }

  deleteAppointment(id) async {
    String url = "${APIData.deleteAppointment}$id?secret=${APIData.secretKey}";
    final res = await http.post(
      url,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $authToken",
        "Accept": "application/json"
      },
    );
    if (res.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "تم حذف الموعد بنجاح!",
          backgroundColor: Colors.green,
          textColor: Colors.white);
      setState(() {});
    } else {
      Fluttertoast.showToast(
          msg: "هناك خطأ ما!",
          backgroundColor: Colors.red,
          textColor: Colors.white);
    }
  }

  showAlertDialog(BuildContext context, mode, courseId, appointment) {
    Widget cancelButton = RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      color: mode.easternBlueColor,
      child: Text(
        "إرسال",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        requestAppointment(courseId, requestController.text, appointment);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      title: Text("طلب موعد"),
      content: Container(
        child: TextFormField(
          maxLines: 3,
          controller: requestController,
          decoration: InputDecoration(
            hintText: "أدخل الطلب",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: cancelButton,
        )
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(textDirection: rtl, child: alert);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context, listen: false);
    var appointment =
        Provider.of<ContentProvider>(context).contentModel.appointment;
    return Directionality(
      textDirection: rtl,
      child: Scaffold(
        appBar: customAppBar(context, "طلب موعد"),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: appointment.length,
                  padding: EdgeInsets.only(
                      left: 18.0, right: 18.0, top: 10, bottom: 5.0),
                  itemBuilder: (context, index) {
                    return appointment[index].accept == 1 ||
                            "${appointment[index].accept}" == "1"
                        ? Container(
                            margin: EdgeInsets.only(bottom: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${appointment[index].user}",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w700,
                                            color: dark),
                                      ),
                                      Text(
                                        "${appointment[index].title}",
                                        maxLines: 4,
                                        style: TextStyle(
                                            fontSize: 15.0, color: dark),
                                      ),
                                      Text(
                                        "${appointment[index].detail}",
                                        maxLines: 4,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: dark,
                                        ),
                                      ),
                                      Text(
                                        DateFormat.yMMMd().add_jm().format(
                                            appointment[index].updatedAt),
                                        style: new TextStyle(
                                            color: dark.withOpacity(0.6),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          appointment[index].reply != null
                                              ? Expanded(
                                                  child: ButtonTheme(
                                                    minWidth: 130,
                                                    height: 40,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                    child: RaisedButton.icon(
                                                        elevation: 0.0,
                                                        padding:
                                                            EdgeInsets.all(0.0),
                                                        color: mode
                                                            .easternBlueColor,
                                                        onPressed: () {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) =>
                                                                      Dialog(
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15)),
                                                                        child:
                                                                            Directionality(
                                                                          textDirection:
                                                                              rtl,
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                EdgeInsets.symmetric(horizontal: 18.0),
                                                                            color:
                                                                                Colors.transparent,
                                                                            height:
                                                                                350,
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Text(
                                                                                      "الرد على الموعد",
                                                                                      style: TextStyle(color: mode.titleTextColor, fontWeight: FontWeight.w500, fontSize: 18.0),
                                                                                    ),
                                                                                    IconButton(
                                                                                        padding: EdgeInsets.all(0.0),
                                                                                        icon: Icon(
                                                                                          CupertinoIcons.clear_thick,
                                                                                          color: mode.titleTextColor,
                                                                                        ),
                                                                                        onPressed: () {
                                                                                          FocusScope.of(context).requestFocus(FocusNode());
                                                                                          Navigator.pop(context);
                                                                                        })
                                                                                  ],
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: Flexible(
                                                                                    child: Text(
                                                                                      "${parse(appointment[index].reply).body.text}",
                                                                                      textAlign: TextAlign.start,
                                                                                      maxLines: 10,
                                                                                      style: TextStyle(fontSize: 16.0, color: mode.titleTextColor),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ));
                                                        },
                                                        icon: Icon(
                                                          Icons.reply,
                                                          color: Colors.white,
                                                        ),
                                                        label: Text(
                                                          "إجابة",
                                                          style: TextStyle(
                                                            fontSize: 16.0,
                                                            color: Colors.white,
                                                          ),
                                                        )),
                                                  ),
                                                )
                                              : SizedBox.shrink(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox.shrink();
                  }),
            ),
            Container(
              color: ice,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: TextFormField(
                  maxLines: 1,
                  controller: requestController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        icon: Icon(
                          Icons.send,
                          color: dark,
                        ),
                        onPressed: () {
                          requestAppointment(widget.courseDetail.course.id,
                              requestController.text, appointment);
                        }),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.5),
                                spreadRadius: 0.5,
                                blurRadius: 12,
                                offset:
                                    Offset(0, 1), // changes position of shadow
                              ),
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/icons/user_avatar.png'))),
                      ),
                    ),
                    hintText: "أدخل الطلب",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
