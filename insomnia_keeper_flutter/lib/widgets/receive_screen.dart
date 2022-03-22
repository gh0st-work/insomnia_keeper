import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:insomnia_keeper_flutter/misc/neumorphism_button.dart';
import 'package:insomnia_keeper_flutter/misc/rem.dart';
import 'package:share/share.dart';

class Recieve extends HookWidget{
  final String coinname;
  final String _wallet = "Wallet number here";

  Recieve({required this.coinname});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        height: MediaQuery.of(context).size.height * 0.5,
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
              _wallet,
              style: TextStyle(
                  fontSize: rem(6),
                  fontWeight: FontWeight.w300
              ),
            ),
            SizedBox(height: 30,),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: NeumorphismButton(
                width: MediaQuery.of(context).size.width * 0.75,
                onPressed: () => _copyToClipboard(context),
                child: const Text(
                  "Copy Address",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 20
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: NeumorphismButton(
                  width: MediaQuery.of(context).size.width * 0.75,
                  onPressed: () => _onShare(context, _wallet),
                  child: const Text(
                    "Share Address",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 20
                    ),
                  ),
              ),
            )
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
    await Share.share("Wallet - ${wallet}", subject: wallet, sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

}