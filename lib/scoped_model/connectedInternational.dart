import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatly/i_screens/choices.dart';
import 'package:hatly/models/offers.dart';
import 'package:hatly/models/order.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hatly/models/trip.dart';
import 'package:hatly/models/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:hatly/models/authmode.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

mixin ConnectedInternational on Model {
  User _auth;

  List<Order> _orders = [];
  int noa = 0;
  String selectorderid;
  List<Order> _availableorders = [];
  List<Order> offersSentToOrders = [];
  List<Order> availableAnotherorders = [];
  Order dataOfOrder;

  List<Trip> availabletrips = [];
  Trip trip = Trip(countryfrom: '', countryto: '', weight: 0, datetime: '');

  List<Offer> alloffers = [];
  List<Offer> fetchedalloffers = [];
  List<Offer> fetchedMyoffers = [];
  List<Offer> deals = [];
  int auctions = 0;
  double lowestAuction;


  List<User> allUsers = [];
  List<Offer> tripChatList = [];
  List<Offer> ordersChatList = [];


  bool _isLoading = false;
  int orderIndex;
  int _index;
}

mixin OrdersModel on ConnectedInternational, Offers {
  Order orderData;

  void index(int index) {
    _index = index;
  }

  get getindex {
    return _index;
  }

  List<Order> get allOrders {
    return List.from(_orders);
  }

//  List<Order> availableAnotherOrderss(){
//    return availableAnotherorders;
//  }

  Order get selectedOrder {
    return _orders[_index];
  }

  Order returnorder(String id) {
    Order o = contain.firstWhere((Order order) {
      return order.id == id;
    });
    print('aaaaa ${o.name}');
    return o;
  }

  void orderid(String id) {
    final ord = _orders.firstWhere((Order order) {
      return order.id == selectedOrder.id;
    });
    selectorderid = ord.id;
    if (selectorderid != null) notifyListeners();
  }

  Future<bool> addorder({
    String name,
    String countryfrom,
    String countryto,
    double price,
    double weight,
    int quantity,
    String category,
    String dateTime,
  }) async {
    noa = 0;
    _isLoading = true;
    Map<String, dynamic> orderdata = {
      'name': name,
      'countryfrom': countryfrom,
      'countryto': countryto,
      'weight': weight,
      'price': price,
      'quantity': quantity,
      'category': category,
      'datetime': dateTime,
      'noa': noa,
      'userEmail': _auth.email,
      'userID': _auth.id
    };
    try {
      http.Response response = await http.post(
          'https://hatly-k.firebaseio.com/InternationalOrders.json?auth=${_auth.token}',
          body: json.encode(orderdata));

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      Map<String, dynamic> responceorder = json.decode(response.body);
      print('response body of orders is $responceorder');
      Order value = Order(
          id: responceorder['name'],
          name: name,
          numberOfAuctions: noa,
          countryfrom: countryfrom,
          category: category,
          countryto: countryto,
          price: price,
          userEmail: _auth.email,
          userID: _auth.id,
          quantity: quantity,
          weight: weight,
          dateTime: dateTime);
      _orders.add(value);
      print(_orders.length);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void deleteatindex({int index}) {
    _availableorders.removeAt(index);
  }

  List<Order> get availableorders {
    return _availableorders;
  }

  submitData(Order ord, double price, Offer offer) async {
//     await fetchorders(true);
    await updateAuctionsInOrder(ord, price);
    await updateOffer(offer);
    fetchoffers();
  }

  List<Order> contain = [];

  Future<Null> availablleorders() async {
    fetchedMyoffers.clear();
    _availableorders.clear();
    _orders.clear();
    await fetchoffers();
    notifyListeners();
    _isLoading = true;
    return http
        .get(
            'https://hatly-k.firebaseio.com/InternationalOrders.json?auth=${_auth.token}')
        .then((http.Response response) {
      print(response.body);
      final List<Order> fetchedAllorders = [];
      final Map<String, dynamic> fetchedorders = json.decode(response.body);
      fetchedorders.forEach((String id, dynamic values) {
        final Order order = Order(
            id: id,
            name: values['name'],
            price: values['price'],
            numberOfAuctions: values['noa'],
            quantity: values['quantity'],
            category: values['category'],
            countryfrom: values['countryfrom'],
            countryto: values['countryto'],
            lowestAuction: values['LowestAuctionPrice'],
            dateTime: values['datetime'],
            weight: values['weight'],
            userID: values['userID'],
            userEmail: values['userEmail']);
        fetchedAllorders.add(order);
        contain.add(order);
        if (order.countryfrom == trip.countryfrom &&
            order.countryto == trip.countryto &&
            order.userEmail != trip.userEmail) _availableorders.add(order);
        if (fetchedMyoffers.length > 0) {
          fetchedMyoffers.forEach((Offer offer) {
            if (offer.orderid == order.id) _availableorders.remove(order);
          });
        }
        notifyListeners();
      });
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<Null> fetchorders(bool onlyForUser, {bool search = false}) async {
    contain.clear();
    notifyListeners();
    _isLoading = true;
    return http
        .get(
            'https://hatly-k.firebaseio.com/InternationalOrders.json?auth=${_auth.token}')
        .then((http.Response response) async {
      print(response.body);
      final List<Order> fetchedallorders = [];
      final Map<String, dynamic> fetchedorders = json.decode(response.body);
      if (response.body != null) {
        fetchedorders.forEach((String id, dynamic values) {
          final Order order = Order(
              id: id,
              name: values['name'],
              price: values['price'],
              quantity: values['quantity'],
              category: values['category'],
              countryfrom: values['countryfrom'],
              countryto: values['countryto'],
              lowestAuction: values['LowestAuctionPrice'],
              dateTime: values['datetime'],
              weight: values['weight'],
              userID: values['userID'],
              numberOfAuctions: values['noa'],
              userEmail: values['userEmail']);
          fetchedallorders.add(order);
          notifyListeners();
        });
        contain = fetchedallorders;
        print('selected or id is $selectorderid');
        deals = fetchedalloffers.where((Offer offer) {
          return offer.orderid == selectorderid && offer.accept != false;
        }).toList();
        _orders = onlyForUser
            ? fetchedallorders.where((Order order) {
                return order.userID == _auth.id;
              }).toList()
            : fetchedallorders;
        _isLoading = false;
        notifyListeners();
      } else {
        _orders = [];
      }
    });
  }

  Future<Null> updateorder(
      {String name,
      String countryfrom,
      String countryto,
      double price,
      int noa,
      double weight,
      int quantity,
      String category,
      String dateTime}) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> updatedata = {
      'id': selectedOrder.id,
      'name': name,
      'countryfrom': countryfrom,
      'countryto': countryto,
      'weight': weight,
      'price': price,
      'quantity': quantity,
      'noa': selectedOrder.numberOfAuctions,
      'LowestAuctionPrice': selectedOrder.lowestAuction,
      'category': category,
      'datetime': '$dateTime',
      'userEmail': selectedOrder.userEmail,
      'userID': selectedOrder.userID
    };
    return http
        .put(
            'https://hatly-k.firebaseio.com/InternationalOrders/${selectedOrder.id}.json?auth=${_auth.token}',
            body: json.encode(updatedata))
        .then((http.Response response) {
      _isLoading = false;
      print('selected order id ${selectedOrder.id}');
      Order product = Order(
          id: selectedOrder.id,
          name: name,
          countryto: countryto,
          category: category,
          countryfrom: countryfrom,
          price: price,
          quantity: quantity,
          weight: weight,
          numberOfAuctions: selectedOrder.numberOfAuctions,
          lowestAuction: selectedOrder.lowestAuction,
          dateTime: dateTime,
          userEmail: selectedOrder.userEmail,
          userID: selectedOrder.userID);
      _orders[_index] = product;
      notifyListeners();
    });
  }

  updateAuctionsInOrder(Order order, double priceTaken) {
    print('trueeeee ${order.id}');
    _isLoading = true;
    int indexoforder = contain.indexWhere((ordd) {
      return ordd.id == order.id;
    });

    auctions = order.numberOfAuctions;
    lowestAuction = order.lowestAuction;
    if (lowestAuction != null)
      lowestAuction = priceTaken <= lowestAuction ? priceTaken : lowestAuction;
    else
      lowestAuction = priceTaken;
    final Map<String, dynamic> updatedata = {
      'id': order.id,
      'name': order.name,
      'countryfrom': order.countryfrom,
      'countryto': order.countryto,
      'weight': order.weight,
      'price': order.price,
      'quantity': order.quantity,
      'noa': auctions + 1,
      'LowestAuctionPrice': lowestAuction,
      'category': order.category,
      'datetime': '${order.dateTime}',
      'userEmail': order.userEmail,
      'userID': order.userID
    };
    return http
        .put(
            'https://hatly-k.firebaseio.com/InternationalOrders/${order.id}.json?auth=${_auth.token}',
            body: json.encode(updatedata))
        .then((http.Response response) {
      _isLoading = false;
      Order product = Order(
          id: order.id,
          name: order.name,
          countryto: order.countryto,
          category: order.category,
          countryfrom: order.countryfrom,
          price: order.price,
          quantity: order.quantity,
          weight: order.weight,
          numberOfAuctions: auctions,
          lowestAuction: lowestAuction,
          dateTime: order.dateTime,
          userEmail: order.userEmail,
          userID: order.userID);
      _isLoading = true;
      notifyListeners();
      print('trueeeee 4  ${_orders.length}');
      contain[indexoforder] = product;
      print('trueeeee 5 ${_orders.length}');
      notifyListeners();
    });
  }

  builddeals() async {
    await fetchoffers();
  }


}

mixin TripModel on ConnectedInternational {
  Trip get tripupdate {
    return trip;
  }

  List<Trip> alltrips = [];

  Future<bool> addTrip(
      {String countryfrom,
      String countryto,
      String datetime,
      double weight}) async {
    _isLoading = true;

    Map<String, dynamic> tripdata = {
      'countryto': countryto,
      'countryfrom': countryfrom,
      'weight': weight,
      'datetime': datetime,
      'userEmail': _auth.email,
      'userID': _auth.id
    };
    try {
      http.Response response;

      response = await http.post(
          'https://hatly-k.firebaseio.com/InternationalTrips.json?auth=${_auth.token}',
          body: json.encode(tripdata));
      print('status code is ${response.statusCode}');
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      print(' body is ${response.body}');
      Map<String, dynamic> responcetrip = json.decode(response.body);
      print(' name is $responcetrip');
      trip = Trip(
          id: responcetrip['name'],
          countryfrom: countryfrom,
          countryto: countryto,
          weight: weight,
          datetime: datetime,
          userEmail: _auth.email,
          userID: _auth.id);
      print(trip);
      notifyListeners();
      _isLoading = false;
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<Null> updatetrip(
      {String countryfrom,
      String countryto,
      String datetime,
      double weight}) async {
    _isLoading = true;

    Map<String, dynamic> tripdata = {
      'id': trip.id,
      'countryto': countryto,
      'countryfrom': countryfrom,
      'weight': weight,
      'datetime': datetime,
      'userEmail': _auth.email,
      'userID': _auth.id
    };
    try {
      http.Response response;
      response = await http.put(
          'https://hatly-k.firebaseio.com/InternationalTrips/${trip.id}.json?auth=${_auth.token}',
          body: json.encode(tripdata));
      print('status code is ${response.statusCode}');
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      print(' body is ${response.body}');
      Map<String, dynamic> responcetrip = json.decode(response.body);
      print(' name is $responcetrip');
      trip = Trip(
          id: trip.id,
          countryfrom: countryfrom,
          countryto: countryto,
          weight: weight,
          datetime: datetime,
          userEmail: trip.userEmail,
          userID: trip.userID);
      print(trip);
      notifyListeners();
      _isLoading = false;
      return;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return;
    }
  }

  Future<Null> fetchtrip() {
    _isLoading = true;
    alltrips = [];
    return http
        .get(
            'https://hatly-k.firebaseio.com/InternationalTrips.json?auth=${_auth.token}')
        .then((http.Response response) {
      Map<String, dynamic> tripdecode = json.decode(response.body);
      print('tripcode is  $tripdecode');
      tripdecode.forEach((String id, dynamic value) {
        final Trip t = Trip(
            id: id,
            countryto: value['countryto'],
            countryfrom: value['countryfrom'],
            weight: value['weight'],
            datetime: value['datetime'],
            userID: value['userID'],
            userEmail: value['userEmail']);
        if (t.userEmail == _auth.email) trip = t;
        alltrips.add(t);
        notifyListeners();
//        trip = t;
      });
      availabletrips = alltrips.where((Trip trip) {
        return _orders[orderIndex].countryfrom == trip.countryfrom &&
            _orders[orderIndex].countryto == trip.countryto &&
            _auth.email != trip.userEmail;
      }).toList();
      notifyListeners();
      trip = alltrips.firstWhere((Trip trip) {
        return trip.id == _auth.id;
//          trip=t;
      });
      _isLoading = false;
      notifyListeners();
    });
  }

  bool isValid() {
    if (trip.countryfrom == null || trip.countryfrom == '')
      return false;
    else if (trip.countryto == null || trip.countryto == '')
      return false;
    else if (trip.weight == null || trip.weight == 0)
      return false;
    else if (trip.datetime == null) return false;
    notifyListeners();
    return true;
  }

  buildInititrip() {
    fetchtrip();
  }
}
mixin Offers on ConnectedInternational {
  Future<bool> addoffers(
      {String orderName,
      String orderid,
      String tripid,
      double price,
      String orderuserEmail,
      String tripuserEmail}) async {
    String datetime = DateTime.now().toIso8601String();
    Map<String, dynamic> value = {
      'orderName': orderName,
      'orderID': orderid,
      "tripID": trip.id,
      'price': price,
      'orderUserEmail': _availableorders.firstWhere((Order order) {
        return order.id == orderid;
      }).userEmail,
      'tripUserEmail': trip.userEmail,
      'datetime': datetime,
    };
    try {
      _isLoading = true;
      http.Response response = await http.post(
          'https://hatly-k.firebaseio.com/InternationalOffers.json?auth=${_auth.token}',
          body: jsonEncode(value));
      Map<String, dynamic> getdata = jsonDecode(response.body);
      print(' this is a offer $getdata');
      Offer offer = Offer(
          id: getdata['name'],
          orderName: orderName,
          orderid: orderid,
          orderUserEmail: orderuserEmail,
          price: price,
          tripid: tripid,
          tripUserEmail: tripuserEmail,
          datetime: datetime);
      alloffers.add(offer);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }




  Future chatList(bool asTrip) async {
    fetchedMyoffers.clear();
    fetchedalloffers=[];
    await fetchoffers();
    print('offers num is ${fetchedalloffers.length}');
    _isLoading = true;
  if(asTrip) {
    tripChatList = fetchedMyoffers.where((Offer offer) {
      return offer.accept == true && offer.tripUserEmail == _auth.email;
    }).toList();
  }
  else
    {ordersChatList = fetchedalloffers.where((Offer offer) {
            return offer.accept == true && offer.orderUserEmail == _auth.email;
          }).toList();
    }
    print('trip num is ${fetchedMyoffers}');
    print('order num is ${fetchedMyoffers.length}');

    _isLoading = false;
    notifyListeners();
  }

  Future<Null> fetchoffers() async {
    fetchedalloffers.clear();
    fetchedMyoffers.clear();
    alloffers.clear();
    _isLoading = true;
    http.Response response = await http.get(
        'https://hatly-k.firebaseio.com/InternationalOffers.json?auth=${_auth.token}');
    print('response ${response.body}');
    if (response.statusCode == 200 && response.body != null) {
      print('responseeee ${response.body}');
      final Map<String, dynamic> fetchedOffers = json.decode(response.body);
      try {
        fetchedOffers.forEach((String id, dynamic values) {
          final Offer offer = Offer(
            id: id,
            price: values['price'],
            tripid: values['tripID'],
            orderName: values['orderName'],
            accept: values['accept'],
            orderid: values['orderID'],
            tripUserEmail: values['tripUserEmail'],
            orderUserEmail: values['orderUserEmail'],
            datetime: values['datetime'],
          );
          alloffers.add(offer);
          offer.tripid == trip.id && offer.tripUserEmail == trip.userEmail
              ? fetchedMyoffers.add(offer)
              : fetchedalloffers.add(offer);
          _isLoading = false;
          notifyListeners();
        });
      } catch (e) {
        fetchedalloffers = [];
        fetchedMyoffers = [];
        _isLoading = false;
        notifyListeners();
      }
    } else {
      fetchedalloffers = [];
      fetchedMyoffers = [];
      _isLoading = false;
      notifyListeners();
    }
    print('number of   my offers  ${fetchedMyoffers.length}');
    print('number of   all offers  ${fetchedalloffers.length}');
    _isLoading = false;
    notifyListeners();
  }

  Future<Null> updateOffer(Offer offer, {bool accept}) async {
    int index = alloffers.indexWhere((Offer o) {
      return offer.id == o.id;
    });
    _isLoading = true;
    Map<String, dynamic> updatedata;
    if (accept == true || accept == false) {
      updatedata = {
        'orderName': offer.orderName,
        'orderID': offer.orderid,
        "tripID": offer.tripid,
        'price': offer.price,
        'orderUserEmail': offer.orderUserEmail,
        'tripUserEmail': offer.tripUserEmail,
        'datetime': offer.datetime,
        'accept': accept
      };
    } else if (accept == null) {
      updatedata = {
        'orderName': offer.orderName,
        'orderID': offer.orderid,
        "tripID": offer.tripid,
        'price': offer.price,
        'orderUserEmail': offer.orderUserEmail,
        'tripUserEmail': offer.tripUserEmail,
        'datetime': offer.datetime,
      };
    }
//    else if (accept == false) {
//      http.Response response = await http.delete(
//          'https://hatly-k.firebaseio.com/InternationalOffers/${offer.id}.json?auth=${_auth.token}');
//      alloffers.removeAt(index);
//      return;
//    }

    http.Response response = await http.put(
        'https://hatly-k.firebaseio.com/InternationalOffers/${offer.id}.json?auth=${_auth.token}',
        body: jsonEncode(updatedata));
    if (response.statusCode == 200) {
      Offer value = Offer(
          id: offer.id,
          orderName: offer.orderName,
          orderUserEmail: offer.orderUserEmail,
          orderid: offer.orderid,
          tripUserEmail: offer.tripUserEmail,
          tripid: offer.tripid,
          datetime: offer.datetime,
          price: offer.price,
          accept: accept);
      alloffers[index] = value;
      _isLoading = true;
      notifyListeners();
    }
  }

  void clearOffer() {
    _isLoading = true;
    offersSentToOrders.add(_availableorders[_index]);
    final id = _availableorders[_index].id;
    _availableorders.removeAt(_index);
    notifyListeners();
    http
        .delete(
            'https://hatly-k.firebaseio.com/InternationalOffers/${id}.json?auth=${_auth.token}')
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
    });
  }
}

mixin UserModel on ConnectedInternational {
  Timer authtimer;

  PublishSubject<bool> _userSubject = PublishSubject();

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  User get user {
    return _auth;
  }

  Future<Null> addUser(String FName, String LName, String number) async {
    _isLoading = true;
    Map<String, dynamic> signdata = {
      'id': _auth.id,
      'fname': FName,
      'lname': LName,
      'email': _auth.email,
      'phonenumber': number
    };
    return await http
        .put(
            'https://hatly-k.firebaseio.com/Users/${_auth.id}/.json?auth=${_auth.token}',
            body: jsonEncode(signdata))
        .then((http.Response response) {
      _isLoading = false;
      print(jsonDecode(response.body));
    });
  }



  Future<Null> fetchUsers() async {
    allUsers=[];
    try {
      _isLoading = true;
      http.Response response = await http.get(
          'https://hatly-k.firebaseio.com/Users/.json?auth=${_auth.token}');
      print('res is ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> userr = jsonDecode(response.body);
        userr.forEach((String id, dynamic value) {
           User user = User(
            id: id,
            firstname: value['fname'],
            lastname: value['lname'],
            email: value['email'],
            phonenumber: value['phonenumber'],
          );
          allUsers.add(user);
        });
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  User userOrder;
  User userTrip;

  getuserForTrip(String email){
    _isLoading=true;
    print('email is $email');
    userTrip= allUsers.firstWhere((User user){
      return user.email==email;
    });
    _isLoading=false;
    print('name is $email');

  }
  getuserForOrder(String email){
           _isLoading=true;
           print('emailllll is $email');
          userOrder= allUsers.firstWhere((User user){
        return user.email==email;
      });
          _isLoading=false;
           print('emaillll is $email');

         }


//   getUser(String email)async{
//   await fetchUsers();
//   return allUsers.firstWhere((User user){
//      return user.email==email;
//    });
//  }

  Future<Map<String, dynamic>> authMode(
      {String email,
      String password,
      AuthMode mode = AuthMode.Signin,
      String fname,
      String lname,
      String phonenumber}) async {
    http.Response response;
    Map<String, dynamic> responsedata;
    bool error = false;
    String message = 'please sign in';
    _isLoading = true;
    notifyListeners();
    Map<String, dynamic> authdata = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };
    if (mode == AuthMode.Signin) {
      response = await http.post(
          'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyATtJayQMjU8QD5c2jKfA4wTy4sI0KF13Q',
          body: json.encode(authdata),
          headers: {'content-type': 'application/json'});
      responsedata = json.decode(response.body);
    } else {
      response = await http.post(
          'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyATtJayQMjU8QD5c2jKfA4wTy4sI0KF13Q',
          body: json.encode(authdata),
          headers: {'content-type': 'application/json'});

      responsedata = json.decode(response.body);
    }
    print('response is $responsedata');
    if (responsedata.containsKey('idToken')) {
      message = 'Auth succeeded';
      error = true;
      print('succes');
      _auth = User(
        id: responsedata['localId'],
        email: email,
        token: responsedata['idToken'],
      );
      DateTime now = DateTime.now();
      DateTime expirytime =
          now.add(Duration(seconds: int.parse(responsedata['expiresIn'])));
      autologout(int.parse(responsedata['expiresIn']));
      print(fname);
      userSubject.add(true);
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('token', responsedata['idToken']);
      pref.setString('email', email);
      pref.setString('userId', responsedata['localId']);
      pref.setString('expiresTime', expirytime.toIso8601String());
    } else if (responsedata['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'this mail not found please signup ';
      error = false;
    } else if (responsedata['error']['message'] == 'INVALID_PASSWORD') {
      message = 'this password is wrong ';
      error = false;
    } else if (responsedata['error']['message'] == 'INVALID_EMAIL') {
      message = 'please enter email and password first ';
      error = false;
    } else if (responsedata['error']['message'] == 'USER_DISABLED') {
      message = 'this user is disabled ';
      error = false;
    } else if (responsedata['error']['message'] == 'EMAIL_EXISTS') {
      error = false;
      message = 'this email already exist';
    }
    _isLoading = false;
    notifyListeners();

    return {'succes': error, 'message': message};
  }

  void authentication() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('token');
    String expirytimestring = pref.getString('expiresTime');
    if (token != null) {
      DateTime now = DateTime.now();
      DateTime expirytimetime = DateTime.parse(expirytimestring);
      if (expirytimetime.isBefore(now)) {
        _auth = null;
        notifyListeners();
        return;
      }
      String email = pref.getString('email');
      String id = pref.getString('userId');
      String fname = pref.getString('fname');
      String lname = pref.getString('lname');
      int authlifespin = expirytimetime.difference(now).inSeconds;
      autologout(authlifespin);
      _auth = User(
          id: id,
          email: email,
          token: token,
          firstname: fname,
          lastname: lname);
      userSubject.add(true);
      notifyListeners();
    }
  }

  void signout() async {
    print('logout');
    _auth = null;
    authtimer.cancel();
    _isLoading = false;
    selectorderid = null;
    trip = Trip(countryfrom: '', countryto: '', weight: 0, datetime: '');
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('token');
    pref.remove('email');
    pref.remove('userId');
    notifyListeners();
  }

  autologout(int timer) {
    authtimer = Timer(Duration(days: timer * 2), () {
      signout();
      userSubject.add(false);
    });
  }
}
mixin UtilityModel on ConnectedInternational {
  get isLoading {
    return _isLoading;
  }
}

mixin Chatclass on ConnectedInternational {
  final _firestore = Firestore.instance;
  String id;
  FieldValue timestamp = FieldValue.serverTimestamp();

  void addMessage(String message, String sender, String offerID) async {
    id = offerID;
//    _firestore.collection('messages').document('$offerID').setData({'message':message,'sender':sender});
    _firestore
        .collection('$offerID')
        .add({'message': message, 'sender': sender, 'time': timestamp});
  }

  void getMesseges() async {
    var messeg = await _firestore.collection(id).snapshots();
    await for (var kk in messeg)
      for (var i in kk.documents) print(i.data['message']);
  }
}
