import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insomnia_keeper_flutter/misc/rem.dart';

class Logout extends HookWidget{
  final TextStyle _groupStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w300);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: FaIcon(FontAwesomeIcons.arrowRightFromBracket),
      title: Text("Log out", style: _groupStyle,),
      onTap: (){
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Log out"),
              titleTextStyle: TextStyle(fontWeight: FontWeight.w300, fontSize: rem(6)),
              content: Text("Are you sure you want to exit?", style: _groupStyle,),
              actions: [
                TextButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel", style: TextStyle(fontWeight: FontWeight.w300, fontSize: rem(5)),)
                ),
                TextButton(
                    onPressed: (){},
                    child: Text("Exit", style: TextStyle(fontWeight: FontWeight.w300, fontSize: rem(5)))
                ),
              ],
            )
        );
      },
    );
  }

}