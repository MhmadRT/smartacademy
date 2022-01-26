import 'dart:convert';
import 'dart:io' show Platform;

import 'package:eclass/Screens/bottom_navigation_screen.dart';
import 'package:eclass/Screens/home_screen.dart';
import 'package:eclass/common/apidata.dart';
import 'package:eclass/common/global.dart';
import 'package:eclass/provider/home_data_provider.dart';
import 'package:eclass/provider/user_details_provider.dart';
import 'package:eclass/services/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../services/http_services.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController passwordController2 = new TextEditingController();

  TextEditingController nameController2 = new TextEditingController();

  bool accept = true;

  Widget privacyPolicy() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
            value: accept,
            onChanged: (c) {
              setState(() {
                accept = c;
              });
            }),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: 'من خلال إنشاء حساب فإنك توافق على شروط ',
              style: TextStyle(
                fontSize: 16.0,
                color: dark.withOpacity(0.5),
                fontFamily: 'alfont_com_AlFont_com_din-next-lt-w23',
              ),
              children: <TextSpan>[
                TextSpan(
                    text: ' على شروط الخدمات ',
                    style: TextStyle(fontWeight: FontWeight.bold, color: dark)),
                TextSpan(text: 'و سياية الخصوصية لدى أبعاد المعرفة'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool _hidePass = true;

  Widget nameField() {
    return TextFormField(
      maxLines: 1,
      keyboardType: TextInputType.text,
      controller: nameController,
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
        hintText: "الإسم الأول",
        hintStyle: TextStyle(color: dark, fontSize: 19.0),
        focusedErrorBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.transparent, width: 2.0)),
        focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.transparent, width: 2.0)),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'ادخل الإسم الأول';
        }
        return null;
      },
    );
  }

  Widget nameField2() {
    return TextFormField(
      maxLines: 1,
      keyboardType: TextInputType.text,
      controller: nameController2,
      decoration: InputDecoration(
        helperStyle: TextStyle(color: Colors.transparent),
        filled: true,
        fillColor: ice,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        hintText: "الإسم الأخير",
        hintStyle: TextStyle(color: dark, fontSize: 19.0),
        focusedErrorBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.transparent, width: 2.0)),
        focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.transparent, width: 2.0)),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'ادخل الإسم الثاني';
        }
        return null;
      },
    );
  }

  Widget emailField() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
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
        hintText: "البريد الإلكتروني",
        hintStyle: TextStyle(color: dark, fontSize: 19.0),
        focusedErrorBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.transparent, width: 2.0)),
        focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.transparent, width: 2.0)),
      ),
      validator: (value) {
        if (value.length == 0) {
          return 'البريد الإلكتروني فارغ';
        } else {
          if (!value.contains('@')) {
            return 'البريد الإلكتروني غير صحيح';
          } else {
            return null;
          }
        }
      },
    );
  }

  Widget passwordField() {
    return TextFormField(
      controller: passwordController,
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
        hintText: "كلمة المرور",
        hintStyle: TextStyle(color: dark, fontSize: 19.0),
        focusedErrorBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.transparent, width: 2.0)),
        focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.transparent, width: 2.0)),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return "ادخل كلمة المرور";
        } else {
          if (value.length < 6) {
            return "يجب ان يتكون من ٦ خانات او اكثر";
          } else {
            return null;
          }
        }
      },
      obscureText: _hidePass == true ? true : false,
    );
  }

  Widget passwordField2() {
    return TextFormField(
      controller: passwordController2,
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
        hintText: "تأكيد كلمة المرور",
        hintStyle: TextStyle(color: dark, fontSize: 19.0),
        focusedErrorBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.transparent, width: 2.0)),
        focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.transparent, width: 2.0)),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return "ادخل كلمة المرور";
        } else {
          if (value != passwordController.text) {
            return "كلمة المرور غير متطابقة";
          } else {
            return null;
          }
        }
      },
      obscureText: _hidePass == true ? true : false,
    );
  }

  Widget logopng() {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 60.0),
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: Duration(milliseconds: 500),
        child: new Image.asset(
          "assets/images/logo.png",
          scale: 1.5,
        ),
      ),
    );
  }

  Widget signUpText() {
    return Text(
      "إنشاء حساب",
      style: TextStyle(color: dark, fontWeight: FontWeight.bold, fontSize: 30),
    );
  }

  //sign up button to submit details to server
  Widget signUpButton(scaffoldKey, formKey) {
    return Container(
      height: 45,
      width: 200,
      decoration: BoxDecoration(
        color: pink,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: pink.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 40,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: InkWell(
        onTap: () async {
          if (accept) {
            FocusScope.of(context).unfocus();
            final form = formKey.currentState;
            form.save();
            if (form.validate()) {
              print('validated');
              setState(() {
                isloading = true;
              });
              bool signUp;
              signUp = await httpService.signUp(
                  nameController.value.text +" "+ nameController2.value.text,
                  emailController.value.text,
                  passwordController.value.text,
                  context,
                  scaffoldKey);
              if (signUp) {
                setState(() {
                  isloading = false;
                });
                authToken = await storage.read(key: "token");

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyBottomNavigationBar(pageInd: 0,)));
              } else {
                setState(() {
                  isloading = false;
                  nameController.text = '';
                  nameController2.text = '';
                  emailController.text = '';
                  passwordController.text = '';
                  passwordController2.text = '';
                });
              }
            } else {
              return;
            }
          } else {
            Fluttertoast.showToast(
                msg:
                    'لإنشاء حساب يجب الموافقة على شروط الخدمات و سياسة الخصوصية');
          }
        },
        child: Center(
          child: !isloading
              ? Text(
                  "إنشاء حساب",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                )
              : CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation(Colors.white),
                ),
        ),
      ),
    );
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("إنشاء حساب ..")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  var profileData;
  var facebookLogin = FacebookLogin();

  void onLoginStatusChanged(bool isLoggedIn, {profileData}) {
    setState(() {
      this.isloading = isLoggedIn;
      this.profileData = profileData;
    });
  }


  // Initialize login with facebook
  void initiateFacebookLogin() async {
    print('STEP 1');
    var facebookLoginResult;
    var facebookLoginResult2 = await facebookLogin.isLoggedIn;
    print(facebookLoginResult2);
    if (facebookLoginResult2 == true) {
      print("TRUE");
      facebookLoginResult = await facebookLogin.currentAccessToken;
      print('STEP 2 >> True');
      var graphResponse = await http.get(
          'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${facebookLoginResult.token}');
      print('STEP 3 >> True');
      var profile = json.decode(graphResponse.body);
      print('STEP 4 >> True');
      setState(() {
        isloading = true;
      });
      print('STEP 5 >> True');
      var name = profile['name'];
      var email = profile['email'];
      var code = profile['id'];
      var password = "password";
      print('STEP 6 >> True');

      if (true) {
        goToDialog();
        print('STEP 7 >> True');
        try {
          socialLogin(APIData.fbLoginAPI, email, password, code, name, "code");
          print('STEP 8 SOCIAL LOGIN >> True');
          onLoginStatusChanged(true, profileData: profile);
          print('STEP 9 SOCIAL LOGIN >> True');
        } catch (e) {
          print('STEP 10 CATCH >> True');
          Navigator.pop(context);
          Fluttertoast.showToast(msg: 'حدث خطاء يرجى المحاولة في وقت لاحق');
        }
      } else {
        Fluttertoast.showToast(msg: 'لم نستطيع الوصل الي البريد الالكتروني');
      }
    } else {
      print("FALSE");
      facebookLoginResult = await facebookLogin.logIn(['email']);
      switch (facebookLoginResult.status) {
        case FacebookLoginStatus.error:
          onLoginStatusChanged(false);
          break;
        case FacebookLoginStatus.cancelledByUser:
          onLoginStatusChanged(false);
          break;
        case FacebookLoginStatus.loggedIn:
          var graphResponse = await http.get(
              'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${facebookLoginResult.accessToken.token}');
          var profile = json.decode(graphResponse.body);
          var name = profile['name'];
          var email = profile['email'];
          var code = profile['id'];
          var password = "password";
          socialLogin(APIData.fbLoginAPI, email, password, code, name, "code");
          onLoginStatusChanged(true, profileData: profile);
          break;
      }
    }
  }

  Future<String> socialLogin(url, email, password, code, name, uid) async {
    print('Social Login ');
    final res = await http.post(url, body: {
      "email": "${email ?? "Email"}",
      "password": "password",
      "$uid": "${code}",
      "name": "${name ?? "user"}",
    });
    print("Status: ${res.statusCode}");
    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      authToken = body["access_token"];
      var refreshToken = body["access_token"];
      await storage.write(key: "token", value: "$authToken");
      await storage.write(key: "refreshToken", value: "$refreshToken");
      authToken = await storage.read(key: "token");
      HomeDataProvider homeData =
          Provider.of<HomeDataProvider>(context, listen: false);
      await homeData.getHomeDetails(context);
      authToken = await storage.read(key: "token");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyBottomNavigationBar(pageInd: 0,)));
    } else {
      setState(() {
        isloading = false;
      });
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "حدثت مشكلة في تسجيل الدخول");
    }
    return null;
  }

  goToDialog() {
    if (isloading == true) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => WillPopScope(
              child: SimpleDialog(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                children: [
                  Center(
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(pink),
                    ),
                  )
                ],
              ),
              onWillPop: () async => false));
    } else {
      Navigator.pop(context);
    }
  }

  Widget googleLoginButton(width, scaffoldKey) {
    return InkWell(
      onTap: () async {
        signInWithGoogle().then((result) {
          if (result != null) {
            setState(() {
              isloading = true;
            });
            var email = result.email;
            var password = "password";
            var code = result.uid;
            var name = result.displayName;
            goToDialog();
            socialLogin(
                APIData.googleLoginApi, email, password, code, name, "uid");
          }
        });
      },
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
            shape: BoxShape.circle, border: Border.all(color: dark, width: 1)),
        child: Center(
            child: Icon(
          FontAwesomeIcons.google,
          size: 22,
          color: dark,
        )),
      ),
    );
  }

  Widget fbLoginButton(width, scaffoldKey) {
    var userDetails = Provider.of<UserDetailsProvider>(context, listen: false);
    return InkWell(
      onTap: () {
        initiateFacebookLogin();
      },
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
            shape: BoxShape.circle, border: Border.all(color: dark, width: 1)),
        child: Center(
            child: Icon(
          FontAwesomeIcons.facebookF,
          size: 22,
          color: dark,
        )),
      ),
    );
  }

  signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'com.aboutyou.dart_packages.sign_in_with_apple.example',
          redirectUri: Uri.parse(
            'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
          ),
        ),
        nonce: 'example-nonce',
        state: 'example-state',
      );
      String email = credential.userIdentifier ?? "";
      if (email == ''||email==null) {
        throw Exception('Something bad happened.');
      } else {
        email = email + 'dimensionsgroupappleuser.sa';
      }
      String name = credential.givenName??'Apple user';
      setState(() {
        isloading = true;
      });
      goToDialog();
      socialLogin(APIData.fbLoginAPI, email, 'password', credential.userIdentifier, name, 'code');
      // onLoginStatusChanged(true);

    } catch (e) {
      Fluttertoast.showToast(
        msg: "لم نستطع الوصول الي معلوماتك ,تاكد من اتصال بالانترنت",);
    }
  }


  Widget appleLoginButton(width, scaffoldKey) {
    var userDetails = Provider.of<UserDetailsProvider>(context, listen: false);
    return InkWell(
      onTap: () {
        signInWithApple();
      },
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
            shape: BoxShape.circle, border: Border.all(color: dark, width: 1)),
        child: Center(
          child: Icon(
            FontAwesomeIcons.apple,
            size: 22,
            color: dark,
          ),
        ),
      ),
    );
  }

  //form for taking inputs
  Widget form(scaffoldKey) {

    var width = MediaQuery.of(context).size.width;
    var fb = Provider.of<HomeDataProvider>(context, listen: false)
        .homeModel
        .settings
        .fbLoginEnable;
    var googleLogin = Provider.of<HomeDataProvider>(context, listen: false)
        .homeModel
        .settings
        .googleLoginEnable;
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: nameField()),
                SizedBox(
                  width: 10,
                ),
                Expanded(child: nameField2())
              ],
            ),
            SizedBox(
              height: 15,
            ),
            emailField(),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(child: passwordField()),
                SizedBox(
                  width: 10,
                ),
                Expanded(child: passwordField2()),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            privacyPolicy(),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'أو التسجيل بواسطة ',
                  style: TextStyle(
                      color: dark, fontWeight: FontWeight.bold, fontSize: 22),
                ),
                SizedBox(
                  width: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    "$googleLogin" == "1" || googleLogin == 1
                        ? googleLoginButton(35, scaffoldKey)
                        : SizedBox.shrink(),
                    SizedBox(
                      width: 5,
                    ),
                    "$fb" == "1"
                        ? fbLoginButton(35, scaffoldKey)
                        : SizedBox.shrink(),
                    SizedBox(
                      width: 5,
                    ),
                    Platform.isIOS
                        ? appleLoginButton(width, scaffoldKey)
                        :
                    Container()
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 70,
            ),
            Center(child: signUpButton(scaffoldKey, _formKey)),
            SizedBox(
              height: 30,
            ),

          ],
        ),
      ),
    );
  }

  Widget scaffoldBody(scaffoldKey) {
    return Directionality(
      textDirection: rtl,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 130,
              ),
              signUpText(),
              SizedBox(
                height: 60,
              ),
              form(scaffoldKey),
              Center(child: tologin()),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                  child: Text(
                    'جميع الحقوق محفوظة لأبعاد المعرفة\u00a9 2021 ',
                    style: TextStyle(color: dark.withOpacity(0.4), height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  final HttpService httpService = HttpService();
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: scaffoldBody(scaffoldKey));
  }

  //navigate back to login
  Widget tologin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          " لديك حساب ؟",
          style: TextStyle(
            fontSize: 20,
            color: dark.withOpacity(0.5),
          ),
        ),
        SizedBox(
          width: 5.0,
        ),
        InkWell(
          child: Text(
            "تسجيل دخول",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: pink),
          ),
          onTap: () {
            return Navigator.of(context).pushNamed('/SignIn');
          },
        ),
      ],
    );
  }
}
