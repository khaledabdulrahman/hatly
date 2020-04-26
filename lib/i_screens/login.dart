import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hatly/i_screens/international/internationalChat/i_chat_list.dart';
import 'package:hatly/i_screens/international/internationalChat/ichat.dart';
import 'package:hatly/i_screens/international/ihome.dart';
import 'package:hatly/i_screens/international/orders/my_orders.dart';
import 'package:hatly/models/authmode.dart';
import 'package:hatly/scoped_model/international-model.dart';
import 'package:scoped_model/scoped_model.dart';
import '../constants/decoration.dart';
import 'signup.dart';
import 'choices.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {


  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  GoogleSignIn _googleSignIn=GoogleSignIn();

  bool hide=true;
  static bool acceptterms=false;
  Map<String , dynamic> forminfo={
    'email':'',
    'password':'',
  };
final GlobalKey<FormState> _formkey=GlobalKey();


submitlogin(BuildContext context,InternationalModel model)async{

  _formkey.currentState.save();

  final Map<String, dynamic> getresponse = await model.authMode(email: forminfo['email'], password: forminfo['password'],mode: AuthMode.Signin);
  print(getresponse['succes']);
  print(getresponse['message']);
  if (getresponse['succes']&&acceptterms&&_formkey.currentState.validate() ){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Choices()));
  }
  else if (getresponse['succes']&&!acceptterms)
    {
      showDialog(context: context, builder: (context) {
        return AlertDialog(title: Text('please accept terms'), actions: <Widget>[
          FlatButton(child: Text('ok'), onPressed: () => Navigator.pop(context),)
        ],);
      });
    }
    else {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('An problem occured'),
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => SignUp()));
            },
            child: Text(
              'Sign up',
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
                key: _formkey,
                child: ListView(children: <Widget>[
                  Center(
                    child: Image.asset('assets/logo.png', scale: 2.0),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (String value) {
                      forminfo['email']=value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Password',suffixIcon: IconButton(icon: Icon(hide?Icons.visibility_off:Icons.visibility,color: Colors.grey,),onPressed: (){
                      setState(() {
                        hide=!hide;
                      });
                    },),enabled: false),
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value){
                      return;
                    },
                    onSaved: (String value) {
                      forminfo['password']=value;
                    },
                    obscureText: hide,
                  ),
                  SwitchListTile(
                    title: Text('Accept terms'),
                    value:acceptterms
                      ,activeColor: Colors.yellowAccent,
                    onChanged: (value){
                      setState(() {
                        acceptterms=value;
                        print(value);
                      });
                    },
                  ),
                  ScopedModelDescendant<InternationalModel>(
                    builder: (BuildContext context, Widget child,
                        InternationalModel model) {
                      return model.isLoading?Center(child: CircularProgressIndicator()):
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:100),
                        child: MaterialButton(
                          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
                          color: Colors.black,
                          child: Text(
                            'Sign In',
                            style: TextStyle(color: Colors.yellowAccent),
                          ),
                            onPressed: ()=> submitlogin(context,model)
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(child: Divider(thickness: 3,color: Colors.black,)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Or Join with ',style: TextStyle(fontWeight: FontWeight.bold,),),
                      ),
                      Expanded(child: Divider(thickness: 3,color: Colors.black,)),

                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: Card(
                            elevation: 3,
                            shape: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(40)),
                            child: ListTile(
                              dense: true,
                              onTap: (){
                                signInWithGoogle().whenComplete((){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Choices()));
                                });
                              },
                              leading: Icon(
                                  FontAwesomeIcons.google
                                      , color: Colors.blue,
                                ),
                              title: Text('Google'),
                              ),
                          ),
                        ),
                        Expanded(
                          child: Card(
                            elevation: 3,
shape: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(40)),
                            child: ListTile(
                              dense: true,
                              onTap: (){},
                              leading: Icon(
                                FontAwesomeIcons.facebook,
                                color: Colors.blue,
                              ),
                              title: Text('Facebook'),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],),

              ),
            ),
          )),
    );
  }

   Future<String> signInWithGoogle()async{
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseAuth auth =FirebaseAuth.instance;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final AuthResult authResult = await auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentuser = await auth.currentUser();
    assert(user.uid==currentuser.uid);

    print("signed in " + currentuser.displayName);
    return 'sign in with google : $currentuser';
  }

}
