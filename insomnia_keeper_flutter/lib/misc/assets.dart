import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:insomnia_keeper_flutter/misc/rem.dart';

class Stats extends HookWidget{
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stat(title: "High", value: "Higher value"),//Format.currency.format(asset.price)
            Container(width: rem(10)),
            Stat(title: "Symbol", value: "Symbol"),//asset.symbol.toUpperCase()
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stat(title: "Low", value: "Lower value"),//Format.currency.format(asset.price)
            Container(width: rem(10)),
            Stat(title: "Rank", value: "Rank"),//asset.rank.toString()
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stat(
                title: "24h vol.",
                value: "24h value"),//Format.compactCurrency.format(asset.volume24h)
            Container(width: rem(10)),
            Stat(
                title: "Mkt cap",
                value: "Market cap"),//Format.compactCurrency.format(asset.marketCap)
          ],
        ),
      ],
    );
  }
}

class Stat extends HookWidget{
  final String title;
  final String value;

  Stat({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(bottom: rem(3), top: rem(3)),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.dividerColor,
              width: 1.0,
            ),
          ),
        ),
        child:
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
        ]),
      ),
    );
  }
}