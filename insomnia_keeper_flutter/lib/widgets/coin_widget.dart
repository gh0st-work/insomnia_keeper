import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:insomnia_keeper_flutter/misc/price.dart';
import 'package:insomnia_keeper_flutter/widgets/asset_price_chart.dart';

import '../misc/format.dart';
import '../misc/rem.dart';

class Coin extends HookWidget{
  final String title;
  final double amount;
  final double percentChange;
  final Amount coinsAmount;

  Coin({
    required this.title,
    required this.amount,
    required this.percentChange,
    required this.coinsAmount
  });

  Widget _buildCoinsAmount(){
    return Container(
        padding: const EdgeInsets.only(bottom: 4),
        child: RichText(
          text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text: coinsAmount.whole.substring(1),
                    style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w300,
                        fontSize: 18
                    )
                ),
                TextSpan(
                    text: ".${coinsAmount.fractional}",
                    style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w300,
                        fontSize: 12
                    )
                )
              ]
          ),
        )
    );
  }

  Widget _buildIconTitle(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //crypto icon here
          Container(
            width: rem(10),
            height: rem(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: rem(1), color: Colors.white),
            ),
          ),
          SizedBox(height: rem(2),),
          Text(
            title,
            style: TextStyle(
                color: Colors.purple[800],
                fontSize: rem(5),
              fontWeight: FontWeight.w300
            ),
          ),
          _buildCoinsAmount()
        ],
      ),
    );
  }

  Widget _buildCoinPrice(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Price(amount: Format.toAmount(amount), percentChange: percentChange,)
        ],
      ),
    );
  }

  Widget _buildPriceChart(BuildContext context){
    final color = (percentChange < 0 ? Colors.redAccent : Colors.greenAccent);
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      child: PriceChart(lineColor: color,),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(rem(1)),
      width: MediaQuery.of(context).size.width * 0.95,
      height: MediaQuery.of(context).size.height * 0.2,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        //border: Border.all(width: 2, color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
            offset: const Offset(1, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildIconTitle(context),
          _buildPriceChart(context),
          _buildCoinPrice(context)
        ],
      ),
    );
  }

}