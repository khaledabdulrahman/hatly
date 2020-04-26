import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatly/i_screens/international/on_trip_click/trip_deals.dart';
import 'package:hatly/models/order.dart';
import 'package:hatly/scoped_model/international-model.dart';
import 'package:scoped_model/scoped_model.dart';

class OrderOffer extends StatelessWidget {

  Order order;
  double price;
  String tripid;
  String tripuserEmail;
  int index;

  OrderOffer({this.order,this.index});

  void sendbutton(InternationalModel model,BuildContext context){

    model.addoffers(orderid: order.id,tripid: tripid,price: price,orderName: order.name).then((succes) {
      if (succes) {
      model.updateAuctionsInOrder(order,price);
model.availablleorders();
      Navigator.pop(context,true);
      }
      else{
        showDialog(context: context,child: AlertDialog(title: Text('something went wrong'),content: Text('its\'s fail , please try again '),actions: <Widget>[
          FlatButton(child: Text('okay'),onPressed: (){Navigator.pop(context);
          Navigator.pop(context,false);
          })
        ],));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.yellowAccent.withOpacity(0.6),automaticallyImplyLeading: false,leading: IconButton(icon: Icon(Icons.keyboard_backspace),onPressed: ()=>Navigator.pop(context,false),),),
        body: Container(
          decoration: BoxDecoration(image: DecorationImage(image:AssetImage('assets/background.jpg'))),
//          color: Colors.yellow.withOpacity(0.5),
          padding: EdgeInsets.all(15),
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex: 2,
                        child: Text(
                          'Number of sending Auctions',
                          style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w600),                        )),
                    Expanded(
                        child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.people,
                            color: Colors.black,
                          ),
                          filled: true,
                          fillColor: Colors.yellowAccent.withOpacity(0.5),
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                          hintStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
                          hintText: '${order.numberOfAuctions}'),
                    ))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex: 2,
                        child: Text(
                          'Lowest Auction Price  ',
                          style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w600),
                        )),
                    Expanded(
                        child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                          prefixIcon:
                              Icon(Icons.attach_money, color: Colors.black),
                          filled: true,
                          fillColor:  Colors.yellowAccent.withOpacity(0.5),
                          hintStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
                          hintText: '${order.lowestAuction}'),
                    ))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Note From User : ',
                      style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w600),                    ),
                    TextField(
                      maxLines: 5,
                      readOnly: true,
                      decoration: InputDecoration(

                          prefixIcon:
                          Icon(Icons.note, color: Colors.black),
                          filled: true,
                          fillColor: Colors.yellowAccent.withOpacity(0.5),
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                          hintStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
                          hintText: 'please take care because it\'s a galasses and can broke when shocking '),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                          'Put your Auction',
                          style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w600),
                        )),
                    Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (String value){
                            price=double.parse(value);
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                              prefixIcon:
                              Icon(Icons.attach_money, color: Colors.black),
                              filled: true,
                              fillColor: Colors.white,
                              hintStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
                              hintText: 'enter a price'),
                        ))
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ScopedModelDescendant<InternationalModel>(builder: (BuildContext context,Widget child,InternationalModel model){
                    return RaisedButton(color: Colors.black,child: Text('send',style: TextStyle(color: Colors.yellow),),onPressed: ()=>sendbutton(model,context));
                  },)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
