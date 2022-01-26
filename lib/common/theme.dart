import 'package:eclass/Screens/home_screen.dart';
import 'package:flutter/material.dart';

class Theme with ChangeNotifier {
  bool lighttheme = true;

  void toggletheme() {
    this.lighttheme = !this.lighttheme;
    print(lighttheme);
    notifyListeners();
  }

  List<Color> gradientColors = [dark, pink];

  Color boxShadowColor = Color(0x1c2464);

  Color headingColor = dark;

  Color courseDetailIcons = Color(0xff3f4654);
  Color starRating =dark;
  Color progressColor = yellow;

  Color backgroundColorSec = Color(0xff29303b);

  Color backgroundColorlight = Color(0xFFFfffff);
  Color backgroundColordark = dark;

  Color tilecolorlight = Colors.white;
  Color tilecolordark = dark;

  Color progresscolorlight = dark;
  Color progresscolordark = dark;

  Color probgcolorlight = Color(0xFFF1F3F8);
  Color probgcolordark = Color(0xffffffff);

  Color titleDark2 = Color(0xffFFFFF);
  Color titleLight2 = Color(0xff3F4654);

  Color notificationDarkColor = Color(0xffFFFFF);
  Color notificationLightColor = Color(0xff3F4654);

//  New

  Color titleTextColor = Color(0xFF3F4654);
  Color shortTextColor = dark;
  Color testimonialTextColor = Color(0xFF586474);
  Color fCatTextColor = Color(0xFF586473);
  Color backgroundColor = Color(0xFFF1F3F8);
  Color customRedColor1 = pink;
  Color easternBlueColor = dark;

  Color get bgcolor {
    return lighttheme ? backgroundColorlight : backgroundColordark;
  }

  Color get tilecolor {
    return lighttheme ? tilecolorlight : tilecolordark;
  }

  Color get txtcolor {
    return lighttheme ? Color(0xFF3F4654) : Colors.white;
  }

  Color get titleColor2 {
    return lighttheme ? titleLight2 : titleDark2;
  }

  Color get notificationIconColor {
    return lighttheme ? notificationLightColor : notificationDarkColor;
  }

  Color get progresscolor {
    return lighttheme ? progresscolorlight : progresscolordark;
  }

  Color get probgcolor {
    return lighttheme ? probgcolorlight : probgcolordark;
  }
}

//655586
