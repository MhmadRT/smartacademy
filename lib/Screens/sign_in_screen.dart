import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:eclass/common/apidata.dart';
import 'package:eclass/common/global.dart';
import 'package:eclass/services/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../Widgets/email_field.dart';
import '../Widgets/password_field.dart';
import '../provider/home_data_provider.dart';
import '../provider/user_details_provider.dart';
import '../services/http_services.dart';
import 'bottom_navigation_screen.dart';
import 'home_screen.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  int _duration;
  bool _visible = false;
  Animation<double> animation;
  AnimationController animationController;
  var squareScaleB = 1.0;
  AnimationController _controllerB;
  final HttpService httpService = HttpService();
  bool isLoggedIn = false;
  var profileData;
  var facebookLogin = FacebookLogin();
  bool isShowing = false;

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      HomeDataProvider homeData =
          Provider.of<HomeDataProvider>(context, listen: false);
      homeData.getHomeDetails(context);
      Timer(Duration(milliseconds: 500), () {
        setState(() {
          _visible = true;
        });
      });
    });

    _duration = 1200;

    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: _duration));

    animation = Tween<double>(begin: 0, end: -165).animate(animationController)
      ..addListener(() {
        setState(() {});
      });
    _controllerB = AnimationController(
        vsync: this,
        lowerBound: 1.0,
        upperBound: 1.20,
        duration: Duration(milliseconds: 3000));

    _controllerB.addListener(() {
      setState(() {
        squareScaleB = _controllerB.value;
      });
    });

    Timer(Duration(milliseconds: 500), () {
      animationController.forward();
      _controllerB.forward(from: 0.0);
    });
    super.initState();
  }

// Alert dialog after clicking on login button
  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      content: Center(
          child: Platform.isIOS
              ? CupertinoActivityIndicator()
              : CircularProgressIndicator()),
    );
    if (isShowing == true)
      Navigator.pop(context);
    else
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
  }

// Logo on login page
  Widget logo(String img) {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 60.0),
      child: AnimatedOpacity(
        opacity: _visible == true ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        child: Image.asset(
          "assets/images/logologin.png",
          scale: 1.5,
        ),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget signInButton(width, scaffoldKey) {
    var userDetails = Provider.of<UserDetailsProvider>(context, listen: false);
    return Center(
      child: GestureDetector(
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          if (_formKey.currentState.validate()) {
            showLoaderDialog(context);
            bool login = await httpService.login(userDetails.getEmail.value,
                userDetails.getPass.value, context, scaffoldKey);
            if (login) {
              userDetails.destroyLoginValues();
              authToken = await storage.read(key: "token");
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyBottomNavigationBar(
                            pageInd: 0,
                          )));
            } else {
              Navigator.pop(context);

              return;
            }
          }
        },
        child: Container(
          height: 45,
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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
            child: Text(
              "تسجيل دخول",
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  void onLoginStatusChanged(bool isLoggedIn, {profileData}) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
      this.profileData = profileData;
    });
  }

  // Initialize login with facebook
  void initiateFacebookLogin() async {
    showLoaderDialog(context);
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
      print('STEP 5 >> True');
      var name = profile['name'];
      print('faceBook Ikmage : ${profile['picture']['data']['url']}');
      var email = profile['id'];
      var code = profile['id'];
      var password = "password";
      print('STEP 6 >> True');

      if (true) {
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
          print('faceBook Ikmage : ${profile['picture']['data']['url']}');
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
    print('Social Login $url \n $email \n $password \n $code \n $name \n $uid');
    final res = await http.post(url, body: {
      "email": "${email ?? "Email"}",
      "password": "${password}",
      "$uid": "${code}",
      "name": "${name ?? "Facebook user"}",
    });
    print("Status: ${res.statusCode}");
    print("body: ${res.body}");
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
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyBottomNavigationBar(
                    pageInd: 0,
                  )));
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "حدثت مشكلة في تسجيل الدخول");
    }
    return null;
  }

  goToDialog() {
    if (isShowing == true) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => WillPopScope(
              child: SimpleDialog(
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                children: [
                  Center(
                      child: Platform.isIOS
                          ? CupertinoActivityIndicator()
                          : CircularProgressIndicator()),
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
        showLoaderDialog(context);
        signInWithGoogle().then((result) {
          if (result != null) {
            var email = result.email;
            var password = "password";
            var code = result.uid;
            var name = result.displayName;
            socialLogin(
                APIData.googleLoginApi, email, password, code, name, "uid");
          }
        }).catchError((onError){
          Navigator.pop(context);
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
        )),
      ),
    );
  }

  signInWithApple() async {
    showLoaderDialog(context);
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
      String email = credential.userIdentifier;
      if (email == '' || email == null) {
        throw Exception('Something bad happened.');
      } else {
        email = email + 'dimensionsgroupappleuser.sa';
      }
      String name = credential.givenName ?? 'Apple user';
      socialLogin(APIData.fbLoginAPI, email, 'password',
          credential.userIdentifier, name, 'code');
      // onLoginStatusChanged(true);

    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: "لم نستطع الوصول الي معلوماتك ,تاكد من اتصال بالانترنت",
      );
    }
  }

//  Sign up row
  Widget signUpRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Opacity(
          opacity: 0.5,
          child: Text(
            "لا تملك حساب ؟",
            style: TextStyle(
              fontSize: 16,
              color: dark,
            ),
          ),
        ),
        SizedBox(
          width: 5.0,
        ),
        InkWell(
          child: Text(
            "إنشاء حساب",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: pink),
          ),
          onTap: () {
            return Navigator.of(context).pushNamed('/signUp');
          },
        ),
      ],
    );
  }

//  Login View
  Widget loginFields(homeAPIData, scaffoldKey) {
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
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 4,
              ),
              Text(
                'تسجيل دخول',
                style: TextStyle(
                    color: dark, fontWeight: FontWeight.bold, fontSize: 30),
              ),
              SizedBox(
                height: 60.0,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    EmailField(),
                    SizedBox(
                      height: 20.0,
                    ),
                    PasswordField(),
                  ],
                ),
              ),
              SizedBox(
                height: 50.0,
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
                          ? googleLoginButton(width, scaffoldKey)
                          : SizedBox.shrink(),
                      SizedBox(
                        width: 5,
                      ),
                      "$fb" == "1"
                          ? fbLoginButton(width, scaffoldKey)
                          : SizedBox.shrink(),
                      SizedBox(
                        width: 5,
                      ),
                      Platform.isIOS
                          ? appleLoginButton(width, scaffoldKey)
                          : Container()
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 70.0,
              ),
              signInButton(width, scaffoldKey),
              SizedBox(
                height: 50.0,
              ),
              signUpRow(),
              SizedBox(
                height: 20.0,
              ),
              Center(
                child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      color: Colors.white, // Text colour here
                      width: 1.0, // Underline width
                    ))),
                    child: InkWell(
                      child: Text(
                        "نسيت كلمة المرور ؟",
                        style: TextStyle(fontSize: 14, color: dark),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, "/forgotPassword");
                      },
                    )),
              ),
              SizedBox(
                height: 20.0,
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

// All Login field logo, text fields, text, social icons, copyright text, sign up text
  Widget loginView(width, homeAPIData, scaffoldKey) {
    return Directionality(
      textDirection: rtl,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
            child: Align(
          alignment: FractionalOffset.bottomCenter,
          child: loginFields(homeAPIData, scaffoldKey),
        )),
      ),
    );
  }

  Widget scaffoldView(width, homeAPIData, scaffoldKey) {
    return loginView(width, homeAPIData, scaffoldKey);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var homeData = Provider.of<HomeDataProvider>(context);
    return WillPopScope(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: homeData == null
              ? Image.asset('assets/images/error404.png')
              : Scaffold(
                  key: scaffoldKey,
                  resizeToAvoidBottomInset: false,
                  body: homeData.homeModel == null
                      ? Center(child: Image.asset("assets/images/DGLoader.gif"))
                      : scaffoldView(width, homeData, scaffoldKey),
                ),
        ),
        onWillPop: onBackPressed);
  }

  Future<bool> onBackPressed() {
    bool value;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        contentPadding: EdgeInsets.only(top: 5.0, left: 20.0, bottom: 0.0),
        title: Text(
          'تأكيد الخروج من التطبيق',
          textAlign: TextAlign.start,
          style:
              TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF0284A2)),
        ),
        content: Text(
          'هل انت متأكد من الخروج',
          style: TextStyle(color: Color(0xFF3F4654)),
        ),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "ألغاء".toUpperCase(),
                style: TextStyle(
                    color: Color(0xFF0284A2), fontWeight: FontWeight.w600),
              )),
          FlatButton(
              onPressed: () {
                SystemNavigator.pop();
                Navigator.pop(context);
              },
              child: Text(
                "نعم".toUpperCase(),
                style: TextStyle(
                    color: Color(0xFF0284A2), fontWeight: FontWeight.w600),
              )),
        ],
      ),
    );
    return new Future.value(value);
  }
}
