import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../misc/rem.dart';

class AddDrawer extends HookWidget{

  Widget _buildDrawerHeader(){
    return DrawerHeader(
        child: RichText(
          text: TextSpan(
              text: "Insomnia Keeper",
              style: TextStyle(
                  fontSize: rem(8),
                  fontWeight: FontWeight.w300
              ),
              children: [
                TextSpan(
                  text: "\nUser Name",
                  style: TextStyle(
                      fontSize: rem(6),
                      fontWeight: FontWeight.w300
                  ),
                ),
                TextSpan(
                  text: "\nWallet number",
                  style: TextStyle(
                      fontSize: rem(4),
                      fontWeight: FontWeight.w300
                  ),
                ),
              ]
          ),
        )
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon
    }){
    return ListTile(
      leading: FaIcon(icon),
      title: Text(text),
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

  Widget _buildPopup() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        "Select currency",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300
        ),
      ),
    );
}

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _buildDrawerHeader(),
          Divider(),
          PopupMenuButton<String>(
            child: _buildPopup(),
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
          )
        ],
      ),
    );
  }
}