import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:insomnia_keeper_flutter/misc/neumorphism_button.dart';

import '../misc/rem.dart';

class BuyDealScreen extends HookWidget{
  final coinName;
  final payment;
  final price;
  final priceFrom;
  final priceTo;
  final amount;
  final total;

  BuyDealScreen({
    required this.coinName,
    required this.payment,
    required this.price,
    required this.priceFrom,
    required this.priceTo,
    required this.amount,
    required this.total
  });

  final TextStyle _titleStyle = TextStyle(fontWeight: FontWeight.w300, fontSize: 18);
  final TextStyle _textFieldStyle = TextStyle(fontWeight: FontWeight.w300, fontSize: 20);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Text("Enter the data to exchange", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 22),),),
          Center(child: Text("$price $payment = $amount $coinName", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),),),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Give $payment", style: _titleStyle,),
              SizedBox(height: 10,),
              TextField(
                onChanged: (String value){},
                decoration: InputDecoration(
                  hintText: "$priceFrom - $priceTo",
                  hintStyle: _textFieldStyle
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("You get $coinName", style: _titleStyle,),
              SizedBox(height: 10,),
              TextField(
                onChanged: (String value){},
                decoration: InputDecoration(
                  hintText: "${double.parse(priceFrom)/double.parse(price)} - ${double.parse(priceTo)/double.parse(price)}",
                  hintStyle: _textFieldStyle
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Enter tag", style: _titleStyle,),
              SizedBox(height: 10,),
              TextField(
                onChanged: (String value){},
                decoration: InputDecoration(
                  //hintText: "$priceFrom - $priceTo",
                  // hintStyle: _textFieldStyle
                ),
              ),
            ],
          ),
          NeumorphismButton(
              child: Text(
                "BUY",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: rem(6)
                ),
              ),
              onPressed: (){}
          )
        ],
      ),
    );
  }
  
}