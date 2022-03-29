import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insomnia_keeper_flutter/widgets/animations.dart';
import 'package:insomnia_keeper_flutter/widgets/lock_screen.dart';

import '../misc/rem.dart';

class FingerScreen extends HookWidget{

  IconData BiometricsIcon = FontAwesomeIcons.fingerprint;
  final _success = useState(false);

  @override
  Widget build(BuildContext context) {
    final color = (_success.value ? Colors.greenAccent : Colors.redAccent);
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(height: MediaQuery.of(context).size.height * 0.2,),
          Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AttentionShakeAnimation(
                    animateState: _success,
                    child: FaIcon(
                      BiometricsIcon,
                      size: rem(20),
                      color: color,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Check",
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: rem(10)
                          ),
                        ),
                        Text(
                          "Touch ID",
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: rem(6)
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
          ),
          Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FaIcon(
                      BiometricsIcon,
                      size: rem(10),
                    ),
                    ElevatedButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LockScreen()));
                      },
                      child: Text("Enter PIN-CODE")
                    )
                  ],
                ),
              ),
          )
        ],
      ),
    );
  }

}