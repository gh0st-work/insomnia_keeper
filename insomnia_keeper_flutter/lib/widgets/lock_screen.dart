import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:animated_widgets/widgets/translation_animated.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insomnia_keeper_flutter/widgets/wallet_screen.dart';

import '../misc/rem.dart';
import 'animations.dart';

class LockScreen extends HookWidget {
  const LockScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    const int codeLength = 4;
    final List<int?> initialCode = List<int?>.filled(codeLength, null);
    final code = useState(initialCode);
    final badCodeShaking = useState(false);

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
        // TODO: check code from
        String resultCode = code.value.join();
        print(resultCode);
      } catch (e, s) {
        success = false;
      }
      
      if (success) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WalletScreen()
          ),
          (Route<dynamic> route) => false,
        );
        
      } else {
        badCodeShaking.value = true;
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
      final codeNumEntered = (codeNum != null);
      final normalColor = (!codeNumEntered ? Colors.white.withOpacity(0.2) : Colors.white.withOpacity(0.8));
      final color = (badCodeShaking.value ? Colors.redAccent : normalColor);


      return FaIcon(
        FontAwesomeIcons.solidCircle,
        color: color,
        size: rem(8),
      );
    }



    Widget CodeNumbers = ShakeAnimation(
      animateState: badCodeShaking,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(codeLength, (i) => buildCodeNumber(i)),
      )
    );

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
                    FontAwesomeIcons.backspace,
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
                CodeNumbers,
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