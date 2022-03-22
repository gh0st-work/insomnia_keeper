import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:insomnia_keeper_flutter/misc/neumorphism_button.dart';
import 'package:insomnia_keeper_flutter/misc/rem.dart';
import 'package:insomnia_keeper_flutter/widgets/deal_buy_screen.dart';

class BuyScreen extends HookWidget{
  final coinName;
  final payment;

  BuyScreen({required this.coinName, required this.payment});

  List<MokTrades> trades = [
    MokTrades(price: "40000", from: "110", to: "20000", coinsamount: "123", amountForPrice: "1"),
    MokTrades(price: "1000", from: "1", to: "10000", coinsamount: "1000000", amountForPrice: "10"),
    MokTrades(price: "40000", from: "110", to: "20000", coinsamount: "123", amountForPrice: "1"),
    MokTrades(price: "40000", from: "110", to: "20000", coinsamount: "123", amountForPrice: "1"),
    MokTrades(price: "40000", from: "110", to: "20000", coinsamount: "123", amountForPrice: "1"),
    MokTrades(price: "40000", from: "110", to: "20000", coinsamount: "123", amountForPrice: "1"),
    MokTrades(price: "40000", from: "110", to: "20000", coinsamount: "123", amountForPrice: "1"),
    MokTrades(price: "40000", from: "110", to: "20000", coinsamount: "123", amountForPrice: "1"),
    MokTrades(price: "40000", from: "110", to: "20000", coinsamount: "123", amountForPrice: "1"),
    MokTrades(price: "40000", from: "110", to: "20000", coinsamount: "123", amountForPrice: "1"),
  ];

  final TextStyle _optionStyle = TextStyle(fontWeight: FontWeight.w500, fontSize: 10);
  final TextStyle _tradeStyle = TextStyle(fontWeight: FontWeight.w300, fontSize: 16);
  final TextStyle _textFieldStyle = TextStyle(fontWeight: FontWeight.w300, fontSize: 20);


  Widget _buildOffers(BuildContext context){
    final theme = Theme.of(context);
    return Expanded(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: trades.length,
          itemBuilder: (context, index){
            MokTrades mokTrade = trades[index];
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: theme.cardColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
              ),
              onPressed: () {
                showModalBottomSheet<void>(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context){
                      return BuyDealScreen(
                        coinName: coinName,
                        payment: payment,
                        amount: mokTrade.amountForPrice,
                        price: mokTrade.price,
                        total: mokTrade.coinsamount,
                        priceFrom: mokTrade.from,
                        priceTo: mokTrade.to,
                      );
                    }
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Row(
                      children: [
                        Text("${mokTrade.price}" , style: _tradeStyle,),
                        SizedBox(width: 5,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("From ${mokTrade.from}", style: _optionStyle,),
                            Text("To ${mokTrade.to}", style: _optionStyle)
                          ],
                        )
                      ],
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Center(
                        child:
                        Text("${mokTrade.amountForPrice}", style: _tradeStyle,
                        )
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    alignment: Alignment.centerRight,
                    //width: MediaQuery.of(context).size.width * 0.3,
                    child: Text("${mokTrade.coinsamount}", style: _tradeStyle,),
                  )
                ],
              ),
            );
          }
      ),
    );
  }

  Widget _buildBalance(BuildContext context){
    final theme = Theme.of(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      decoration: BoxDecoration(
          color: theme.cardColor,
          border: Border.all(color: theme.cardColor),
          borderRadius: BorderRadius.circular(10)
      ),
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Text(
          "Balance: 00.00",
          style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: rem(8)
          ),
        ),
      ),
    );
  }

  Widget _buildNewDeal(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Enter your price", style: _tradeStyle,),
          TextField(
            onChanged: (String value){},
            decoration: InputDecoration(
                hintText: "Enter price",
                hintStyle: _textFieldStyle
            ),
          ),
          Row(
            children: [
              Flexible(
                  child: TextField(
                    onChanged: (String value){},
                    decoration: InputDecoration(
                        hintText: "Min price",
                        hintStyle: _textFieldStyle
                    ),
                  )
              ),
              SizedBox(width: 20,),
              Flexible(
                  child: TextField(
                    onChanged: (String value){},
                    decoration: InputDecoration(
                        hintText: "Max price",
                        hintStyle: _textFieldStyle
                    ),
                  )
              ),
            ],
          ),
          Text("Enter the number of coins you want to buy", style: _tradeStyle,),
          TextField(
            onChanged: (String value){},
            decoration: InputDecoration(
                hintText: "Enter amount",
                hintStyle: _textFieldStyle
            ),
          ),
          SizedBox(height: 10,),
          NeumorphismButton(
              child: Text(
                "Create deal",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: rem(6)
                ),
              ),
              onPressed: (){}
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$payment/$coinName",
          style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w300
          ),
        ),
        centerTitle: true,
      ),

      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildBalance(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Price"),
                SizedBox(width: 1,),
                Text("Amount"),
                SizedBox(width: 1,),
                Text("Total"),
              ],
            ),
            _buildOffers(context),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: NeumorphismButton(
                onPressed: (){
                  showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context){
                        return _buildNewDeal();
                      }
                  );
                },
                child: Text(
                  "Make a deal",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: rem(6)
                  ),
                ),
              )

            )
          ],
        ),
      )
    );
  }

}

class MokTrades{
  final price;
  final from;
  final to;
  final coinsamount;
  final amountForPrice;

  MokTrades({
    required this.price,
    required this.from,
    required this.to,
    required this.coinsamount,
    required this.amountForPrice
  });
}