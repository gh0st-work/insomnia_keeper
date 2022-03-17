import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../misc/rem.dart';

class ExchangeScreen extends HookWidget{

  List<Color> colorList = [
    Color(0xff9036f4),
    Color(0xffb021f3),
    Color(0xff6a8cda),
    Color(0xff8763c3),
  ];

  List<Alignment> alignmentList = [
    Alignment.topLeft,
    Alignment.bottomRight,
  ];

  final index = useState(0);
  final bottomColor = useState(Color(0xff9036f4));
  final topColor = useState(Color(0xffb021f3));
  final begin = useState(Alignment.topLeft);
  final end = useState(Alignment.bottomRight);


  Widget _buildHistoryButton(){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
      ),
      onPressed:() {},
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: rem(3)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const <Widget>[
            Text(
                "History",
                style:TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize:24
                )
            ),
            Icon(
              Icons.history,
              size: 32.0,
            ),
          ],
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(const Duration(milliseconds: 10), () {
    //     bottomColor.value = Colors.blue;
    // });
    // return AnimatedContainer(
    //   duration: Duration(seconds: 2),
    //   onEnd: () {
    //       index.value += 1;
    //       // animate the color
    //       bottomColor.value = colorList[index.value % colorList.length];
    //       topColor.value = colorList[(index.value + 1) % colorList.length];
    //
    //       //// animate the alignment
    //       begin.value = alignmentList[index.value % alignmentList.length];
    //       end.value = alignmentList[(index.value + 2) % alignmentList.length];
    //   },
    //   decoration: BoxDecoration(
    //       gradient: LinearGradient(
    //           begin: begin.value,
    //           end: end.value,
    //           colors: [bottomColor.value, topColor.value]
    //       )
    //   ),
    //   child: Column(
    //     children: [
    //       Padding(
    //         padding: EdgeInsets.symmetric(horizontal: 10, vertical: 50),
    //         child: _buildHistoryButton(),
    //       ),
    //       Container(height: MediaQuery.of(context).size.height * 0.1,),
    //       InkWell(
    //         onTap: (){},
    //         child: TradeButtons(title: "Sell"),
    //       ),
    //       SizedBox(height: 20,),
    //       InkWell(
    //         onTap: (){},
    //         child: TradeButtons(title: "Buy"),
    //       ),
    //       SizedBox(height: 20,),
    //       InkWell(
    //         onTap: (){},
    //         child: TradeButtons(title: "Make a deal"),
    //       ),
    //     ],
    //   ),
    // );


    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 50),
          child: _buildHistoryButton(),
        ),
        Container(height: MediaQuery.of(context).size.height * 0.1,),
        InkWell(
          onTap: (){},
          child: TradeButtons(title: "Sell"),
        ),
        SizedBox(height: 20,),
        InkWell(
          onTap: (){},
          child: TradeButtons(title: "Buy"),
        ),
        SizedBox(height: 20,),
        InkWell(
          onTap: (){},
          child: TradeButtons(title: "Make a deal"),
        ),
      ],
    );
  }
}

class TradeButtons extends HookWidget{
  final String title;

  TradeButtons({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(rem(1)),
      width: MediaQuery.of(context).size.width * 0.95,
      height: MediaQuery.of(context).size.height * 0.12,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
            offset: const Offset(1, 2),
          ),
        ],
      ),
      child: Center(
          child: Text(
              title,
              style:TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize:24
              )
          )
      ),
    );
  }

}