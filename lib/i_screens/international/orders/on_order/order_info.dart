import 'package:flutter/material.dart';

class OrderInfo extends StatelessWidget {
  double price;
  String notes;

  OrderInfo({this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                          enabled: false,
                          fillColor: Colors.yellowAccent.withOpacity(0.5),
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                          hintStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
                          hintText: '5'),
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
                      'Last Price',
                      style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w600),
                    )),
                Expanded(
                    child: TextField(
                      enableInteractiveSelection: true,
                      readOnly: true,
                      decoration: InputDecoration(
                        enabled: false,
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                          prefixIcon:
                          Icon(Icons.attach_money, color: Colors.black),
                          filled: true,
                          fillColor:  Colors.yellowAccent.withOpacity(0.5),
                          hintStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
                          hintText: ' 55'),
                    ))
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                      'Price is ${price*(2/100)} \$ for HATLY + .. from Traveller ',
                      style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w600),
                    )),
                Expanded(
                    child: TextField(
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
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Notes for your Order : ',
                  style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w600),),
                TextField(
                  onChanged: (String value){
                    notes=value;
                  },
                  maxLines: 3,
                  maxLengthEnforced: true,
                  maxLength: 100,
                  decoration: InputDecoration(
                      prefixIcon:
                      Icon(Icons.note, color: Colors.black),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.7),
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                      hintStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
                      hintText: 'if you have any notes of your order'),
                )
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(color: Colors.black,child: Text('update',style: TextStyle(color: Colors.yellow),),onPressed: (){},)
            ],
          )
        ],
      ),
    );
  }
}
