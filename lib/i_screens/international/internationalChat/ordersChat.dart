import 'package:flutter/material.dart';
import 'package:hatly/i_screens/international/internationalChat/ichat.dart';
import 'package:hatly/models/user.dart';
import 'package:hatly/scoped_model/international-model.dart';
import 'package:scoped_model/scoped_model.dart';



class ChatOrders extends StatefulWidget {

  InternationalModel model;

  ChatOrders(this.model);

  @override
  _ChatOrdersState createState() => _ChatOrdersState();
}

class _ChatOrdersState extends State<ChatOrders> {

  fetchuser()async{
    await  widget.model.fetchUsers();
  await  widget. model.chatList( false);

  }
  @override
  void initState()  {
    fetchuser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
        return  ScopedModelDescendant<InternationalModel>(builder: (context,child,model) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RefreshIndicator(onRefresh: ()async =>await model.fetchUsers(),
                  backgroundColor: Colors.yellow,
                  child: model.ordersChatList.length == 0 ? Center(
                      child: Text('No Chats Found !')):model.isLoading?
                  Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.yellow,
                    ),
                  ): ListView.builder(
                    itemBuilder: (context, index)  => userBuilder(context, index, model), itemCount: model.ordersChatList.length,
                  )),
            ),
          );
        });

  }

  Widget userBuilder(context,int index,InternationalModel model){

     model.getuserForOrder(model.ordersChatList[index].tripUserEmail);
    return ListTile(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
            IChat(offer: model.ordersChatList[index],name:'${model.userOrder.firstname+' '+ model.userOrder.lastname}',))).then((_){
          fetchuser();
        });
      },
      leading: CircleAvatar(child: Icon(Icons.person),
        backgroundColor: Colors.yellowAccent,),
      title: Text('${model.userOrder.firstname+' '+model.userOrder.lastname}'),
    );

  }
}
