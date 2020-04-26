import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hatly/constants/decoration.dart';
import 'package:hatly/models/offers.dart';


class ChatSteps extends StatefulWidget {
Offer offer;

ChatSteps(this.offer);

@override
  _ChatStepsState createState() => _ChatStepsState();
}

class _ChatStepsState extends State<ChatSteps> {
  int _currentStep=0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Container(
          decoration: backgroundImage,
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(child:  Text('Price is : ',style: TextStyle(color: Colors.green,fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),),
                    Row(crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,

                      children: <Widget>[
                        Container(child:  Text('${widget.offer.price}',style: TextStyle(color: Colors.green,fontSize: 50,fontWeight: FontWeight.bold),),),
                        Container(child:  Text(' \$',style: TextStyle(color: Colors.green,fontSize: 25,fontWeight: FontWeight.bold)),),
                      ],
                    ),
                  ],
                ),
                Stepper(
                   steps:Stepss(),
                   currentStep: _currentStep,
                   onStepContinue: (){
                     if(_currentStep<Stepss().length-1)
                     setState(() {
                       _currentStep=_currentStep+1;
                     });
                   },
                   onStepCancel: (){
                     if(_currentStep>0)
                       setState(() {
                         _currentStep=_currentStep-1;
                       });
                   },
                 ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List <Step> Stepss() {
    return [
      Step(
          isActive: _currentStep >= 0,
          title: Text('enter credit card '),
          content: Container(
            child: Column(
              children: <Widget>[
                TextField(decoration: InputDecoration(hintText: 'Card Holder Name '),),
                TextField(decoration: InputDecoration(hintText: '**** **** **** ****'),),
                Row(
                  children: <Widget>[
                    Expanded(child: TextField(decoration: InputDecoration(hintText: 'MM\\YY '),)),
                    SizedBox(width: 20,),
                    Expanded(child: TextField(decoration: InputDecoration(hintText: 'CMV'),)),
                  ],
                ),
              ],
            ),
          ),subtitle: Text('note : HATLY will take 3% from this price')
      ),
    Step(
      title: Text('order is recieved '),
      subtitle: Text(''),
      content: Container(),

      isActive: _currentStep>=1,
    ),
      Step(
      title: Text('Deal is Done'),
      subtitle: ClipRect( child:SingleChildScrollView(
        child:
          Text('when you recieve your Order give \n this this QR code to the user '),
        scrollDirection: Axis.horizontal,
      )),
      content: TextField()
      ,isActive: _currentStep>=2,
        state: StepState.complete
    ),
    ];
  }
}
