import 'package:country_list_pick/support/code_countrys.dart';
import 'package:flutter/material.dart';
import 'package:hatly/models/order.dart';
import 'package:hatly/scoped_model/international-model.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:scoped_model/scoped_model.dart';

class AddOrder extends StatefulWidget {
  Order editorder;

  AddOrder({this.editorder});

  @override
  _AddOrderState createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {

  static String dropdownValue;
  static DateTime datenow = DateTime.now();
  static CountryCode orderto;
  static CountryCode orderfrom;
  static Map<String, dynamic> formData = {
    'name': null,
    'countryfrom': orderfrom == null ? null : orderfrom.name,
    'countryto': orderto == null ? null : orderto.name,
    'weight': null,
    'price': null,
    'quantity': '',
    'category': dropdownValue != null ? dropdownValue : null,
    'datetime': '${datenow.day}/${datenow.month}/${datenow.year}'
  };

  void submitForm(InternationalModel model) {
    globalKey.currentState.save();
    if (!globalKey.currentState.validate()) {
      return;
    }
    if (widget.editorder == null) {
      model
          .addorder(
              countryfrom: formData['countryfrom'],
              countryto: formData['countryto'],
              name: formData['name'],
              weight: formData['weight'],
              quantity: formData['quantity'],
              price: formData['price'],
              category: formData['category'],
              dateTime: formData['datetime'])
          .then((bool done) {
        if (done) {
          dropdownValue = null;
          globalKey.currentState.save();
          Navigator.pop(context);
        }
        else{
          showDialog(context: context,child: AlertDialog(title: Text('something went wrong'),content: Text('its\'s fail , please try again '),actions: <Widget>[
            FlatButton(child: Text('okay'),onPressed: (){Navigator.pop(context);
            Navigator.pop(context);
            })
          ],));
        }
      });
    } else {
      model
          .updateorder(
              countryfrom: formData['countryfrom'],
              countryto: formData['countryto'],
              name: formData['name'],
              weight: formData['weight'],
              quantity: formData['quantity'],
              price: formData['price'],
              category: formData['category'],
              dateTime: formData['datetime'])
          .then((_) {
        Navigator.pop(context);
      });
    }
  }

//
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  Widget buildnameTextField() {
    return TextFormField(
        initialValue: widget.editorder == null ? '' : widget.editorder.name,
        keyboardType: TextInputType.text,
        validator: (String value) {
          if (value.isEmpty || value.length < 4) {
            return 'name of product is requied and more than 4 characters';
          }

        },
        onSaved: (String value) {
//          if (widget.editorder != null) widget.editorder.name = value;
          formData['name'] = value;
//else{
//        nameofproduct=value;
//        print('in add order $nameofproduct');
//      }}
        },
        decoration: InputDecoration(
          labelText: 'Name of a product',
        ));
  }

  Widget BuildSubmitButton() {
    return ScopedModelDescendant<InternationalModel>(
      builder: (BuildContext context, Widget child, InternationalModel model) {
        return RaisedButton(
          onPressed: () => submitForm(model),
          color: Colors.black,
          child: Text(
            'Add',
            style: TextStyle(color: Colors.yellow),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                                orderfrom = code;
                                formData['countryfrom']=code.name;
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
                                orderto = code;
                                formData['countryto'] = code.name;
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
                            'Date you want to recieve your order befor :',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          DatePickerTimeline(
                            datenow,
                            onDateChange: (date) {
                              setState(() {
                                datenow = date;
                                formData['datetime'] =
                                    '${datenow.day}/${datenow.month}/${datenow.year}';
                              });
                              // New date selected

                              print(datenow.day.toString());
                              print(datenow.month.toString());
                            },
                            daysCount: 365,
                          ),
                        ],
                      )),
                  Container(
                    child: buildnameTextField(),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: Container(
                        child: buildweightTextField(),
                      )),
                      SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: buildSelectcategory(),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(child: buildPriceTextField()),
                      SizedBox(
                        width: 30,
                      ),
                      Expanded(child: buildQuantityTextField()),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
//                  BuildSubmitButton(),
                  BuildSubmitButton()
                ],
              ),
            )),
      ),
    );
  }

  Widget buildQuantityTextField() {
    return TextFormField(
      initialValue:
          widget.editorder == null ? '' : widget.editorder.quantity.toString(),
      keyboardType: TextInputType.number,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value))
          return 'Quantity of product is requied';
      },
      onSaved: (String value) {
//        if (widget.editorder != null)
//          widget.editorder.quantity = int.parse(value);
        formData['quantity'] = int.parse(value);
      },
      decoration: InputDecoration(labelText: 'Quantity'),
    );
  }

  Widget buildPriceTextField() {
    return TextFormField(
      initialValue:
          widget.editorder == null ? '' : widget.editorder.price.toString(),
      keyboardType: TextInputType.number,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
          return 'Price of product is requied';
        }
      },
      onSaved: (String value) {
//        if (widget.editorder != null)
//          widget.editorder.price = double.parse(value);
        formData['price'] = double.parse(value);
      },
      decoration: InputDecoration(labelText: 'Price \$'),
    );
  }

  Container buildSelectcategory() {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: Colors.black),
      ),
      child: DropdownButton<String>(
        hint: Text('select category'),
        value: dropdownValue,
        icon: Icon(
          Icons.arrow_drop_down,
        ),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.black),
        onChanged: (String newValue) {
          setState(() {
//           if( widget.editorder.category==null) {
             dropdownValue = newValue;
             formData['category'] = dropdownValue;
//           }else {
//             dropdownValue = widget.editorder.category;
//             formData['category'] = dropdownValue;
//           }
           });
        },
        items: <String>['Electronics', 'papers', 'vitamines', 'mobiles']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget buildweightTextField() {
    return TextFormField(
      initialValue:
          widget.editorder == null ? '' : widget.editorder.weight.toString(),
      keyboardType: TextInputType.number,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
          return 'Weight of product is requied';
        }
      },
      onSaved: (String value) {
        formData['weight'] = double.parse(value);
      },
      decoration: InputDecoration(labelText: 'Weight (kg)'),
    );
  }
}
