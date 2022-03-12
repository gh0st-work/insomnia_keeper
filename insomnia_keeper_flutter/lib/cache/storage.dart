
import 'package:localstorage/localstorage.dart';

import '../settings.dart';

final LocalStorage storage = LocalStorage(storageName);

dynamic storageGet(String key) {
  Map<String, dynamic> data = {key: null};
  try {
    data = storage.getItem(key);
  } catch (e, s) {
    print(e);
    print(s);
  }
  dynamic result = data[key];
  return result;
}

void storageSet(String key, dynamic value, [bool overwrite = true]) {
  if (overwrite) {
     storage.setItem(key, value);
  } else {
    bool exists = (storageGet(key) != null);
    if (exists) {
      throw Exception('Key "$key" already exists');
    } else {
      storage.setItem(key, value);
    }
  }
}

void storageDelete(String key) {
  storage.deleteItem(key);
}