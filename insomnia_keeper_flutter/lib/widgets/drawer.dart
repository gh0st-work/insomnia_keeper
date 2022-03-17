import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../misc/rem.dart';

class AddDrawer extends HookWidget{

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
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
          ),

        ],
      ),
    );
  }
}