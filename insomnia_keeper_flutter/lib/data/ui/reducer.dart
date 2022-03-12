import '../misc.dart';

const String SET_TITLES = "SET_TITLES";
const String SET_ERROR_REPORTED = "SET_ERROR_REPORTED";

class UIReducerData {
  List<String> titles = [];
  List<dynamic> errorsReported = [];
}

UIReducerData uiReducer(UIReducerData ui, ReduxAction action) {
  switch (action.type) {
    case SET_TITLES:
      ui.titles = action.payload;
      return ui;
    case SET_ERROR_REPORTED:
      ui.errorsReported.add(action.payload);
      return ui;
    default:
      return ui;
  }
}

ReduxAction setUITitles (List<String> titles) => (ReduxAction(SET_TITLES, titles));
ReduxAction setUIErrorReported (dynamic error) => (ReduxAction(SET_ERROR_REPORTED, error));
