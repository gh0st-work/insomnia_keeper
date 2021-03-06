import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insomnia_keeper_flutter/misc/flutter_redux_hooks.dart';
import 'package:local_auth/local_auth.dart';

import '../cache/storage.dart';
import '../data/ui/reducer.dart';
import '../misc/buttons.dart';
import '../misc/rem.dart';
import 'animations.dart';


class LockScreen extends HookWidget {
  const LockScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final dispatch = useDispatch();
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
    final ThemeData theme = Theme.of(context);
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
      dispatch(setUIUnlocked(true));
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
      CircleButton(
        onPressed: authBiometrics,
        child: FaIcon(
          BiometricsIcon,
          size: rem(6),
        ),
      )
    ) : SizedBox(
      height: rem(16),
      width: rem(16),
    ));

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
      return CircleButton(
        onPressed: () => addNumber(num),
        child: Text(
          "$num",
          style: TextStyle(
            fontSize: rem(6),
            fontWeight: FontWeight.bold,
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
            children: [
              BiometricsButton,
              buildNumber(0),
              CircleButton(
                onPressed: backspace,
                child: FaIcon(
                  FontAwesomeIcons.backspace,
                  size: rem(6),
                ),
              )
            ],
          ),
        ],
      )),
    );

    return Stack(
      children: [
        // lockScreenPlasma,
        Container(
          padding: EdgeInsets.symmetric(vertical: rem(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Security Code",
                style: TextStyle(
                  fontSize: rem(8),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: rem(15)),
              CodeNumbers,
              SizedBox(height: rem(15)),
              NumberPad,
            ],
          ),
        )
      ]
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

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final color = (wrong ? theme.errorColor : scheme.onBackground);

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
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