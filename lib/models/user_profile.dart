class UserProfile {
  String name;
  String email;
  String? profilePictureUrl;
  DateTime joinDate;

  UserProfile({
    required this.name,
    required this.email,
    this.profilePictureUrl,
    required this.joinDate,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? profilePictureUrl,
    DateTime? joinDate,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      joinDate: joinDate ?? this.joinDate, // Salin joinDate
    );
  }
}