import 'package:insomnia_keeper_flutter/data/misc.dart';
import 'package:insomnia_keeper_flutter/data/personalAccount/reducer.dart';
import 'package:insomnia_keeper_flutter/data/profile/reducer.dart';
import 'package:insomnia_keeper_flutter/data/ui/reducer.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'global/reducer.dart';

class AppState {
  final GlobalReducerData global;
  final PersonalAccountReducerData personalAccount;
  final ProfileReducerData profile;
  final UIReducerData ui;
  AppState(
    this.global,
    this.personalAccount,
    this.profile,
    this.ui,
  );
}

AppState appStateReducer(AppState state, dynamic action) => AppState(
  globalReducer(state.global, action),
  personalAccountReducer(state.personalAccount, action),
  profileReducer(state.profile, action),
  uiReducer(state.ui, action),
);

final Store<AppState> store = Store<AppState>(
  appStateReducer,
  initialState: AppState(
    GlobalReducerData(),
    PersonalAccountReducerData(),
    ProfileReducerData(),
    UIReducerData(),
  ),
  middleware: [thunkMiddleware],
);