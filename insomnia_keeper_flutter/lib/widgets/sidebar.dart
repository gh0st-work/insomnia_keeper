
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SideBar extends HookWidget{

  @override
  Widget build(BuildContext context) {
    final _duration = Duration(milliseconds: 500);
    final _animationController = useAnimationController(duration: _duration);
    var isSideBarOpenedStreamController = useStreamController();
    var isSidebarOpenedStream = useStream(isSideBarOpenedStreamController.stream);
    var isSidebarOpenedSink = isSideBarOpenedStreamController.sink;
    isSideBarOpenedStreamController = PublishSubject<bool>();

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
      stream: isSidebarOpenedStream.data,
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
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 100,
                      ),
                        ListTile(
                          title: Text(
                            "Prateek",
                            style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800),
                          ),
                          subtitle: Text(
                            "www.techieblossom.com",
                            style: TextStyle(
                              color: Color(0xFF1BB5FD),
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
                        color: Colors.white.withOpacity(0.3),
                        indent: 32,
                        endIndent: 32,
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, -0.9),
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