import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:insomnia_keeper_flutter/misc/animated_gradient_bg.dart';
import 'package:insomnia_keeper_flutter/misc/price.dart';
import 'package:insomnia_keeper_flutter/widgets/analytics_screen.dart';
import 'package:insomnia_keeper_flutter/widgets/coin_grid_preview.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../misc/format.dart';

class MockCoin {
  String title;
  double amount;
  double percentChange;
  double coinsAmount;
  Color color;

  MockCoin(this.title, this.amount, this.percentChange, this.coinsAmount, this.color);
}

class WalletScreen extends HookWidget {

  @override
  Widget build(BuildContext context) {
     List<MockCoin> coins = [
       MockCoin('BTC', 100000.0, 23.1, 1258, Colors.red),
       MockCoin("TON", 20.5, -3.4, 11.5, Colors.blueAccent),
       MockCoin("ETH", 2000.0, 61.9, 12, Colors.pinkAccent),
       MockCoin("DOGE", 2000.0, 61.9, 12, Colors.indigo),
    ];

    return Scaffold(
      body: Background(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(height: 250,),
                    SfCircularChart(
                      series: <CircularSeries>[
                        DoughnutSeries<MockCoin, String>(
                          dataSource: coins,
                          xValueMapper: (MockCoin data, _) => data.title,
                          yValueMapper: (MockCoin data, _) => data.amount,
                          pointColorMapper: (MockCoin data, _) => data.color,
                          innerRadius: '90%',
                        )
                      ],
                    ),
                    Price(
                      amount: Format.toAmount(10.0),
                      percentChange: 10.0,
                      isTitle: true,
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Analytics()),
                        );
                      },
                      child: Container(height: 250,width: MediaQuery.of(context).size.width * 0.8, color: Colors.transparent,),
                    ),
                  ],
                )
            ),
            const SliverToBoxAdapter(
              child: Center(
                child: Text(
                  "Portfolio",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 24
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    MockCoin mockCoin = coins[index];
                    return CoinGrid(amount: mockCoin.amount, coinsAmount: mockCoin.coinsAmount, percentChange: mockCoin.percentChange, title: mockCoin.title,);
                  },
                  childCount: coins.length,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

