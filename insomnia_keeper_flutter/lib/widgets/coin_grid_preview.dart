import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../misc/format.dart';
import '../misc/rem.dart';
import 'coin_screen.dart';

class CoinGrid extends HookWidget{
  final String title;
  final double amount;
  final double percentChange;
  final double coinsAmount;

  const CoinGrid({
    Key? key,
    required this.title,
    required this.amount,
    required this.percentChange,
    required this.coinsAmount
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CoinScreen(
                title: title,
                amount: amount,
                percentChange: percentChange,
                amountCoins: coinsAmount
            )),
          );
        },
        style: ElevatedButton.styleFrom(
          primary: theme.cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: rem(2)),
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
                  fontSize: rem(4)
              ),
            ),
            Text(
              "${Format.toCompactCurrency(amount*coinsAmount)}",
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: rem(5)
              ),
            )
          ],
        ),
    );
    // return Container(
    //   width: MediaQuery.of(context).size.width * 0.1,
    //   height: MediaQuery.of(context).size.height * 0.1,
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(10),
    //     boxShadow: const [
    //       BoxShadow(
    //         spreadRadius: 2,
    //         blurRadius: 3,
    //         offset: Offset(1, 2),
    //       ),
    //     ],
    //   ),
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       Padding(
    //         padding: EdgeInsets.symmetric(vertical: rem(2)),
    //         child: Container(
    //           width: rem(10),
    //           height: rem(10),
    //           decoration: BoxDecoration(
    //             shape: BoxShape.circle,
    //             border: Border.all(width: rem(1), color: Colors.white),
    //           ),
    //         ),
    //       ),
    //       Text(
    //         "${Format.toCompactCurrency(amount*coinsAmount)}",
    //         style: TextStyle(
    //           fontWeight: FontWeight.w300,
    //           fontSize: rem(5)
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }

}