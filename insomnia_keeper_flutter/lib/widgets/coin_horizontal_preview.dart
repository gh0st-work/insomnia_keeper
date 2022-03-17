import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../misc/rem.dart';
import 'asset_price_chart.dart';

class CoinHorizontal extends HookWidget{
  final String title;
  final double amount;
  final double percentChange;
  final double coinsAmount;

  const CoinHorizontal({
    Key? key,
    required this.title,
    required this.amount,
    required this.percentChange,
    required this.coinsAmount
  }) : super(key: key);

  Widget _buildTitleIcon(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //coin icon here
          Padding(
              padding: EdgeInsets.symmetric(vertical: rem(1)),
              child: Container(
                width: rem(10),
                height: rem(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: rem(1), color: Colors.white),
                ),
              ),
          ),
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: rem(5)
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceChart(BuildContext context){
    final color = (percentChange > 0 ? Colors.greenAccent : Colors.redAccent);
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        child: PriceChart(lineColor: color),
      ),
    );
  }

  Widget _buildPrice(BuildContext context){
    final color = (percentChange > 0 ? Colors.green : Colors.red);
    final icon = (percentChange > 0 ? Icons.arrow_upward : Icons.arrow_downward);
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Align(
        alignment: Alignment.bottomLeft,
        child:  Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "\$$amount",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: rem(6),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: rem(4),
                    color: color,
                  ),
                  Text(
                    "$percentChange%",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: rem(4),
                        color: color
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(1, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                _buildPriceChart(context),
                _buildPrice(context),
              ],
            ),
            _buildTitleIcon(context)
          ],
        ),
      ),
    );
  }

}