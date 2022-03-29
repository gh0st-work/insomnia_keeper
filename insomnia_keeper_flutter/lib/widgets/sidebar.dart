
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insomnia_keeper_flutter/misc/rem.dart';
import 'package:insomnia_keeper_flutter/widgets/receive_send_screen.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'buy_sell_screen.dart';

class SideBar extends HookWidget{

  final TextStyle _groupStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w300);
  final _isSwitched = useState(false);

  void _changeTheme(bool value){

  }

  List<String> languages = [
    "Default",
    "Rus",
    "Eng",
    "Deutsch",
    "Italiano",
    "Polski",
    "Ukrainian"
  ];

  List<String> currency = [
    "US Dollar",
    "Yuan",
    "Euro",
    "Pound",
    "Rupee",
    "Yen",
    "Ruble"
  ];

  Widget _buildMenuItem(BuildContext context, String text, IconData icon, Widget? route) {
    return ListTile(
      title: Text(text, style: _groupStyle,),
      leading: FaIcon(icon),
      onTap: route == null ? (){} : (){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => route)
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _duration = Duration(milliseconds: 500);
    final _animationController = useAnimationController(duration: _duration);
    var isSideBarOpenedStreamController = useStreamController<bool>();
    isSideBarOpenedStreamController = PublishSubject<bool>();
    var isSidebarOpenedSink = isSideBarOpenedStreamController.sink;

    void onIconPressed() {
      final animationStatus = _animationController.status;
      final isAnimationCompleted = animationStatus == AnimationStatus.completed;
      if (isAnimationCompleted) {
        isSidebarOpenedSink.add(false);
        _animationController.reverse();
      } else {
        isSidebarOpenedSink.add(true);
        _animationController.forward();
      }
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

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

    return StreamBuilder<bool>(
      initialData: false,
      stream: isSideBarOpenedStreamController.stream,
      builder: (context, isSideBarOpenedAsync) {
        return AnimatedPositioned(
          duration: _duration,
          top: 0,
          bottom: 0,
          left: isSideBarOpenedAsync.data! ? 0 : -screenWidth,
          right: isSideBarOpenedAsync.data! ? 0 : screenWidth - 40,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: theme.cardColor,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      const SizedBox(
                        height: 100,
                      ),
                        const ListTile(
                          title: Text(
                            "Welcome",
                            style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800),
                          ),
                          subtitle: Text(
                            "@tag",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          leading: CircleAvatar(
                            child: Icon(
                              Icons.perm_identity,
                              color: Colors.white,
                            ),
                            radius: 40,
                          ),
                        ),
                      Divider(
                        height: 64,
                        thickness: 0.5,
                        indent: 32,
                        endIndent: 32,
                      ),
                      ListTile(
                        title: Text("Manage", style: _groupStyle,),
                      ),
                      Divider(),
                      _buildMenuItem(
                          context,
                          "Buy/sell",
                          FontAwesomeIcons.basketShopping,
                          BuySellScreen()
                      ),
                      _buildMenuItem(
                          context,
                          "Receive/send",
                          FontAwesomeIcons.moneyBillTransfer,
                          ReceiveSendScreen()
                      ),
                      ListTile(
                        title: Text("Preferences", style: _groupStyle,),
                      ),
                      Divider(),
                      ListTile(
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
                      ),
                      ListTile(
                        leading: FaIcon(FontAwesomeIcons.coins),
                        title: Text("Select Language", style: _groupStyle,),
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
                      ),
                      ListTile(
                        leading: const Text(
                          "Light theme",
                          style: TextStyle(
                            fontSize: 16,
                            //fontWeight: FontWeight.w300
                          ),
                        ),
                        title: Switch(
                            value: _isSwitched.value,
                            onChanged: (value){
                              _isSwitched.value = value;
                              _changeTheme(value);
                            }
                        ),
                      ),
                      ListTile(
                        leading: FaIcon(FontAwesomeIcons.arrowRightFromBracket),
                        title: Text("Log out", style: _groupStyle,),
                        onTap: (){
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Log out"),
                                titleTextStyle: TextStyle(fontWeight: FontWeight.w300, fontSize: rem(6)),
                                content: Text("Are you sure you want to exit?", style: _groupStyle,),
                                actions: [
                                  TextButton(
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Cancel", style: TextStyle(fontWeight: FontWeight.w300, fontSize: rem(5)),)
                                  ),
                                  TextButton(
                                      onPressed: (){}, 
                                      child: Text("Exit", style: TextStyle(fontWeight: FontWeight.w300, fontSize: rem(5)))
                                  ),
                                ],
                              )
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, -0.8),
                child: GestureDetector(
                  onTap: () {
                    onIconPressed();
                    },
                  child: ClipPath(
                    clipper: CustomMenuClipper(),
                    child: Container(
                      width: 35,
                      height: 110,
                      color: theme.cardColor,
                      alignment: Alignment.centerLeft,
                      child: AnimatedIcon(
                        progress: _animationController.view,
                        icon: AnimatedIcons.menu_close,
                        size: 25,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
    );
  }
}

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}