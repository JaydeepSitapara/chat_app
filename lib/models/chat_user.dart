class ChatUser {
  ChatUser({
    required this.image,
    required this.about,
    required this.name,
    required this.createdAt,
    required this.isOnline,
    required this.lastActive,
    required this.id,
    required this.email,
    required this.pushToken,
  });
  late String image;
  late String about;
  late String name;
  late String createdAt;
  late bool isOnline;
  late String id;
  late String lastActive;
  late String email;
  late String pushToken;

  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    about = json['about'] ?? '';
    name = json['name'] ?? '';
    createdAt = json['createdAt'] ?? '';
    isOnline = json['isOnline'] ?? '';
    id = json['id'] ?? '';
    lastActive = json['lastActive'] ?? '';
    email = json['email'] ?? '';
    pushToken = json['oush_token'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['about'] = about;
    data['name'] = name;
    data['createdAt'] = createdAt;
    data['isOnline'] = isOnline;
    data['id'] = id;
    data['lastActive'] = lastActive;
    data['email'] = email;
    data['oush_token'] = pushToken;
    return data;
  }
}
