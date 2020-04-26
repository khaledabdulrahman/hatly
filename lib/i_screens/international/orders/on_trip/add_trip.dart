import 'package:flutter/material.dart';
import 'package:hatly/models/trip.dart';
import 'package:hatly/scoped_model/international-model.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

import 'package:scoped_model/scoped_model.dart';

class AddTrip extends StatefulWidget {

  @override
  _AddTripState createState() => _AddTripState();
}

class _AddTripState extends State<AddTrip> {
  CountryCode tripfrom;

  CountryCode tripto;

  String tdropdownvalue;

  double weight;

  DateTime dateTime = DateTime.now();

  Trip ordermap(InternationalModel model,BuildContext context) {
    bool check=true;
    print ('ay 7aga fl trip  ${model.trip.countryfrom}');
    if (model.trip.countryfrom==''||model.trip.countryto==''||model.trip.datetime==''||model.trip.weight==0)
{
  model.addTrip(
      countryto: tripto.name,
      countryfrom: tripfrom.name,
      datetime: '${dateTime.day}/${dateTime.month}/${dateTime.year}',
      weight: weight);

}else{
      model.updatetrip(
          countryto: tripto.name,
          countryfrom: tripfrom.name,
          datetime: '${dateTime.day}/${dateTime.month}/${dateTime.year}',
          weight: weight);
    }

    print(model.trip.countryto);
    print(model.trip.countryfrom);
    print(model.trip.weight);
    print(model.trip.datetime);
    Navigator.pop(context);
  }

  GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
//    String from = tripfrom == null ? '' : tripfrom.name;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
            margin: EdgeInsets.all(15),
            child: Form(
              key: globalKey,
              child: ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        height: 30,
                        decoration: BoxDecoration(
                            color: Color(0xffFF0000), shape: BoxShape.circle),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text('From :'),
                            Icon(Icons.flight_takeoff),
                            SizedBox(
                              width: 5,
                            ),
                            CountryListPick(
                              isShowFlag: true,
                              isShowTitle: false,
                              isDownIcon: true,
                              initialSelection: '+971',
                              onChanged: (CountryCode code) {
                                tripfrom = code;
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text('To :'),
                            Icon(Icons.flight_land),
                            SizedBox(
                              width: 10,
                            ),
                            CountryListPick(
                              isShowFlag: true,
                              isShowTitle: false,
                              isDownIcon: true,
                              initialSelection: '+20',
                              onChanged: (CountryCode code) {
                                tripto = code;
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 20),
//              decoration: BoxDecoration( color: Colors.yellowAccent,border: Border.all(color: Colors.black),),

                      child: Column(
                        children: <Widget>[
                          Text(
                            'When will You travel from  ? :',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          DatePickerTimeline(
                            dateTime,
                            onDateChange: (date) {
                              // New date selected
                              dateTime = date;

                              print(date.day.toString());
                              print(date.month.toString());
                            },
                          ),
                        ],
                      )),
//
                  SizedBox(
                    width: 30,
                  ),
//                  buildweightTextField(),
                  TextFormField(
                    validator: (String value) =>
                        value.isEmpty ? 'please input a weight' : '',
                    onChanged: (String value) {
                      weight = double.parse(value);
                    },
                    keyboardType: TextInputType.number,
                    decoration:
                        InputDecoration(labelText: 'available weight with u '),
                  ),
//                    ],
//                  ),

                  SizedBox(
                    height: 15,
                  ),

//            ])
//                  BuildSubmitButton(),
                  ScopedModelDescendant<InternationalModel>(
                    builder: (BuildContext context, Widget child,
                        InternationalModel model) {
                      return RaisedButton(
                        onPressed: () {
                          ordermap(model,context);
                        },
                        color: Colors.black,
                        child: Text(
                          'Add',
                          style: TextStyle(color: Colors.yellow),
                        ),
                      );
                    },
                  )
                ],
              ),
            )),
//      ),
      ),
    );
  }

  Widget buildweightTextField() {
    return TextFormField(
      initialValue:
      weight == null ? '' : weight.toString(),
      keyboardType: TextInputType.number,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
          return 'Weight of product is requied';
        }
      },
      onSaved: (String value) {
        weight = double.parse(value);
//        if (widget.editorder != null)
//          widget.editorder.weight = double.parse(value);
      },
      decoration: InputDecoration(labelText: 'Available Weight (kg)'),
    );
  }
}
