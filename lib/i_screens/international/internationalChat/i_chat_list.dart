import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hatly/constants/decoration.dart';
import 'package:hatly/i_screens/international/internationalChat/ordersChat.dart';
import 'package:hatly/i_screens/international/internationalChat/tripsChat.dart';
import 'package:hatly/scoped_model/international-model.dart';
import 'package:scoped_model/scoped_model.dart';

class IChatList extends StatelessWidget {
@override
  Widget build(BuildContext context) {
      return ScopedModelDescendant <InternationalModel>(builder: (context,child,model){
        return DefaultTabController(
          length: 2,
          child: Scaffold(
              appBar: AppBar(title: Text('Chat'),
                bottom: TabBar( indicatorWeight: 5,
                  tabs: <Widget>[
                    Tab(
                      text: 'Orders chat',
                      icon: Icon(FontAwesomeIcons.box),

                    ),
                    Tab(
                      text: 'Trip chat',
                      icon: Icon(FontAwesomeIcons.plane),
                    ),
                  ],),
              ),

              body:Container(
                decoration: backgroundImage,
                child: TabBarView(
                  children: <Widget>[
                    ChatOrders(model),//orders: orders,),
                    ChatTrips(model)
                  ],
                ),
              )
          ),
        );
      });
  }
}
