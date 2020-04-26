import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hatly/i_screens/international/on_trip_click/tripManager.dart';
import 'package:hatly/scoped_model/international-model.dart';
import 'package:scoped_model/scoped_model.dart';

class TripList extends StatefulWidget {
  InternationalModel model;

  TripList(this.model);

  @override
  _TripListState createState() => _TripListState();
}

class _TripListState extends State<TripList> {
  bool yes=true;
  @override
  void initState() {
    widget.model.fetchtrip();
    print('orders el ana 3mltlhom offers  trip list is ${ widget.model.fetchedMyoffers.length}');

    super.initState();

  }
  @override
  Widget build(BuildContext context) {

    return ScopedModelDescendant<InternationalModel>(builder:
        (BuildContext context, Widget child, InternationalModel model) {
      return RefreshIndicator(onRefresh: ()=>model.fetchtrip(),child: Container(
        color: Colors.yellow,
        child: Container(
          padding: EdgeInsets.only(bottom: 20, right: 30, top: 20, left: 20),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.flight_takeoff,
                                  size: 40,
                                  color: Colors.black,
                                ),
                                Text(
                                  'From',
                                  style: TextStyle(fontSize: 20),
                                ),
                                SingleChildScrollView(
                                  child: Text(
                                    '${model.trip.countryfrom==null?'':model.trip.countryfrom}',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.flight_land,
                                  size: 40,
                                  color: Colors.black,
                                ),
                                Text(
                                  'To',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  '${model.trip.countryto==null?'':model.trip.countryto}',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  'assets/weight.png',
                                  scale: 0.7,
                                ),
                                Text(
                                  'weight',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  '${model.trip.weight==null?0:model.trip.weight}',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  size: 40,
                                  color: Colors.black,
                                ),
                                Text(
                                  'Date of travel',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  '${model.trip.datetime==null?'':model.trip.datetime}',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              ScopedModelDescendant<InternationalModel>(builder: (BuildContext context, Widget child,InternationalModel model){
                return  Container(
                    alignment: Alignment.centerRight,
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 25,
                      child: IconButton(
                        onPressed: (){
                          model.isValid()?Navigator.push(context, MaterialPageRoute(builder: (context)=>TripManager())):Container();
                        },
                        icon: Icon(
                          Icons.forward,
                          color: Colors.yellow,
                        ),
                      ),
                    ));
              },)
              ,
            ],
          ),
        ),
      ));
    });
  }
}
