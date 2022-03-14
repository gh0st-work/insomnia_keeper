import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../misc/rem.dart';

class LockScreen extends HookWidget {
  const LockScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    const int codeLength = 6;
    final List<int?> initialCode = List<int?>.filled(codeLength, null);
    final code = useState(initialCode);
    final cursorPosition = useState(0);

    final String codeText = useMemoized(
      () {
        if (code.value.every((char) => char != null)) {
          return code.value.join();
        } else {
          return List<int?>.filled(codeLength, 0).join();
        }
      },
      [code.value],
    );

    checkCode () {
      bool success = false;
      try {
        // TODO: check code
        success = true;
      } catch (e, s) {
        success = false;
      }
      
      if (success) {
        // TODO: go further
        
      } else {
        // TODO: shake, then
        code.value = initialCode;
      }
    }

    addNumber (number) {
      List<int?> newCode = code.value;
      int startingFrom = cursorPosition.value;
      newCode[startingFrom] = number;
      newCode.fillRange(startingFrom, codeLength-1, null);
      if (startingFrom == codeLength - 1) {
        checkCode();
      }
    }
    
    exit () {
      
    }
    
    final ExitButton =  Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MaterialButton(
            onPressed: exit(),
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

    final SecurityText = Text(
      "Security Code",
      style: TextStyle(
        color: Colors.white,
        fontSize: rem(5),
        fontWeight: FontWeight.bold,
      ),
    );

    final codeControllers = useRef(List.filled(codeLength, TextEditingController()));

    buildCodeNumber (i) {
      final codeNum = code.value[i];
      return Container(
        width: 50.0,
        child: TextField(
          controller: codeControllers.value[i],
          enabled: false,
          obscureText: true,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(rem(4)),
            border:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(rem(3)),
              borderSide: const BorderSide(color: Colors.transparent)
            ),
            filled: true,
            fillColor: Colors.white30,
          ),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: rem(5),
            color: Colors.white,
          ),
        ),
      );
    }

    final CodeNumbers = List.generate(codeLength, (i) => buildCodeNumber(i));

    final NumberPad = Text('numpad');

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
            alignment: Alignment(0, 0.6),
            padding: EdgeInsets.symmetric(horizontal: rem(4)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SecurityText,
                SizedBox(
                  height: 40.0,
                ),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: CodeNumbers,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          NumberPad,
        ],
      ),
    );
  }
}