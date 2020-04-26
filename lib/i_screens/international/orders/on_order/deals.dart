import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hatly/i_screens/international/internationalChat/ichat.dart';
import 'package:hatly/models/user.dart';
import 'package:hatly/scoped_model/international-model.dart';

import '../../internationalChat/i_chat_list.dart';

class Deals extends StatefulWidget {
  InternationalModel model;
  double lowestauction;
  int noa;

  Deals(this.model, this.lowestauction, this.noa);

  @override
  _DealsState createState() => _DealsState();
}

class _DealsState extends State<Deals> {
  Widget buildDeal(BuildContext context, int index, InternationalModel model) {
    model.getuserForOrder(model.deals[index].tripUserEmail);
    model.index(index);
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          shape: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          child: Column(
            children: <Widget>[
              Container(
                  height: 260,
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
                                child:
                                    Text('${model.deals[index].tripUserEmail}'),
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
                                  '${model.deals[index].orderName}',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            ListTile(
                              trailing: Text('${widget.lowestauction} \$',
                                  style: TextStyle(fontSize: 18)),
                              leading: Text('Lowest Auction '),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 70),
                            ),
                            ListTile(trailing:Text('${widget.noa}',style: TextStyle(fontSize: 18)) ,leading: Icon(FontAwesomeIcons.users,color: Colors.black),contentPadding: EdgeInsets.symmetric(horizontal: 70),),
                            Divider(
                              thickness: 3,
                            ),
                            ListTile(
                              dense: true,
                              trailing: Text('${model.deals[index].price}  \$',
                                  style: TextStyle(fontSize: 18)),
                              leading: Text('auction offer '),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 70),
                            ),
                            model.deals[index].accept==null||model.deals[index].accept==false
                                ?
                            Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      RaisedButton(
                                        shape: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        elevation: 10,
                                        color: Colors.white,
                                        child: Text(
                                          'reject',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: ()async {
                                          await   model.updateOffer(model.deals[index],accept: false);
                                          model.builddeals();
                                          model.fetchorders(true);
                                        },
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      RaisedButton(
                                        shape: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        elevation: 10,
                                        color: Colors.white,
                                        child: Text(
                                          'accept',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                        onPressed: ()async {

                                       await   model.updateOffer(model.deals[index],accept: true);
                                model.builddeals();
                                          model.fetchorders(true);
                                        },
                                      )
                                    ],
                                  ):RaisedButton(
                              shape: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(15)),
                              elevation: 10,
                              color: Colors.black,
                              child: Text(
                                'chat',
                                style: TextStyle(color: Colors.yellow),
                              ),
                              onPressed: () async{

//                                User user=model.getUser(model.deals[index].orderUserEmail);
//                                await   model.updateOffer(model.deals[index],accept: false);
//                                model.builddeals();
//                                model.fetchorders(true);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            IChat(offer:model.deals[index],name:'${model.userOrder.firstname+' '+ model.userOrder.lastname}' )));
                              },
                            ),
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

  bu()async{
   await widget.model.fetchoffers();
    widget.model.fetchorders(true);

  }
  fetchuser()async{
    await  widget.model.fetchUsers();
  }
  @override
  void initState() {
    bu();
    fetchuser();
     super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RefreshIndicator(
        onRefresh: ()async {
          await widget.model.fetchoffers();
//         widget.model.buildInititrip();
          return;
          },
        backgroundColor: Colors.yellow,
        child: !widget.model.isLoading
            ? ListView.builder(
                itemBuilder: (BuildContext context, int index) =>
                    buildDeal(context, index, widget.model),
                itemCount: widget.model.deals.length,
              )
            : widget.model.fetchedMyoffers.length > 0
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.yellow,
                    ),
                  )
                : Container(),
      ),
    );
  }
}
