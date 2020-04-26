import 'package:flutter/material.dart';
import 'package:hatly/constants/decoration.dart';
import 'package:hatly/i_screens/international/on_trip_click/suggested_orders.dart';
import 'package:hatly/i_screens/international/on_trip_click/trip_deals.dart';
import 'package:hatly/i_screens/international/on_trip_click/trip_info.dart';
import 'package:hatly/scoped_model/international-model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:hatly/scoped_model/connectedInternational.dart';


class TripManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<InternationalModel>(builder: (BuildContext context,Widget child,InternationalModel model){
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(title: Text('Trip comes from ${model.trip.countryfrom}'),centerTitle: true,bottom: TabBar(tabs: <Widget>[
            Tab(text: 'Suggest orders',icon: Icon(Icons.list),),
            Tab(text: 'Deals',icon: Icon(Icons.playlist_add_check)),
            Tab(text: 'trip info',icon: Icon(Icons.info)),
          ],),),
          body: Container(
            decoration: backgroundImage,
            child: TabBarView(
              children: <Widget>[
                SuggestedOrders(model),
                TripDeals(model:model),
                TripInfo(),
              ],
            ),

          ),
        ),
      );

    });
  }
}
