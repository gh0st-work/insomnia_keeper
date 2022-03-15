import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../data/ui/colors.dart';
import 'format.dart';

class Price extends HookWidget{
  late final String? title;
  late final Amount amount;
  late final Amount? amountAllCoins;
  late final double percentChange;
  late final bool? isTitle;

  Price({
    required this.amount,
    required this.percentChange,
    this.title,
    this.amountAllCoins,
    this.isTitle
  });

  Widget _buildTitle(BuildContext context){
    return title != null
        ? Container(
      padding: EdgeInsets.only(bottom: 4),
      child: Text(
        title!,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300
        ),
      ),
    )
        : Container();
  }

  Widget _buildAmountAllCoins(BuildContext context){
    return amountAllCoins != null ? Container(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: amountAllCoins?.whole.substring(1),
                  style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w300,
                      fontSize: 18
                  )
              ),
              TextSpan(
                  text: ".${amountAllCoins?.fractional}",
                  style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w300,
                      fontSize: 12
                  )
              )
            ]
        ),
      )
    )
        : Container();
  }

  Widget _buildAmount(BuildContext context){
    final color = (isTitle != null ? Colors.white : Colors.purple);
    return RichText(
      text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                text: amount.whole,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w300,
                    fontSize: 24
                )
            ),
            TextSpan(
                text: ".${amount.fractional}",
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w300,
                    fontSize: 16
                )
            )
          ]
      ),
    );
  }

  Widget _buildPercentage(){
    return Text(
      Format.toPercent(percentChange),
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w300,
        color: ColorFormatter.percentage(percentChange),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          _buildTitle(context),
          _buildAmount(context),
          SizedBox(height: 4,),
          _buildPercentage(),
          _buildAmountAllCoins(context)
        ],
      ),
    );
  }

}