import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:insomnia_keeper_flutter/widgets/buy_screen.dart';

import '../misc/rem.dart';

class BuySettings extends HookWidget{
  final coinname;

  // List of items in our dropdown menu
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  BuySettings({required this.coinname});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dropdownValue = useState('Item 1');
    return Scaffold(
        body: Container(
            alignment: Alignment.center,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: rem(3), vertical: rem(6)),
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.6,
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Give",
                                  style: TextStyle(
                                      fontSize: rem(10),
                                      fontWeight: FontWeight.w300
                                  ),
                                ),
                                Container(
                                  height: MediaQuery.of(context).size.height * 0.08,
                                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: theme.cardColor
                                  ),
                                  child: DropdownButton(
                                    isExpanded: true,
                                    underline: null,
                                    // Initial Value
                                    value: dropdownValue.value,
                                    // Down Arrow Icon
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    // Array list of items
                                    items: items.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(
                                          items,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: rem(6)
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    // After selecting the desired option,it will
                                    // change button value to selected value
                                    onChanged: (String? newValue) {
                                      dropdownValue.value = newValue!;
                                    },
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 30),
                            Text(
                              "Get",
                              style: TextStyle(
                                  fontSize: rem(10),
                                  fontWeight: FontWeight.w300
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.08,
                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: theme.cardColor
                              ),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                coinname,
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: rem(6)
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: rem(18),),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromHeight(50),
                          ),
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BuyScreen(coinName: coinname, payment: dropdownValue.value,)),
                            );
                          },
                          child: const Text(
                            "Trade",
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 20
                            ),
                          )
                      ),
                    )
                  ],
                )
            )
        )
    );
  }

}