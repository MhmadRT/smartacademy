import 'package:eclass/Screens/home_screen.dart';
import 'package:eclass/Widgets/appbar.dart';
import 'package:eclass/common/theme.dart' as T;
import 'package:eclass/model/content_model.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:provider/provider.dart';

class CheckQuizResult extends StatelessWidget {
  final List<QuizQuestion> questions;
  final Map<int, dynamic> answers;

  const CheckQuizResult(
      {Key key, @required this.questions, @required this.answers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    return Directionality(
      textDirection: rtl,
      child: Scaffold(
        appBar: customAppBar(context, "نتيجة الاختبار"),
        body: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: questions.length + 1,
          itemBuilder: _buildItem,
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    T.Theme mode = Provider.of<T.Theme>(context);
    if (index == questions.length) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: Container(
          height: 45,
          child: RaisedButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: mode.easternBlueColor,
            child: Text("الرئيسية", style: TextStyle(color: Colors.white),),
            onPressed: () {
              Navigator.of(context).popUntil(ModalRoute.withName(Navigator.defaultRouteName));
            },
          ),
        ),
      );
    }
    QuizQuestion question = questions[index];
    bool correct = question.correct == answers[index];
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: ice,
        borderRadius: BorderRadius.circular(15)

      ),

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              HtmlUnescape().convert(question.question),
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0),
            ),
            SizedBox(height: 5.0),
            Text(
              HtmlUnescape().convert("${answers[index]}"),
              style: TextStyle(
                  color: correct ? Colors.green : Colors.red,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5.0),
            correct
                ? Container()
                : Text.rich(
                    TextSpan(children: [
                      TextSpan(text: "الإجابة: "),
                      TextSpan(
                          text: HtmlUnescape().convert(question.correct),
                          style: TextStyle(fontWeight: FontWeight.w500))
                    ]),
                    style: TextStyle(fontSize: 16.0),
                  )
          ],
        ),
      ),
    );
  }
}