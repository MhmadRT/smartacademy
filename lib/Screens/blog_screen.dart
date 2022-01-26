import 'package:eclass/Widgets/appbar.dart';
import 'package:eclass/common/apidata.dart';
import 'package:eclass/common/theme.dart' as T;
import 'package:eclass/provider/blog_provider.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';

class BlogScreen extends StatefulWidget {
  BlogScreen(this.index);
  final int index;

  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    var blog = Provider.of<BlogProvider>(context).blogModel.blog[widget.index];
    return Directionality(
      textDirection: rtl,
      child: Scaffold(
        body: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: customAppBar(context, "${blog.heading}"),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: Image.network(
                      "${APIData.blogImage}${blog.image}",
                      fit: BoxFit.cover,
                    )
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${blog.heading}',
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 25,
                          color: mode.titleTextColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      Text(
                        DateFormat.yMd().format(blog.updatedAt),
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 12,
                          color: mode.titleTextColor.withOpacity(0.6),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        '${parse(blog.detail).body.text}',
                        style: TextStyle(color: mode.titleTextColor, fontSize: 16.0, height: 1.5),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
