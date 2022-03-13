import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LockScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.deepPurpleAccent,
                  Colors.deepPurple,
                ],
                begin: Alignment.topRight
            )
        ),
        child: PassCode(),
      ),
    );
  }
}

class PassCode extends StatefulWidget {
  const PassCode({Key? key}) : super(key: key);

  @override
  _PassCodeState createState() => _PassCodeState();
}

class _PassCodeState extends State<PassCode> {
  List<String> currentPin = ["","","",""];
  TextEditingController pinOneController = TextEditingController();
  TextEditingController pinTwoController = TextEditingController();
  TextEditingController pinThreeController = TextEditingController();
  TextEditingController pinFourController = TextEditingController();

  var outLineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: Colors.transparent)
  );

  int pinIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          buildExitButton(),

          Container(
            alignment: Alignment(0,0.6),
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                buildSecurityText(),
                SizedBox(height: 40.0,),
                buildPinRow(),
              ],
            ),
          ),
          SizedBox(height: 50,),
          buildNumberPad(),
        ],
      ),
    );
  }

  buildNumberPad(){
    return Expanded(
      child: Container(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  KeyboardNumber(
                      n:1,
                      onPressed: (){
                        pinIndexSetup("1");
                      }
                  ),
                  KeyboardNumber(
                      n:2,
                      onPressed: (){
                        pinIndexSetup("2");
                      }
                  ),
                  KeyboardNumber(
                      n:3,
                      onPressed: (){
                        pinIndexSetup("3");
                      }
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  KeyboardNumber(
                      n:4,
                      onPressed: (){
                        pinIndexSetup("4");
                      }
                  ),
                  KeyboardNumber(
                      n:5,
                      onPressed: (){
                        pinIndexSetup("5");
                      }
                  ),
                  KeyboardNumber(
                      n:6,
                      onPressed: (){
                        pinIndexSetup("6");
                      }
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  KeyboardNumber(
                      n:7,
                      onPressed: (){
                        pinIndexSetup("7");
                      }
                  ),
                  KeyboardNumber(
                      n:8,
                      onPressed: (){
                        pinIndexSetup("8");
                      }
                  ),
                  KeyboardNumber(
                      n:9,
                      onPressed: (){
                        pinIndexSetup("9");
                      }
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 60.0,
                    child: MaterialButton(
                      height: 60.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60.0),
                      ),
                      onPressed: (){},
                      child: const FaIcon(
                        FontAwesomeIcons.fingerprint,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  KeyboardNumber(
                      n:0,
                      onPressed: (){
                        pinIndexSetup("0");
                      }
                  ),
                  Container(
                    width: 60.0,
                    child: MaterialButton(
                      height: 60.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60.0),
                      ),
                      onPressed: (){
                        clearPin();
                      },
                      child: const FaIcon(
                        FontAwesomeIcons.arrowLeft,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
      ),
    );
  }

  pinIndexSetup(String text){
    if (pinIndex == 0)
      pinIndex = 1;
    else if (pinIndex < 4)
      pinIndex++;
    setPin(pinIndex, text);
    currentPin[pinIndex-1] = text;
    String strPin = "";
    currentPin.forEach((e) {
      strPin += e;
    });
    if(pinIndex == 4)
      print(strPin);
  }

  setPin(int n, String text){
    switch(n){
      case 1:
        pinOneController.text = text;
        break;
      case 2:
        pinTwoController.text = text;
        break;
      case 3:
        pinThreeController.text = text;
        break;
      case 4:
        pinFourController.text = text;
        break;
    }
  }

  clearPin(){
    if(pinIndex == 0)
      pinIndex = 0;
    else{
      setPin(pinIndex, "");
      currentPin[pinIndex-1] = "";
      pinIndex--;
    }
  }

  buildPinRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        PinNumber(
          outlineInputBorder: outLineInputBorder,
          textEditingController: pinOneController,
        ),
        PinNumber(
          outlineInputBorder: outLineInputBorder,
          textEditingController: pinTwoController,
        ),
        PinNumber(
          outlineInputBorder: outLineInputBorder,
          textEditingController: pinThreeController,
        ),
        PinNumber(
          outlineInputBorder: outLineInputBorder,
          textEditingController: pinFourController,
        ),
      ],
    );
  }

  buildExitButton(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MaterialButton(
            onPressed: (){},
            height: 50.0,
            minWidth: 50.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0)
            ),
            child: const Icon(Icons.clear, color: Colors.white,),
          ),
        )
      ],
    );
  }

  buildSecurityText(){
    return const Text(
      "Security Pin",
      style: TextStyle(
        color: Colors.white,
        fontSize: 21.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class PinNumber extends StatelessWidget {
  final TextEditingController textEditingController;
  final OutlineInputBorder outlineInputBorder;
  PinNumber({required this.textEditingController, required this.outlineInputBorder});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.0,
      child: TextField(
        controller: textEditingController,
        enabled: false,
        obscureText: true,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16.0),
          border: outlineInputBorder,
          filled: true,
          fillColor: Colors.white30,
        ),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 21.0,
          color: Colors.white,
        ),
      ),
    );
  }
}

class KeyboardNumber extends StatelessWidget {
  final int n;
  final Function() onPressed;
  KeyboardNumber({required this.n, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.0,
      height: 70.0,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.purpleAccent.withOpacity(0.1)
      ),
      alignment: Alignment.center,
      child: MaterialButton(
        padding: EdgeInsets.all(8.0),
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60.0)
        ),
        height: 800.0,
        child: Text(
          "$n",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26*MediaQuery.of(context).textScaleFactor,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),),
      ),
    );
  }
}