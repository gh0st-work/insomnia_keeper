import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:insomnia_keeper_flutter/misc/price.dart';
import 'package:insomnia_keeper_flutter/widgets/coin_screen.dart';
import 'package:insomnia_keeper_flutter/widgets/coin_preview.dart';

import '../misc/format.dart';
import '../misc/rem.dart';

class MockCoin {
  String title;
  double amount;
  double percentChange;
  double coinsAmount;
  MockCoin(this.title, this.amount, this.percentChange, this.coinsAmount);
}

class WalletScreen extends HookWidget {

  @override
  Widget build(BuildContext context) {
     List<MockCoin> coins = [
       MockCoin('BTC', 100000.0, 23.1, 1258),
       MockCoin("TON", 20.5, -3.4, 11.5),
       MockCoin("ETH", 2000.0, 61.9, 12),
    ];
    const TextStyle optionStyle = TextStyle(fontSize: 26, fontWeight: FontWeight.bold);

    Widget Title = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.only(left: 10),
          height: MediaQuery.of(context).size.height * 0.1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Wallet",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 21,
                ),
              ),
              Text(
                "Hello, username!",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                ),
              )
            ],
          )
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.1,
          padding: EdgeInsets.only(right: 10, top: 5),
          child: Price(
            amount: Format.toAmount(10.0),//Format.toCompactCurrency(value)
            percentChange: 10.0,
            isTitle: true,
          ),
        )
      ],
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.height * 0.2,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                child: Title,
              ),
              centerTitle: true,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                MockCoin mockCoin = coins[index];
                return CoinPreview(
                  title: mockCoin.title,
                  amount: mockCoin.amount,
                  percentChange: mockCoin.percentChange,
                  coinsAmount: mockCoin.coinsAmount
                );
              },
              childCount: coins.length
            )
          )
        ],
      ),
    );
  }
}

