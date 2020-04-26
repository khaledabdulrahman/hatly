import 'package:flutter/material.dart';


class Ktextfiled extends StatelessWidget {
  String name;
  TextInputType type;
  bool password;

  Ktextfiled({this.name='',this.type=TextInputType.text,this.password=false});

  String text;

  @override
  Widget build(BuildContext context) {

    return TextField(
      obscureText: password,
      onChanged: (value){
         text=value;
      },
      keyboardType: type,
      decoration: InputDecoration(
          labelText: name,
          labelStyle: TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}

//
//const ktextfiled = TextField(
//  controller: TextEditingController(),
//  decoration: InputDecoration(
//      labelText: 'First name:',
//      labelStyle: TextStyle(fontWeight: FontWeight.w700)),
//),