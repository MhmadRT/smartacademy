import 'package:eclass/Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
class PDFView extends StatelessWidget {
  final String url,title;
  const PDFView(this.url,this.title);

  @override
  Widget build(BuildContext context) {
    return  Directionality(
      textDirection: rtl,
      child: Scaffold(
        appBar:
        AppBar(
          backgroundColor: dark,
          title: Text('$title'),
        ),
        // body: WebView(initialUrl: url,),
        body:   SfPdfViewer.network(
        url
        ),
      ),
    );
  }
}
