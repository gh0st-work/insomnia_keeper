import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:insomnia_keeper_flutter/misc/neumorphism_button.dart';
import 'package:insomnia_keeper_flutter/misc/rem.dart';
import 'package:flutter_qr_bar_scanner/qr_bar_scanner_camera.dart';

class Send extends HookWidget{
  final String coinname;

  Send({required this.coinname});

  final TextStyle _textFieldStyle = TextStyle(fontWeight: FontWeight.w300, fontSize: 20);


  @override
  Widget build(BuildContext context) {
    final _walletInfo = useState("Enter wallet");
    final camState = useState(false);
    final qrCallback = useCallback((String? code){
      _walletInfo.value = code??"Enter wallet";
      camState.value = false;
    }, []);

    return Container(
      width: double.infinity,
      child: camState.value ? Center(
        child: SizedBox(
          height: 1000,
          width: 500,
          child: QRBarScannerCamera(
            onError: (context, error) => Center(
              child: Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
            ),
            qrCodeCallback: (code) {
              qrCallback(code);
            },
          ),
        ),
      ) : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30,),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            width: MediaQuery.of(context).size.width * 0.9,
            child: TextField(
              decoration: InputDecoration(
                  icon: Icon(Icons.monetization_on),
                  hintText: "Enter amount",
                  hintStyle: _textFieldStyle
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            width: MediaQuery.of(context).size.width * 0.9,
            child: TextField(
              decoration: InputDecoration(
                  icon: Icon(Icons.wallet_travel_rounded),
                  hintText: _walletInfo.value,
                  hintStyle: _textFieldStyle,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.qr_code_scanner),
                    onPressed: () {
                      camState.value = !camState.value;
                    },
                  )
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: rem(5)),
            child: NeumorphismButton(
              width: MediaQuery.of(context).size.width * 0.8,
              onPressed: () {  },
              child: const Text(
                "Send",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 20
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

}