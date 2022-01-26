import 'dart:convert';

import 'package:eclass/Screens/home_screen.dart';
import 'package:eclass/common/apidata.dart';
import 'package:eclass/model/instructor.dart';
import 'package:eclass/model/instructor_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../common/theme.dart' as T;

class InstructorList extends StatefulWidget {
 final InstructorModelList instructor;


   InstructorList({Key key, this.instructor}) : super(key: key);

  @override
  _InstructorListState createState() => _InstructorListState();
}

class _InstructorListState extends State<InstructorList> {
  Color therd = Color(0xffF84B63);

  T.Theme mode;
  Instructor detials;
  @override
  Widget build(BuildContext context) {
    mode = Provider.of<T.Theme>(context);
    // InstructorProvider instructorProvider = Provider.of<InstructorProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        height: 65,
        child:  ListView.builder(
                shrinkWrap: true,
                itemCount: this.widget.instructor?.instructors?.length??0,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) =>
                    item(this.widget.instructor.instructors[index]),
              ),
      ),
    );
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
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: instructorItem.userImg == '' ||
                                            instructorItem.userImg == null
                                        ? AssetImage('assets/icons/user_avatar.png')
                                        : NetworkImage(
                                            '${APIData.userImage}${instructorItem.userImg}'),
                                    fit: BoxFit.cover)),
                          ),
                        ),

                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Center(
                      child: Text.rich(
                        TextSpan(text: '', children: [
                          TextSpan(
                              text:
                                  '${instructorItem.fname} ${instructorItem.lname}\n',
                              style: TextStyle(
                                  color: therd,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11)),
                          TextSpan(
                              text: 'مدرب\n',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 8,
                                  color: T.Theme().fCatTextColor)),
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
