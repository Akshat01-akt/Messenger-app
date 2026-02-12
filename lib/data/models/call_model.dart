class CallModel {
  final String id;
  final String callerName;
  final String callerAvatar;
  final String receiverName;
  final String receiverAvatar;
  final String time;
  final CallType callType;
  final String? duration;
  final bool isVideoCall;
  final String status; // 'missed', 'completed', 'outgoing', 'incoming'
  final String userId; // The user whose history this belongs to

  CallModel({
    required this.id,
    required this.callerName,
    required this.callerAvatar,
    required this.receiverName,
    required this.receiverAvatar,
    required this.time,
    required this.callType,
    this.duration,
    this.isVideoCall = false,
    required this.status,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'callerName': callerName,
      'callerAvatar': callerAvatar,
      'receiverName': receiverName,
      'receiverAvatar': receiverAvatar,
      'time': time,
      'callType': callType.toString(),
      'duration': duration,
      'isVideoCall': isVideoCall,
      'status': status,
      'userId': userId,
      'timestamp': DateTime.now().millisecondsSinceEpoch, // For sorting
    };
  }

  factory CallModel.fromMap(Map<String, dynamic> map) {
    return CallModel(
      id: map['id'] ?? '',
      callerName: map['callerName'] ?? '',
      callerAvatar: map['callerAvatar'] ?? '',
      receiverName: map['receiverName'] ?? '',
      receiverAvatar: map['receiverAvatar'] ?? '',
      time: map['time'] ?? '',
      callType: map['callType'] == 'CallType.incoming'
          ? CallType.incoming
          : CallType.outgoing,
      duration: map['duration'],
      isVideoCall: map['isVideoCall'] ?? false,
      status: map['status'] ?? 'completed',
      userId: map['userId'] ?? '',
    );
  }
}

enum CallType { incoming, outgoing }
