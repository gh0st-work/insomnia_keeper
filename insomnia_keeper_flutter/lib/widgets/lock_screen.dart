import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animated_widgets/animated_widgets.dart';
import 'package:insomnia_keeper_flutter/widgets/wallet_screen.dart';

import '../misc/rem.dart';

class LockScreen extends HookWidget {
  const LockScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    bool _enable = false;
    const int codeLength = 6;
    const String currentCode = "123456";
    final List<int?> initialCode = List<int?>.filled(codeLength, null);
    final code = useState(initialCode);

    clearCode () {
      code.value = initialCode;
    }

    backspace () {
      List<int?> newCode = [...code.value];
      int startingFrom = code.value.indexOf(null);
      if (startingFrom != 0) {
        newCode.fillRange(startingFrom-1, codeLength - 1, null);
        code.value = newCode;
      }
    }

    checkCode () {
      bool success = false;
      try {
        // TODO: check code
        String resultCode = code.value.join();
        if(currentCode == resultCode) {
          success = true;
        }
        print(resultCode);
      } catch (e, s) {
        success = false;
      }
      
      if (success) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => WalletScreen()),
              (Route<dynamic> route) => false,
        );
        
      } else {
        _enable = true;
        print(success);
        // TODO: shake, then
        clearCode();
      }
    }

    addNumber (number) {
      List<int?> newCode = [...code.value];
      int startingFrom = code.value.indexOf(null);
      if (startingFrom != -1) {
        int lastIndex = codeLength - 1;
        newCode[startingFrom] = number;
        newCode.fillRange((startingFrom + 1 < lastIndex ? startingFrom + 1 : lastIndex), lastIndex, null);
        code.value = newCode;
        if (startingFrom >= lastIndex) {
          checkCode();
        }
      }
    }
    
    exit () {
      SystemNavigator.pop();
    }
    
    Widget ExitButton =  Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MaterialButton(
            onPressed: exit,
            height: 50.0,
            minWidth: 50.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0)
            ),
            child: const Icon(
              Icons.clear,
              color: Colors.white,
            ),
          ),
        )
      ],
    );

    Widget buildCodeNumber (i) {
      final codeNum = code.value[i];
      final codeNumText = (codeNum != null ? '*' : '');
      return Container(
        width: 50.0,
        height: 60.0,
        child: Center(
          child: Text(
            codeNumText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: rem(6),
              color: Colors.white,
            ),
          ),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.blueGrey.withOpacity(0.4),
                Colors.grey.withOpacity(0.2),
              ],
              begin: Alignment.topRight
          ),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(1, 2),
            ),
          ],
        ),
      );
    }

    List<Widget> CodeNumbers = useMemoized(() => List.generate(codeLength, (i) => buildCodeNumber(i)), [code.value]);

    Widget _codeNumbers(){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: CodeNumbers,
      );
    }

    fingerprint () {

    }


    Widget buildNumber (int num) {
      return Container(
        width: 70.0,
        height: 70.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle, color: Colors.purpleAccent.withOpacity(0.1)
        ),
        alignment: Alignment.center,
        child: MaterialButton(
          padding: const EdgeInsets.all(8.0),
          onPressed: () => addNumber(num),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60.0)
          ),
          height: 800.0,
          child: Text(
            "$num",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: rem(6),
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    Widget NumberPad = Expanded(
      child: Container(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (i) => buildNumber(i+1)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (i) => buildNumber(i+4)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (i) => buildNumber(i+7)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                width: 60.0,
                child: MaterialButton(
                  height: 60.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60.0),
                  ),
                  onPressed: fingerprint,
                  child: const FaIcon(
                    FontAwesomeIcons.fingerprint,
                    color: Colors.white,
                  ),
                ),
              ),
              buildNumber(0),
              SizedBox(
                width: 60.0,
                child: MaterialButton(
                  height: 60.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60.0),
                  ),
                  onPressed: backspace,
                  child: const FaIcon(
                    FontAwesomeIcons.arrowLeft, // TODO: Backspace
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      )),
    );

    return Container(
      decoration: const BoxDecoration(
        gradient: 
        LinearGradient(
          colors: [
            Colors.deepPurpleAccent,
            Colors.deepPurple,
          ],
          begin: Alignment.topRight
        )
      ),
      child: Column(
        children: <Widget>[
          ExitButton,
          Container(
            alignment: const Alignment(0, 0.6),
            padding: EdgeInsets.symmetric(horizontal: rem(4)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Security Code",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: rem(7),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 40.0,
                ),
               // Row(
               //    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               //    children: CodeNumbers,
               //  ),
                ShakeAnimatedWidget(
                  enabled: _enable,
                  duration: const Duration(milliseconds: 500),
                  shakeAngle: Rotation.deg(y: 40),
                  curve: Curves.linear,
                  child: _codeNumbers(),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          NumberPad,
        ],
      ),
    );
  }
}