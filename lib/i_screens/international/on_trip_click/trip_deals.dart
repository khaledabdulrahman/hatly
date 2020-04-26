import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatly/i_screens/international/internationalChat/ichat.dart';
import 'package:hatly/i_screens/international/on_trip_click/sendofferagain.dart';
import 'package:hatly/models/order.dart';
import 'package:hatly/models/user.dart';
import 'package:hatly/scoped_model/international-model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

class TripDeals extends StatelessWidget {
  InternationalModel model;
  int numberofautions;

  TripDeals({this.model, this.numberofautions});

  String id;
  double lastprice;
  Order ord;
  bool accept;
  Widget buildDeal(BuildContext context, int index, InternationalModel model) {


    accept =model.fetchedMyoffers[index].accept;
    Order ord=model.returnorder(model.fetchedMyoffers[index].orderid);
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          shape: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(20)),
          elevation: 10,
          child: Column(
            children: <Widget>[
              Container(
                  height: 280,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                              Center(
                                child: Text(
                                    '${model.fetchedMyoffers[index].orderUserEmail}'),
                              )
                            ],
                          ),
                        ),
                      )),
                      Expanded(
                        flex: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                FaIcon(
                                  FontAwesomeIcons.boxOpen,
                                ),
                                Text(
                                  '${ord.name}',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            ListTile(
                              trailing: Text(
                                  '${ord.lowestAuction == null ? "0" : ord.lowestAuction}',
                                  style: TextStyle(fontSize: 18)),
                              leading: Text('Lowest Auction '),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 70),
                            ),
                            ListTile(
                              trailing: Text(
                                  '${ord.numberOfAuctions == null ? "no one" : ord.numberOfAuctions}',
                                  style: TextStyle(fontSize: 18)),
                              leading: Icon(FontAwesomeIcons.users,
                                  color: Colors.black),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 70),
                            ),
                            Divider(
                              thickness: 3,
                            ),
                            ListTile(
                              trailing: Text(
                                  '${model.fetchedMyoffers[index].price}',
                                  style: TextStyle(fontSize: 18)),
                              leading: Icon(FontAwesomeIcons.dollarSign,
                                  color: Colors.black),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 80),
                            ),
                            accept==null
                                ?  Text(
                              'Waiting for Accept ...',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18),
                            ):accept==true?
                            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text('accepted',style: TextStyle(color: Colors.green,fontWeight: FontWeight.w700,fontSize: 20),),
                                RaisedButton(
                                        shape: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        elevation: 10,
                                        color: Colors.black,
                                        child: Text(
                                          'Chat',
                                          style: TextStyle(color: Colors.yellow),
                                        ),
                                        onPressed: () {
                                          model.getuserForTrip(model.fetchedMyoffers[index].orderUserEmail);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      IChat(offer: model.fetchedMyoffers[index],name: '${model.userTrip.firstname + ' ' + model.userTrip.lastname}')

                                              ));
//
                                        },
                                      ),
                              ],
                            )
                                : ListTile(
                                        title: Text(
                                          'rejected',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        trailing: RaisedButton(
                                            shape: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            elevation: 10,
                                            color: Colors.black,
                                            child: Text(
                                              'update offer',
                                              style: TextStyle(
                                                  color: Colors.yellow),
                                            ),
                                            onPressed: () {
                                              Navigator.push(context,MaterialPageRoute(
                                                      builder: (_) =>
                                                          OfferAgain(
                                                            getoffer: model
                                                                .fetchedMyoffers[index],
                                                            model: model,
                                                          )));
//                                                  .then((value) {
//                                                if (value) model.buildoffers();
//                                                print(
//                                                    'name of order${model.availableorders[index].name}');
////                                                check.add(index);
////                                                ordersuccess = value;
//                                              });
                                            }),
                                      )

                          ],
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }


//
//  bool ordersuccess = false;
//  List<int> check = [];

  @override
  Widget build(BuildContext context) {
   return ScopedModelDescendant<InternationalModel>(builder: (context,child,InternationalModel model){
      return Container(
        child: RefreshIndicator(
          onRefresh: () async => await model.fetchoffers(),
          backgroundColor: Colors.yellow,
          child: !model.isLoading
              ? ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                buildDeal(context, index, model)
            ,
            itemCount: model.fetchedMyoffers.length,
          )
              : model.fetchedMyoffers.length > 0
              ? Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.yellow,
            ),
          )
              : Container(),
        ),
      );
    });

  }
}
