import '../misc.dart';
import 'classes.dart';

const String SET_GLOBAL = "SET_GLOBAL";
const String SET_GLOBAL_LOADING = "SET_GLOBAL_LOADING";

class GlobalReducerData {
  bool loading = false;
  Global? data;
}

GlobalReducerData globalReducer(GlobalReducerData global, ReduxAction action) {
  switch (action.type) {
    case SET_GLOBAL:
      global.data = action.payload;
      global.loading = false;
      return global;
    case SET_GLOBAL_LOADING:
      global.loading = action.payload;
      return global;
    default:
      return global;
  }
}

ReduxAction setGlobal (Global global) => (ReduxAction(SET_GLOBAL, global));
ReduxAction setGlobalLoading (bool isLoading) => (ReduxAction(SET_GLOBAL_LOADING, isLoading));
