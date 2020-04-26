import 'package:flutter/material.dart';

import 'package:hatly/scoped_model/international-model.dart';
import 'package:scoped_model/scoped_model.dart';

import 'orders/my_orders.dart';
import 'orders/my_trip.dart';

class IOrder extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<InternationalModel>(builder: (BuildContext context ,Widget child,InternationalModel model){
      return  DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: Text('Orders',),
              bottom: TabBar(
                indicatorWeight: 5,
                tabs: <Widget>[
                  Tab(
                    text: 'My Orders',
                    icon: Icon(Icons.add_box),

                  ),
                  Tab(
                    text: 'My Trip',
                    icon: Icon(Icons.airplanemode_active),
                  ),
                ],
              ),
            ),

            body: Container(
//            decoration: backgroundImage,
              child: TabBarView(
                children: <Widget>[
                  MyOrders(model: model),//orders: orders,),
                  MyTrip()
                ],
              ),
            )
        ),
      );
    });
  }
}

