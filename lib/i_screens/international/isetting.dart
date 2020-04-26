import 'package:flutter/material.dart';
import 'package:hatly/constants/decoration.dart';
import 'package:hatly/scoped_model/international-model.dart';
import 'package:scoped_model/scoped_model.dart';

import '../login.dart';

class ISetting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<InternationalModel>(builder:
        (BuildContext context, Widget child, InternationalModel model) {
      return Container(
        decoration: backgroundImage,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                RaisedButton(
                  child: Text(
                    'Profile',
                    style: TextStyle(color: Colors.yellowAccent),
                  ),
                  color: Colors.black,
                  onPressed: () {},
                ),
                RaisedButton(
                  child: Text(
                    'Notifications',
                    style: TextStyle(color: Colors.yellowAccent),
                  ),
                  color: Colors.black,
                  onPressed: () {},
                ),
                RaisedButton(
                  child: Text(
                    'Promo Code',
                    style: TextStyle(color: Colors.yellowAccent),
                  ),
                  color: Colors.black,
                  onPressed: () {},
                ),
                RaisedButton(
                  child: Text(
                    'Help',
                    style: TextStyle(color: Colors.yellowAccent),
                  ),
                  color: Colors.black,
                  onPressed: () {},
                ),
                RaisedButton(
                  child: Text(
                    'Sign out',
                    style: TextStyle(color: Colors.yellowAccent),
                  ),
                  color: Colors.black,
                  onPressed: () {
                    model.signout();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
