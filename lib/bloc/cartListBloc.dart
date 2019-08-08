import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:food_app/bloc/provider.dart';
import 'package:food_app/model/foodItem.dart';
import 'package:rxdart/rxdart.dart';

class CartListBloc extends BlocBase {
  CartListBloc();
  var _listController = BehaviorSubject<List<FoodItem>>.seeded([]);
  CartProvider provider = CartProvider();
//output
  Stream<List<FoodItem>> get listStream => _listController.stream;
//input
  Sink<List<FoodItem>> get listSink => _listController.sink;

  addToList(FoodItem fooditem)
  {
    listSink.add(provider.addToList(fooditem));
  }

  removeFromList(FoodItem foodItem)
  {
    listSink.add(provider.removeFromList(foodItem));
  }

//dispose will be called automatically by closing its streams
  @override
  void dispose() {
    _listController.close();
    super.dispose();
  }
}
