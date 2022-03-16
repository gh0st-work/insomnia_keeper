import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:insomnia_keeper_flutter/widgets/settings_screen.dart';
import 'package:insomnia_keeper_flutter/widgets/trade_screen.dart';
import 'package:insomnia_keeper_flutter/widgets/wallet_screen.dart';

class MainScreen extends HookWidget{
  final _selectedMenuIndex = useState(0);
  PageController pageController = PageController();

  void _onItemTapped(int index) {
    _selectedMenuIndex.value = index ;
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: [
          WalletScreen(),
          TradeScreen(),
          SettingsScreen()
        ],
        onPageChanged: _onItemTapped,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet_travel_rounded),
            label: "Wallet",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.price_change),
            label: 'Trade',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedMenuIndex.value,
        onTap: _onItemTapped,
      ),
    );
  }

}