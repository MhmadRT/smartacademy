import 'package:eclass/Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html/parser.dart';
import 'package:provider/provider.dart';

import '../model/faq_model.dart';

class FaqView extends StatefulWidget {
  @override
  _FaqViewState createState() => _FaqViewState();
}

class _FaqViewState extends State<FaqView> {
  Widget html(htmlContent, clr, size) {
    return HtmlWidget(
      htmlContent,
      textStyle: TextStyle(
        fontSize: size,
        color: clr,
      ),
      customStylesBuilder: (element) {
        return {
          'text-overflow': 'ellipsis',
          'font-weight': '600',
          'font-size': '16',
          'align': 'justify'
        };
      },
    );
  }

  List<Widget> _buildExpansionTileChildren(index, faq) => [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: html(
              faq[index].details, Color(0xff3F4654).withOpacity(0.7), 16.0),
        ),
      ];
  int idx = -1;

  Widget expansionTile(index, faq) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Container(
        decoration: BoxDecoration(
          color: ice.withOpacity(0),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: dark.withOpacity(1),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: Text(
                  faq[index].title ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: ice, borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  parse(faq[index].details).body.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: dark, fontSize: 13, fontWeight: FontWeight.normal),
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    List<FaqElement> faq = Provider.of<List<FaqElement>>(context);
    return faq == null
        ? Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(pink),
            ),
          )
        : Directionality(
            textDirection: rtl,
            child: Scaffold(
              body: ListView.builder(
                key: Key('builder ${idx.toString()}'),
                shrinkWrap: true,
                itemCount: faq.length,
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                itemBuilder: (BuildContext context, int index) =>
                    expansionTile(index, faq),
              ),
            ),
          );
  }
}
