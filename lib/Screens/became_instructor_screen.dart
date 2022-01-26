import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../Widgets/utils.dart';
import '../common/apidata.dart';
import '../common/global.dart';
import '../common/theme.dart' as T;
import 'home_screen.dart';

class BecomeInstructor extends StatefulWidget {
  @override
  _BecomeInstructorState createState() => _BecomeInstructorState();
}

class _BecomeInstructorState extends State<BecomeInstructor> {
  List<String> genders = [
    "أختر",
    "ذكر",
    "انثى",
  ];
  String _gender = "أختر";
  String _fname = "", _lname = "", _email = "", _phone = "", _detail = "";
  TextStyle _labelStyle =
      TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: dark);

  TextStyle _mainStyle(txtColor) {
    return TextStyle(color: txtColor, fontSize: 17);
  }

  UnderlineInputBorder enborder(Color borderClr) {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        color: borderClr.withOpacity(0.7),
        width: 1.0,
      ),
    );
  }

  File _image;
  final picker = ImagePicker();

  String _dateofbirth = "";
  bool _datesel = false;
  TextEditingController dobCtrl = new TextEditingController();

  File _resume;

  TextEditingController imgCtl = new TextEditingController();
  bool _imgsel = false;

  TextEditingController resumeCtl = new TextEditingController();
  bool _resumeSel = false;

  UnderlineInputBorder foborder(Color borderClr) {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        color: borderClr,
        width: 2.0,
      ),
    );
  }

  void _updateDetails(int idx, String value) {
    switch (idx) {
      case 0:
        setState(() {
          _fname = value;
        });
        break;
      case 1:
        setState(() {
          _lname = value;
        });
        break;
      case 2:
        setState(() {
          _email = value;
        });
        break;
      case 3:
        setState(() {
          _phone = value;
        });
        break;
      case 4:
        setState(() {
          _detail = value;
        });
        break;
      default:
    }
  }

  Widget gender(Color borderClr) {
    return Container(
      height: 90,
      child: DropdownButtonFormField(
        validator: (value) {
          if (value == "أختر")
            return "الرجاء تحديد الجنس!";
          else
            return null;
        },
        items: genders.map((String gender) {
          return DropdownMenuItem(
            value: gender,
            child: Text(gender, style: _mainStyle(txtColor)),
          );
        }).toList(),
        onChanged: (newValue) {
          // do other stuff with _category
          setState(() => _gender = newValue);
        },
        value: _gender,
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
            hintStyle: TextStyle(color: dark, fontSize: 19.0),
            focusedErrorBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent, width: 2.0)),
            border: border,
            focusedBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent, width: 2.0)),
            labelText: "الجنس",
            // border: InputBorder.none,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelStyle: _labelStyle),
      ),
    );
  }

  Widget inputField(String label, int idx, Color borderclr) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        validator: (value) {
          if (value == "") {
            return "لا يمكن ترك هذا الحقل فارغا!";
          }
          return null;
        },
        onChanged: (value) {
          _updateDetails(idx, value);
        },
        cursorColor: Colors.black,
        style: _mainStyle(txtColor),
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
          hintText: label,
          hintStyle: TextStyle(color: dark, fontSize: 19.0),
          focusedErrorBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.transparent, width: 2.0)),
          focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.transparent, width: 2.0)),
        ),
      ),
    );
  }

  Widget dateofbirth(Color borderClr) {
    return Container(
      height: 90,
      child: TextFormField(
        controller: dobCtrl,
        onTap: () async {
          DateTime date = DateTime(1900);
          FocusScope.of(context).requestFocus(new FocusNode());

          date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100));
          setState(() {
            _datesel = true;
            _dateofbirth = date.toIso8601String() ?? "";
          });
          dobCtrl.text = "${date.day}/${date.month}/${date.year}";
        },
        validator: (value) {
          if (value == "")
            return "الرجاء اختيار تاريخ صحيح!";
          else
            return null;
        },
        readOnly: true,
        style: TextStyle(
            color: txtColor,
            fontSize: 17,
            fontWeight: _datesel ? FontWeight.normal : FontWeight.w600),
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
          hintStyle: TextStyle(color: dark, fontSize: 19.0),
          focusedErrorBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.transparent, width: 2.0)),
          focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.transparent, width: 2.0)),
          labelText: "تاريخ الميلاد",
          labelStyle: _labelStyle,
        ),
      ),
    );
  }

  var border = UnderlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: Colors.transparent, width: 2.0));

  String extractName(String path) {
    int i;
    for (i = path.length - 1; i >= 0; i--) {
      if (path[i] == "/") break;
    }
    return path.substring(i + 1);
  }

  Future getImageCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        imgCtl.text = extractName(_image.path);
        _imgsel = true;
      } else {}
    });
  }

  Future getImageGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _imgsel = true;
        imgCtl.text = extractName(_image.path);
      } else {}
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('الصور'),
                      onTap: () async {
                        await getImageGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('الكاميرة'),
                    onTap: () async {
                      await getImageCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget imagepickerfield(Color borderClr) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        onTap: () {
          _showPicker(context);
        },
        controller: imgCtl,
        readOnly: true,
        maxLines: 1,
        validator: (value) {
          if (value.length == 0)
            return "ارفق الصورة الشخصية هنا!";
          else
            return null;
        },
        style: TextStyle(
            color: dark,
            fontSize: 17,
            fontWeight: _imgsel ? FontWeight.normal : FontWeight.w600),
        decoration: InputDecoration(
            filled: true,
            fillColor: ice,
            focusedBorder: border,
            enabledBorder: border,
            border: border,
            hintText: "الصورة الشخصية",
            labelStyle: _labelStyle),
      ),
    );
  }

  Future<bool> sendDetailsForInstructor() async {
    String url = APIData.becomeAnInstructor + APIData.secretKey;
    String imageName = _image.path.split('/').last;
    String resumeName = _resume.path.split('/').last;
    var _body = FormData.fromMap({
      "fname": _fname,
      "lname": _lname,
      "dob": dobCtrl.text,
      "email": _email,
      "gender": _gender,
      "mobile": _phone,
      "detail": _detail,
      "file": await MultipartFile.fromFile(_resume.path, filename: imageName),
      "image": await MultipartFile.fromFile(_image.path, filename: resumeName)
    });
    Response res;
    try {
      res = await Dio().post(url,
          data: _body,
          options: Options(method: 'POST', headers: {
            // ignore: deprecated_member_use
            HttpHeaders.AUTHORIZATION: "Bearer " + authToken,
            "Accept": "application/json"
          }));
    } catch (e) {}
    if (res.statusCode == 200) {
      return true;

    } else
      return false;
  }

  Widget resumePicker(Color borderClr) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        onTap: () async {
          FilePickerResult result = await FilePicker.platform.pickFiles(
              type: FileType.custom, allowedExtensions: ["pdf", "doc"]);
          if (result != null) {
            _resume = File(result.files.single.path);
            setState(() {
              _resumeSel = true;
              resumeCtl.text = extractName(_resume.path);
            });
          }
        },
        validator: (value) {
          if (value == "")
            return 'ارفق السيرة الذاتية هنا!';
          else
            return null;
        },
        controller: resumeCtl,
        readOnly: true,
        style: TextStyle(
            color: dark,
            fontSize: 17,
            fontWeight: _resumeSel ? FontWeight.normal : FontWeight.w600),
        decoration: InputDecoration(
            filled: true,
            fillColor: ice,
            focusedBorder: border,
            enabledBorder: border,
            hintText: 'السيرة الذاتية',
            border: border,
            labelStyle: _labelStyle),
      ),
    );
  }

  bool submitLoading = false;

  Widget submitButton(Color clr) {
    return InkWell(
      onTap: () async {
        setState(() {
          submitLoading = true;
        });
        if (_formKey.currentState.validate() == true) {
          bool x = await sendDetailsForInstructor();
          if (x) {
            _scaffoldKey.currentState
                .showSnackBar(SnackBar(content: Text("تم ارسال الطلب!")));
           Future.delayed(Duration(seconds: 1),(){
             Navigator.pop(context);
           });
          } else {
            _scaffoldKey.currentState
                .showSnackBar(SnackBar(content: Text("فشل إرسال الطلب!")));
          }
        }
        setState(() {
          submitLoading = false;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: pink,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: pink.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 40,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(submitLoading ? 5 : 0),
          height: 50,
          width: 120,
          alignment: Alignment.center,
          child: submitLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Center(
                  child: Text(
                    "إرسال",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
        ),
      ),
    );
  }

  Widget form(Color borderClr) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 1, child: inputField("الاسم الأول", 0, borderClr)),
            SizedBox(
              width: 10.0,
            ),
            Expanded(flex: 1, child: inputField("الاسم الأخير", 1, borderClr)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: dateofbirth(borderClr),
                )),
            SizedBox(
              width: 10.0,
            ),
            Expanded(flex: 1, child: gender(borderClr)),
          ],
        ),
        inputField("البريد الإلكتروني", 2, borderClr),
        inputField("رقم الاتصال", 3, borderClr),
        imagepickerfield(borderClr),
        resumePicker(borderClr),
        inputField("التفاصيل", 4, borderClr),
        SizedBox(
          height: 50,
        ),
        submitButton(Colors.red),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  double fullw, halfw;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Color txtColor;

  Widget scaffoldView(mode) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18),
      child: SingleChildScrollView(
          child: Form(key: _formKey, child: form(mode.notificationIconColor))),
    );
  }

  @override
  Widget build(BuildContext context) {
    fullw = MediaQuery.of(context).size.width - 30;
    halfw = fullw / 2.0;
    T.Theme mode = Provider.of<T.Theme>(context);
    txtColor = mode.txtcolor;
    return Directionality(
      textDirection: rtl,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: mode.bgcolor,
        appBar: secondaryAppBar(
            mode.notificationIconColor, mode.bgcolor, context, "التسجيل كمدرب"),
        body: scaffoldView(mode),
      ),
    );
  }
}
