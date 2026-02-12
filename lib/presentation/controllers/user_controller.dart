import 'dart:io';
import 'package:chat_app/data/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var name = 'John Doe'.obs;
  var phone = '+1 234 567 8900'.obs;
  var about = 'Hey there! I am using ChatApp 👋'.obs;
  var profileImage = 'https://i.pravatar.cc/200?img=12'.obs;

  @override
  void onInit() {
    super.onInit();
    ever(_authService.currentUser, (user) {
      if (user != null) {
        _loadUserProfile();
      }
    });
  }

  Future<void> _loadUserProfile() async {
    try {
      String uid = _authService.uid!;
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(uid)
          .get();

      if (doc.exists) {
        // Load existing data
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        name.value = data['name'] ?? name.value;
        phone.value = data['phone'] ?? phone.value;
        about.value = data['about'] ?? about.value;
        // Backward compatibility: check photoURL first, then profileImage
        profileImage.value =
            data['photoURL'] ?? data['profileImage'] ?? profileImage.value;
      } else {
        // Create new user doc with default data
        await _firestore.collection('users').doc(uid).set({
          'name': name.value,
          'phone': phone.value,
          'about': about.value,
          'photoURL': profileImage.value,
        });
      }
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  Future<void> updateProfile(
    String newName,
    String newPhone,
    String newAbout,
  ) async {
    name.value = newName;
    phone.value = newPhone;
    about.value = newAbout;

    if (_authService.uid != null) {
      try {
        await _firestore.collection('users').doc(_authService.uid).update({
          'name': newName,
          'phone': newPhone,
          'about': newAbout,
        });
      } catch (e) {
        print('Error updating profile in Firestore: $e');
      }
    }
  }

  Future<void> updateProfileImage(String newUrl) async {
    profileImage.value = newUrl;
    if (_authService.uid != null) {
      try {
        await _firestore.collection('users').doc(_authService.uid).update({
          'photoURL': newUrl,
        });
      } catch (e) {
        print('Error updating profile image in Firestore: $e');
      }
    }
  }

  // Returns true if upload successful, false otherwise
  Future<bool> uploadProfileImage(File imageFile) async {
    if (_authService.uid == null) return false;

    try {
      String uid = _authService.uid!;
      String fileName =
          'profile_images/$uid/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = FirebaseStorage.instance.ref().child(fileName);

      await ref.putFile(imageFile);
      String downloadUrl = await ref.getDownloadURL();

      await updateProfileImage(downloadUrl);
      return true;
    } catch (e) {
      print('Error uploading profile image: $e');
      Get.snackbar(
        'Error',
        'Failed to upload image',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }
}
