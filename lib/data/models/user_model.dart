import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? uid;
  final String? userName;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final bool? isOnline;
  final Timestamp? lastSeen;
  final Timestamp? createdAt;
  final String? fcmToken;
  final List<String>? blockedUsers;

  UserModel({
    this.email,
    this.uid,
    this.userName,
    this.fcmToken,
    this.fullName,
    this.phoneNumber,
    this.isOnline = false,
    Timestamp? lastSeen,
    Timestamp? createdAt,
    this.blockedUsers,
  }) : lastSeen = lastSeen ?? Timestamp.now(),
       createdAt = createdAt ?? Timestamp.now();

  UserModel copyWith({
    String? uid,
    String? userName,
    String? fullName,
    String? email,
    String? phoneNumber,
    bool? isOnline,
    Timestamp? lastSeen,
    Timestamp? createdAt,
    String? fcmToken,
    List<String>? blockedUsers,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      userName: userName ?? this.userName,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      createdAt: createdAt ?? this.createdAt,
      fcmToken: fcmToken ?? this.fcmToken,
      blockedUsers: blockedUsers ?? this.blockedUsers,
    );
  }

  factory UserModel.fromFireStore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      userName: data['userName'],
      email: data['email'],
      fullName: data['fullName'],
      phoneNumber: data['phoneNumber'],
      fcmToken: data['fcmToken'],
      lastSeen: data['lastSeen'],
      createdAt: data['createdAt'],
      blockedUsers: data['blockedUsers'],
    );
  }

  Map<String, dynamic> tojson() {
    return {
      'userName': userName,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'isOnline': isOnline,
      'lastSeen': lastSeen,
      'createdAt': createdAt,
      'fcmToken': fcmToken,
      'blockedUsers': blockedUsers,
    };
  }
}
