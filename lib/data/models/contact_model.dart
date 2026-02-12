class Contact {
  final String id;
  final String name;
  final String phoneNumber;
  final String avatarUrl;
  final bool isOnline;
  final String email;
  final String? targetUserId;

  Contact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.avatarUrl,
    this.isOnline = false,
    this.email = '',
    this.targetUserId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'avatarUrl': avatarUrl,
      'isOnline': isOnline,
      'email': email,
      'targetUserId': targetUserId,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      avatarUrl: map['avatarUrl'] ?? '',
      isOnline: map['isOnline'] ?? false,
      email: map['email'] ?? '',
      targetUserId: map['targetUserId'],
    );
  }
}
