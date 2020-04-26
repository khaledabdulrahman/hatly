import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatly/i_screens/international/on_trip_click/trip_deals.dart';
import 'package:hatly/i_screens/international/orders/on_order/send_offers_to_trip/order_offer.dart';
import 'package:hatly/scoped_model/international-model.dart';
import 'package:scoped_model/scoped_model.dart';

class SuggestedOrders extends StatefulWidget {

  InternationalModel model;

  SuggestedOrders(this.model);

  @override
  _SuggestedOrdersState createState() => _SuggestedOrdersState();
}

class _SuggestedOrdersState extends State<SuggestedOrders> {
  bool ordersuccess=false;

  List <int> check=[];

  Widget buildavailableorders(
      BuildContext context, int index, InternationalModel model) {
    model.index(index);
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          shape: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(15)),
          elevation: 10,
          child: Column(
            children: <Widget>[
              Container(
                height: 200,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                CircleAvatar(
                      radius: 25,
                      child: Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.yellow,
                      ),
                      backgroundColor: Colors.black,
                    ),
                                Center(child: Text('${model.availableorders[index].userEmail}'),)
                              ],
                            ),
                          ),
                        )),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SingleChildScrollView(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[],
                                ),
                                Text(
                                    'From ${model.availableorders[index].countryfrom}'),
                                Text(
                                    'To ${model.availableorders[index].countryto}'),
                              ],
                            ),
//                        scrollDirection: Axis.horizontal,
                          ),
                          Text('${model.availableorders[index].name}'),
                          ListTile(
                            title: Icon(Icons.attach_money),
                            trailing:
                                Text('${model.availableorders[index].price} \$ '),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text('${model.availableorders[index].category}  '),
                              RaisedButton(shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),elevation: 10,color: Colors.black,child: Text('send offer',style: TextStyle(color: Colors.yellow),),onPressed: (){

                                Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderOffer(order: model.availableorders[index],index: index))).then((value){

//                                  if(value)
//                                  widget.model.availablleorders();

//                                  check.add(index);
//                                  ordersuccess=value;
                                });
                              },)
                            ],
                          ),
//                      ListTile(
//                        title: Text('${model.allorders[index].userEmail}'),
//                      )
//                          check.contains(index)&&ordersuccess? Container(alignment: Alignment.bottomRight,padding: EdgeInsets.all(8),child: Text('Offer sent',style: TextStyle(color: Colors.green,fontWeight: FontWeight.w700),),):Container(),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  fetchuser()async{
    await  widget.model.fetchUsers();
  }
  @override
  void initState() {
     widget.model.availablleorders();
     fetchuser();
     super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  ScopedModelDescendant<InternationalModel>(builder:(context,child,InternationalModel model)  {
      return Container(
        child: RefreshIndicator(
          onRefresh: ()async=> model.availablleorders(),
          backgroundColor: Colors.yellow,
          child: !model.isLoading
              ?
//          FutureBuilder(
//            future: model.availablleorders(),
//builder:(_,snapshots){
//              snapshots.
//              return buildavailableorders(context, index, model),
//},
        ListView.builder(
           itemBuilder : (BuildContext context, int index) =>
                buildavailableorders(context, index, model),
            itemCount: model.availableorders.length,
          )
              : Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.yellow,
            ),
          ),
        ),
      );
    });
  }
}
