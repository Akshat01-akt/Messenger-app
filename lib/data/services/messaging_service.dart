import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/data/models/message_model.dart';

class MessagingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get chat room ID (consistent for any pair of users)
  String getChatRoomId(String userId1, String userId2) {
    List<String> ids = [userId1, userId2];
    ids.sort();
    return ids.join('_');
  }

  // Send Message
  Future<void> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    final Timestamp timestamp = Timestamp.now();

    // Create message data
    // Note: We'll convert to Message model structure
    Map<String, dynamic> messageData = {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': message,
      'timestamp': timestamp,
      'isRead': false,
    };

    // Add to subcollection
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(messageData);

    // Update chat room metadata (latest message)
    await _firestore.collection('chat_rooms').doc(chatRoomId).set({
      'users': [senderId, receiverId],
      'lastMessage': message,
      'lastMessageTime': timestamp,
      'lastMessageBy': senderId,
      'lastMessageRead': false,
    }, SetOptions(merge: true));
  }

  // Get Chat Rooms Stream
  Stream<QuerySnapshot> getChatRooms(String userId) {
    return _firestore
        .collection('chat_rooms')
        .where('users', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  // Get Messages Stream
  Stream<List<Message>> getMessages(String chatRoomId, String currentUserId) {
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data();

            // Handle Cloud Firestore Timestamp
            DateTime dateTime;
            if (data['timestamp'] is Timestamp) {
              dateTime = (data['timestamp'] as Timestamp).toDate();
            } else if (data['timestamp'] is String) {
              dateTime = DateTime.parse(data['timestamp']);
            } else {
              dateTime = DateTime.now();
            }

            return Message(
              id: doc.id,
              text: data['text'] ?? '',
              isSentByMe: data['senderId'] == currentUserId,
              timestamp: dateTime,
              isRead: data['isRead'] ?? false,
              imageUrl: data['imageUrl'],
              fileUrl: data['fileUrl'],
              fileName: data['fileName'],
            );
          }).toList();
        });
  }

  // Mark chat as read
  Future<void> markChatAsRead(String chatRoomId) async {
    await _firestore.collection('chat_rooms').doc(chatRoomId).update({
      'lastMessageRead': true,
    });
  }
}
