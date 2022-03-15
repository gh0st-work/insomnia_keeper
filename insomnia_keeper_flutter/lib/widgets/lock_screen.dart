import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insomnia_keeper_flutter/widgets/wallet_screen.dart';
import 'package:local_auth/local_auth.dart';

import '../cache/storage.dart';
import '../misc/rem.dart';
import 'animations.dart';

class LockScreen extends HookWidget {
  const LockScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    const int codeLength = 4;
    final List<int?> initialCode = List<int?>.filled(codeLength, null);
    final code = useState(initialCode);
    final realCode = storageGet('lock-code') ?? '1234';
    final badCodeShaking = useState(false);
    final localAuth = LocalAuthentication();
    final canCheckBiometrics = useState(false);
    final availableBiometrics = useState([]);
    final faceIdAvailable = availableBiometrics.value.contains(BiometricType.face);
    final fingerprintAvailable = availableBiometrics.value.contains(BiometricType.fingerprint);
    // TODO: Bruteforce defence



    loadBiometrics () async {
      bool canCheckBiometricsNew = await localAuth.canCheckBiometrics;
      canCheckBiometrics.value = canCheckBiometricsNew;
      if (canCheckBiometricsNew) {
        List<BiometricType> availableBiometricsNew = await localAuth.getAvailableBiometrics();
        availableBiometrics.value = availableBiometricsNew;
      }
    }

    useEffect(() {
      loadBiometrics();
    }, []);

    authenticated () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => WalletScreen()
        ),
        (Route<dynamic> route) => false,
      );
    }

    authBiometrics () async {
      var localAuth = LocalAuthentication();
      bool didAuthenticate = await localAuth.authenticate(
        stickyAuth: true,
        useErrorDialogs: true,
        localizedReason: 'Please authenticate',
        biometricOnly: true
      );
      if (didAuthenticate) {
        authenticated();
      }
    }


    IconData? BiometricsIcon = (faceIdAvailable ? FontAwesomeIcons.smile : (
      fingerprintAvailable ? FontAwesomeIcons.fingerprint : null
    ));


    Widget? BiometricsButton = (faceIdAvailable || fingerprintAvailable ? (
      MaterialButton(
        height: 60.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60.0),
        ),
        onPressed: authBiometrics,
        child: FaIcon(
          BiometricsIcon,
          color: Colors.white,
        ),
      )
    ) : null);

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
        success = (resultCode == realCode);
      } catch (e, s) {
        success = false;
      }
      
      if (success) {
        authenticated();
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


    Widget CodeNumbers = AttentionShakeAnimation(
      animateState: badCodeShaking,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: code.value.map((codeNum) => CodeNumber(
          numEntered: codeNum != null,
          wrong: badCodeShaking.value
        )).toList(),
      )
    );




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
                child: BiometricsButton,
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
          // ExitButton,
          Container(
            padding: EdgeInsets.all(rem(8)),
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
                  height: 60.0,
                ),
                CodeNumbers,
              ],
            ),
          ),
          NumberPad,
        ],
      ),
    );
  }
}

class CodeNumber extends HookWidget {
  bool numEntered = false;
  bool wrong = false;
  CodeNumber({
    Key? key,
    this.numEntered = false,
    this.wrong = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = (wrong ? Colors.redAccent : Colors.white.withOpacity(0.8));

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // borderRadius: BorderRadius.circular(100),
        border: Border.all(width: rem(1), color: color),
      ),
      child: ToggleZoomAnimation(
        zoom: numEntered,
        child: Container(
          height: rem(5),
          width: rem(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
      )
    );

  }
}