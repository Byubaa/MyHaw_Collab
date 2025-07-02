import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';

class UserProfileService extends ChangeNotifier {
  UserProfile _userProfile;

  UserProfileService({
    required String initialEmail,
    required String initialName,
    String? initialProfilePictureUrl,
    DateTime? initialJoinDate,
  }) : _userProfile = UserProfile(
    email: initialEmail,
    name: initialName,
    profilePictureUrl: initialProfilePictureUrl,
    joinDate: initialJoinDate ?? DateTime.now(),
  );

  // Getter
  UserProfile get userProfile => _userProfile;

  String get email => _userProfile.email;
  String get name => _userProfile.name;
  String? get profilePictureUrl => _userProfile.profilePictureUrl;
  DateTime get joinDate => _userProfile.joinDate;

  // Setter Methods
  void updateProfile({String? name, String? email}) {
    if (name != null) _userProfile.name = name;
    if (email != null) _userProfile.email = email;
    notifyListeners();
  }

  void updateProfilePicture(String? newUrl) {
    _userProfile.profilePictureUrl = newUrl;
    notifyListeners();
  }

  void setEmail(String email) {
    _userProfile.email = email;
    notifyListeners();
  }

  void setName(String name) {
    _userProfile.name = name;
    notifyListeners();
  }
}
