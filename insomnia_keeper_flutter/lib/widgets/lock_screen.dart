import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../misc/rem.dart';

class LockScreen extends HookWidget {
  const LockScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {

    const int codeLength = 6;
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
        print(resultCode);
        // success = true;
      } catch (e, s) {
        success = false;
      }
      
      if (success) {
        // TODO: go further
        
      } else {
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
      final codeNumText = (codeNum != null ? '*' : '-');
      return SizedBox(
        width: 50.0,
        child: Text( // TODO: UI
          codeNumText,
          textAlign: TextAlign.center,
          // decoration: InputDecoration(
          //   contentPadding: EdgeInsets.all(rem(4)),
          //   border:  OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(rem(3)),
          //     borderSide: const BorderSide(color: Colors.transparent)
          //   ),
          //   filled: true,
          //   fillColor: Colors.white30,
          // ),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: rem(6),
            color: Colors.white,
          ),
        ),
      );
    }

    List<Widget> CodeNumbers = useMemoized(() => List.generate(codeLength, (i) => buildCodeNumber(i)), [code.value]);

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
                    fontSize: rem(5),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 40.0,
                ),
               Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: CodeNumbers,
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