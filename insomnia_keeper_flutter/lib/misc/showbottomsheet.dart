import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ShowBottomSheet extends HookWidget{
  final Widget child;

  ShowBottomSheet({required this.child});
  
  Widget _closeButton(BuildContext context){
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.topRight,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.circular(50)
          ),
          child: Icon(Icons.close),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Stack(
        children: [
          child,
          _closeButton(context)
        ],
      ),
    );
  }

}