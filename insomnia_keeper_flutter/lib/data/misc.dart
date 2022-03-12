import 'package:dio/dio.dart';
import 'package:insomnia_keeper_flutter/misc/flutter_redux_hooks.dart';

import '../get_dio_instance.dart';

class ReduxAction {
  String type = 'NULL_ACTION';
  dynamic payload = {};
  ReduxAction(this.type, this.payload);
}

typedef CallToDispatch = Future Function(Dispatch dispatch);

class BaseAction {
  dynamic setter;
  dynamic loadingSetter;
  dynamic cls;
  String url = '';
  dynamic Function(dynamic data) dataToKey;
  bool isArray = false;
  BaseAction(this.cls, this.url, this.dataToKey, this.setter, this.loadingSetter, [this.isArray = false]);
  fetch () async {
    Dio dioInstance = await getDioInstance();
    dynamic response = await dioInstance.get(url);
    dynamic data = dataToKey(response.data);
    dynamic result = (isArray ? data.map((d) => cls.fromJson(d)).toList() : cls.fromJson(data));
    return result;
  }
  CallToDispatch get () => (dispatch) async {
    try {
      dispatch(loadingSetter(true));
      dispatch(setter(fetch()));
    } catch (e, s) {
      print(e);
      print(s);
      dispatch(loadingSetter(false));
    }
  };
  CallToDispatch update () => (dispatch) async {
    try {
      dispatch(setter(fetch()));
    } catch (e, s) {
      print(e);
      print(s);
    }
  };
  CallToDispatch getOrUpdate (existingData) => (existingData != null ? update() : get());
}
