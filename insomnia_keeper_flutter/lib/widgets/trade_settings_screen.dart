import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:insomnia_keeper_flutter/misc/rem.dart';

class TradeSettings extends HookWidget{
  final title;
  final coinname;

  // List of items in our dropdown menu
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  TradeSettings({required this.title ,required this.coinname});

  Widget _buidSell(BuildContext context){
    final theme = Theme.of(context);
    final dropdownValue = useState('Item 1');
    return Column(
      children: [
        Container(
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                Text(
                  "Give",
                  style: TextStyle(
                      fontSize: rem(10),
                      fontWeight: FontWeight.w300
                  ),
                ),
                SizedBox(height: 12,),
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
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
                        fontSize: rem(8)
                    ),
                  ),
                )
              ],
            )
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
        Text(
          "Get",
          style: TextStyle(
              fontSize: rem(10),
              fontWeight: FontWeight.w300
          ),
        ),
        SizedBox(height: 12,),
        Container(
          height: MediaQuery.of(context).size.height * 0.1,
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
                      fontSize: rem(8)
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
    );
  }

  Widget _buildBuy(BuildContext context){
    final theme = Theme.of(context);
    final dropdownValue = useState('Item 1');
    return Column(
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
              SizedBox(height: 12,),
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
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
                            fontSize: rem(8)
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
        SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
        Text(
          "Get",
          style: TextStyle(
              fontSize: rem(10),
              fontWeight: FontWeight.w300
          ),
        ),
        SizedBox(height: 12,),
        Container(
          height: MediaQuery.of(context).size.height * 0.1,
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
              fontSize: rem(8)
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSettings(BuildContext context){
    return title == "Sell" ? _buidSell(context) : _buildBuy(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 24
          ),
        ),
        centerTitle: true,
      ),
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
                  _buildSettings(context),
                  SizedBox(height: rem(18),),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50),
                    ),
                    onPressed: (){},
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