
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatly/i_screens/international/internationalChat/steps.dart';
import 'package:hatly/models/offers.dart';
import 'package:hatly/models/user.dart';
import 'package:hatly/scoped_model/international-model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';


Firestore _firestore = Firestore.instance;

class IChat extends StatelessWidget {
  Offer offer;
  String name;
  IChat({this.offer,this.name});

  String message;

TextEditingController _textEditingController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.black.withOpacity(0.8),
          title: Text('$name',style: TextStyle(color: Colors.yellow),),
          leading: IconButton(color: Colors.yellow,icon:Icon(Icons.arrow_back),onPressed: () {
            Navigator.pop(context);
          }, ),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.info_outline),color: Colors.yellow,onPressed: (){
Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatSteps(offer)));
            },)
          ],
        ),
          //   title: Text(, style: TextStyle(color: Colors.black),),

        body: Container(
            color: Colors.yellow.withAlpha(64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MessagesStream(offer.id,name),
                Container(
//                    alignment: Alignment.bottomCenter,
                    child: ScopedModelDescendant<InternationalModel>(
                        builder: (context, child, InternationalModel model) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: TextField(
                                    autocorrect: false,
                                    enabled: true,
                                    controller: _textEditingController,
                                    decoration: InputDecoration(
                                        hintText: 'New message',
                                        contentPadding: EdgeInsets.symmetric(horizontal: 18,vertical: 15),
                                        enabled: true,
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                40), borderSide: BorderSide.none),
                                        filled: true,
                                        fillColor: Colors.white),
                                    onChanged: (value) {
                                      message = value;
                                    },
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _textEditingController.clear();
                                    model.addMessage(
                                        message, model.user.email,offer.id);
                                  },
                                  icon: Icon(Icons.send),
                                  iconSize: 35,
                                )
                              ],
                            ),
                          );
                        })
                )
              ],
            )
        )

    );
  }
}

class MessagesStream extends StatelessWidget {
  String offerID;
  MessagesStream(this.offerID,this.name);
  String name;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection(offerID).orderBy('time',descending: true).snapshots(),
      builder: (BuildContext context, snapshot){
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
          var msg = snapshot.data.documents;
          List <MessageBubble> messegewidgets = [];
          for (var m in msg) {
            final msgsender = m.data['sender'];
            final msgtext = m.data['message'];
            var  msgTime;
if (m.data['time']!=null)
              msgTime = (m.data['time'] as Timestamp).toDate();

            final msgwidget = MessageBubble(
              message: msgtext, sender: msgsender,tt: msgTime,name: name,);
            messegewidgets.add(msgwidget);
          }
           return Expanded(
              child: ListView(
                reverse: true,
                padding: EdgeInsets.all(15),
                children: messegewidgets,
              )
          );
      },
    );
  }
}


class MessageBubble extends StatelessWidget {
  String message;
  String sender;
DateTime tt;
  DateTime time;
  String name;

  MessageBubble({this.message, this.sender,this.tt,this.name});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<InternationalModel>(builder:(context,child,InternationalModel model){
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            model.user.email!=sender?CircleAvatar(child: Icon(Icons.person,color: Colors.yellowAccent,),backgroundColor: Colors.black,):Container(),
            SizedBox(width: 10,),
            Expanded(
              child: Column(
                crossAxisAlignment:model.user.email==sender?CrossAxisAlignment.end:CrossAxisAlignment.start,
                children: <Widget>[
//                  Text('$name', style: TextStyle(fontSize: 15, color:Colors.black45),),
                  Material(
                    elevation: 5,
                    color:model.user.email==sender? Colors.lightGreen.shade300:Colors.yellow.shade300,
                    borderRadius:model.user.email==sender? BorderRadius.only(topLeft: Radius.circular(30),bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)):BorderRadius.only(topRight: Radius.circular(30),bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                      child: Text('$message', style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: model.user.email==sender?Colors.white:Colors.black),),
                    ),

                  ),
                  SizedBox(height: 7,),
                  tt==null?Container():Text(' ${DateFormat.jm().format(tt)}',style: TextStyle(color: Colors.black45),)
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}


