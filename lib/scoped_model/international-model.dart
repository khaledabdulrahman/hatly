import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:hatly/scoped_model/connectedInternational.dart';

class InternationalModel extends Model with ConnectedInternational,UserModel, Chatclass,Offers,OrdersModel,TripModel,UtilityModel {

}