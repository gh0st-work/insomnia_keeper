import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NeumorphismButton extends HookWidget{
  final Widget child;
  final VoidCallback onPressed;
  final width;
  final height;
  final color;

  NeumorphismButton({
    required this.child,
    required this.onPressed,
    this.width,
    this.height,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    final _pressing = useState(false);
    final theme = Theme.of(context);
    return GestureDetector(
      onTapDown: (details){
        _pressing.value = true;
      },
      onTapUp: (value){
        _pressing.value = false;
      },
      onTapCancel: (){
        _pressing.value = false;
      },
      onTap: onPressed,
      child: AnimatedContainer(
        width: width ?? MediaQuery.of(context).size.width,
        height: height ?? 50,
        duration: const Duration(milliseconds: 200),
        child: Center(child: child,),
        decoration: BoxDecoration(
            color: _pressing.value ? theme.cardColor : theme.primaryColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: _pressing.value ? [

              BoxShadow(
                  color: theme.primaryColor,
                  blurRadius: 6,
                  offset: const Offset(1, 1),
                  spreadRadius: 1
              ),
              BoxShadow(
                  color: theme.cardColor,
                  blurRadius: 6,
                  offset: Offset(-1, -1),
                  spreadRadius: 1
              ),

            ] :
            [
              BoxShadow(
                  color: theme.primaryColor,
                  blurRadius: 8,
                  offset: const Offset(1, 1),
                  spreadRadius: 1
              ),
              BoxShadow(
                  color: theme.cardColor,
                  blurRadius: 8,
                  offset: Offset(-1, -1),
                  spreadRadius: 1
              ),
            ]
        ),
      ),
    );
  }

}

// class NeumorphismButton extends StatefulWidget {
//
//   final Widget child;
//   final VoidCallback onPressed;
//   const NeumorphismButton({Key? key, required this.child,
//     required this.onPressed}) : super(key: key);
//
//   @override
//   _NeumorphismButtonState createState() => _NeumorphismButtonState();
// }
//
// class _NeumorphismButtonState extends State<NeumorphismButton> {
//
//   bool _pressing = false;
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//   }
// }