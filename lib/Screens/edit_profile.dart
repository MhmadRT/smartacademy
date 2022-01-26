import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:eclass/Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../common/apidata.dart';
import '../common/global.dart';
import '../common/theme.dart' as T;
import '../provider/user_profile.dart';
import 'password_reset_screen.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Dio dio = new Dio();

  // String pathName = "";
  File _image;
  final picker = ImagePicker();

  bool social = false;

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
        // imgCtl.text = extractName(_image.path);
        // _imgsel = true;
      } else {}
    });
  }

  Future getImageGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
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

  Widget _getEditIcon() {
    return new InkWell(
      child: new CircleAvatar(
        backgroundColor: pink,
        radius: 17.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 17.0,
        ),
      ),
      onTap: () {
        _showPicker(context);
      },
    );
  }

  String upfname = "", uplname = "", upmob = "", updetail = "", upaddress = "";

  Widget inputField(BuildContext ctx, String hintTxt, String label, int idx,
      double width, Color borderclr) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        initialValue: hintTxt,
        validator: (value) {
          if (value == "") {
            return "لايمكن ان يكون الحقل فارغ";
          }
          return null;
        },
        maxLines: 1,
        onChanged: (value) {
          if (idx == 0) {
            upfname = value;
          } else if (idx == 1) {
            uplname = value;
          } else if (idx == 2) {
            upmob = value;
          } else if (idx == 3) {
            pass = value;
          } else if (idx == 4) {
            upaddress = value;
          } else {
            updetail = value;
          }
        },
        cursorColor: Colors.black,
        style: TextStyle(color: Colors.black, fontSize: 15),
        decoration: InputDecoration(
          hintText: label,
          filled: true,
          fillColor: ice,
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: ice,
              width: 2.0,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: ice,
              width: 2.0,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: ice,
              width: 1.0,
            ),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.grey[500]),
        ),
      ),
    );
  }

  String pass = "";

  Future<bool> updateDetails(String email) async {
    String url = APIData.updateUserProfile + APIData.secretKey;
    String imagefileName = _image != null ? _image.path.split('/').last : '';
    var headers = {
      "content-type": "multipart/form-data",
      "authorization": "Bearer $authToken"
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('${APIData.updateUserProfile + APIData.secretKey}'));
    request.fields.addAll({
      "email": email,
      "current_password": password.text,
      "fname": upfname.toString(),
      "lname": uplname.toString(),
      "mobile": upmob.toString(),
      "address": 'NA',
      "detail": 'NA',
    });
    if (_image != null)
      request.files
          .add(await http.MultipartFile.fromPath('user_img', _image.path));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    String httpResponse = await response.stream.bytesToString();
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(httpResponse);
    } else {
      print(response.reasonPhrase);
    }
    if (response.statusCode == 200) {
      return true;
    } else
      return false;
  }

  Widget showImage(String img) {
    return Container(
      height: 130,
      width: 130,
      child: Stack(children: [
        Center(
          child: CircleAvatar(
            radius: 55.0,
            backgroundImage: _image == null
                ? ((img == "" || img == "null")
                    ? AssetImage("assets/placeholder/avatar.png")
                    : CachedNetworkImageProvider(
                        APIData.userImage + img,
                      ))
                : FileImage(_image),
          ),
        ),
        Positioned(right: 7, bottom: 7, child: _getEditIcon())
      ]),
    );
  }

  bool isloading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController password = TextEditingController();

  Widget form(
      String img,
      String fName,
      String lName,
      String mobileNum,
      String detail,
      String add,
      double halfWi,
      double fullWi,
      Color bordercolor,
      String email) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            //img
            showImage(img),
            SizedBox(
              height: 20,
            ),
            //Name
            Row(
              children: [
                Expanded(
                    child: inputField(
                        context, fName, "الإسم الأول", 0, fullWi, bordercolor)),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: inputField(
                      context, lName, "الإسم الأخير", 1, fullWi, bordercolor),
                ),
              ],
            ),

            //mobile
            inputField(
                context, mobileNum, "رقم الهاتف", 2, fullWi, bordercolor),
            Row(
              children: [

                Checkbox(
                    value: social,
                    onChanged: (v) {
                      setState(() {
                        social = v;
                        if (social) {
                          password.text = 'password';
                        }else{
                          password.text='';
                        }
                      });
                    }),
                Text('مستخدم عن طريق مواقع التواصل الاجتماعي'),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: TextFormField(
                controller: password,
                obscureText: true,
                validator: (value) {
                  if (value == "") {
                    return "لايمكن ان يكون الحقل فارغ";
                  }
                  return null;
                },
                maxLines: 1,
                onChanged: (value) {
                  pass = value;
                },
                cursorColor: Colors.black,
                style: TextStyle(color: Colors.black, fontSize: 15),
                decoration: InputDecoration(
                  hintText: "كلمة المرور",
                  filled: true,
                  fillColor: ice,

                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: ice,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: ice,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: ice,
                      width: 1.0,
                    ),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[500]),
                ),
              ),
            ),
            //address
           SizedBox(
              height: 40.0,
            ),
            InkWell(
              onTap: () async {
                UserProfile user =
                    Provider.of<UserProfile>(context, listen: false);
                // String userpass =
                //     Provider.of<detailsprovider>(context, listen: false)
                //         .Pass
                //         .value;
                setState(() {
                  isloading = true;
                });
                if (upfname == "") upfname = user.profileInstance.fname;
                if (uplname == "") uplname = user.profileInstance.lname;
                if (upmob == "") upmob = user.profileInstance.mobile;
                if (_formKey.currentState.validate())
                  await updateDetails(email).then((value) async {
                    if (value) {
                      scaffoldKey.currentState.showSnackBar(
                          SnackBar(content: Text("تم تحديث الملف الشخصي")));
                      await user.fetchUserProfile();
                    } else {
                      scaffoldKey.currentState.showSnackBar(
                          SnackBar(content: Text("فشل تحديث الملف الشخصي")));
                    }
                  });

                setState(() {
                  isloading = false;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: pink,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: pink.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 30,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Container(
                  padding: EdgeInsets.all(isloading ? 5 : 0),
                  height: 40,
                  width: 120,
                  decoration: BoxDecoration(),
                  alignment: Alignment.center,
                  child: isloading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Center(
                          child: Text(
                            "تحديث",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                ),
              ),
            ),

            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

  void handleDropDownTap(String value) {
    if (value == "Change Password") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => PasswordReset(1)));
    }
  }

  AppBar pappbar(Color bgColor, Color txtColor) {
    return AppBar(
      elevation: 0.0,
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: pink,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          }),
      centerTitle: true,
      title: Text(
        "تعديل المعلومات الشخصية",
        style: TextStyle(
          color: pink,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: bgColor,
      actions: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: PopupMenuButton<String>(
            child: Container(
              margin: EdgeInsets.only(right: 20),
              child: Icon(
                FontAwesomeIcons.ellipsisV,
                color: txtColor,
                size: 20,
              ),
            ),
            onSelected: handleDropDownTap,
            itemBuilder: (BuildContext context) {
              return {'Change Password'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        )
      ],
    );
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Widget scaffoldView(user, halfwi, fullwi, mode) {
    return SingleChildScrollView(
      child: form(
          user.profileInstance.userImg == null
              ? ""
              : user.profileInstance.userImg,
          user.profileInstance.fname == null ? "" : user.profileInstance.fname,
          user.profileInstance.lname == null ? "" : user.profileInstance.lname,
          user.profileInstance.mobile == null
              ? ""
              : user.profileInstance.mobile,
          user.profileInstance.detail == null
              ? ""
              : user.profileInstance.detail,
          user.profileInstance.address == null
              ? ""
              : user.profileInstance.address,
          halfwi,
          fullwi,
          mode.notificationIconColor,
          user.profileInstance.email == null ? "" : user.profileInstance.email),
    );
  }

  @override
  Widget build(BuildContext context) {
    double fullwi = MediaQuery.of(context).size.width - 30;
    double halfwi = (MediaQuery.of(context).size.width / 2) - 30;
    UserProfile user = Provider.of<UserProfile>(context);
    T.Theme mode = Provider.of<T.Theme>(context);
    return Directionality(
      textDirection: rtl,
      child: Scaffold(
          key: scaffoldKey,
          backgroundColor: mode.bgcolor,
          appBar: pappbar(mode.bgcolor, mode.notificationIconColor),
          body: scaffoldView(user, halfwi, fullwi, mode)),
    );
  }
}
