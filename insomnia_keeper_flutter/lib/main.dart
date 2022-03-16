import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insomnia_keeper_flutter/widgets/root.dart';

import 'package:redux/redux.dart' show Store;
import 'package:insomnia_keeper_flutter/data/app_state.dart' show store;
import 'package:insomnia_keeper_flutter/misc/flutter_redux_hooks.dart' show StoreProvider;
import 'package:flex_color_scheme/flex_color_scheme.dart';

void main() {
  runApp(const App());
}



class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeMode currentThemeMode = store.state.ui.currentThemeMode;

    final lightTheme = FlexThemeData.light(
			colors: const FlexSchemeColor(
				primary: Color(0xff651fff),
				primaryVariant: Color(0xff6200ea),
				secondary: Color(0xffffff00),
				secondaryVariant: Color(0xffffea00),
				appBarColor: Color(0xffffea00),
				error: Color(0xffb00020),
			),
			surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold,
			blendLevel: 40,
			appBarStyle: FlexAppBarStyle.primary,
			appBarOpacity: 0.9,
			appBarElevation: 0,
			transparentStatusBar: true,
			tabBarStyle: FlexTabBarStyle.forAppBar,
			tooltipsMatchBackground: true,
			swapColors: false,
			lightIsWhite: true,
			useSubThemes: true,
			visualDensity: FlexColorScheme.comfortablePlatformDensity,
			// To use playground font, add GoogleFonts package and uncomment:
			// fontFamily: GoogleFonts.notoSans().fontFamily,
			subThemesData: const FlexSubThemesData(
				useTextTheme: true,
				fabUseShape: true,
				interactionEffects: true,
				bottomNavigationBarElevation: 0,
				bottomNavigationBarOpacity: 0.9,
				navigationBarOpacity: 0.9,
				bottomNavigationBarSchemeColor: SchemeColor.primary,
				navigationBarIconSchemeColor: SchemeColor.primary,
				navigationBarTextSchemeColor: SchemeColor.primary,
				navigationBarHighlightSchemeColor: SchemeColor.primary,
				navigationBarMutedUnselectedText: true,
				navigationBarMutedUnselectedIcon: true,
				inputDecoratorIsFilled: true,
				inputDecoratorBorderType: FlexInputBorderType.outline,
				inputDecoratorUnfocusedHasBorder: true,
				blendOnColors: true,
				blendTextTheme: true,
				popupMenuOpacity: 0.95,
			),
		);
		final darkTheme = FlexThemeData.dark(
				colors: const FlexSchemeColor(
					primary: Color(0xff7c4dff),
					primaryVariant: Color(0xff651fff),
					secondary: Color(0xffffff00),
					secondaryVariant: Color(0xffffea00),
					appBarColor: Color(0xffffea00),
					error: Color(0xffcf6679),
				),
				surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold,
				blendLevel: 40,
				appBarStyle: FlexAppBarStyle.primary,
				appBarOpacity: 0.9,
				appBarElevation: 0,
				transparentStatusBar: true,
				tabBarStyle: FlexTabBarStyle.forAppBar,
				tooltipsMatchBackground: true,
				swapColors: false,
				darkIsTrueBlack: true,
				useSubThemes: true,
				visualDensity: FlexColorScheme.comfortablePlatformDensity,
				// To use playground font, add GoogleFonts package and uncomment:
				// fontFamily: GoogleFonts.notoSans().fontFamily,
				subThemesData: const FlexSubThemesData(
					useTextTheme: true,
					fabUseShape: true,
					interactionEffects: true,
					bottomNavigationBarElevation: 0,
					bottomNavigationBarOpacity: 0.9,
					navigationBarOpacity: 0.9,
					bottomNavigationBarSchemeColor: SchemeColor.primary,
					navigationBarIconSchemeColor: SchemeColor.primary,
					navigationBarTextSchemeColor: SchemeColor.primary,
					navigationBarHighlightSchemeColor: SchemeColor.primary,
					navigationBarMutedUnselectedText: true,
					navigationBarMutedUnselectedIcon: true,
					inputDecoratorIsFilled: true,
					inputDecoratorBorderType: FlexInputBorderType.outline,
					inputDecoratorUnfocusedHasBorder: true,
					blendOnColors: true,
					blendTextTheme: false,
					popupMenuOpacity: 0.95,
				),
			);

    return StoreProvider<dynamic>(
      store: store,
      child: MaterialApp(
        title: 'Insomnia keeper',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: currentThemeMode,
        home: const Root(),
      )
    );
  }
}




