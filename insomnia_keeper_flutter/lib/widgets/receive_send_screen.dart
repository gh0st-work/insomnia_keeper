import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_qr_bar_scanner/qr_bar_scanner_camera.dart';
import 'package:insomnia_keeper_flutter/widgets/send_screen.dart';
import 'package:share/share.dart';

import '../misc/dropdown.dart';
import '../misc/neumorphism_button.dart';
import '../misc/showbottomsheet.dart';
import 'history_screen.dart';

class ReceiveSendScreen extends HookWidget {
  final String _wallet = "@tag here";

  var coins = ['BTC', 'TON', 'ETH', 'DOGE'];

  final TextStyle _textFieldStyle =
      TextStyle(fontWeight: FontWeight.w300, fontSize: 20);

  @override
  Widget build(BuildContext context) {
    final selectedCoin = useTextEditingController();
    final coin = useState("");
    final _walletInfo = useState("Enter wallet");
    final camState = useState(false);
    final qrCallback = useCallback((String? code) {
      _walletInfo.value = code ?? "Enter wallet";
      camState.value = false;
    }, []);
    print(camState.value);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Receive/send",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
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
                        minimumSize:
                            Size(MediaQuery.of(context).size.width * 0.4, 50)),
                    onPressed: () {
                      showModalBottomSheet<void>(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return ShowBottomSheet(
                                child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              alignment: Alignment.center,
                              child: camState.value
                                  ? Center(
                                      child: SizedBox(
                                        height: 1000,
                                        width: 500,
                                        child: QRBarScannerCamera(
                                          onError: (context, error) => Center(
                                            child: Text(
                                              error.toString(),
                                              textAlign: TextAlign.center,
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                          qrCodeCallback: (code) {
                                            qrCallback(code);
                                          },
                                        ),
                                      ),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        DropDownField(
                                          controller: selectedCoin,
                                          hintText: "Select any coin",
                                          enabled: true,
                                          required: true,
                                          strict: false,
                                          items: coins,
                                          onValueChanged: (value) {
                                            coin.value = value;
                                          },
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          child: TextField(
                                            decoration: InputDecoration(
                                                icon:
                                                    Icon(Icons.monetization_on),
                                                hintText: "Enter amount",
                                                hintStyle: _textFieldStyle),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          child: TextField(
                                            decoration: InputDecoration(
                                                icon: Icon(Icons
                                                    .wallet_travel_rounded),
                                                hintText: _walletInfo.value,
                                                hintStyle: _textFieldStyle,
                                                suffixIcon: IconButton(
                                                  icon: Icon(
                                                      Icons.qr_code_scanner),
                                                  onPressed: () {
                                                    camState.value =
                                                        !camState.value;
                                                  },
                                                )),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        NeumorphismButton(
                                          onPressed: () {},
                                          child: const Text(
                                            "Send",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 20),
                                          ),
                                        )
                                      ],
                                    ),
                            ));
                          });
                    },
                    child: Text(
                      "Send",
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(MediaQuery.of(context).size.width * 0.4, 50)),
                    onPressed: () {
                      showModalBottomSheet<void>(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return ShowBottomSheet(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    DropDownField(
                                      controller: selectedCoin,
                                      hintText: "Select any coin",
                                      enabled: true,
                                      required: true,
                                      strict: false,
                                      items: coins,
                                      onValueChanged: (value) {
                                        coin.value = value;
                                      },
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    NeumorphismButton(
                                      onPressed: () =>
                                          _copyToClipboard(context),
                                      child: const Text(
                                        "Copy Address",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    NeumorphismButton(
                                      onPressed: () =>
                                          _onShare(context, _wallet),
                                      child: const Text(
                                        "Share Address",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    child: Text(
                      "Receive",
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
                    ))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "History",
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 28),
            ),
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

  Future<void> _copyToClipboard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: _wallet));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Copied to clipboard'),
    ));
  }

  void _onShare(BuildContext context, String wallet) async {
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    await Share.share("Wallet - ${wallet}",
        subject: wallet,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }
}
