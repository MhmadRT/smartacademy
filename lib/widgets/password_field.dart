import 'package:eclass/Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/user_details_provider.dart';

class PasswordField extends StatefulWidget {
  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _showPassword = true;

  Widget passField(context) {
    var usedeob = Provider.of<UserDetailsProvider>(context);
    return Container(
      child: TextFormField(
        obscureText: _showPassword,
        style: TextStyle(color: dark, fontSize: 19.0),
        onChanged: (String value) {
          usedeob.changePass(value);
        },
        validator: (v) {
          if (v.length < 5) {
            return 'يجب ان تكون كلمة المرور اكبر من ٦ احرف';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          suffixIcon: GestureDetector(
            child: Icon(
              _showPassword?Icons.visibility_off:Icons.visibility,
              size: 16,
              color: dark,
            ),
            onTap: () {
              _showPassword = !_showPassword;
              setState(() {});
            },
          ),
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
