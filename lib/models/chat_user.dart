class ChatUser {
  ChatUser({
    this.image,
    this.about,
    this.name,
    this.createdAt,
    this.isOnline,
    this.lastActive,
    this.id,
    this.email,
    this.pushToken,
  });
  String? image;
  String? about;
  String? name;
  String? createdAt;
  bool? isOnline;
  String? id;
  String? lastActive;
  String? email;
  String? pushToken;

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
