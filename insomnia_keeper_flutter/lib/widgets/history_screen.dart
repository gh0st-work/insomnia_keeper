import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:insomnia_keeper_flutter/widgets/history_preview.dart';

class History extends HookWidget {
  final historyType;

  History({required this.historyType});

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
        type: "buy",
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
        type: "sell",
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
    final buySellTransfers = transfers.where((element) => element.getType()=="buy" || element.getType()=="sell").toList();
    final receiveSendTransfers = transfers.where((element) => element.getType()=="receive" || element.getType()=="send").toList();
    final _transfers = historyType == "trades" ? receiveSendTransfers : buySellTransfers;

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
            child: _transfers.length != 0 ?ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: _transfers.length,
                itemBuilder: (context, index){
                  MokTransfers transfer = _transfers[index];
                  print(transfer.type);
                  return HistoryPreview(
                      type: transfer.type,
                      coin: transfer.coin,
                      date: transfer.date,
                      value: transfer.value,
                      senderWallet: transfer.senderWallet,
                      transferDescription: transfer.transferDescription,
                      comission: transfer.comission,
                      message: transfer.message
                  );
                }
            )
            : Center(
              child: Text(
                  "It`s empty now",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 32
                ),
              ),
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
  getType(){
    return type;
  }
}
