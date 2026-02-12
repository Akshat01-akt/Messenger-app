import 'dart:io';
import 'package:chat_app/data/models/contact_model.dart';
import 'package:chat_app/data/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class ContactController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  var contacts = <Contact>[].obs;
  var filteredContacts = <Contact>[].obs;


  @override
  void onInit() {
    super.onInit();
    // Listen for auth changes to setup contacts stream
    if (_authService.currentUser.value != null) {
      _bindContactsStream();
    }

    ever(_authService.currentUser, (user) {
      if (user != null) {
        _bindContactsStream();
      }
    });
  }

  void _bindContactsStream() {
    String uid = _authService.uid!;
    print("Binding contacts stream for User ID: $uid");

    contacts.bindStream(
      _firestore
          .collection('users')
          // .where('uid', isNotEqualTo: uid) // Optional: Exclude current user
          .snapshots()
          .map((query) {
            print("Users Stream Update: ${query.docs.length} docs found");
            return query.docs
                .where(
                  (doc) => doc.id != uid,
                ) // Exclude current user locally if query limitation exists
                .map((doc) {
                  final data = doc.data();
                  return Contact(
                    id: doc.id,
                    name: data['name'] ?? 'Unknown',
                    phoneNumber: data['phoneNumber'] ?? '',
                    email: data['email'] ?? '',
                    avatarUrl:
                        data['photoURL'] ??
                        'https://i.pravatar.cc/150?u=${doc.id}',
                    isOnline: false, // You could add online status logic later
                    targetUserId: doc.id, // THE USER ID IS THE TARGET
                  );
                })
                .toList();
          }),
    );
    // Also update filteredContacts when contacts change
    debounce(
      contacts,
      (_) {
        print("Contacts list updated. Total: ${contacts.length}");
        filterContacts('');
      },
      time: const Duration(milliseconds: 100),
    ); // Debounce to avoid rapid updates
  }

  Future<String?> _uploadContactImage(File file) async {
    try {
      String fileName = 'contacts/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference ref = _storage.ref().child(fileName);
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading contact image: $e');
      return null;
    }
  }

  Future<void> addContact(
    String name,
    String phone,
    File? imageFile, {
    String email = '',
  }) async {
    if (_authService.uid == null) return;

    String avatarUrl =
        'https://i.pravatar.cc/150?img=${(DateTime.now().millisecondsSinceEpoch % 70)}';
    String? targetUserId;

    // 1. Upload Image if provided
    if (imageFile != null) {
      String? uploadedUrl = await _uploadContactImage(imageFile);
      if (uploadedUrl != null) {
        avatarUrl = uploadedUrl;
      }
    }

    // 2. Check if a user with this email exists
    if (email.isNotEmpty) {
      try {
        final userQuery = await _firestore
            .collection('users')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

        if (userQuery.docs.isNotEmpty) {
          targetUserId = userQuery.docs.first.id;
          print("Found registered user for contact: $targetUserId");
        }
      } catch (e) {
        print("Error searching for user by email: $e");
      }
    }

    final newContact = Contact(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      phoneNumber: phone,
      avatarUrl: avatarUrl,
      isOnline: false,
      email: email,
      targetUserId: targetUserId,
    );

    try {
      await _firestore.collection('contacts').doc(newContact.id).set({
        ...newContact.toMap(),
        'userId': _authService.uid, // Link contact to the current user owner
      });
      print("Contact added to Firestore: ${newContact.name}");
    } catch (e) {
      print('Error adding contact to Firestore: $e');
    }
  }

  Future<void> updateContactPhoto(String contactId, File imageFile) async {
    try {
      String? uploadedUrl = await _uploadContactImage(imageFile);
      if (uploadedUrl != null) {
        await _firestore.collection('contacts').doc(contactId).update({
          'avatarUrl': uploadedUrl,
        });
        print("Contact photo updated for ID: $contactId");
      }
    } catch (e) {
      print('Error updating contact photo: $e');
    }
  }

  void filterContacts(String query) {
    if (query.isEmpty) {
      filteredContacts.assignAll(contacts);
    } else {
      filteredContacts.assignAll(
        contacts
            .where(
              (contact) =>
                  contact.name.toLowerCase().contains(query.toLowerCase()) ||
                  contact.phoneNumber.contains(query),
            )
            .toList(),
      );
    }
  }
}
