import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class User {
   String id;
  String email;
  String token;
  String password;
  String firstname;
  String lastname;
  String phonenumber;
   User({this.id, this.email, this.password,this.phonenumber,this.firstname,this.lastname,this.token});



}