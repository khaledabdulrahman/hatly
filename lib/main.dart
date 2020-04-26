import 'package:flutter/material.dart';
import 'package:hatly/scoped_model/international-model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'i_screens/choices.dart';
import 'i_screens/login.dart';
import 'package:rxdart/rxdart.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final InternationalModel _model = InternationalModel();
  bool _isAuthenticated=false;


  @override
  void initState() {
    _model.authentication();
    _model.userSubject.listen((bool authaa){
      setState(() {
        _isAuthenticated=authaa;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: ScopedModel<InternationalModel>(
          model: _model,
          child: ScopedModelDescendant<InternationalModel>(
            builder:
                (BuildContext context, Widget child, InternationalModel model) {
              return MaterialApp(
                  theme: ThemeData(
                      tabBarTheme: TabBarTheme(
                        labelColor: Colors.black,
                      ),
                      hintColor: Colors.grey,
                      appBarTheme: AppBarTheme(
                          color: Colors.yellow,
                          textTheme: TextTheme(
                              title: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                              button: TextStyle(color: Colors.black))),
                      inputDecorationTheme: InputDecorationTheme(
                          labelStyle: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w700)),
                      textTheme: TextTheme(
                        title: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
brightness: Brightness.light,
                      primaryColor: Colors.black,
                      secondaryHeaderColor: Colors.yellow,
                      accentColor: Colors.black),
                  debugShowCheckedModeBanner: false,
                  home: model.user == null ? Login() : Choices());
            },
          ),
        ));
  }
}
