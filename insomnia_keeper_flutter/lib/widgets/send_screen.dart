import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:insomnia_keeper_flutter/misc/neumorphism_button.dart';
import 'package:insomnia_keeper_flutter/misc/rem.dart';

class Send extends HookWidget{
  final String coinname;
  final double amountCoins;

  Send({required this.coinname, required this.amountCoins});

  final TextStyle _textFieldStyle = TextStyle(fontWeight: FontWeight.w300, fontSize: 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30,),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                decoration: InputDecoration(
                    icon: Icon(Icons.monetization_on),
                    hintText: "Enter amount",
                    hintStyle: _textFieldStyle
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                decoration: InputDecoration(
                    icon: Icon(Icons.wallet_travel_rounded),
                    hintText: "Enter wallet",
                    hintStyle: _textFieldStyle
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: rem(5)),
              child: NeumorphismButton(
                width: MediaQuery.of(context).size.width * 0.75,
                onPressed: () {  },
                child: const Text(
                  "Send",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 20
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}