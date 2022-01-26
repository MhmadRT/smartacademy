import 'package:cached_network_image/cached_network_image.dart';
import 'package:eclass/Screens/bottom_navigation_screen.dart';
import 'package:eclass/Screens/home_screen.dart';
import 'package:eclass/provider/visible_provider.dart';
import 'package:eclass/services/http_services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/apidata.dart';
import '../provider/user_profile.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  Widget drawerHeader(UserProfile user) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyBottomNavigationBar(
                  pageInd: 4,
                )));

      },
      child: Container(
        decoration: BoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              CircleAvatar(
                radius: 40.0,
                backgroundColor: dark,
                backgroundImage: user.profileInstance.userImg == null
                    ? AssetImage("assets/icons/user_avatar.png")
                    : CachedNetworkImageProvider(
                        APIData.userImage + "${user.profileInstance.userImg}"),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                user.profileInstance.fname,
                maxLines: 1,
                style: TextStyle(
                    color: pink, fontSize: 17, fontWeight: FontWeight.w700),
              ),
              Text(
                user.profileInstance.email,
                style: TextStyle(color: dark, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget supportTile(idx, icons, title, Color txtColor) {
    return ListTile(
      onTap: () {
        if (idx == 0) {
          Navigator.pushNamed(context, "/becameInstructor");
        } else if (idx == 1) {
          Navigator.pushNamed(context, "/aboutUs");
        } else if (idx == 2) {
          Navigator.pushNamed(context, "/contactUs");
        } else if (idx == 3) {
          Navigator.pushNamed(context, "/userFaq");
        } else if (idx == 4) {
          Navigator.pushNamed(context, "/instructorFaq");
        }
      },
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: pink.withOpacity(1),
            borderRadius: BorderRadius.circular(20)),
        alignment: Alignment.center,
        child: Icon(
          icons,
          size: 15,
          color: Colors.white,
        ),
      ),
      title: Text(
        title,
        maxLines: 2,
        style: TextStyle(
            fontSize: 16.3, fontWeight: FontWeight.w500, color: txtColor),
      ),
    );
  }

  Widget supportSection(Color txtColor) {
    return Container(
        child: Column(
      children: [
        supportTile(
            0, FontAwesomeIcons.questionCircle, "التسجيل كمدرب", txtColor),
        supportTile(1, FontAwesomeIcons.shieldVirus, "من نحن", txtColor),
        supportTile(
            2, FontAwesomeIcons.facebookMessenger, "اتصل بنا", txtColor),
        supportTile(
            3, FontAwesomeIcons.handsHelping, "الأسئلة الشائعة", txtColor),
        supportTile(4, FontAwesomeIcons.handsHelping, "الأسئلة الشائعة للمدرب",
            txtColor),
        ListTile(
          onTap: () async {
            setState(() {
              logoutLoading = true;
            });
            bool result = await HttpService().logout();
            setState(() {
              logoutLoading = false;
            });
            if (result) {
              Provider.of<Visible>(context, listen: false).toggleVisible(false);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/SignIn', (Route<dynamic> route) => false);
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/SignIn', (Route<dynamic> route) => false);
            }
            SharedPreferences ref = await SharedPreferences.getInstance();
            ref.remove('userProfile');
            ref.remove('userProfileTime');
          },
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: pink.withOpacity(1),
                borderRadius: BorderRadius.circular(20)),
            alignment: Alignment.center,
            child: logoutLoading
                ? Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Icon(
                    Icons.exit_to_app,
                    size: 18,
                    color: Colors.white,
                  ),
          ),
          title: Text(
            'تسجيل خروج',
            maxLines: 2,
            style: TextStyle(
                fontSize: 16.3, fontWeight: FontWeight.w500, color: txtColor),
          ),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    UserProfile user = Provider.of<UserProfile>(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          drawerHeader(user),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/purchaseHistory");
            },
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: pink.withOpacity(1),
                  borderRadius: BorderRadius.circular(20)),
              alignment: Alignment.center,
              child: Icon(
                Icons.monetization_on_outlined,
                size: 15,
                color: Colors.white,
              ),
            ),
            title: Text(
              'دوراتي',
              maxLines: 2,
              style: TextStyle(
                  fontSize: 16.3, fontWeight: FontWeight.w500, color: dark),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/blogList");
            },
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: pink.withOpacity(1),
                  borderRadius: BorderRadius.circular(20)),
              alignment: Alignment.center,
              child: Icon(
                Icons.list_alt,
                size: 15,
                color: Colors.white,
              ),
            ),
            title: Text(
              'مدونات',
              maxLines: 2,
              style: TextStyle(
                  fontSize: 16.3, fontWeight: FontWeight.w500, color: dark),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context)
                  .pushNamed('/InstructorScreen', arguments: 514);
            },
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: pink.withOpacity(1),
                  borderRadius: BorderRadius.circular(20)),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.asset(
                  'assets/images/almoneef_logo.png',
                  color: Colors.white,
                ),
              ),
            ),
            title: Text(
              'الدكتور خالد المنيف',
              maxLines: 2,
              style: TextStyle(
                  fontSize: 16.3, fontWeight: FontWeight.w500, color: dark),
            ),
          ),
          supportSection(dark),
          // Align(alignment: Alignment.centerRight, child: logoutSection(pink)),
        ],
      ),
    );
  }

  bool logoutLoading = false;

  //logout of current session
  Widget logoutSection(Color headingColor) {
    return Container(
      child: FlatButton(
          onPressed: () async {
            setState(() {
              logoutLoading = true;
            });
            bool result = await HttpService().logout();
            setState(() {
              logoutLoading = false;
            });
            if (result) {
              Provider.of<Visible>(context, listen: false).toggleVisible(false);
              Navigator.of(context).pushNamed('/SignIn');
            } else {
              Fluttertoast.showToast(msg: 'فشل تسجيل الخروج');
            }
          },
          child: logoutLoading
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(headingColor),
                )
              : Text(
                  "تسجيل خروج",
                  style: TextStyle(
                      color: headingColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                )),
    );
  }
}
