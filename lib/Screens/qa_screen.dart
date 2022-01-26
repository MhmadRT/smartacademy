import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eclass/Widgets/appbar.dart';
import 'package:eclass/common/apidata.dart';
import 'package:eclass/common/global.dart';
import 'package:eclass/common/theme.dart' as T;
import 'package:eclass/model/content_model.dart';
import 'package:eclass/model/main_api.dart';
import 'package:eclass/provider/content_provider.dart';
import 'package:eclass/provider/full_course_detail.dart';
import 'package:eclass/provider/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';

class QAScreen extends StatefulWidget {
  QAScreen(this.courseDetails);

  final FullCourse courseDetails;

  @override
  _QAScreenState createState() => _QAScreenState();
}

class _QAScreenState extends State<QAScreen> {
  TextEditingController _replyController = TextEditingController();
  TextEditingController _askQuizController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  bool showFab = true;

  void showFloatingActionButton(bool value) {
    setState(() {
      showFab = value;
    });
  }

  addAnswers(index, courseId, questionId) async {
    var reply = Provider.of<ContentProvider>(context, listen: false)
        .contentModel
        .questions[index]
        .answer;
    var userDetails =
        Provider.of<UserProfile>(context, listen: false).profileInstance;
    var content =
        Provider.of<ContentProvider>(context, listen: false).contentModel;
    final res = await http
        .post("${APIData.submitAnswer}${APIData.secretKey}", headers: {
      HttpHeaders.authorizationHeader: "Bearer $authToken",
      "Accept": "application/json"
    }, body: {
      "course_id": "$courseId",
      "question_id": "$questionId",
      "answer": "${_replyController.text}",
    });
    print(res.statusCode);
    print(res.body);
    if (res.statusCode == 200) {
      var response = json.decode(res.body);
      var newQues;
      setState(() {
        newQues = response['question'];
      });
      reply.add(Answer(
        course: widget.courseDetails.course.title,
        user: userDetails.fname,
        instructor: newQues['instructor_id'],
        image: userDetails.userImg,
        imagepath: "${APIData.userImagePath}${userDetails.userImg}",
        question: "${newQues['question_id']}",
        answer: "${newQues['answer']}",
        status: "1",
      ));
      Fluttertoast.showToast(
          msg: "تم تقديم الإجابة بنجاح!",
          backgroundColor: Colors.green,
          textColor: Colors.white);
      _replyController.text = '';
      setState(() {});
    } else {
      Fluttertoast.showToast(
          msg: "فشل تقديم الإجابة!",
          backgroundColor: Colors.red,
          textColor: Colors.white);
    }
  }

  askQuestions(BuildContext context, courseId) async {
    FocusScope.of(context).requestFocus(FocusNode());
    var content =
        Provider.of<ContentProvider>(context, listen: false).contentModel;
    var userDetails =
        Provider.of<UserProfile>(context, listen: false).profileInstance;
    final res = await http
        .post("${APIData.submitQuestion}${APIData.secretKey}", headers: {
      HttpHeaders.authorizationHeader: "Bearer $authToken",
      "Accept": "application/json"
    }, body: {
      "course_id": "$courseId",
      "question": "${_askQuizController.text}",
    });

    if (res.statusCode == 200) {
      var response = json.decode(res.body);
      var newQues;
      setState(() {
        newQues = response['question'];
      });
      content.questions.add(ContentModelQuestion(
        id: newQues['id'],
        user: userDetails.fname,
        instructor: newQues['instructor_id'],
        image: userDetails.userImg,
        imagepath: "${APIData.userImagePath}${userDetails.userImg}",
        course: "$courseId",
        title: newQues['question'],
        answer: [],
        status: "1",
        createdAt: DateTime.parse(newQues['created_at']),
        updatedAt: DateTime.parse(newQues['updated_at']),
      ));
      Fluttertoast.showToast(
          msg: "تم الارسال بنجاح",
          backgroundColor: Colors.green,
          textColor: Colors.white);
      _askQuizController.text = '';
      setState(() {});
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
          msg: "فشل إرسال السؤال!",
          backgroundColor: Colors.red,
          textColor: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context, listen: false);
    var questions =
        Provider.of<ContentProvider>(context).contentModel.questions;
    return Directionality(
      textDirection: rtl,
      child: Scaffold(
        appBar: customAppBar(context, "سؤال و جواب"),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: questions.length,
                  padding: EdgeInsets.all(15),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: ice,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: questions[index]
                                                    .imagepath
                                                    .replaceAll(
                                                        'https://eclass.smartmediajo.com/images/user_img',
                                                        '') !=
                                                ''
                                            ? NetworkImage(
                                                "${questions[index].imagepath}",
                                              )
                                            : AssetImage(
                                                'assets/icons/user_avatar.png'))),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${questions[index].user}",
                                      style: TextStyle(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w500,
                                          color: dark),
                                    ),
                                    Text(
                                      "${questions[index].title}",
                                      maxLines: 4,
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: dark.withOpacity(0.7)),
                                    ),
                                    SizedBox(
                                      height: 3.0,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          DateFormat.yMMMd().add_jm().format(
                                              questions[index].updatedAt),
                                          style: new TextStyle(
                                              color: mode.titleTextColor
                                                  .withOpacity(0.6),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ButtonTheme(
                                    minWidth: 20,
                                    height: 40,
                                    child: FlatButton.icon(
                                        padding: EdgeInsets.all(0.0),
                                        onPressed: () {
                                          var reply =
                                              Provider.of<ContentProvider>(
                                                  context,
                                                  listen: false)
                                                  .contentModel
                                                  .questions[index]
                                                  .answer;
                                          showModalBottomSheet(
                                              context: context,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      15)),
                                              isScrollControlled: true,
                                              builder:
                                                  (context) => Directionality(
                                                textDirection: rtl,
                                                child: Container(
                                                  color: Colors
                                                      .transparent,
                                                  height: MediaQuery.of(
                                                      context)
                                                      .size
                                                      .height /
                                                      1.3,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(
                                                                8.0),
                                                            child: Align(
                                                              alignment:
                                                              Alignment
                                                                  .topLeft,
                                                              child:
                                                              Container(
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                    ice,
                                                                    shape:
                                                                    BoxShape.circle),
                                                                child: IconButton(
                                                                    padding: EdgeInsets.all(0.0),
                                                                    icon: Icon(
                                                                      CupertinoIcons.clear_thick,
                                                                      color:
                                                                      mode.titleTextColor,
                                                                    ),
                                                                    onPressed: () {
                                                                      FocusScope.of(context).requestFocus(FocusNode());
                                                                      Navigator.pop(context);
                                                                    }),
                                                              ),
                                                            ),
                                                          ),
                                                          answersList(
                                                              reply,questions[index].id,
                                                              index),
                                                        ],
                                                      ),
                                                      Container(
                                                        color: ice,
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 30.0,horizontal: 20),
                                                          child: Form(
                                                            key: _formKey1,
                                                            child: TextFormField(
                                                              maxLines: 1,
                                                              controller: _replyController,
                                                              decoration: InputDecoration(
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
                                                                hintText: "الجواب",
                                                                suffixIcon: IconButton(
                                                                    icon: Icon(Icons.send),
                                                                    color: mode.easternBlueColor,
                                                                    onPressed: () {
                                                                      final form = _formKey1.currentState;
                                                                      form.save();
                                                                      if (form.validate() == true) {
                                                                        addAnswers(index, widget.courseDetails.course.id,
                                                                          questions[index].id,);
                                                                      }
                                                                    }),
                                                              ),
                                                              validator: (val) {
                                                                if (val.length == 0) {
                                                                  return "أكتب الجواب";
                                                                }
                                                                return null;
                                                              },
                                                              onSaved: (val) => _replyController.text = val,
                                                            ),
                                                          ),
                                                        ),)
                                                    ],
                                                  ),
                                                ),
                                              ));
                                        },
                                        icon: SvgPicture.asset(
                                          'assets/icons/comment.svg',
                                          height: 20,
                                          color: dark,
                                        ),
                                        label: Text(
                                          "${questions[index].answer.length}",
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: dark),
                                        )),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            Container(
              color: ice,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0,horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _askQuizController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: ice,
                            focusColor: pink,
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  if (_formKey.currentState.validate())
                                    askQuestions(context,
                                        widget.courseDetails.course.id);
                                },
                                child: RotatedBox(
                                    quarterTurns: 8,
                                    child: Icon(
                                      Icons.send,
                                      color: dark,
                                    ))),
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
                                        offset: Offset(
                                            0, 1), // changes position of shadow
                                      ),
                                    ],
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/icons/user_avatar.png'))),
                              ),
                            ),
                            // border: OutlineInputBorder(
                            //   borderRadius: BorderRadius.circular(10.0),
                            // ),
                            hintText: "أسئل سؤال"),
                        validator: (val) {
                          if (val.length == 0) {
                            return "حقل السؤال فارغ";
                          }
                          return null;
                        },
                        onSaved: (val) => _askQuizController.text = val,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget answersList(reply, questionId, index) {
    T.Theme mode = Provider.of<T.Theme>(context);
    List<Widget> list = new List();
    for (int i = 0; i < reply.length; i++) {
      list.add(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          reply[i].imagepath == null
              ? Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).accentColor.withOpacity(0.5),
                          spreadRadius: 0.5,
                          blurRadius: 12,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ],
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage('assets/icons/user_avatar.png'))),
                )
              : Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: reply[i].imagepath.toString().replaceAll(
                                    'https://eclass.smartmediajo.com/images/user_img',
                                    '') !=
                                ''
                            ? NetworkImage(reply[i].imagepath)
                            : AssetImage('assets/icons/user_avatar.png'),
                        fit: BoxFit.cover),
                  ),
                ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "${reply[i].user}",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                    color: dark,
                  ),
                ),
                Text(
                  "${reply[i].answer}",
                  maxLines: 4,
                  style: TextStyle(fontSize: 16.0, color: mode.titleTextColor),
                ),
                Divider()
              ],
            ),
          ),
        ],
      ));
    }
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          
          children: [
            Column(
              children: list,
            ),

          ],
        ));
  }
}
