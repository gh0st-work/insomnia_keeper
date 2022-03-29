import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:insomnia_keeper_flutter/data/global/actions.dart';
import 'package:insomnia_keeper_flutter/data/personalAccount/actions.dart';
import 'package:insomnia_keeper_flutter/data/profile/actions.dart';
import 'package:insomnia_keeper_flutter/misc/flutter_redux_hooks.dart';
import 'package:insomnia_keeper_flutter/settings.dart' as settings;

import '../data/misc.dart';
import '../misc/to_bool.dart';
import 'navigation_screen.dart';

class Root extends HookWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dispatch = useDispatch();
    final global = useSelector((state) => state.global.data);
    final globalLoading = useSelector((state) => state.global.loading);
    final profile = useSelector((state) => state.profile.data);
    final profileLoading = useSelector((state) => state.profile.loading);
    final personalAccountLoading = useSelector((state) => state.personalAccount.loading);
    final titles = useSelector((state) => state.ui.titles);
		final currentThemeMode = useSelector((state) => state.ui.currentThemeMode);

    final allLoading = (personalAccountLoading || profileLoading);

		final allLoaded = useState(false);
		final postLoading = useState(false);
		const postLoadingDelay = 500;

    useEffect(() {
      reactDispatch(dispatch, getGlobal());
      reactDispatch(dispatch, getProfile());
      reactDispatch(dispatch, getPersonalAccount());
    }, []);

		getTitle () {
			if (toBool(global?.site_name)) { // same as react global?.site_name
				String newTitle = global.site_name;
				if (titles.length) {
					newTitle += ' | ' + titles.join(' - ');
				}
				return newTitle;
			} else {
				return settings.base;
			}
		}

		final title = getTitle();

		useEffect(() {
			Timer checkGlobalTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
				reactDispatch(dispatch, updateGlobal());
			});
			return () => checkGlobalTimer.cancel();
		}, []);

		final globalAvailable = toBool(global?.active);

		useEffect(() {
			if (!globalLoading && globalAvailable && !allLoading) {
				allLoaded.value = true;
				sleep(const Duration(milliseconds: postLoadingDelay));
				postLoading.value = false;
			}
		}, [globalLoading, globalAvailable, allLoading]);

		useEffect(() {
			if (!globalAvailable && allLoaded.value) {
				allLoaded.value = false;
			}
		}, [globalAvailable]);

    return const Scaffold(
			body: NavigationScreen(),
		);
  }
}