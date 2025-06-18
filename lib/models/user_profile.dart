// lib/models/user_profile.dart
class UserProfile {
  String name;
  String email;
  String? profilePictureUrl; // Bisa null jika belum ada foto profil
  DateTime joinDate; // Tambahkan properti tanggal bergabung

  UserProfile({
    required this.name,
    required this.email,
    this.profilePictureUrl,
    required this.joinDate, // Wajib diisi
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? profilePictureUrl,
    DateTime? joinDate, // Tambahkan di copyWith
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      joinDate: joinDate ?? this.joinDate, // Salin joinDate
    );
  }
}