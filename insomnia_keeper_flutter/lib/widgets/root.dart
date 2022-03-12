import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:insomnia_keeper_flutter/data/global/actions.dart';
import 'package:insomnia_keeper_flutter/data/personalAccount/actions.dart';
import 'package:insomnia_keeper_flutter/data/profile/actions.dart';
import 'package:insomnia_keeper_flutter/data/ui/reducer.dart';
import 'package:insomnia_keeper_flutter/misc/flutter_redux_hooks.dart';
import 'package:insomnia_keeper_flutter/settings.dart' as settings;

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

    final allLoading = (personalAccountLoading || profileLoading);

		final allLoaded = useState(false);
		final postLoading = useState(false);
		const postLoadingDelay = 500;

    useEffect(() {
      dispatch(getGlobal());
      dispatch(getProfile());
      dispatch(getPersonalAccount());
    }, []);

		getTitle () {
			if (global?.site_name) {
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
				dispatch(updateGlobal());
			});
			return () => checkGlobalTimer.cancel();
		}, []);

		final globalAvailable = global?.active;

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

		final windowDimensions = MediaQuery.of(context).size;

		// useEffect(() {
		//   dispatch(setUIWindowDimensions(windowDimensionsNative))
		// }, [windowDimensionsNative])
		//
		// const getWindowDimension = () {
		//
		//   const getNative = () {
		//     return {
		//       height: windowDimensionsNative?.height,
		//       width: windowDimensionsNative?.width,
		//     }
		//   }
		//
		//   return getNative()
		//
		//   try {
		//     if (window.innerHeight && window.innerWidth) {
		//       return {
		//         height: window.innerHeight,
		//         width: window.innerWidth,
		//       }
		//     } else {
		//       return getNative()
		//     }
		//   } catch (e) {
		//     return getNative()
		//   }
		// }
		//
		// const windowDimensions = getWindowDimension()
		//
		// useEffect(() {
		//   if (UIWindowDimensions?.height !== windowDimensions?.height && UIWindowDimensions?.width !== windowDimensions?.width) {
		//     dispatch(setUIWindowDimensions(windowDimensions))
		//   }
		// }, [windowDimensions])



    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
				child: (globalLoading ? Text('global loading') : (
					globalAvailable ? (
						postLoading.value ? Text('post loading') : Text('content')
					) : (
						Text('global not available')
					)
				)),
			),
    );
  }
}