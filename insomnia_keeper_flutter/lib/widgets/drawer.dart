import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insomnia_keeper_flutter/widgets/buy_sell_screen.dart';
import 'package:insomnia_keeper_flutter/widgets/receive_send_screen.dart';
import 'package:insomnia_keeper_flutter/widgets/transfer_screen.dart';


import '../misc/neumorphism_button.dart';
import '../misc/rem.dart';
import 'history_screen.dart';

class AddDrawer extends HookWidget{

  final _isSwitched = useState(false);

  void _changeTheme(bool value){

  }

  final TextStyle _groupStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w300);

  Widget _buildDrawerHeader(){
    return DrawerHeader(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: RichText(
          text: TextSpan(
              text: "Insomnia Keeper",
              style: TextStyle(
                  fontSize: rem(8),
                  fontWeight: FontWeight.w300
              ),
              children: [
                TextSpan(
                  text: "\n@tag",
                  style: TextStyle(
                      fontSize: rem(6),
                      fontWeight: FontWeight.w300
                  ),
                ),
              ]
          ),
        )
    );
  }

  void choiceAction(String choice){
    print("working");
  }

  List<String> currency = [
    "USD",
    "RUB",
    "EUR"
  ];

  Widget _buildMenuItem(BuildContext context, String text, IconData icon, Widget? route) {
    return ListTile(
      title: Text(text),
      leading: FaIcon(icon),
      onTap: route == null ? (){} : (){
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => route));
      },
    );
  }

  Widget _buildHistoryTile(BuildContext context){
    return  ListTile(
      title: Text("History"),
      leading: FaIcon(FontAwesomeIcons.clockRotateLeft),
      onTap: (){
        showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context){
              return Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    NeumorphismButton(
                      width: MediaQuery.of(context).size.width * 0.75,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => History(historyType: "purchase")),
                        );
                      },
                      child: Text(
                        "Purchase history",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 20
                        ),
                      ),
                    ),
                    SizedBox(height: 50,),
                    NeumorphismButton(
                      width: MediaQuery.of(context).size.width * 0.75,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => History(historyType: "trades")),
                        );
                      },
                      child: Text(
                        "History of trades",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 20
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _buildDrawerHeader(),
          ListTile(
            title: Text("Manage", style: _groupStyle,),
          ),
          Divider(),
          //_buildHistoryTile(context),
          _buildMenuItem(
              context,
              "Buy/sell",
              FontAwesomeIcons.basketShopping,
              BuySellScreen()
          ),
          _buildMenuItem(
              context,
              "Receive/send",
              FontAwesomeIcons.moneyBillTransfer,
              ReceiveSendScreen()
          ),
          ListTile(
            title: Text("Preferences", style: _groupStyle,),
          ),
          Divider(),
          PopupMenuButton<String>(
            child: _buildMenuItem(context, "Select currency", FontAwesomeIcons.coins, null),
            initialValue: currency[0],
            offset: Offset(50, 50),
            onSelected: choiceAction,
            itemBuilder: (context){
              return currency.map((String choice) {
                return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice)
                );
              }).toList();
            },
          ),
          PopupMenuButton<String>(
            child: _buildMenuItem(context, "Select language", FontAwesomeIcons.globe, null),
            initialValue: currency[0],
            offset: Offset(50, 50),
            onSelected: choiceAction,
            itemBuilder: (context){
              return currency.map((String choice) {
                return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice)
                );
              }).toList();
            },
          ),
          ListTile(
            leading: const Text(
              "Light theme",
              style: TextStyle(
                  fontSize: 16,
                  //fontWeight: FontWeight.w300
              ),
            ),
            title: Switch(
                value: _isSwitched.value,
                onChanged: (value){
                  _isSwitched.value = value;
                  _changeTheme(value);
                }
            ),
          ),
          _buildMenuItem(
              context,
              "Log out",
              FontAwesomeIcons.arrowRightFromBracket,
              null
          ),
        ],
      ),
    );
  }
}