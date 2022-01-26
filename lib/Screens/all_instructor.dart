import 'dart:convert';

import 'package:eclass/common/apidata.dart';
import 'package:eclass/model/instructor.dart';
import 'package:eclass/model/instructor_model.dart';
import 'package:eclass/provider/instructor_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../common/theme.dart' as T;
import 'home_screen.dart';

class AllInstructor extends StatefulWidget {
  @override
  _AllInstructorState createState() => _AllInstructorState();
}

class _AllInstructorState extends State<AllInstructor> {
  InstructorModelList instructor = new InstructorModelList();
  bool isLoading = true;

  Instructor detials;

  @override
  void initState() {
    isLoading = true;
    getBody();
  }

  Color therd = Color(0xffF84B63);
  T.Theme mode;

  @override
  Widget build(BuildContext context) {
    mode = Provider.of<T.Theme>(context);

    // InstructorProvider instructorProvider = Provider.of<InstructorProvider>(context, listen: false);
    return Directionality(
      textDirection: rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('مدربين أبعاد', style: TextStyle(color: pink),),
          iconTheme: IconThemeData(color: pink),
          elevation: 0.0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Container(
            child: isLoading
                ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal:20.0),
                  child: ListView.builder(
                  itemCount: 100, itemBuilder: (context, index) {
              return Container(
                  height: 70,
                  width: 140,
                  child: Shimmer.fromColors(
                    baseColor: Color(0xFFd3d7de),
                    highlightColor: Color(0xFFe2e4e9),
                    child: Card(
                      elevation: 0.0,
                      color: Color.fromRGBO(45, 45, 45, 1.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12000),
                        ),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Container(
                        height: 70,
                        width: 100,
                      ),
                    ),
                  ),
              );
            }),
                )
                : ListView.builder(
                shrinkWrap: true,
                itemCount: instructor.instructors?.length,
                itemBuilder: (context, index) =>
                    Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      child: item(instructor.instructors[index]),
                    )),
          ),
        ),
      ),
    );
  }

  Future<Null> getBody() async {
    InstructorProvider instructorProvider =
    Provider.of<InstructorProvider>(context, listen: false);
     instructorProvider.getInstructors(context);
    setState(() {
      this.instructor=instructorProvider.instructor;
      isLoading = false;
    });
  }

  getinstdata(dynamic id) async {
    Instructor insdetail;
    String url = "${APIData.instructorProfile}${APIData.secretKey}";
    print(url);
    Response res = await post(url, body: {"instructor_id": "$id"});
    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      insdetail = Instructor.fromJson(body);
    } else {
      throw "${res.statusCode}err";
    }
    detials = insdetail;
    return insdetail;
  }

  item(InstructorModel instructorItem) {
    return InkWell(
      onTap: () async {
        showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                children: [Center(child: CircularProgressIndicator())],
              );
            });
        Instructor instructor = await getinstdata(instructorItem.id);
        Navigator.pop(context);

        Navigator.of(context)
            .pushNamed('/InstructorScreen', arguments: instructor.user.id);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Container(
          height: 60,
          child: Container(
            decoration: BoxDecoration(
                color: ice, borderRadius: BorderRadius.circular(100)),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: instructorItem.userImg == '' ||
                                    instructorItem.userImg == null
                                    ? AssetImage(
                                    'assets/icons/user_avatar.png')
                                    : NetworkImage(
                                    '${APIData.userImage}${instructorItem
                                        .userImg}'),
                                fit: BoxFit.cover)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Center(
                      child: Text.rich(
                        TextSpan(text: '', children: [
                          TextSpan(
                              text:
                              '${instructorItem.fname} ${instructorItem
                                  .lname}\n',
                              style: TextStyle(
                                  color: therd,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11)),
                          TextSpan(
                              text: 'مدرب\n',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 8,
                                  color: T
                                      .Theme()
                                      .fCatTextColor)),
                        ]),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
