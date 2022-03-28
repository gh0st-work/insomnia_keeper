import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:insomnia_keeper_flutter/misc/neumorphism_button.dart';
import 'package:insomnia_keeper_flutter/widgets/sell_screen.dart';

import '../misc/dropdown.dart';
import '../misc/rem.dart';

class SellSettings extends HookWidget{
  final coinname;
  final coinsAmount;

  // List of items in our dropdown menu
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  var coins = [
    'BTC',
    'TON',
    'ETH',
    'DOGE'
  ];

  SellSettings({this.coinname = "", this.coinsAmount = 0});

  @override
  Widget build(BuildContext context) {
    final selectedPayment = useTextEditingController();
    final payment = useState("");
    final selectedCoin = useTextEditingController();
    final coin = useState(coinname);
    return Container(
        alignment: Alignment.center,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: rem(5), vertical: rem(6)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            Text(
                              "Give",
                              style: TextStyle(
                                  fontSize: rem(10),
                                  fontWeight: FontWeight.w300
                              ),
                            ),
                            DropDownField(
                              controller: selectedCoin,
                              hintText: coinname != "" ? coin.value : "Select any coin",
                              enabled: true,
                              required: true,
                              strict: false,
                              items: coins,
                              onValueChanged: (value){
                                coin.value = value;
                              },
                            )
                          ],
                        )
                    ),
                    SizedBox(height: 30),
                    Text(
                      "Get",
                      style: TextStyle(
                          fontSize: rem(10),
                          fontWeight: FontWeight.w300
                      ),
                    ),
                    DropDownField(
                      controller: selectedPayment,
                      hintText: "Select any payment",
                      enabled: true,
                      required: true,
                      strict: false,
                      items: items,
                      onValueChanged: (value){
                        payment.value = value;
                      },
                    )
                  ],
                ),
                SizedBox(height: rem(18),),
                NeumorphismButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SellScreen(coinName: coin.value, payment: payment.value, coinsBalance: coinsAmount,)),
                    );
                  },
                  child: const Text(
                    "SELL",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 20
                    ),
                  ),
                )
              ],
            )
        )
    );
  }

}