import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:insomnia_keeper_flutter/misc/animated_gradient_bg.dart';
import 'package:insomnia_keeper_flutter/misc/price.dart';
import 'package:insomnia_keeper_flutter/widgets/analytics_screen.dart';
import 'package:insomnia_keeper_flutter/widgets/coin_grid_preview.dart';
import 'package:insomnia_keeper_flutter/widgets/coin_horizontal_preview.dart';
import 'package:insomnia_keeper_flutter/widgets/coin_screen.dart';
import 'package:insomnia_keeper_flutter/widgets/coin_preview.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../misc/format.dart';
import '../misc/rem.dart';

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
      body: Background(
        child: CustomScrollView(
          slivers: <Widget>[
            // SliverAppBar(
            //   automaticallyImplyLeading: false, // this will hide Drawer hamburger icon
            //   pinned: false,
            //   expandedHeight: MediaQuery.of(context).size.height * 0.2,
            //   flexibleSpace: FlexibleSpaceBar(
            //     title: Container(
            //       child: Title,
            //     ),
            //     centerTitle: true,
            //   ),
            // ),
            // SliverToBoxAdapter(
            //   child: Container(
            //     height: MediaQuery.of(context).size.height * 0.15,
            //     child: ListView.builder(
            //         scrollDirection: Axis.horizontal,
            //         itemCount: coins.length,
            //         itemBuilder: (context, index){
            //           MockCoin mockCoin = coins[index];
            //           return CoinHorizontal(
            //               title: mockCoin.title,
            //               amount: mockCoin.amount,
            //               percentChange: mockCoin.percentChange,
            //               coinsAmount: mockCoin.coinsAmount
            //           );
            //         }
            //     ),
            //   ),
            // ),
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

