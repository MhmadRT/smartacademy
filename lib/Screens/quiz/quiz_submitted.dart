import 'package:eclass/Screens/home_screen.dart';
import 'package:eclass/Widgets/appbar.dart';
import 'package:eclass/common/theme.dart' as T;
import 'package:eclass/model/content_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'check_quiz_result.dart';

// ignore: must_be_immutable
class QuizSubmitted extends StatelessWidget {
  final List<QuizQuestion> questions;
  final Map<int, dynamic> answers;

  int correctAnswers;

  QuizSubmitted({Key key, @required this.questions, @required this.answers})
      : super(key: key) {}

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    int correct = 0;
    this.answers.forEach((index, value) {
      if (this.questions[index].correct == value) correct++;
    });
    final TextStyle titleStyle = TextStyle(
        color: mode.titleTextColor,
        fontSize: 18.0,
        fontWeight: FontWeight.w500);
    final TextStyle trailingStyle = TextStyle(
        color: mode.easternBlueColor,
        fontSize: 20.0,
        fontWeight: FontWeight.bold);

    return Directionality(
      textDirection: rtl,
      child: Scaffold(
        appBar: customAppBar(context, "نتيجة الاختبار"),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: ice,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text("مجموع الاسئلة", style: titleStyle),
                        trailing:
                            Text("${questions.length}", style: trailingStyle),
                      ),
                      ListTile(
                        title: Text("النقاط", style: titleStyle),
                        trailing: Text("${correct / questions.length * 100}%",
                            style: trailingStyle),
                      ),
                      ListTile(
                        title: Text("الإجابات الصحيحة", style: titleStyle),
                        trailing: Text("$correct/${questions.length}",
                            style: trailingStyle),
                      ),
                      ListTile(
                        title: Text("الإجابات الخاطئة", style: titleStyle),
                        trailing: Text(
                            "${questions.length - correct}/${questions.length}",
                            style: trailingStyle),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      color: dark,
                      child: Text(
                        "رجوع",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: RaisedButton(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      color: pink,
                      child: Text(
                        "عرض التقرير",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => CheckQuizResult(
                                  questions: questions,
                                  answers: answers,
                                )));
                      },
//                    child: Text("Check Answers", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.white),),
//                    onPressed: (){
//                      Navigator.of(context).push(MaterialPageRoute(
//                        builder: (_) => CheckAnswersPage(questions: questions, answers: answers,)
//                      ));
//                    },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
