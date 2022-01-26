import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widgets/utils.dart';
import '../common/theme.dart' as T;
import '../services/http_services.dart';
import 'home_screen.dart';

class PasswordReset extends StatefulWidget {
  final int medium;

  PasswordReset(this.medium);

  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  String pass = "", repass = "", email = "";
  bool _hidepass = true, _hiderepass = true;

  Widget input(int idx, BuildContext context, String label, Color borderclr) {
    return TextFormField(
      validator: (value) {
        if (value == "") return "This field can't left empty !..";
        return null;
      },
      obscureText:
          idx == 0 ? false : (idx == 1 ? _hidepass : _hiderepass),
      maxLines: 1,
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
          hintStyle: TextStyle(color: dark, fontSize: 15.0),
          focusedErrorBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide:
                  BorderSide(color: Colors.transparent, width: 2.0)),
          focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.transparent, width: 2.0)),
          suffixIcon: idx == 0
              ? SizedBox.shrink()
              : IconButton(
                  icon: Icon(
                    idx == 1
                        ? (_hidepass
                            ? Icons.visibility_off
                            : Icons.visibility)
                        : (_hiderepass
                            ? Icons.visibility_off
                            : Icons.visibility),
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    if (idx == 1) {
                      setState(() {
                        _hidepass = !_hidepass;
                      });
                    } else {
                      setState(() {
                        _hiderepass = !_hiderepass;
                      });
                    }
                  }),
          labelText: label,
          labelStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey[500])),
      onChanged: (value) {
        if (idx == 0)
          setState(() {
            email = value;
          });
        else if (idx == 1)
          setState(() {
            pass = value;
          });
        else if (idx == 2)
          setState(() {
            repass = value;
          });
      },
      cursorColor: Colors.black,
      style: TextStyle(color: Colors.black),
    );
  }

  /*
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
   */

  Widget form(Color clr) {
    return Center(
      child: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 50,),
              input(0, context, "البريد الإلكتروني", clr),
              SizedBox(height: 10,),
              input(1, context, "كلمة المرور الجديدة", clr),
              SizedBox(height: 10,),
              input(2, context, "تأكيد كلمة المرور", clr),
            ],
          ),
        ),
      ),
    );
  }

  Widget submitButton() {
    return Container(
      width: 150,
      child: InkWell(
        onTap: ()async{
            if (_formKey.currentState.validate() && pass == repass) {
              setState(() {
                isLoading = true;
              });
              await HttpService().resetPassword(pass, email).then((ispassed) {
                setState(() {
                  isLoading = false;
                });
                if (ispassed) {
                  SnackBar snackbar =
                  SnackBar(content: Text("تم تعين كلمة المرور"));
                  _scaffoldKey.currentState.showSnackBar(snackbar);
                  // await
                  if (widget.medium == 0) {
                    Navigator.of(context).pushNamed("/loginscreen");
                  }
                }
                else if (!ispassed) {
                  SnackBar snackbar =
                  SnackBar(content: Text("فشل تغير كلمة المرور"));
                  _scaffoldKey.currentState.showSnackBar(snackbar);
                }
                Future.delayed(Duration(milliseconds: 500),(){
                  Navigator.pop(context);
                });
              });
            }
        },
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: pink.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 40,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            color: pink,
            borderRadius: BorderRadius.circular(100),

          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 15),
            child: Center(
                child: isLoading
                    ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                    : Text(
                        "تعديل",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      )),
          ),
        ),
      ),
    );
  }

  Widget scaffoldBody(Color clr) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          form(clr),
          submitButton(),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // HttpService http = new HttpService();
    T.Theme mode = Provider.of<T.Theme>(context);
    return Directionality(
      textDirection: rtl,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: mode.bgcolor,
        appBar: secondaryAppBar(
            Colors.black, mode.bgcolor, context, "تعديل كلمة المرور"),
        body: scaffoldBody(mode.notificationIconColor),
      ),
    );
  }
}
