import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:insomnia_keeper_flutter/misc/flutter_redux_hooks.dart';
import 'package:insomnia_keeper_flutter/widgets/lock_screen.dart';
import 'package:insomnia_keeper_flutter/widgets/wallet_screen.dart';

class NavigationScreen extends HookWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final unlocked = useSelector((state) => state.ui.unlocked);
    final theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;


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
        SafeArea(child: WalletScreen()),
        ...unlockedStackItems,
      ],
    );
  }
}