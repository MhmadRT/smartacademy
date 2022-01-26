import 'package:eclass/Screens/home_screen.dart';
import 'package:eclass/Widgets/appbar.dart';
import 'package:eclass/common/theme.dart' as T;
import 'package:eclass/provider/content_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AnnouncementScreen extends StatefulWidget {
  @override
  _AnnouncementScreenState createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    var content =
        Provider.of<ContentProvider>(context, listen: false).contentModel;
    return Directionality(
      textDirection: rtl,
      child: Scaffold(
        appBar: customAppBar(context, "إعلان"),
        body: ListView.builder(
            itemCount: content.announcement.length,
            padding: EdgeInsets.symmetric(horizontal: 18.0),
            itemBuilder: (BuildContext context, int i) {
              return DescriptionTextWidget(
                text: "${content.announcement[i].detail}",
                index: i,
              );
            }),
      ),
    );
  }
}

class DescriptionTextWidget extends StatefulWidget {
  final String text;
  final int index;

  DescriptionTextWidget({@required this.text, this.index});

  @override
  _DescriptionTextWidgetState createState() =>
      new _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  String firstHalf;
  String secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > 130) {
      firstHalf = widget.text.substring(0, 130);
      secondHalf = widget.text.substring(130, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    var content =
        Provider.of<ContentProvider>(context, listen: false).contentModel;
    return Container(
      padding: new EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      margin: EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: firstHalf.isEmpty
          ? Center(child: Column(
            children: [
              Image.asset('assets/images/emptycategory.png'),
              new Text('لا يوجد إعلانات'),
            ],
          ))
          : new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${content.announcement[widget.index].user}",
                  style: new TextStyle(
                      color: dark,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 5.0,
                ),
                new Text(
                  flag ? (firstHalf + "...") : (firstHalf + secondHalf),
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 16.0, color:dark),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  DateFormat.yMMMd()
                      .add_jm()
                      .format(content.announcement[widget.index].updatedAt),
                  style: new TextStyle(
                    color: dark.withOpacity(0.5),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,),
                ),
                new InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Text(
                        flag ? "اقرأ أكثر" : "أقرأ أقل",
                        style: new TextStyle(
                            color: pink,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      flag = !flag;
                    });
                  },
                ),
                Divider()
              ],
            ),
    );
  }
}
