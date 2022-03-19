import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:insomnia_keeper_flutter/misc/rem.dart';

class Recieve extends HookWidget{
  final String coinname;

  Recieve({required this.coinname});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Receive ${coinname}",
          style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w300
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Wallet",
              style: TextStyle(
                  fontSize: rem(8),
                  fontWeight: FontWeight.w300
              ),
            ),
            Text(
              "Wallet number here",
              style: TextStyle(
                  fontSize: rem(6),
                  fontWeight: FontWeight.w300
              ),
            ),
            SizedBox(height: 30,),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: rem(5)),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(MediaQuery.of(context).size.width * 0.75, 50),
                  ),
                  onPressed: (){},
                  child: const Text(
                    "Copy Address",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 20
                    ),
                  )
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20,),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(MediaQuery.of(context).size.width * 0.75, 50),
                  ),
                  onPressed: (){},
                  child: const Text(
                    "Share Address",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 20
                    ),
                  )
              ),
            )
          ],
        ),
      ),
    );
  }

}