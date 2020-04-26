import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hatly/constants/decoration.dart';

import 'home_delivery.dart';
class Choices extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: backgroundImage,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
         mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/logo.png', scale: 2.0,),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(80.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    RaisedButton(
                      elevation: 10,
                      padding: EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>IIHome()));
                      },
                      child: Text(
                        'International Delivery',
                        style: TextStyle(color: Colors.black,fontSize: 20),
                      ),
                    ),SizedBox(height: 20,),
                    RaisedButton(
                      elevation: 10,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      padding: EdgeInsets.all(15),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>IIHome()));
                      },
                      child: Text(
                        'Local Delivery',
                        style: TextStyle(color: Colors.black,fontSize: 20),
                      ),
                    ),
                    SizedBox(height: 20,),
                    RaisedButton(
                      elevation: 10,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      padding: EdgeInsets.all(15),
                      color: Colors.white,
                      onPressed: () {},
                      child: Text(
                        'Appartements ',
                        style: TextStyle(color: Colors.black,fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
