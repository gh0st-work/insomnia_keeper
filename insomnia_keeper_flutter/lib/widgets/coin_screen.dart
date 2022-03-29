import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insomnia_keeper_flutter/misc/animated_gradient_bg.dart';
import 'package:insomnia_keeper_flutter/misc/chart_filter.dart';
import 'package:insomnia_keeper_flutter/misc/price.dart';
import 'package:insomnia_keeper_flutter/misc/showbottomsheet.dart';
import 'package:insomnia_keeper_flutter/widgets/asset_price_chart.dart';
import 'package:insomnia_keeper_flutter/widgets/buy_settings.dart';
import 'package:insomnia_keeper_flutter/widgets/history_screen.dart';
import 'package:insomnia_keeper_flutter/widgets/receive_screen.dart';
import 'package:insomnia_keeper_flutter/widgets/sell_settings.dart';
import 'package:insomnia_keeper_flutter/widgets/send_screen.dart';

import '../misc/format.dart';
import '../misc/rem.dart';

class CoinScreen extends HookWidget{
  final String title;
  final double amount;
  final double amountCoins;
  final double percentChange;

  CoinScreen({
    required this.title,
    required this.amount,
    required this.amountCoins,
    required this.percentChange
  });

  Widget _buildPrice(){
    return Container(
      padding: EdgeInsets.all(rem(10)),
      child: Price(
        percentChange: percentChange,
        amount: Format.toAmount(amount),
        amountAllCoins: Format.toAmount(amountCoins),
      ),
    );
  }

  Widget _buildPriceChart(BuildContext context){
    final color = (percentChange > 0 ? Colors.greenAccent : Colors.redAccent);
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width * 0.95,
      child: PriceChart(lineColor: color),
    );
  }

  Widget _buildButtons(BuildContext context){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              icon: FaIcon(
                FontAwesomeIcons.cartPlus,
                size: rem(5),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 50),
                primary: percentChange > 0 ? Colors.red : Colors.green
              ),
              onPressed: (){
                showModalBottomSheet<void>(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context){
                      return ShowBottomSheet(
                          child: BuySettings(
                            coinname: title,
                          )
                      );
                    }
                );
              },
              label: const Text(
                'Buy',
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 20
                ),
              ),
              //child:
            ),
            ElevatedButton.icon(
              icon: FaIcon(
                FontAwesomeIcons.cartArrowDown,
                size: rem(5),
              ),
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 50),
                  primary: percentChange < 0 ? Colors.red : Colors.green
              ),
              onPressed: (){
                showModalBottomSheet<void>(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context){
                      return ShowBottomSheet(
                          child: SellSettings(
                            coinname: title,
                            coinsAmount: amountCoins,
                          )
                      );
                    }
                  );
              },
              label: const Text(
                'Sell',
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 20
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              icon: FaIcon(
                FontAwesomeIcons.peopleArrowsLeftRight,
                size: rem(5),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 50),
              ),
              onPressed: (){
                showModalBottomSheet<void>(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context){
                      return ShowBottomSheet(child: Send(coinname: title,));
                    }
                );
              },
              label: const Text(
                'Send',
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 20
                ),
              ),
            ),
            ElevatedButton.icon(
              icon: FaIcon(
                FontAwesomeIcons.inbox,
                size: rem(5),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 50),
              ),
              onPressed: (){
                showModalBottomSheet<void>(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context){
                        return ShowBottomSheet(child: Recieve(coinname: title,),);
                    }
                  );
                },
              label: const Text(
                'Receive',
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 20
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ScrollController _firstController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w300
          ),
        ),
        centerTitle: true,
      ),

      body: Background(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildPrice(),
                      Divider(),
                      _buildPriceChart(context),
                      ChartFilter(),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                _buildButtons(context),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text(
                    "History",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: rem(10)
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Scrollbar(
                    isAlwaysShown: true,
                    controller: _firstController,
                    child: History(historyType: "", coinName: title, isCoinPage: true,),
                  ),
                )
              ],
            ),
          ],
        ),
      )
    );
  }

}