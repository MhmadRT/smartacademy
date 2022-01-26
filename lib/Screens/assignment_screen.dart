import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eclass/Screens/home_screen.dart';
import 'package:eclass/Widgets/appbar.dart';
import 'package:eclass/common/apidata.dart';
import 'package:eclass/common/global.dart';
import 'package:eclass/common/theme.dart' as T;
import 'package:eclass/provider/full_course_detail.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class AssignmentScreen extends StatefulWidget {
  AssignmentScreen(this.courseDetails);

  final FullCourse courseDetails;

  @override
  _AssignmentScreenState createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  final _formKey = GlobalKey<FormState>();
  Dio dio = new Dio();
  String _mySelection;
  bool _visible = false;
  FormData formData;
  TextEditingController titleController = new TextEditingController();
  bool isUploading = false;
  var sFileName;
  List<ChaptersData> data = [];
  PlatformFile file;

  Widget dropDown(List<ChaptersData> data) {
    if (data.length != 0) {
      return Container(
        height: 50,
        decoration:
            BoxDecoration(color: ice, borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Center(
            child: DropdownButton<String>(
              dropdownColor: ice,
              icon: Icon(Icons.keyboard_arrow_down_outlined),
              underline: Text(''),
              isExpanded: true,
              isDense: true,
              hint: new Text("إختر الوحدة"),
              value: _mySelection,
              onChanged: (String newValue) {
                setState(() {
                  _mySelection = newValue;
                });

                print(_mySelection);
              },
              items: data.map((ChaptersData item) {
                return DropdownMenuItem<String>(
                  value: item.chapterId,
                  child: Text(
                    item.chapterName,
                    overflow: TextOverflow.fade,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      );
    } else
      return Center(
        child: CircularProgressIndicator(),
      );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _visible = false;
    });
    getChaptersList();
  }

  getChaptersList() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var chapters = widget.courseDetails.course.chapter;
      for (int i = 0; i < chapters.length; i++) {
        data.add(
            ChaptersData("${chapters[i].id}", "${chapters[i].chapterName}"));
      }
      setState(() {
        _visible = true;
      });
    });
  }

  void uploadAssignment(file, courseId, chapterId) async {
    setState(() {
      isUploading = true;
    });
    showLoaderDialog(context);
    var _body;
    String fileName = file != null ? file.path.split('/').last : '';
    print(fileName);
    print(file.path);
    print(titleController.text);
    _body = FormData.fromMap({
      "course_id": "$courseId",
      "chapter_id": "$chapterId",
      "title": "${titleController.text}",
      "file": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });
    final response =
        await dio.post("${APIData.submitAssignment}${APIData.secretKey}",
            data: _body,
            options: Options(
                method: 'POST',
                headers: {
                  "Accept": "application/json",
                  HttpHeaders.authorizationHeader: "Bearer $authToken",
                },
                responseType: ResponseType.plain,
                followRedirects: false,
                validateStatus: (status) {
                  return status < 500;
                }));
    print(response.statusMessage);
    print(response.data);
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        isUploading = false;
      });
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: "تم إرسال الواجب بنجاح!",
          textColor: Colors.white,
          backgroundColor: Colors.green);
    } else {
      setState(() {
        isUploading = false;
      });
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: "فشل إرسال الواجب",
          textColor: Colors.white,
          backgroundColor: Colors.red);
    }
  }

  // Alert dialog after clicking on login button
  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("ارسال...")),
        ],
      ),
    );
    if (isUploading == true) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    return Directionality(
      textDirection: rtl,
      child: Scaffold(
        appBar: customAppBar(context, "واجب"),
        body: _visible == false
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 60.0),
                scrollDirection: Axis.vertical,
                children: [
                  Image.asset(
                    'assets/images/assig.png',
                    height:200,
                  ),
                  SizedBox(height: 40,),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: ice,
                            borderRadius: BorderRadius.circular(15)),
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: InkWell(
                            onTap: () async {
                              FilePickerResult result =
                                  await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: [
                                  'jpg',
                                  'pdf',
                                  'doc',
                                  'zip',
                                  'png',
                                  'jpeg'
                                ],
                              );
                              if (result != null) {
                                file = result.files.first;
                                setState(() {
                                  sFileName = file.name;
                                });
                              } else {}
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.attach_file,
                                  size: 15,
                                  color: yellow,
                                ),
                                SizedBox(
                                  width: 2,
                                ), Text(
                                  "إختر ملف",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                      color: dark),

                        ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(child: dropDown(data)),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  sFileName==null?Container(): Center(
                    child: Container(
                      height: 20,
                      child: Text(sFileName,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(
                          fontSize: 12.0,

                          fontWeight: FontWeight.w300,
                          color: dark),),
                    ),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Container(
                      child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: titleController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: ice,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: "ادخل عنوان الواجب",
                        hintStyle: TextStyle(color: dark, fontSize: 16.0),
                        focusedErrorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Colors.transparent, width: 2.0)),
                        focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Colors.transparent, width: 2.0)),
                      ),
                      validator: (value) {
                        if (value.length == 0) {
                          return "يجب أدخال العنوان";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) => titleController.text = value,
                    ),
                  )),
                  SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 45,
                      decoration: BoxDecoration(
                          color: pink, borderRadius: BorderRadius.circular(15),  boxShadow: [
                        BoxShadow(
                          color: pink.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 40,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],),
                      child: InkWell(
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          final form = _formKey.currentState;
                          form.save();
                          if (form.validate() == true) {
                            if (_mySelection != null) {
                              if (sFileName != null) {
                                uploadAssignment(
                                    file,
                                    widget.courseDetails.course.id,
                                    _mySelection);
                              } else {
                                Fluttertoast.showToast(
                                    msg: "اختر ملف الواجب");
                              }
                            } else {
                              Fluttertoast.showToast(msg: "حدد الفصل");
                            }
                          } else {
                            return;
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Center(
                            child: Text(
                              "إرسال الواجب",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}

class ChaptersData {
  String chapterId;
  String chapterName;

  ChaptersData(this.chapterId, this.chapterName);
}
