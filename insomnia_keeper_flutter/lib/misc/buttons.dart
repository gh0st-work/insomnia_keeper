import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CircleButton extends HookWidget {
  final double paddingSize;
  final double innerSize;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final Clip clipBehavior;
  final FocusNode? focusNode;
  final bool autofocus;
  final Widget? child;

  const CircleButton({
    Key? key,
    required this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
    this.paddingSize = 16,
    this.innerSize = 32,
    required this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return ElevatedButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      onHover: onHover,
      onFocusChange: onFocusChange,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      child: Container(
        height: innerSize,
        width: innerSize,
        alignment: Alignment.center,
        child: Center(
          child: child,
        ),
      ),
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: EdgeInsets.all(paddingSize),
      ),
    );
  }


}