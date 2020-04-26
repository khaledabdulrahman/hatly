import 'package:flutter/material.dart';
import 'package:hatly/constants/decoration.dart';
import 'package:hatly/scoped_model/international-model.dart';
import 'package:scoped_model/scoped_model.dart';

class IHome extends StatefulWidget {
  InternationalModel model;

  IHome({this.model});

  @override
  _IHomeState createState() => _IHomeState();
}

class _IHomeState extends State<IHome> {
  Widget buildorders(
      BuildContext context, int index, InternationalModel model) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        shape: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(20)),
//          color: Colors.black,
        elevation: 15,
        child: Container(
//            decoration: BoxDecoration(color:Colors.white ,borderRadius: BorderRadius.only(topLeft: Radius.circular(100))),
          height: 210,
          child: Row(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.topLeft,
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 9,
                  )),
              Expanded(
                  child: CircleAvatar(
                radius: 25,
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.yellow,
                ),
                backgroundColor: Colors.black,
              )),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SingleChildScrollView(
                      scrollDirection:Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('From ${model.allOrders[index].countryfrom}'),
                          Text('To ${model.allOrders[index].countryto}'),
                        ],
                      ),
//                        scrollDirection: Axis.horizontal,
                    ),
                    Text('${model.allOrders[index].name}'),
                    ListTile(
                      leading: Icon(Icons.attach_money),
                      trailing: Text('${model.allOrders[index].price} \$ '),
                    ),
                    ListTile(
                      leading: Icon(Icons.date_range),
                      trailing: Text('${model.allOrders[index].dateTime}'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text('${model.allOrders[index].category}  '),
                        Text('${model.allOrders[index].userEmail}  '),
                      ],
                    ),
//                      ListTile(
//                        title: Text('${model.allorders[index].userEmail}'),
//                      )
                  ],
                ),
              ),
              Expanded(
                  child: CircleAvatar(
                radius: 25,
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.yellow,
                ),
                backgroundColor: Colors.black,
              ))
            ],
          ),
        ),
      ),
    );
  }

  @override
   initState()  {
    widget.model.fetchorders(false);
    widget.model.fetchtrip();

    print(widget.model.user.email);
    print(widget.model.user.firstname);


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<InternationalModel>(builder:
        (BuildContext context, Widget child, InternationalModel model) {
      return Scaffold(
          appBar: AppBar(
            title: Text('HATLY'),
            centerTitle: true,
          ),
          body: Container(
              decoration: backgroundImage,
              child: RefreshIndicator(
                  onRefresh: () => model.fetchorders(false),
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
                        ))));
    });
  }
}
