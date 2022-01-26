import 'package:eclass/Screens/home_screen.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String message;

  const ErrorPage({Key key, this.message = "يوجد مشكلة عند تكرار المشكلة قم بالتواصل مع قسم الدعم الفني" }) : super(key: key);


  @override
  Widget build(BuildContext context){
    return Directionality(
      textDirection: rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('حدث خظاء'),
          elevation: 0,
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).accentColor
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
            )
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(message,textAlign: TextAlign.center,style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.red
                      ),),
                      SizedBox(height: 20.0),
                      RaisedButton(
                        child: Text("حاول مرة اخرى"),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}