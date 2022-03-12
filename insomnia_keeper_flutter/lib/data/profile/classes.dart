class ExternalImage {
  String? imageUrl;
  String? imageUrlWebp;
  ExternalImage(this.imageUrl, this.imageUrlWebp);
}


class AccessStatuses {
  static String defaultStatus = 'default';
  static String admin = 'admin';
}

class User {
  int? id;
  String? email;
  DateTime? dateJoined;
  User.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    email = data['email'];
    dateJoined = DateTime(data['date_joined']);
  }
  toJson() => ({
    'id': id,
    'email': email,
    'date_joined': dateJoined?.toIso8601String(),
  });
}

class Profile {
  int? id;
  User? user;
  String? status;
  String accessStatus = AccessStatuses.defaultStatus;
  Profile.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    user = User.fromJson(data['user']);
    status = data['status'];
    accessStatus = data['access_status'];
  }
  toJson() => ({
    'id': id,
    'user': user?.toJson(),
    'status': status,
    'access_status': accessStatus,
  });
}
