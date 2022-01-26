import 'package:eclass/Screens/blog_screen.dart';
import 'package:eclass/Screens/home_screen.dart';
import 'package:eclass/Widgets/appbar.dart';
import 'package:eclass/common/apidata.dart';
import 'package:eclass/common/theme.dart' as T;
import 'package:eclass/provider/blog_provider.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BlogListScreen extends StatefulWidget {

  @override
  _BlogListScreenState createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
bool _visible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final blogs= Provider.of<BlogProvider>(context, listen: false);
      await blogs.fetchBlogList(context);
      setState(() {
        _visible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var blogModel = Provider.of<BlogProvider>(context).blogModel;
    T.Theme mode = Provider.of<T.Theme>(context);
    return Directionality(
      textDirection: rtl,
      child: Scaffold(
        appBar: customAppBar(context,'مدونات'),
         body: _visible == true ? blogModel.blog.length<1?Container(
           child: Center(
             child: Image.asset(
               'assets/images/emptycategory.png',
             ),
           ),
         ):ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            itemCount: blogModel.blog.length,
            itemBuilder: (context, index){
              return Container(
                margin: EdgeInsets.only(bottom: 20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                            child: Image.network("${APIData.blogImage}${blogModel.blog[index].image}",
                              height: 200,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              alignment: Alignment.center,),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text("${blogModel.blog[index].heading}", style: TextStyle(fontSize: 18.0,
                                color: mode.titleTextColor,
                                fontWeight: FontWeight.w700), maxLines: 2, overflow: TextOverflow.ellipsis,),),
                          SizedBox(
                            height: 5.0,
                          ),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10.0), child: Text(
                            DateFormat.yMMMd().format(DateTime.parse("${blogModel.blog[index].updatedAt}"),),
                            style: TextStyle(
                                color: mode.titleTextColor.withOpacity(0.5),
                                fontSize: 13.0),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),),
                          SizedBox(
                            height: 5.0,
                          ),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              "${parse(blogModel.blog[index].detail).body.text}",
                              style: TextStyle(
                                  color: mode.titleTextColor.withOpacity(0.7),
                                  fontSize: 13.0),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Divider()
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> BlogScreen(index)));
                    }
                  ),
                ),
              );
            }) : Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
