import 'package:flutter/material.dart';
import 'package:hatly/scoped_model/international-model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'choices.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'international/ihome.dart';
import 'international/internationalChat/i_chat_list.dart';
import 'international/iorder.dart';
import 'international/isetting.dart';

class IIHome extends StatefulWidget {
  @override
  _IIHomeState createState() => _IIHomeState();
}

class _IIHomeState extends State<IIHome> {
  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant <InternationalModel>(builder: (BuildContext context,Widget child ,InternationalModel model) {
      return Scaffold(
//      appBar: AppBar(
//        leading: GestureDetector(
//          child: Icon(
//            Icons.arrow_back_ios,
//            color: Colors.black,
//          ),
//          onTap: () {
//            Navigator.pop(context);
//          },
//        ),
//        backgroundColor: Colors.white,
//        centerTitle: true,
//        title: Text(
//          'HATLY',
//          style: TextStyle(color: Colors.yellow, fontSize: 30),
//        ),
//      ),
        body: SizedBox.expand(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: <Widget>[
              IHome(model: model,),
              IOrder(),
              IChatList(),
              ISetting(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavyBar(
          backgroundColor: Colors.black,
          selectedIndex: _currentIndex,
          onItemSelected: (index) {
            setState(() => _currentIndex = index);
            _pageController.jumpToPage(index);
          },
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
                activeColor: Colors.yellow,
                title: Text('Home'),
                icon: Icon(
                  Icons.home,
                  color: Colors.yellow,
                )),
            BottomNavyBarItem(
                activeColor: Colors.yellow,
                title: Text('Orders'),
                icon: Icon(
                  Icons.add_box,
                  color: Colors.yellow,
                )),
            BottomNavyBarItem(
                activeColor: Colors.yellow,
                title: Text('Chat'),
                icon: Icon(
                  Icons.chat,
                  color: Colors.yellow,
                )),
            BottomNavyBarItem(
                activeColor: Colors.yellow,
                title: Text('Setting'),
                icon: Icon(
                  Icons.settings,
                  color: Colors.yellow,
                )),
          ],
        ),
      );
    });
  }
}

