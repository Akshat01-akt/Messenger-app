class Chat {
  final String id;
  final String name;
  final String message;
  final String time;
  final String avatarUrl;
  final int unreadCount;
  final bool isOnline;
  final bool isGroup;
  final String? targetUserId;

  Chat({
    required this.id,
    required this.name,
    required this.message,
    required this.time,
    required this.avatarUrl,
    this.unreadCount = 0,
    this.isOnline = false,
    this.isGroup = false,
    this.targetUserId,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      name: json['name'],
      message: json['message'],
      time: json['time'],
      avatarUrl: json['avatarUrl'],
      unreadCount: json['unreadCount'] ?? 0,
      isOnline: json['isOnline'] ?? false,
      isGroup: json['isGroup'] ?? false,
      targetUserId: json['targetUserId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'message': message,
      'time': time,
      'avatarUrl': avatarUrl,
      'unreadCount': unreadCount,
      'isOnline': isOnline,
      'isGroup': isGroup,
      'targetUserId': targetUserId,
    };
  }
}
