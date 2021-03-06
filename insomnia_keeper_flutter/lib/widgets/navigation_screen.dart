import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:insomnia_keeper_flutter/misc/flutter_redux_hooks.dart';
import 'package:insomnia_keeper_flutter/widgets/lock_screen.dart';
import 'package:insomnia_keeper_flutter/widgets/sidebar_layout.dart';
import 'package:insomnia_keeper_flutter/widgets/wallet_screen.dart';

class Page {
  Widget widget = const Text('Page widget');
  String name = 'Page name';
  IconData icon = Icons.settings;
  Page(this.widget, this.name, this.icon);
}

class NavigationScreen extends HookWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final unlocked = useSelector((state) => state.ui.unlocked);
    final theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    final List<Page> pages = [
      Page(WalletScreen(), 'Wallet', Icons.account_balance_wallet),
      // Page(ExchangeScreen(), 'Exchange', Icons.swap_horizontal_circle),
      // Page(SettingsScreen(), 'Settings', Icons.settings),
    ];

    final selectedPageIndex = useState(0);
    PageController pageController = PageController();

    void onPageChanged(int index) {
      selectedPageIndex.value = index;
      pageController.jumpToPage(index);
    }

    Widget navigation = Scaffold(
      body: PageView(
        controller: pageController,
        children: pages.map((Page page) => page.widget).toList(),
        onPageChanged: onPageChanged,
      ),
    );


    final unlockedStackItems = (unlocked ? [] : [
      Container(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor.withOpacity(0.8),
            ),
          ),
        ),
      ),
      LockScreen(),
    ]);



    return Stack(
      children: [
        SafeArea(child: SidebarLayout()),
        ...unlockedStackItems,
      ],
    );
  }
}