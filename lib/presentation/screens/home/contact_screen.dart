import 'dart:io';

import 'package:chat_app/data/models/contact_model.dart';
import 'package:chat_app/presentation/controllers/contact_controller.dart';
import 'package:chat_app/presentation/controllers/call_controller.dart';
import 'package:chat_app/data/models/chat_model.dart';
import 'package:chat_app/presentation/screens/home/chat_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ContactsScreen extends StatelessWidget {
  ContactsScreen({super.key});

  final ContactController _contactController = Get.find<ContactController>();
  final TextEditingController _searchController = TextEditingController();

  Future<void> _pickImage(
    BuildContext context,
    Function(File) onImagePicked,
  ) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      onImagePicked(File(image.path));
    }
  }

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
          'Contacts',
          style: TextStyle(
            color: theme.appBarTheme.foregroundColor,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_add, color: theme.iconTheme.color),
            onPressed: () {
              _showAddContactDialog(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: theme.iconTheme.color),
            onPressed: () {

            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: theme.scaffoldBackgroundColor,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              controller: _searchController,
              onChanged: _contactController.filterContacts,
              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
              decoration: InputDecoration(
                hintText: 'Search contacts...',
                hintStyle: TextStyle(color: Colors.grey[500]),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    _contactController.filterContacts('');
                  },
                ),
                filled: true,
                fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Contacts List
          Expanded(
            child: Obx(() {
              if (_contactController.filteredContacts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      const Text(
                        'No contacts found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              // Group contacts by first letter
              Map<String, List<Contact>> groupedContacts = {};
              for (var contact in _contactController.filteredContacts) {
                String firstLetter = contact.name.isNotEmpty
                    ? contact.name[0].toUpperCase()
                    : '#';
                if (!groupedContacts.containsKey(firstLetter)) {
                  groupedContacts[firstLetter] = [];
                }
                groupedContacts[firstLetter]!.add(contact);
              }

              List<String> sortedKeys = groupedContacts.keys.toList()..sort();

              return ListView.builder(
                itemCount: sortedKeys.length,
                itemBuilder: (context, index) {
                  String letter = sortedKeys[index];
                  List<Contact> contacts = groupedContacts[letter]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Header
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        color: isDark
                            ? const Color(0xFF1E1E1E)
                            : Colors.grey[100], // Visual separation
                        width: double.infinity,
                        child: Text(
                          letter,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6C63FF),
                          ),
                        ),
                      ),
                      // Contacts in this section
                      ...contacts.map(
                        (contact) => _buildContactItem(context, contact),
                      ),
                    ],
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(BuildContext context, Contact contact) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: ListTile(
        leading: GestureDetector(
          onTap: () {
            // _showUpdatePhotoDialog(context, contact); // Disable photo update for other users
          },
          child: Stack(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey[300],
                backgroundImage: NetworkImage(contact.avatarUrl),
              ),
              if (contact.isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00D4AA),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).cardColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        title: Text(
          contact.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        subtitle: Text(
          contact.phoneNumber.isNotEmpty ? contact.phoneNumber : contact.email,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey,
          ),
        ),
        onTap: () {
          // Navigate to Chat
          final chat = Chat(
            id: contact.id,
            name: contact.name,
            message: '',
            time: '',
            avatarUrl: contact.avatarUrl,
            isOnline: contact.isOnline,
            targetUserId: contact.targetUserId,
          );

          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ChatDetailScreen(chat: chat)),
          );
        },
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.videocam, color: Color(0xFF6C63FF)),
              onPressed: () {
                Get.find<CallController>().makeCall(contact, true);
              },
            ),
            IconButton(
              icon: const Icon(Icons.call, color: Color(0xFF00D4AA)),
              onPressed: () {
                Get.find<CallController>().makeCall(contact, false);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddContactDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController emailController =
        TextEditingController(); // Added email controller
    Rx<File?> pickedImage = Rx<File?>(null);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          title: Text(
            'Add New Contact',
            style: TextStyle(
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    await _pickImage(context, (file) {
                      pickedImage.value = file;
                    });
                  },
                  child: Obx(() {
                    return CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: pickedImage.value != null
                          ? FileImage(pickedImage.value!)
                          : null,
                      child: pickedImage.value == null
                          ? const Icon(
                              Icons.camera_alt,
                              size: 30,
                              color: Colors.grey,
                            )
                          : null,
                    );
                  }),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Name',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Email (Optional)',
                    hintText: 'Link to existing user',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    phoneController.text.isNotEmpty) {
                  _contactController.addContact(
                    nameController.text,
                    phoneController.text,
                    pickedImage.value,
                    email: emailController.text.trim(),
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
              ),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showUpdatePhotoDialog(BuildContext context, Contact contact) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Contact Photo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pick from Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(context, (file) {
                    _contactController.updateContactPhoto(contact.id, file);
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () async {
                  // Implement camera logic if needed, reusing _pickImage for now (gallery default)
                  Navigator.pop(context);
                  await _pickImage(context, (file) {
                    _contactController.updateContactPhoto(contact.id, file);
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
