
import 'package:flutter/material.dart';
import 'package:hatly/scoped_model/international-model.dart';




class SuggestTrips extends StatefulWidget {
  InternationalModel model;

  SuggestTrips(this.model);
  @override
  _SuggestTripsState createState() => _SuggestTripsState();
}

class _SuggestTripsState extends State<SuggestTrips> {


  buildavailabletrips(BuildContext context , int index,InternationalModel model)
  {return Container(
    child: GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          elevation: 10,
          child: Container(
            height: 210,
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
                            Center(child: Text('${model.availabletrips[index].userEmail}'),)
                          ],
                        ),
                      ),
                    )),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: <Widget>[],
                            ),
                            Text(
                                'From ${model.availabletrips[index].countryfrom}'),
                            Text(
                                'To ${model.availabletrips[index].countryto}'),
                          ],
                        ),
//                        scrollDirection: Axis.horizontal,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Image.asset(
                              'assets/weight.png',
                              scale: 0.9,),
                            Text('${model.availabletrips[index].weight}  '),
                          ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('${model.availabletrips[index].datetime}  '),
//                          RaisedButton(elevation: 10,color: Colors.black,child: Text('send offer',style: TextStyle(color: Colors.yellow),),onPressed: (){
//
//                          },)
                        ],
                      ),
//                      ListTile(
//                        title: Text('${model.allorders[index].userEmail}'),
//                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );}

  bu()async{
    await widget.model.fetchtrip();

  }

  @override
  void initState() {
    bu();

//    widget.model.buildIniti();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Container(
      child: RefreshIndicator(
        onRefresh: () async=>await widget.model.fetchtrip(),
        backgroundColor: Colors.yellow,
        child:
//        !widget.model.isLoading
//            ?
        ListView.builder(
          itemBuilder: (BuildContext context, int index) =>
              buildavailabletrips(context, index, widget.model),
          itemCount: widget.model.availabletrips.length,
        )
//            : Center(
//          child: CircularProgressIndicator(
//            backgroundColor: Colors.yellow,
//          ),
        ),
//      ),
    );
  }
}
