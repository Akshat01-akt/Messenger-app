import 'package:chat_app/presentation/controllers/call_controller.dart';
import 'package:chat_app/data/models/call_model.dart';
import 'package:chat_app/data/models/contact_model.dart'; // For Contact class in retry logic
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CallsScreen extends StatefulWidget {
  const CallsScreen({super.key});

  @override
  _CallsScreenState createState() => _CallsScreenState();
}

class _CallsScreenState extends State<CallsScreen> {
  final CallController _callController = Get.find<CallController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Text(
          'Calls',
          style: TextStyle(
            color: theme.appBarTheme.foregroundColor,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: theme.iconTheme.color),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: theme.iconTheme.color),
            onPressed: () => _showCallOptions(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Create Link Button
          Container(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: InkWell(
              onTap: () {
                // Create call link
              },
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFF6C63FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.link,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create call link',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        Text(
                          'Share a link for your call',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Divider(height: 1, thickness: 1, color: theme.dividerColor),

          // Recent Calls Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: isDark ? Colors.black26 : Colors.grey[100],
            width: double.infinity,
            child: const Text(
              'Recent',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6C63FF),
              ),
            ),
          ),

          // Calls List
          Expanded(
            child: Obx(() {
              if (_callController.calls.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.call_end, size: 80, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      const Text(
                        'No recent calls',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: _callController.calls.length,
                itemBuilder: (context, index) {
                  return _buildCallLogItem(
                    context,
                    _callController.calls[index],
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCallDialog(context);
        },
        backgroundColor: const Color(0xFF6C63FF),
        child: const Icon(Icons.add_call, color: Colors.white),
      ),
    );
  }

  Widget _buildCallLogItem(BuildContext context, CallModel callLog) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dismissible(
      key: Key(callLog.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        _callController.deleteCallLog(callLog.id);
      },
      child: Container(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: isDark ? Colors.grey[700] : Colors.grey[300],
            backgroundImage: NetworkImage(
              callLog.receiverAvatar,
            ), // Show receiver avatar for outgoing
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  callLog.receiverName, // Show receiver name for outgoing
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: callLog.status == 'missed'
                        ? Colors.red
                        : theme.textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  callLog.isVideoCall ? Icons.videocam : Icons.call,
                  color: const Color(0xFF6C63FF),
                ),
                onPressed: () {
                  // Make call again
                  _callController.makeCall(
                    Contact(
                      id: '',
                      name: callLog.receiverName,
                      phoneNumber: '',
                      avatarUrl: callLog.receiverAvatar,
                      isOnline: false,
                    ), // simplified contact for retry
                    callLog.isVideoCall,
                  );
                },
              ),
            ],
          ),
          subtitle: Row(
            children: [
              Icon(
                _getCallIcon(callLog),
                size: 16,
                color: callLog.status == 'missed' ? Colors.red : Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                callLog.time,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              if (callLog.duration != null) ...[
                const Text(' • ', style: TextStyle(color: Colors.grey)),
                Text(
                  callLog.duration!,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.grey),
            onPressed: () => _showCallDetails(context, callLog),
          ),
        ),
      ),
    );
  }

  IconData _getCallIcon(CallModel callLog) {
    if (callLog.status == 'missed') {
      return Icons.call_missed;
    } else if (callLog.callType == CallType.incoming) {
      return Icons.call_received;
    } else {
      return Icons.call_made;
    }
  }

  void _showCallOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.clear_all),
                title: const Text('Clear call log'),
                onTap: () {
                  Navigator.pop(context);
                  _callController.clearCallLogs();
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Call settings'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCallDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text('New Call'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.call, color: Color(0xFF6C63FF)),
                title: Text('Voice Call'),
                onTap: () {
                  Navigator.pop(context);
                  // Start voice call
                },
              ),
              ListTile(
                leading: Icon(Icons.videocam, color: Color(0xFF6C63FF)),
                title: Text('Video Call'),
                onTap: () {
                  Navigator.pop(context);
                  // Start video call
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCallDetails(BuildContext context, CallModel callLog) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: NetworkImage(callLog.receiverAvatar),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          callLog.receiverName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          callLog.isVideoCall ? 'Video Call' : 'Voice Call',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildDetailRow('Time', callLog.time),
              if (callLog.duration != null)
                _buildDetailRow('Duration', callLog.duration!),
              _buildDetailRow(
                'Type',
                callLog.callType == CallType.incoming ? 'Incoming' : 'Outgoing',
              ),
              _buildDetailRow(
                'Status',
                callLog.status == 'missed' ? 'Missed' : 'Completed',
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        // Call back
                        _callController.makeCall(
                          Contact(
                            id: '',
                            name: callLog.receiverName,
                            phoneNumber: '',
                            avatarUrl: callLog.receiverAvatar,
                            isOnline: false,
                          ),
                          callLog.isVideoCall,
                        );
                      },
                      icon: const Icon(Icons.call),
                      label: const Text('Call Back'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        // Message
                      },
                      icon: const Icon(Icons.message),
                      label: const Text('Message'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF6C63FF),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Color(0xFF6C63FF)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
