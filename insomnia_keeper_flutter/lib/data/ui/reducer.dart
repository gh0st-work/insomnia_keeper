import 'package:flutter/material.dart';

import '../misc.dart';

const String SET_TITLES = "SET_TITLES";
const String SET_ERROR_REPORTED = "SET_ERROR_REPORTED";
const String SET_CURRENT_THEME_MODE = "SET_CURRENT_THEME_MODE";
const String SET_UNLOCKED = "SET_UNLOCKED";


class UIReducerData {
  List<String> titles = [];
  List<dynamic> errorsReported = [];
  ThemeMode currentThemeMode = ThemeMode.dark;
  bool unlocked = false;
}

UIReducerData uiReducer(UIReducerData ui, ReduxAction action) {
  switch (action.type) {
    case SET_TITLES:
      ui.titles = action.payload;
      return ui;
    case SET_ERROR_REPORTED:
      ui.errorsReported.add(action.payload);
      return ui;
    case SET_CURRENT_THEME_MODE:
      ui.currentThemeMode = action.payload;
      return ui;
    case SET_UNLOCKED:
      ui.unlocked = action.payload;
      return ui;
    default:
      return ui;
  }
}

ReduxAction setUITitles (List<String> titles) => (ReduxAction(SET_TITLES, titles));
ReduxAction setUIErrorReported (dynamic error) => (ReduxAction(SET_ERROR_REPORTED, error));
ReduxAction setUICurrentThemeMode (ThemeMode mode) => (ReduxAction(SET_CURRENT_THEME_MODE, mode));
ReduxAction setUIUnlocked (bool isUnlocked) => (ReduxAction(SET_UNLOCKED, isUnlocked));
