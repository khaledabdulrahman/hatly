import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hatly/constants/decoration.dart';
import 'package:hatly/i_screens/international/product/add_order.dart';
import 'package:hatly/models/order.dart';
import 'package:hatly/scoped_model/international-model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'on_order/on_full_order.dart';
class MyOrders extends StatefulWidget {
  InternationalModel model;

  MyOrders({this.model});

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  Order editingorder;

  Widget buildorders(
      BuildContext context, int index, InternationalModel model) {
    return GestureDetector(
      onTap: () {
        model.selectorderid=model.allOrders[index].id;
        model.orderIndex=index;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OnFullOrder(
                    model.allOrders[index].name,
                    model.allOrders[index].countryfrom,
                    model.allOrders[index].countryto,
                    model.allOrders[index].price,
                  model.allOrders[index].userEmail,
                  model.allOrders[index].lowestAuction,
                  model.allOrders[index].numberOfAuctions,

                ))).then((_){
                model.fetchorders(true);
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(20)),
//        color: Colors.black,
        elevation: 15,
          child: Container(
//          decoration: BoxDecoration(color:Colors.white ,borderRadius: BorderRadius.only(topLeft: Radius.circular(100))),
            height: 196,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(color: Colors.yellow.withOpacity(0.5)),
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.topLeft,
                    child: Text('Order')),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[],
                    ),
                    Text('From ${model.allOrders[index].countryfrom}'),
                    Text('To ${model.allOrders[index].countryto}'),
                  ],
                ),
                Text('${model.allOrders[index].name}'),
                Text('Price : ${model.allOrders[index].price} \$ '),
                Text('${model.allOrders[index].category}  '),
                Text('${model.allOrders[index].quantity}  '),
                Text('date is before ${model.allOrders[index].dateTime}'),
                ListTile(
                  title: Text('${model.allOrders[index].userEmail}'),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      model.index(index);
                      model.orderid(model.allOrders[index].id);
                      editingorder =
                          model.allOrders.firstWhere((Order order) {
                        return order.id == model.allOrders[index].id;
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AddOrder(editorder: editingorder)));
                    },
                  ),
                )
              ],
            ),
          ),
          ),
      ),
      );
  }

  Widget checkOrder(List<Order> orders, InternationalModel model) {
    if (orders == null) {
      return Center(
        child: Text('please enter any thing !!'),
      );
    } else {
      if (orders.length == 0) {
        return Center(
          child: Text('Please add an Order '),
        );
      } else {
        return RefreshIndicator(
            onRefresh: () => model.fetchorders(true),
            backgroundColor: Colors.yellow,
            child: !model.isLoading
                ? ListView.builder(
                    itemBuilder: (BuildContext context, int index) =>
                        buildorders(context, index, model),
                    itemCount: model.allOrders.length,
                  )
                : Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.yellow,
                    ),
                  ));
      }
    }
  }

  @override
  void initState() {
    widget.model.fetchorders(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<InternationalModel>(
      builder: (BuildContext context, Widget child, InternationalModel model) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet<Order>(
//                    isScrollControlled: true,
                    context: context,
                    builder: (context) => AddOrder(),
                    backgroundColor: Colors.white,
                    elevation: 5.0);
//                  .then((Order  value){
//                model.addorder(Order(name: value.name,countryfrom: value.countryfrom,countryto: value.countryto,category: value.category,price: value.price,)
//                );
//              }
//              );
              },
              backgroundColor: Colors.black,
              foregroundColor: Colors.yellow,
              elevation: 15,
              child: Icon(Icons.add)),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: Container(
              decoration: backgroundImage,
              child: checkOrder(model.allOrders, model)),
        );
      },
    );
  }
}
