import 'package:dio/dio.dart';
import 'package:insomnia_keeper_flutter/update_access_token.dart';
import 'package:localstorage/localstorage.dart';
import 'package:insomnia_keeper_flutter/settings.dart' as settings;


Future<Dio> getDioInstance ({int connectTimeout = 5000, int receiveTimeout = 60000}) async {
  final LocalStorage storage = LocalStorage(settings.storageName);
  String? accessToken = storage.getItem('access_token');
  Dio dioInstance = Dio(BaseOptions(
    baseUrl: settings.apiHttpUrl,
    connectTimeout: connectTimeout,
    receiveTimeout: receiveTimeout,
    headers: {
      'Authorization': accessToken != null ? 'JWT ' + accessToken : null,
      'Content-Type': 'application/json',
      'accept': 'application/json',
    },
  ));
  dioInstance.interceptors.add(InterceptorsWrapper(
    onError: (DioError e, handler) async {
      if (e.response?.statusCode == 401) {
        // prevent infinite loops
        if (e.requestOptions.uri.path.contains(settings.HTTPEndpoints.tokenRefresh)) {
          return handler.reject(e);
        } else if (e.response?.data['code'] == 'token_not_valid') {
          String? accessToken = await updateAccessToken(dioInstance);
          if (accessToken != null) {
            dioInstance.options.headers['Authorization'] = "JWT " + accessToken;
            e.requestOptions.headers['Authorization'] = "JWT " + accessToken;
            var response = await dioInstance.request(
                e.requestOptions.path,
                data: e.requestOptions.data,
                queryParameters: e.requestOptions.queryParameters,
            );
            return handler.resolve(response);
          }
        }
      }
      // Unhandled exceptions
      return handler.next(e);
    }
  ));
  return dioInstance;
}

