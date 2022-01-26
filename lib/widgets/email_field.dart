import 'package:eclass/Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/user_details_provider.dart';

class EmailField extends StatelessWidget {
  Widget passField(context) {
    var usedeob = Provider.of<UserDetailsProvider>(context);
    return Container(
      child: TextFormField(
        style: TextStyle(color: dark, fontSize: 19.0),
        onChanged: (String value) {
          usedeob.changeEmail(value);
        },
        validator: (v) {
          if (v.isEmpty) {
            return 'عنوان البريد الإلكتروني غير صالح';
          } else {
            return null;
          }
        },
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
          errorBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Colors.transparent,
              )),
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

  @override
  Widget build(BuildContext context) {
    return passField(context);
  }
}
