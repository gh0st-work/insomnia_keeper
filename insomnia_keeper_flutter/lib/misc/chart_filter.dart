import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ChartFilter extends HookWidget{
  late final VoidCallback? onPressed;

  ChartFilter({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          TextButton(
              onPressed: onPressed,
              child: const Text(
                "1H"
              )
          ),
          TextButton(
              onPressed: onPressed,
              child: const Text(
                  "1D"
              )
          ),
          TextButton(
              onPressed: onPressed,
              child: const Text(
                  "1W"
              )
          ),
          TextButton(
              onPressed: onPressed,
              child: const Text(
                  "1M"
              )
          ),
          TextButton(
              onPressed: onPressed,
              child: const Text(
                  "1Y"
              )
          ),
          TextButton(
              onPressed: onPressed,
              child: const Text(
                  "All"
              )
          ),
        ],
      ),
    );
  }

}