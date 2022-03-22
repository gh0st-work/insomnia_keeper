import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'history_screen.dart';

class ReceiveSendScreen extends HookWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Receive/send",
          style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w300
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 50)
                    ),
                    onPressed: (){},
                    child: Text(
                      "Send",
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 20
                      ),
                    )
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 50)
                    ),
                    onPressed: (){},
                    child: Text(
                      "Receive",
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 20
                      ),
                    )
                )
              ],
            ),
            SizedBox(height: 20,),
            Text("History", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 28),),
            Divider(),
            Container(
              height: MediaQuery.of(context).size.height * 0.65,
              child: History(historyType: "trades"),
            ),

          ],
        ),
      ),
    );
  }

}