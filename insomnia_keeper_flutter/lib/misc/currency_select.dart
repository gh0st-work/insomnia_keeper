import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insomnia_keeper_flutter/misc/rem.dart';

class SelectCurrency extends HookWidget{
  final TextStyle _groupStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w300);

  List<String> currency = [
    "US Dollar",
    "Yuan",
    "Euro",
    "Pound",
    "Rupee",
    "Yen",
    "Ruble"
  ];

  @override
  Widget build(BuildContext context) {
    final _selectedCurrency = useState(currency[0]);

    Widget _currencySelect(String currency){
      return ListTile(
        title: Text(currency, style: _groupStyle),
        onTap: (){
          _selectedCurrency.value = currency;
          Navigator.of(context).pop();
        },
      );
    }

    return ListTile(
      leading: FaIcon(FontAwesomeIcons.coins),
      title: Text("Select Currency", style: _groupStyle,),
      subtitle: Text(_selectedCurrency.value, style: TextStyle(fontWeight: FontWeight.w300),),
      onTap: (){
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Select Currency"),
              titleTextStyle: TextStyle(fontWeight: FontWeight.w300, fontSize: rem(6)),
              content: Container(
                width: 200,
                height: 300,
                child: ListView.builder(
                  itemCount: currency.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _currencySelect(currency[index]);
                  },
                ),
              ),
            )
        );
      },
    );
  }

}