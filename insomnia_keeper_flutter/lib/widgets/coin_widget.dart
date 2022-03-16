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
  final double coinsAmount;

  const Coin({
    required this.title,
    required this.amount,
    required this.percentChange,
    required this.coinsAmount
  });
  
  Widget _buildCoinsAmount(){
    return Container(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        Format.toCompact(coinsAmount),
          style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 32
          )
      ),
    );
  }

  Widget _buildCoinTitle(){
    return Container(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
            text: title,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: rem(6),
            ),
          children: [
            TextSpan(
              text: "\nFull coin name here",
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: rem(4),
              ),
            )
          ]
        ),
      ),
    );
  }

  Widget _buildCoinStatus(){
    final color = (percentChange > 0 ? Colors.greenAccent : Colors.redAccent);
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${amount}\$",
            //"1111.11\$",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: rem(4),
            ),
          ),
          Text(
            "${percentChange}%",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: rem(4),
              color: color
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCoinInfo(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.45,
          height: MediaQuery.of(context).size.height * 0.12,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xffbfbbbb), width: rem(0.5))
            )
          ),
          child: _buildCoinTitle(),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.45,
          height: MediaQuery.of(context).size.height * 0.065,
          child: _buildCoinStatus(),
        )
      ],
    );
  }

  Widget _buildCoinIcon(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      child: Container(
        width: rem(14),
        height: rem(14),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: rem(1), color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildInWalletCoins(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildCoinsAmount(),
          Text(
            "${Format.toCompactCurrency(amount * coinsAmount)}",
            style: TextStyle(
              fontSize: rem(4),
              fontWeight: FontWeight.w300,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(rem(1)),
      width: MediaQuery.of(context).size.width * 0.95,
      height: MediaQuery.of(context).size.height * 0.2,
      decoration: BoxDecoration(
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
          _buildCoinIcon(context),
          _buildCoinInfo(context),
          _buildInWalletCoins(context)
        ],
      ),
    );
  }

}