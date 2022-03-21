import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HistoryPreview extends HookWidget{
  final type;
  final coin;
  final date;
  final value;
  final senderWallet;
  final transferDescription;
  final comission;
  final message;

  HistoryPreview(
      {required this.type,
        required this.coin,
        required this.date,
        required this.value,
        required this.senderWallet,
        required this.transferDescription,
        required this.comission,
        required this.message});

  final TextStyle _typeStyle =
  const TextStyle(fontSize: 18, fontWeight: FontWeight.w300);
  final TextStyle _subTypeStyle =
  const TextStyle(fontSize: 14, fontWeight: FontWeight.w300);
  final TextStyle _subDescriptionStyle =
  const TextStyle(fontSize: 16, fontWeight: FontWeight.w300);

  String capitalize(String string) {
    if (string.isEmpty) {
      return string;
    }

    return string[0].toUpperCase() + string.substring(1);
  }

  Widget _buildDescription(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            type == "receive" ? "+ ${value} ${coin}" : "- ${value} ${coin}",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
          ),
          Text(
            "$date",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(10)),
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      type == "receive" ? "Sender" : "Recipient",
                      style: _typeStyle,
                    ),
                    Text(
                      "$senderWallet",
                      style: _subDescriptionStyle,
                    )
                  ],
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Transfer",
                      style: _typeStyle,
                    ),
                    Text(
                      "$transferDescription",
                      style: _subDescriptionStyle,
                    )
                  ],
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Commission",
                      style: _typeStyle,
                    ),
                    Text(
                      "$comission $coin",
                      style: _subDescriptionStyle,
                    )
                  ],
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Message",
                      style: _typeStyle,
                    ),
                    Text(
                      "$message",
                      style: _subDescriptionStyle,
                    )
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
    IconData _icon = FontAwesomeIcons.dollarSign;
    switch(type){
      case "receive":
        _icon = FontAwesomeIcons.inbox;
        break;
      case "send":
        _icon =  FontAwesomeIcons.paperPlane;
        break;
      case "buy":
        _icon = FontAwesomeIcons.bagShopping;
        break;
      case "sell":
        _icon = FontAwesomeIcons.dollarSign;
        break;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          child: Text("$date", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 24),),
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, bottom: 20),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: theme.cardColor,
              maximumSize: Size(MediaQuery.of(context).size.width * 0.8,
                  MediaQuery.of(context).size.height * 0.2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          onPressed: () {
            showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return _buildDescription(context);
                });
          },
          child: Row(
            children: [
              Container(
                child: FaIcon(
                  _icon,
                  size: 50,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                width: MediaQuery.of(context).size.width * 0.6,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(TextSpan(children: [
                          TextSpan(text: "${capitalize(type)}", style: _typeStyle),
                          TextSpan(text: type == "receive" || type == "buy" ? "\nSender" : "\nRecipient", style: _subTypeStyle)
                        ])),
                        Text.rich(TextSpan(children: [
                          TextSpan(text: type == "receive" || type == "buy" ? "+ ${value} ${coin}" : "- ${value} ${coin}", style: _typeStyle),
                          TextSpan(text: "\nWallet number", style: _subTypeStyle)
                        ])),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      padding:
                      EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      width: MediaQuery.of(context).size.width * 0.6,
                      decoration: BoxDecoration(
                          color: theme.backgroundColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        "Wallet number",
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 14),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 20,)
      ],
    );
  }

}