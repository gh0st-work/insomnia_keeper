import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class History extends HookWidget{

  final TextStyle _typeStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w300);
  final TextStyle _subTypeStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w300);
  final TextStyle _subDescriptionStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w300);


  Widget _buildDescription(BuildContext context){
    final theme = Theme.of(context);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("+ 5.12453214 TON", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),),
          Text("Transfer date", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),),
          SizedBox(height: 30,),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(10)
            ),
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Sender", style: _typeStyle,),
                    Text("Sender wallet number", style: _subDescriptionStyle,)
                  ],
                ),
                Divider(),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Transfer", style: _typeStyle,),
                    Text("Transfer number", style: _subDescriptionStyle,)
                  ],
                ),
                Divider(),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Commission", style: _typeStyle,),
                    Text("0.0000001 TON", style: _subDescriptionStyle,)
                  ],
                ),
                Divider(),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Message", style: _typeStyle,),
                    Text("Message text", style: _subDescriptionStyle,)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: theme.cardColor,
              maximumSize: Size(MediaQuery.of(context).size.width * 0.8, MediaQuery.of(context).size.height * 0.2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
          ),
          onPressed: () {
            showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context){
                  return _buildDescription(context);
                }
            );
          },
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: FaIcon(FontAwesomeIcons.inbox, size: 50,),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                width: MediaQuery.of(context).size.width * 0.6,
                //color: Colors.blue,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                            TextSpan(
                                children: [
                                  TextSpan(
                                      text: "Recieve",
                                      style: _typeStyle
                                  ),
                                  TextSpan(
                                      text: "\nRecieve",
                                      style: _subTypeStyle
                                  )
                                ]
                            )
                        ),
                        Text.rich(
                            TextSpan(
                                children: [
                                  TextSpan(
                                      text: "+ 5.12 TON",
                                      style: _typeStyle
                                  ),
                                  TextSpan(
                                      text: "\nWallet",
                                      style: _subTypeStyle
                                  )
                                ]
                            )
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      width: MediaQuery.of(context).size.width * 0.6,
                      decoration: BoxDecoration(
                        color: theme.backgroundColor,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text(
                        "Wallet number",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}