import 'package:insomnia_keeper_flutter/data/misc.dart';
import 'package:insomnia_keeper_flutter/data/personalAccount/reducer.dart';
import 'package:insomnia_keeper_flutter/settings.dart' as settings;
import 'classes.dart';

final BaseAction personalAccountAction = BaseAction(
    PersonalAccount,
    settings.HTTPEndpoints.personalAccount,
    (data) => data.personalAccounts,
    setPersonalAccount,
    setPersonalAccountLoading,
    false,
);

CallToDispatch getPersonalAccount () => personalAccountAction.get();
CallToDispatch updatePersonalAccount () => personalAccountAction.update();
CallToDispatch getOrUpdatePersonalAccount (PersonalAccount existingPersonalAccount) => personalAccountAction.getOrUpdate(existingPersonalAccount);

