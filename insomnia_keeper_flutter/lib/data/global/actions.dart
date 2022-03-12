import 'package:insomnia_keeper_flutter/data/misc.dart';
import 'package:insomnia_keeper_flutter/data/global/reducer.dart';
import 'package:insomnia_keeper_flutter/settings.dart' as settings;
import 'classes.dart';

final BaseAction globalAction = BaseAction(
    Global,
    settings.HTTPEndpoints.global,
    (data) => data.global,
    setGlobal,
    setGlobalLoading,
    false,
);

CallToDispatch getGlobal () => globalAction.get();
CallToDispatch updateGlobal () => globalAction.update();
CallToDispatch getOrUpdateGlobal (Global? existingGlobal) => globalAction.getOrUpdate(existingGlobal);

