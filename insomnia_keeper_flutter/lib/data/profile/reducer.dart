import '../misc.dart';
import 'classes.dart';

const String SET_PROFILE = "SET_PROFILE";
const String SET_PROFILE_LOADING = "SET_PROFILE_LOADING";

class ProfileReducerData {
  bool loading = false;
  Profile? data;
  String accessStatus = AccessStatuses.defaultStatus;
}

ProfileReducerData profileReducer(ProfileReducerData profile, ReduxAction action) {
  switch (action.type) {
    case SET_PROFILE:
      profile.data = action.payload;
      profile.loading = false;
      if ([AccessStatuses.defaultStatus, AccessStatuses.admin].contains(action.payload.access_status)) {
        profile.accessStatus = action.payload.access_status;
      }
      return profile;
    case SET_PROFILE_LOADING:
      profile.loading = action.payload;
      return profile;
    default:
      return profile;
  }
}

ReduxAction setProfile (Profile profile) => (ReduxAction(SET_PROFILE, profile));
ReduxAction setProfileLoading (bool isLoading) => (ReduxAction(SET_PROFILE_LOADING, isLoading));
