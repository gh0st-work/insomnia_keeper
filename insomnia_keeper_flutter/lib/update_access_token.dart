import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:localstorage/localstorage.dart';
import 'package:insomnia_keeper_flutter/settings.dart' as settings;

Future<String?> updateAccessToken(Dio dioInstance) async {
  final LocalStorage storage = LocalStorage(settings.storageName);
  String refreshToken = storage.getItem('refresh_token');

  if (refreshToken != '') {
    var tokenParts = json.decode(base64.decode(refreshToken.split('.')[1]).toString());
    var nowMicroSeconds = (DateTime.now().microsecondsSinceEpoch).ceil();
    print('token exp ${tokenParts.exp}, $nowMicroSeconds, ${tokenParts.exp - nowMicroSeconds}');
    if (tokenParts.exp > nowMicroSeconds) {
      try {
        var refreshResponse = await dioInstance.post(settings.HTTPEndpoints.tokenRefresh, data: {
          'refresh': refreshToken,
        });
        var data = json.decode(refreshResponse.data);
        storage.setItem('access_token', data['access']);
        storage.setItem('refresh_token', data['refresh']);
        return data['access'];
      } catch (e, s) {
        print(e);
        print(s);
      }
    }
  }
}