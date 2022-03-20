import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Transfer extends HookWidget{

  final TextStyle _textFieldStyle = TextStyle(fontWeight: FontWeight.w300, fontSize: 20);
  final TextStyle _titleStyle = TextStyle(fontWeight: FontWeight.w300, fontSize: 24);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transfer"),
        centerTitle: true,
      ),

      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Enter transfer amount", style: _titleStyle,),
                  SizedBox(height: 10,),
                  TextField(
                    onChanged: (String value){},
                    decoration: InputDecoration(
                        hintText: "Enter amount",
                        hintStyle: _textFieldStyle
                    ),
                  )
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Enter card number", style: _titleStyle,),
                  SizedBox(height: 10,),
                  TextField(
                    onChanged: (String value){},
                    decoration: InputDecoration(
                        hintText: "Card number",
                        hintStyle: _textFieldStyle
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 30,),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50)
                ),
                onPressed: (){},
                child: Center(child: Text("Send", style: _textFieldStyle,),)
            )
          ],
        ),
      ),
    );
  }

}