import 'package:flutter/material.dart';
import 'package:hatly/constants/decoration.dart';
import 'package:hatly/i_screens/international/orders/on_order/suggest_trips.dart';
import 'package:hatly/scoped_model/international-model.dart';
import 'package:scoped_model/scoped_model.dart';

import 'deals.dart';
import 'order_info.dart';


class OnFullOrder extends StatelessWidget {
  String name;
  String countryfrom;
  String countryto;
  double price;
  String orderUserEmail;
  double lowestprice;
  int noa;

  OnFullOrder(this.name, this.countryfrom, this.countryto, this.price,this.orderUserEmail,this.lowestprice,this.noa);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<InternationalModel>(builder:(BuildContext context,Widget child,InternationalModel model){
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(title: Text(name),centerTitle: true,bottom: TabBar(tabs: <Widget>[
            Tab(text: 'Suggest Trips',),
            Tab(text: 'Deals',),
            Tab(text: 'order info',),
          ],),),
          body: Container(
            decoration: backgroundImage,
            child: TabBarView(
              children: <Widget>[
                SuggestTrips(model),
                Deals(model,lowestprice,noa),
                OrderInfo(price:price,),
              ],
            ),

          ),
        ),
      );
    } );
  }
}

