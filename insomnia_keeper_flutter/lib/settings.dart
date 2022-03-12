const bool debug = true;
const String base = 'insomnia-keeper.com';
const String baseUrl = (debug ? 'http://192.168.0.3:8000' : 'https://' + base);
const String apiPostfix = '/api/v1/';
const String apiHttpUrl = baseUrl + apiPostfix;
const String storageName = 'storage.json';

class HTTPEndpoints {
  static const String static = 'server-data/';
  static const String media = 'users-data/';
  static const String tokenCreate = 'auth/token/obtain/';
  static const String tokenRefresh = 'auth/token/refresh/';
  static const String logout = 'auth/logout/';
  static const String global = 'global/';
  static const String home = 'home/';
  static const String profile = 'profile/';
  static const String profileChangePassword = 'profile/change-password/';
  static const String profileResetPassword = 'profile/reset-password/';
  static const String profileCheckPassword = 'profile/check-password/';
  static const String personalAccount = 'personal-account/';
}