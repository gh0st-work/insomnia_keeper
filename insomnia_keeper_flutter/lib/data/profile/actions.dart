
import 'package:insomnia_keeper_flutter/data/misc.dart';
import 'package:insomnia_keeper_flutter/data/profile/reducer.dart';
import 'package:insomnia_keeper_flutter/settings.dart' as settings;
import 'classes.dart';

final BaseAction profileAction = BaseAction(
    Profile,
    settings.HTTPEndpoints.profile,
    (data) => data.profile,
    setProfile,
    setProfileLoading,
    false,
);

CallToDispatch getProfile () => profileAction.get();
CallToDispatch updateProfile () => profileAction.update();
CallToDispatch getOrUpdateProfile (Profile? existingProfile) => profileAction.getOrUpdate(existingProfile);

