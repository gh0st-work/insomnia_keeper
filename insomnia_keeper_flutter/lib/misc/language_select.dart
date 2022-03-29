import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insomnia_keeper_flutter/misc/rem.dart';

class SelectLanguage extends HookWidget{
  final TextStyle _groupStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w300);

  List<String> languages = [
    "Default",
    "Rus",
    "Eng",
    "Deutsch",
    "Italiano",
    "Polski",
    "Ukrainian"
  ];

  @override
  Widget build(BuildContext context) {
    final _selectedLanguage = useState(languages[0]);

    Widget _languageSelect(String language){
      return ListTile(
        title: Text(language, style: _groupStyle,),
        onTap: (){
          _selectedLanguage.value = language;
          Navigator.of(context).pop();
        },
      );
    }
    return ListTile(
      leading: FaIcon(FontAwesomeIcons.globe),
      title: Text("Select Language", style: _groupStyle,),
      subtitle: Text(_selectedLanguage.value, style: TextStyle(fontWeight: FontWeight.w300),),
      onTap: (){
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Select Language"),
              titleTextStyle: TextStyle(fontWeight: FontWeight.w300, fontSize: rem(6)),
              content: Container(
                width: 200,
                height: 300,
                child: ListView.builder(
                  itemCount: languages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _languageSelect(languages[index]);
                  },
                ),
              ),
            )
        );
      },
    );
  }

}