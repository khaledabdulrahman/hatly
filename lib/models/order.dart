import 'package:flutter/material.dart';

class Order {
  String countryfrom;
  String countryto;
  String name;
  String category;
  int quantity;
  double price;
  double weight;
  bool isdone;
  String userEmail;
  String userID;
  String dateTime;
  String id;
  int numberOfAuctions;
  double lowestAuction;

//   DateTime date;

  Order(
      {@required this.id,
      @required this.countryfrom,
      @required this.countryto,
      @required this.name,
      @required this.quantity,
      @required this.price,
      @required this.weight,
      @required this.category,
      this.isdone = false,
      @required this.userEmail,
      @required this.userID,
      @required this.dateTime,
      this.numberOfAuctions,
        this.lowestAuction
      });
}
