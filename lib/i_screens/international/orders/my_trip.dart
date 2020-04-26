import 'package:flutter/material.dart';
import 'package:hatly/constants/decoration.dart';
import 'package:hatly/models/trip.dart';
import 'package:hatly/scoped_model/international-model.dart';
import 'package:scoped_model/scoped_model.dart';

import 'on_trip/add_trip.dart';
import 'on_trip/trip-list.dart';

class MyTrip extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<InternationalModel>(builder:
        (BuildContext context, Widget child, InternationalModel model) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet<Trip>(
//                    isScrollControlled: true,
                      context: context,
                      builder: (context) => AddTrip(),
                      backgroundColor: Colors.white,
                      elevation: 5.0);
//                  .then((Trip value) {
//                if (model.trip == null)
//                  model.addtrip(value.tripfrom, value.tripto, value.weight,value.dateTime);
//                print(trip.tripfrom);
//                print(trip.tripto);
//                print(trip.weight);
//              }
//              );
            },
            backgroundColor: Colors.black,
            foregroundColor: Colors.yellow,
            elevation: 15,
            child: Icon(Icons.add)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Container(
          decoration: backgroundImage,
          child: GestureDetector(
//            child:
//             TripList(model),
          ),
        ),
      );
    });
  }
}

//model.trip == null ? Container(child: Center(
//child: Text('If you want to get money : enter a Trip'),),) :
