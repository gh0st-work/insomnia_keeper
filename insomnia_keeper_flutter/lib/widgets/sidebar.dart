import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insomnia_keeper_flutter/widgets/receive_send_screen.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../misc/currency_select.dart';
import '../misc/language_select.dart';
import '../misc/logout.dart';
import 'buy_sell_screen.dart';

class SideBar extends HookWidget{

  final TextStyle _groupStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w300);
  final _isSwitched = useState(false);

  void _changeTheme(bool value){

  }

  Widget _buildThemeSwitch(){
    return ListTile(
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
                      //menu block
                      ListTile(
                        title: Text("Manage", style: _groupStyle,),
                      ),
                      Divider(),
                      ListTile(
                        title: Text("Buy/sell", style: _groupStyle,),
                        leading: FaIcon(FontAwesomeIcons.basketShopping),
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => BuySellScreen())
                          );
                        },
                      ),
                      ListTile(
                        title: Text("Receive/send", style: _groupStyle,),
                        leading: FaIcon(FontAwesomeIcons.moneyBillTransfer),
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => ReceiveSendScreen())
                          );
                        },
                      ),

                      //settings block
                      ListTile(
                        title: Text("Preferences", style: _groupStyle,),
                      ),
                      Divider(),
                      SelectLanguage(),
                      SelectCurrency(),
                      _buildThemeSwitch(),
                      Logout(),
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