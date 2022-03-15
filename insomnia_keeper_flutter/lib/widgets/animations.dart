import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:vector_math/vector_math_64.dart';
import 'dart:math';


ValueNotifier<double> useAnimated ({
  required Duration duration,
  required ValueNotifier<bool> animateState,
}) {

  final animationController = useAnimationController(
    duration: duration,
  );

  final animationProgress = useState(animationController.value);

  animationController.addListener(() {
    animationProgress.value = animationController.value;
  });

  animationController.addStatusListener((AnimationStatus status) {
    switch (status) {
      case AnimationStatus.dismissed:
        animationController.reset();
        animateState.value = false;
        break;
      case AnimationStatus.forward:
        animateState.value = true;
        break;
      case AnimationStatus.reverse:
        animateState.value = true;
        break;
      case AnimationStatus.completed:
         animationController.reset();
        animateState.value = false;
        break;
    };
  });

  useEffect(() {
    if (animateState.value == true) {
      animationController.forward();
    } else {
      animationController.stop();
      animationController.reset();
    }
  }, [animateState.value]);

  return animationProgress;
}



class ShakeAnimation extends HookWidget {
  final Duration shakeDuration;
  final bool shakeVertical;
  final double shakeOffset;
  final int shakeCount;
  final Widget child;
  final ValueNotifier<bool> animateState;

  const ShakeAnimation({
    Key? key,
    this.shakeDuration = const Duration(milliseconds: 600),
    this.shakeVertical = false,
    this.shakeOffset = 15,
    this.shakeCount = 3,
    this.child = const Text('ShakeAnimation child'),
    required this.animateState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final animationProgress = useAnimated(
      duration: shakeDuration,
      animateState: animateState,
    );

    final sineValue = sin(shakeCount * 2 * pi * animationProgress.value);
    final offsetPixels = sineValue * shakeOffset;
    final Offset offset = (shakeVertical ? Offset(0, offsetPixels) : Offset(offsetPixels, 0));

    return Transform.translate(
      offset: offset,
      child: child,
    );

    return Text('${animationProgress.value}');



    return Transform.translate(
      offset: (shakeVertical ? Offset(0, offsetPixels) : Offset(offsetPixels, 0)),
      child: child,
    );
  }
}
