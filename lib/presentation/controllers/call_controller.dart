import 'package:chat_app/data/models/call_model.dart';
import 'package:chat_app/data/models/contact_model.dart';
import 'package:chat_app/data/services/auth_service.dart';
import 'package:chat_app/presentation/controllers/user_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CallController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final UserController _userController = Get.find<UserController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var calls = <CallModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    // Check if user is already logged in
    if (_authService.currentUser.value != null) {
      _bindCallHistoryStream();
    }

    ever(_authService.currentUser, (user) {
      if (user != null) {
        _bindCallHistoryStream();
      } else {
        calls.clear(); // Clear calls on logout
      }
    });
  }

  void _bindCallHistoryStream() {
    String uid = _authService.uid!;
    print("Binding call history stream for User ID: $uid");

    calls.bindStream(
      _firestore
          .collection('call_history')
          .where('userId', isEqualTo: uid)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((query) {
            print(
              "Call History Stream Update: ${query.docs.length} records found",
            );
            return query.docs
                .map((doc) => CallModel.fromMap(doc.data()))
                .toList();
          }),
    );
  }

  Future<void> makeCall(Contact contact, bool isVideo) async {
    if (_authService.uid == null) return;

    final String callId = DateTime.now().millisecondsSinceEpoch.toString();
    final String timeParams = DateFormat('jm').format(DateTime.now());

    // Generate unique IDs for both records
    final String callerRecordId = '${callId}_${_authService.uid}';
    final String receiverRecordId = '${callId}_${contact.targetUserId}';

    // 1. Caller Record (Outgoing) - Shows Friend
    final callerCall = CallModel(
      id: callerRecordId,
      callerName: _userController.name.value,
      callerAvatar: _userController.profileImage.value,
      receiverName: contact.name,
      receiverAvatar: contact.avatarUrl,
      time: 'Today, $timeParams',
      callType: CallType.outgoing,
      isVideoCall: isVideo,
      status: 'completed',
      userId: _authService.uid!,
    );

    await _addToHistory(callerCall);

    // 2. Receiver Record (Incoming) - Shows Me (Caller)
    if (contact.targetUserId != null && contact.targetUserId!.isNotEmpty) {
      final receiverCall = CallModel(
        id: receiverRecordId,
        callerName: _userController.name.value,
        callerAvatar: _userController.profileImage.value,
        // Hack: UI displays 'receiverName', so we put Caller Name here for the Receiver to see
        receiverName: _userController.name.value,
        receiverAvatar: _userController.profileImage.value,
        time: 'Today, $timeParams',
        callType: CallType.incoming,
        isVideoCall: isVideo,
        status:
            'missed', // Default to missed or completed? Let's say completed for sync test, or missed if not answered.
        // Real VOIP would update this. For now, 'completed' indicates a record exists.
        // Actually, 'missed' usually grabs attention better for "history".
        // But let's stick to 'completed' as "Call Log".
        userId: contact.targetUserId!,
      );

      await _addToHistory(receiverCall);
    }

    print("Call logs added for caller and receiver.");

    // Simulate call UI or logic here if needed
    Get.snackbar(
      'Calling',
      'Calling ${contact.name}...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> _addToHistory(CallModel call) async {
    try {
      await _firestore
          .collection('call_history')
          .doc(call.id)
          .set(call.toMap());
    } catch (e) {
      print('Error adding call to history: $e');
    }
  }

  Future<void> clearCallLogs() async {
    if (_authService.uid == null) return;

    try {
      final batch = _firestore.batch();
      final querySnapshot = await _firestore
          .collection('call_history')
          .where('userId', isEqualTo: _authService.uid)
          .get();

      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      print('Error clearing call logs: $e');
    }
  }

  Future<void> deleteCallLog(String callId) async {
    try {
      await _firestore.collection('call_history').doc(callId).delete();
      print("Deleted call log: $callId");
    } catch (e) {
      print('Error deleting call log: $e');
    }
  }
}
