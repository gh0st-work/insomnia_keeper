import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:math';

class AttentionShakeAnimation extends HookWidget {
  final Duration shakeDuration;
  final bool shakeVertical;
  final double shakeOffset;
  final int shakeCount;
  final Widget child;
  final ValueNotifier<bool> animateState;

  const AttentionShakeAnimation({
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
    final animationController = useAnimationController(
      duration: shakeDuration,
    );
    final animationProgress = useState(animationController.value);
    animationController.addListener(() {
      animationProgress.value = animationController.value;
    });
    animationController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        animationController.reset();
        animateState.value = false;
      }
    });
    useEffect(() {
      if (animateState.value == true) {
        animationController.forward();
      } else {
        animationController.stop();
        animationController.reset();
      }
    }, [animateState.value]);

    final sineValue = sin(shakeCount * 2 * pi * animationController.value);
    final offsetPixels = sineValue * shakeOffset;
    final Offset offset = (shakeVertical ? Offset(0, offsetPixels) : Offset(offsetPixels, 0));

    return Transform.translate(
      offset: offset,
      child: child,
    );
  }
}


class ToggleZoomAnimation extends HookWidget {
  final Duration zoomInDuration;
  final Duration zoomOutDuration;
  final bool zoom;
  final Widget child;
  final Curve? curve;

  const ToggleZoomAnimation({
    Key? key,
    this.zoomInDuration = const Duration(milliseconds: 200),
    this.zoomOutDuration = const Duration(milliseconds: 200),
    this.child = const Text('ToggleZoomAnimation child'),
    required this.zoom,
    this.curve,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: zoomInDuration,
      reverseDuration: zoomOutDuration,
    );
    final animationProgress = useState(animationController.value);
    animationController.addListener(() {
      animationProgress.value = animationController.value;
    });
    useEffect(() {
      if (zoom) {
        animationController.stop();
        animationController.forward();
      } else {
        animationController.stop();
        animationController.reverse();
      }
    }, [zoom]);
    
    CurvedAnimation(parent: animationController, curve: curve ?? Curves.bounceInOut);
    return Transform.scale(
      scale: animationProgress.value,
      child: child
    );
  }
}