import 'package:insomnia_keeper_flutter/data/misc.dart';
import 'package:insomnia_keeper_flutter/data/personalAccount/reducer.dart';
import 'package:insomnia_keeper_flutter/data/profile/reducer.dart';
import 'package:insomnia_keeper_flutter/data/ui/reducer.dart';
import 'package:insomnia_keeper_flutter/data/global/reducer.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart' show Store;

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
  static getInitialState () => AppState(
    GlobalReducerData(),
    PersonalAccountReducerData(),
    ProfileReducerData(),
    UIReducerData()
  );
  static AppState reducer(AppState state, ReduxAction action) => AppState(
    globalReducer(state.global, action),
    personalAccountReducer(state.personalAccount, action),
    profileReducer(state.profile, action),
    uiReducer(state.ui, action),
  );
  static AppState reducerDynamic(AppState state, dynamic action) => AppState.reducer(state, ReduxAction.fromDynamic(action));
}

final Store<AppState> store = Store<AppState>(
  AppState.reducerDynamic,
  initialState: AppState.getInitialState(),
  middleware: [thunkMiddleware],
);