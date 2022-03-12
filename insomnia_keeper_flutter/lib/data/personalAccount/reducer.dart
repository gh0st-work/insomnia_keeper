import '../misc.dart';
import 'classes.dart';

const String SET_PERSONAL_ACCOUNT = "SET_PERSONAL_ACCOUNT";
const String SET_PERSONAL_ACCOUNT_LOADING = "SET_PERSONAL_ACCOUNT_LOADING";


class PersonalAccountReducerData {
  bool loading = false;
  PersonalAccount? data;
}

PersonalAccountReducerData personalAccountReducer(PersonalAccountReducerData personalAccount, ReduxAction action) {
  switch (action.type) {
    case SET_PERSONAL_ACCOUNT:
      personalAccount.data = action.payload;
      personalAccount.loading = false;
      return personalAccount;
    case SET_PERSONAL_ACCOUNT_LOADING:
      personalAccount.loading = action.payload;
      return personalAccount;
    default:
      return personalAccount;
  }
}

ReduxAction setPersonalAccount (PersonalAccount personalAccount) => (ReduxAction(SET_PERSONAL_ACCOUNT, personalAccount));
ReduxAction setPersonalAccountLoading (bool isLoading) => (ReduxAction(SET_PERSONAL_ACCOUNT_LOADING, isLoading));