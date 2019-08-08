import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_app/bloc/cartListBloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:food_app/main.dart';
import 'package:food_app/model/foodItem.dart';
///////////////
class Cart extends StatelessWidget {
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();

  @override
  Widget build(BuildContext context) {
    List<FoodItem> foodItems;
    return StreamBuilder(
      stream: bloc.listStream,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          foodItems = snapshot.data;
          return Scaffold(
            body: SafeArea(
              child: Container(
                child: CartBody(foodItems),
              ),
            ),
            bottomNavigationBar: BottomBar(foodItems: foodItems),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class BottomBar extends StatelessWidget {
  final List<FoodItem> foodItems;
  BottomBar({@required this.foodItems});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 35, bottom: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          totalAmount(foodItems),
          Divider(
            height: 1,
            color: Colors.grey[700],
          ),
          persons(),
          nextButtonBar(),
        ],
      ),
    );
  }
}

Container nextButtonBar()
{
  return Container(
    margin: EdgeInsets.only( right: 25),
    padding: EdgeInsets.all(25),
    decoration: BoxDecoration(
      color: Color(0xfffeb324),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("15-25 min", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
        Text("Next", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16))
      ],
    ),
  );
}

Container persons() {
  return Container(
    margin: EdgeInsets.only(right: 10),
    padding: EdgeInsets.symmetric(vertical: 30),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("Persons",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        CustomPersonWidget(),
      ],
    ),
  );
}

Container totalAmount(List<FoodItem> foodItem) {
  return Container(
    margin: EdgeInsets.only(right: 10),
    padding: EdgeInsets.all(25),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("Total: ",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300)),
        Text(
          "\$${returnTotalAmount(foodItem)}",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
      ],
    ),
  );
}

String returnTotalAmount(List<FoodItem> foodItems) {
  double totalAmount = 0.0;
  for (int i = 0; i < foodItems.length; ++i) {
    totalAmount = totalAmount + foodItems[i].price * foodItems[i].quantity;
  }

  return totalAmount.toStringAsFixed(2);
}

class CustomPersonWidget extends StatefulWidget {
  @override
  _CustomPersonWidgetState createState() => _CustomPersonWidgetState();
}

class _CustomPersonWidgetState extends State<CustomPersonWidget> {
  int noOffPersons = 1;
  double _buttonwidth = 30;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 30),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300], width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(vertical: 5),
      width: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            width: _buttonwidth,
            height: _buttonwidth,
            child: FlatButton(
              child: Text("-",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
                  onPressed: () {
                    setState(() {
                      if(noOffPersons > 1)
                      {
                        noOffPersons --;
                      }
                    });
                  },
            ),
          ),
          Text(noOffPersons.toString(), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
          SizedBox(
            width: _buttonwidth,
            height: _buttonwidth,
            child: FlatButton(
              child: Text("+",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
                  onPressed: () {
                    setState(() {
                        noOffPersons ++;
                    });
                  },
            ),
          ),
        ],
      ),
    );
  }
}

class CartBody extends StatelessWidget {
  final List<FoodItem> foodItems;
  CartBody(this.foodItems);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(35, 40, 25, 0),
      child: Column(
        children: <Widget>[
          CustomAppBar(),
          title(),
          Expanded(
            flex: 1,
            child: foodItems.length > 0 ? foodItemList() : noItemContainer(),
          ),
        ],
      ),
    );
  }

  Container noItemContainer() {
    return Container(
      child: Center(
        child: Text("No more item left in the cart",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.grey[500])),
      ),
    );
  }

  ListView foodItemList() {
    return ListView.builder(
      itemCount: foodItems.length,
      itemBuilder: (builder, index) {
        return CartListItem(foodItem: foodItems[index]);
      },
    );
  }
}

Widget title() {
  return Padding(
      padding: EdgeInsets.symmetric(vertical: 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("My",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 35)),
              Text(
                "Order",
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 35),
              )
            ],
          ),
        ],
      ));
}

class CartListItem extends StatelessWidget {
  final FoodItem foodItem;

  CartListItem({@required this.foodItem});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      child: ItemContent(foodItem: foodItem),
    );
  }
}

class ItemContent extends StatelessWidget {
  final FoodItem foodItem;
  ItemContent({@required this.foodItem});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(foodItem.imgUrl,
                fit: BoxFit.fitHeight, height: 55, width: 80),
          ),
          RichText(
            text: TextSpan(
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
                children: [
                  TextSpan(text: foodItem.quantity.toString()),
                  TextSpan(text: "x"),
                  TextSpan(text: foodItem.title)
                ]),
          ),
          Text(
            "\$${foodItem.quantity * foodItem.price}",
            style: TextStyle(
                color: Colors.grey[300],
                fontWeight: FontWeight.w600,
                fontSize: 16),
          )
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(5),
          child: GestureDetector(
            child: Icon(
              CupertinoIcons.back,
              size: 30,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        GestureDetector(
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Icon(CupertinoIcons.delete, size: 30),
          ),
          onTap: () {},
        )
      ],
    );
  }
}
