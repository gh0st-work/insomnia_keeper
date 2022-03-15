import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insomnia_keeper_flutter/misc/price.dart';
import 'package:insomnia_keeper_flutter/widgets/asset_price_chart.dart';
import 'package:insomnia_keeper_flutter/widgets/coin_screen.dart';
import 'package:insomnia_keeper_flutter/widgets/coin_widget.dart';

import '../misc/format.dart';
import '../misc/rem.dart';

class WalletScreen extends HookWidget{
  const WalletScreen({Key? key}) : super(key: key);

  final int _selectedMenuIndex = 0;
  void _onItemTapped(int index) {

  }

  static List coins = [];
  static const TextStyle optionStyle =
  TextStyle(fontSize: 26, fontWeight: FontWeight.bold);

  Widget _buildTitle(BuildContext context){
    return Row(
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
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 21,
                ),
              ),
              Text(
                "Hello, username!",
                style: TextStyle(
                  color: Colors.white,
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
            amount: Format.toAmount(10.0),
            percentChange: 10.0,
            isTitle: true,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    coins.add(MokCoins("BTC", 100000.0, 23.1, 10));
    coins.add(MokCoins("TON", 20.0, -3.4, 11));
    coins.add(MokCoins("ETH", 2000.0, 61.9, 12));
    return Scaffold(
      backgroundColor: Colors.purple[100],
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.purple[600],
            pinned: false,
            expandedHeight: MediaQuery.of(context).size.height * 0.2,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                color: Colors.purple[600],
                padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                child: _buildTitle(context),
              ),
              centerTitle: true,
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index){
                    return Padding(
                      padding: EdgeInsets.all(5.0),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CoinScreen(title:coins[index].title, amount: coins[index].amount,
                              percentChange: coins[index].percentChange, amountCoins: coins[index].coinsAmount,)),
                          );
                          },
                        child: Coin(title: coins[index].title, amount: coins[index].amount, percentChange: coins[index].percentChange,
                          coinsAmount: Format.toAmount(coins[index].coinsAmount),),
                      )
                    );
                  },
                childCount: coins.length
              )
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet_travel_rounded),
            label: "Wallet",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.price_change),
            label: 'Exchange',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedMenuIndex,
        selectedItemColor: Colors.purple[600],
        onTap: _onItemTapped,
      ),
    );
  }
}

class MokCoins{
  String title;
  double amount;
  double percentChange;
  double coinsAmount;

  MokCoins(this.title, this.amount, this.percentChange, this.coinsAmount);
}