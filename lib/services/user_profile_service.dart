// lib/services/user_profile_service.dart
import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class UserProfileService extends ChangeNotifier {
  UserProfile _userProfile;

  UserProfileService({required String initialEmail, String? initialName})
      : _userProfile = UserProfile(
    name: initialName ?? initialEmail.split('@')[0],
    email: initialEmail,
    profilePictureUrl: null,
    joinDate: DateTime.now(), // Inisialisasi tanggal bergabung
  );

  UserProfile get userProfile => _userProfile;

  void updateProfile({String? name, String? email, String? profilePictureUrl, DateTime? joinDate}) {
    _userProfile = _userProfile.copyWith(
      name: name,
      email: email,
      profilePictureUrl: profilePictureUrl,
      joinDate: joinDate,
    );
    notifyListeners();
  }

  void updateProfilePicture(String? newUrl) {
    _userProfile = _userProfile.copyWith(profilePictureUrl: newUrl);
    notifyListeners();
  }
}