import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:insomnia_keeper_flutter/misc/animated_gradient_bg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../misc/format.dart';
import '../misc/price.dart';
import 'coin_horizontal_preview.dart';

class MockCoin {
  String title;
  double amount;
  double percentChange;
  double coinsAmount;
  Color color;

  MockCoin(this.title, this.amount, this.percentChange, this.coinsAmount, this.color);
}

class Analytics extends HookWidget{
  TooltipBehavior _tooltip = TooltipBehavior(enable: true);

  List<MockCoin> coins = [
    MockCoin('BTC', 100000.0, 23.1, 1258, Colors.red),
    MockCoin("TON", 20.5, -3.4, 11.5, Colors.blueAccent),
    MockCoin("ETH", 2000.0, 61.9, 12, Colors.pinkAccent),
    MockCoin("DOGE", 2000.0, 61.9, 12, Colors.indigo),
  ];

  Widget _buildCircleChart(){
    return Stack(
      children: [
        SfCircularChart(
          title: ChartTitle(text: "Portfolio analytics", textStyle: TextStyle(fontWeight: FontWeight.w300, fontSize: 24),),
          legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.scroll, textStyle: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),),
          tooltipBehavior: _tooltip,
          series: <CircularSeries>[
            DoughnutSeries<MockCoin, String>(
                dataSource: coins,
                xValueMapper: (MockCoin data, _) => data.title,
                yValueMapper: (MockCoin data, _) => data.amount,
                pointColorMapper: (MockCoin data, _) => data.color,
                innerRadius: '90%',
                enableTooltip: true
            )
          ],
        ),
      ],
    );
  }

  Widget _buildPriceCard(BuildContext context){
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(10)
      ),
      child: Price(
        amount: Format.toAmount(10.0),
        percentChange: 10.0,
        isTitle: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "@tag",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w300
          ),
        ),
        centerTitle: true,
      ),
      body: Background(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              sliver: SliverToBoxAdapter(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCircleChart(),
                    _buildPriceCard(context),
                  ],
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index){
                    MockCoin mockCoin = coins[index];
                    return Container(
                      height: 100,
                      width: 100,
                      child: CoinHorizontal(
                          title: mockCoin.title,
                          amount: mockCoin.amount,
                          percentChange: mockCoin.percentChange,
                          coinsAmount: mockCoin.coinsAmount
                      ),
                    );
                  },
                  childCount: coins.length,
                )
            )
          ],
        ),
      ),
    );
  }

}