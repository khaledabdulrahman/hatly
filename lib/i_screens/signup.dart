import 'package:flutter/material.dart';
import 'package:hatly/models/authmode.dart';
import 'package:hatly/scoped_model/international-model.dart';
import 'package:scoped_model/scoped_model.dart';
import '../constants/decoration.dart';
import 'login.dart';
import 'choices.dart';

class SignUp extends StatelessWidget {
  TextEditingController textEditingController = TextEditingController();
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  Map<String, dynamic> authdata = {
    'fname': '',
    'lname': '',
    'email': '',
    'password': '',
    'phonenumber': ''
  };

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<InternationalModel>(builder:
        (BuildContext context, Widget child, InternationalModel model) {
      return Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
                child: Text(
                  'Login',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                ),
              )
            ],
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text(
              'HATLY',
              style: TextStyle(color: Colors.yellow, fontSize: 30),
            ),
          ),
          body: Container(
            decoration: backgroundImage,
            child: Container(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: globalKey,
                  child: ListView(children: <Widget>[
                    Center(
                      child: Image.asset('assets/logo.png', scale: 3.2),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: TextFormField(
                          decoration: InputDecoration(
                              labelText: 'First name',
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.w700)),
                          keyboardType: TextInputType.text,
                          onSaved: (value) {
                            authdata['fname'] = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) return 'please enter this field';

                          },
                        )),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                            child: TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Second name',
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.w700)),
                          keyboardType: TextInputType.text,
                          onSaved: (value) {
                            authdata['lname'] = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) return 'please enter this field';

                          },
                        ))
                      ],
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(fontWeight: FontWeight.w700)),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (value) {
                        authdata['email'] = value;
                      },
                      validator: (value) {
                        if (value.isEmpty) return 'please enter this field';

                      },
                    ),
                    TextFormField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(fontWeight: FontWeight.w700)),
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      onSaved: (value) {
                        authdata['password'] = value;
                      },
                      validator: (value) {
                        if (value.isEmpty || value.length < 8)
                          return 'please enter this field must more than 8 characters';

                      },
                    ),
                    TextFormField(
                      validator: (value) {
                        if (textEditingController.text != value)
                          return 'please enter a same password';

                      },
                      decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          labelStyle: TextStyle(fontWeight: FontWeight.w700)),
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Phone Number',
                          labelStyle: TextStyle(fontWeight: FontWeight.w700)),
                      keyboardType: TextInputType.phone,
                      onSaved: (value) {
                        authdata['phonenumber'] = value;
                      },
                      validator: (value) {
                        if ((value.isEmpty) || (value.length < 10|| !RegExp(r'[1-9]').hasMatch(value)))
                          return 'please enter phone number';

                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
//                  RaisedButtonconfirm(context),
                    model.isLoading
                        ? Center(child: CircularProgressIndicator())
                        : RaisedButton(
                        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),

                            child: Text(
                              'Sign Up',
                              style: TextStyle(color: Colors.yellowAccent),
                            ),
                            color: Colors.black,
                            onPressed: () => submitForm(model, context)),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.black12,
                          foregroundColor: Colors.black,
                          radius: 30,
                          child: IconButton(
                            icon: Image.asset(
                              'assets/facebook.png',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.black12,
                          foregroundColor: Colors.black,
                          radius: 30,
                          child: IconButton(
                            icon: Image.asset(
                              'assets/twitter.png',
                              color: Colors.blue,
                            ),
                          ),
                        )
                      ],
                    )
                  ]),
                ),
              ),
            ),
          ));
    });
  }

  void submitForm(InternationalModel model, BuildContext context) async {
    globalKey.currentState.save();
    if (!globalKey.currentState.validate()) {
      return;
    }


    final Map<String, dynamic> getresponse = await model.authMode(email:authdata['email'], password: authdata['password'],mode: AuthMode.Signup);
    if (getresponse['succes']){
    await  model.addUser(authdata['fname'], authdata['lname'], authdata['phonenumber']);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Choices()));
    }
    else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('there is a problem'),
              content: Text(getresponse['message']),
              actions: <Widget>[
                FlatButton(
                  child: Text('ok'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    }
  }
}
