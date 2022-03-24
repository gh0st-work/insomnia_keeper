import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:insomnia_keeper_flutter/widgets/sidebar.dart';
import 'package:insomnia_keeper_flutter/widgets/wallet_screen.dart';

class SidebarLayout extends HookWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WalletScreen(),
          SideBar()
        ],
      ),
    );
  }
}