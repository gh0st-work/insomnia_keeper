import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insomnia_keeper_flutter/misc/assets.dart';
import 'package:insomnia_keeper_flutter/misc/chart_filter.dart';
import 'package:insomnia_keeper_flutter/misc/price.dart';
import 'package:insomnia_keeper_flutter/widgets/asset_price_chart.dart';
import 'package:insomnia_keeper_flutter/widgets/buy_settings.dart';
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

  List tradeButtons = [
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
      ),
      onPressed: (){},
      child: const Text(
        'Buy',
        style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 26
        ),
      ),
    ),
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
      ),
      onPressed: (){},
      child: const Text(
        'Sell',
        style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 26
        ),
      ),
    ),
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
      ),
      onPressed: (){},
      child: const Text(
        'Trade',
        style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 26
        ),
      ),
    ),
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
      ),
      onPressed: (){},
      child: const Text(
        'Make a deal',
        style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 26
        ),
      ),
    ),
  ];

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

  Widget _buildStatistics(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: rem(5)),
      child: Stats(),
    );
  }

  Widget _buildDescription(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: rem(5), vertical: rem(5)),
      child: Text(
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis "
            "nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate "
            "velit esse cillum dolore eu "
            "fugiat nulla pariatur. "
            "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        textAlign: TextAlign.justify,
      ),
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
                    context: context,
                    builder: (BuildContext context){
                      return BuySettings(
                        coinname: title,
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
                    context: context,
                    builder: (BuildContext context){
                      return SellSettings(
                        coinname: title,
                        coinsAmount: amountCoins,
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
                    context: context,
                    builder: (BuildContext context){
                      return Send(coinname: title, amountCoins: amountCoins,);
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
                    context: context,
                  builder: (BuildContext context){
                      return Recieve(coinname: title,);
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

      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _buildPrice(),
              _buildPriceChart(context),
              ChartFilter(),
              // _buildStatistics(),
              // _buildDescription(),
            ],
          ),
          _buildButtons(context)
        ],
      ),
    );
  }

}