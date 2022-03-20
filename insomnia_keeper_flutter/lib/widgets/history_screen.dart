import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insomnia_keeper_flutter/widgets/history_preview.dart';

class History extends HookWidget {
  final TextStyle _typeStyle =
      const TextStyle(fontSize: 18, fontWeight: FontWeight.w300);
  final TextStyle _subTypeStyle =
      const TextStyle(fontSize: 14, fontWeight: FontWeight.w300);
  final TextStyle _subDescriptionStyle =
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w300);

  List<MokTransfers> transfers = [
    MokTransfers(
        type: "receive",
        coin: "TON",
        date: "01.01.2022",
        value: "100",
        senderWallet: "dadasda@!2fasfaf",
        transferDescription: "description",
        comission: "0000.1",
        message: "hi there"),
    MokTransfers(
        type: "send",
        coin: "TON",
        date: "01.01.2022",
        value: "100",
        senderWallet: "dadasda@!2fasfaf",
        transferDescription: "description",
        comission: "0000.1",
        message: "hi there"),
    MokTransfers(
        type: "receive",
        coin: "TON",
        date: "02.01.2022",
        value: "100",
        senderWallet: "dadasda@!2fasfaf",
        transferDescription: "description",
        comission: "0000.1",
        message: "hi there"),
    MokTransfers(
        type: "receive",
        coin: "TON",
        date: "03.01.2022",
        value: "100",
        senderWallet: "dadasda@!2fasfaf",
        transferDescription: "description",
        comission: "0000.1",
        message: "hi there"),
    MokTransfers(
        type: "receive",
        coin: "TON",
        date: "01.01.2022",
        value: "100",
        senderWallet: "dadasda@!2fasfaf",
        transferDescription: "description",
        comission: "0000.1",
        message: "hi there"),
  ];


  @override
  Widget build(BuildContext context) {
    transfers.sort((a, b) => a.getDate().compareTo(b.getDate()));
    return Scaffold(
        appBar: AppBar(
          title: Text("History"),
          centerTitle: true,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 50),
            width: MediaQuery.of(context).size.width * 0.8,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: transfers.length,
                itemBuilder: (context, index){
                  MokTransfers transfer = transfers[index];
                  print(transfer.type);
                  return HistoryPreview(
                      type: transfer.type,
                      coin: transfer.coin,
                      date: transfer.date,
                      value: transfer.value,
                      senderWallet: transfer.senderWallet,
                      transferDescription: transfer.transferDescription,
                      comission: transfer.comission,
                      message: transfer.message);
                }
            ),
          )
        )
    );
  }
}

class MokTransfers {
  final type;
  final coin;
  final date;
  final value;
  final senderWallet;
  final transferDescription;
  final comission;
  final message;

  MokTransfers(
      {required this.type,
      required this.coin,
      required this.date,
      required this.value,
      required this.senderWallet,
      required this.transferDescription,
      required this.comission,
      required this.message});
  getDate(){
    return date;
  }
}
