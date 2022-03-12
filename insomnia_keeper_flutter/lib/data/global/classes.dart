import 'package:insomnia_keeper_flutter/data/profile/classes.dart';

class OpenGraph {
  String? title;
  String? description;
  String? imageUrl;
  OpenGraph({this.title, this.description, this.imageUrl});
}

class Global {
  String? phoneNumber;
  String? whatsappNumber;
  String? instagramUsername;
  String? telegramLink;
  String? facebookUsername;
  Global.fromJson(Map<String, dynamic> data) {
    phoneNumber = data['phoneNumber'];
    whatsappNumber = data['whatsappNumber'];
    instagramUsername = data['instagramUsername'];
    telegramLink = data['telegramLink'];
    facebookUsername = data['facebookUsername'];
  }
}