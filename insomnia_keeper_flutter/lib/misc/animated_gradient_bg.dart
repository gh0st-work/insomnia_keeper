import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Background extends HookWidget{
  final Widget child;

  Background({required this.child});

  List<Color> colorList = [
    Color(0xff7c409f),
    Color(0xff3755a3),
    Color(0xff694667),
    Color(0xff372a68),
  ];
  List<Alignment> alignmentList = [
    Alignment.bottomLeft,
    Alignment.bottomRight,
    Alignment.topRight,
    Alignment.topLeft,
  ];


  @override
  Widget build(BuildContext context) {
    final index = useState(0);
    final bottomColor = useState( Color(0xff3755a3));
    final topColor = useState(Color(0xff372a68));
    final begin = useState(Alignment.bottomLeft);
    final end = useState(Alignment.topRight);

    Future.delayed(const Duration(milliseconds: 10), () {
      bottomColor.value = Color(0xff694667);
    });

    return Stack(
      children: [
        AnimatedContainer(
          duration: Duration(seconds: 5),
          onEnd: () {
            index.value += 1;
            bottomColor.value = colorList[index.value % colorList.length];
            topColor.value = colorList[(index.value + 1) % colorList.length];
            begin.value = alignmentList[index.value % alignmentList.length];
            end.value = alignmentList[(index.value + 2) % alignmentList.length];
          },
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: begin.value, end: end.value, colors: [bottomColor.value, topColor.value])),
        ),
        child
      ],
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Stack(
  //     children: [
  //       Container(
  //         width: double.infinity,
  //         height: double.infinity,
  //         decoration: BoxDecoration(
  //           gradient: LinearGradient(
  //             begin: Alignment.topLeft,
  //             end: Alignment.bottomRight,
  //             colors: [Colors.purple, Colors.blue]
  //           )
  //         ),
  //       ),
  //       child
  //     ],
  //   );
  // }

}