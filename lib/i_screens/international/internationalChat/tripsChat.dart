import 'package:flutter/material.dart';
import 'package:hatly/i_screens/international/internationalChat/ichat.dart';
import 'package:hatly/scoped_model/international-model.dart';
import 'package:scoped_model/scoped_model.dart';


class ChatTrips extends StatefulWidget {

  InternationalModel model;

  ChatTrips(this.model);

  @override
  _ChatTripsState createState() => _ChatTripsState();
}

class _ChatTripsState extends State<ChatTrips> {

  fetchuser()async{
    await  widget.model.fetchUsers();
  await  widget. model.chatList(true);

  }
  @override
  void initState() {
    fetchuser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<InternationalModel>(
        builder: (context, child, model) {
          return Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: model.tripChatList.length == 0 ? Center(
                  child: Text('No chats for Orders'),) : ListView.builder(
                  itemBuilder: (context, index) =>
                      builderChat(context, index, model)
                  , itemCount: model.tripChatList.length,
                ),
              )
          );
        });
  }

  Widget builderChat(BuildContext context, int index,
      InternationalModel model) {
    print('email is aaa');
    print('${model.tripChatList.length}');
    model.getuserForTrip(model.tripChatList[index].orderUserEmail);
    print('${model.userTrip.id}');
    return Card(
      margin: EdgeInsets.all(0),
      elevation: 5,
      color: Colors.white,
      child: ListTile(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              IChat(offer: model.tripChatList[index],
                name: '${model.userTrip.firstname + ' ' +
                    model.userTrip.lastname}',)));
        },
        leading: CircleAvatar(
          child: Icon(Icons.person), backgroundColor: Colors.yellowAccent,),
        title: Text(
            '${model.userTrip.firstname + ' ' + model.userTrip.lastname}'),

      ),
    );
  }
}
