// lib/screens/profil_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show File;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/user_profile_service.dart';
import '../models/user_profile.dart';
import 'login_screen.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {

  Future<void> _pickAndUploadImage(UserProfileService service, ImageSource source) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source, imageQuality: 50, maxWidth: 800);

    if (image == null) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Tidak ada foto yang dipilih.')),
      );
      return;
    }

    try {
      final bytes = await image.readAsBytes();
      final fileExt = image.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final userId = Supabase.instance.client.auth.currentUser!.id;
      final filePath = '$userId/$fileName';

      await Supabase.instance.client.storage.from('avatars').uploadBinary(
        filePath,
        bytes,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
      );

      final imageUrl = Supabase.instance.client.storage.from('avatars').getPublicUrl(filePath);

      // ✅ MENGGUNAKAN UPSERT, BUKAN UPDATE
      // Ini akan membuat profil jika belum ada, atau memperbaruinya jika sudah ada.
      await Supabase.instance.client.from('profiles').upsert({
        'id': userId,
        'avatar_url': imageUrl,
        'username': service.userProfile.name // Pastikan username juga tersimpan
      });

      service.updateProfilePicture(imageUrl);

      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Foto profil berhasil diubah!')),
      );

    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Gagal mengunggah foto: ${e.toString()}')),
      );
    }
  }

  void _showEditNameDialog(UserProfileService service, String currentValue) {
    final TextEditingController controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (dialogContext) {
        final navigator = Navigator.of(dialogContext);
        final scaffoldMessenger = ScaffoldMessenger.of(context);

        return AlertDialog(
          title: const Text('Edit Nama Lengkap'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Nama Lengkap',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.text,
          ),
          actions: [
            TextButton(
              onPressed: () => navigator.pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (controller.text.isNotEmpty) {
                  final userId = Supabase.instance.client.auth.currentUser!.id;

                  // ✅ MENGGUNAKAN UPSERT DI SINI JUGA
                  await Supabase.instance.client.from('profiles').upsert({
                    'id': userId,
                    'username': controller.text,
                  });

                  service.updateProfile(name: controller.text);
                  navigator.pop();
                } else {
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text('Nama tidak boleh kosong!')),
                  );
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showChangePhotoOptions(UserProfileService service) {
    showModalBottomSheet(
      context: context,
      builder: (bottomSheetContext) {
        final navigator = Navigator.of(bottomSheetContext);

        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pilih dari Galeri'),
                onTap: () {
                  navigator.pop();
                  _pickAndUploadImage(service, ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Ambil dari Kamera'),
                onTap: () {
                  navigator.pop();
                  _pickAndUploadImage(service, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Hapus Foto Profil'),
                onTap: () async {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  final userId = Supabase.instance.client.auth.currentUser!.id;

                  await Supabase.instance.client
                      .from('profiles')
                      .upsert({'id': userId, 'avatar_url': null});

                  service.updateProfilePicture(null);

                  navigator.pop();
                  scaffoldMessenger.showSnackBar(
                      const SnackBar(content: Text('Foto profil dihapus!')));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget build tidak ada perubahan
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileService>(
      builder: (context, userProfileService, child) {
        final UserProfile user = userProfileService.userProfile;

        ImageProvider<Object>? profileImageProvider;
        if (user.profilePictureUrl != null && user.profilePictureUrl!.isNotEmpty) {
          if (user.profilePictureUrl!.startsWith('http')) {
            profileImageProvider = NetworkImage(user.profilePictureUrl!);
          } else if (!kIsWeb) {
            try {
              final File imageFile = File(user.profilePictureUrl!);
              if (imageFile.existsSync()) {
                profileImageProvider = FileImage(imageFile);
              }
            } catch (e) {
              debugPrint('Error loading local file image: $e');
            }
          }
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Profil')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _showChangePhotoOptions(userProfileService);
                  },
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.blueGrey.shade100,
                    backgroundImage: profileImageProvider,
                    child: profileImageProvider == null
                        ? const Icon(Icons.person, size: 80, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  user.name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  user.email,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 30),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person_outline, color: Colors.blue),
                          title: const Text('Nama Lengkap', style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(user.name),
                          trailing: const Icon(Icons.edit, color: Colors.grey),
                          onTap: () {
                            _showEditNameDialog(userProfileService, user.name);
                          },
                        ),
                        const Divider(indent: 16, endIndent: 16),
                        ListTile(
                          leading: const Icon(Icons.email_outlined, color: Colors.blue),
                          title: const Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(user.email),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    await Supabase.instance.client.auth.signOut();

                    navigator.pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (Route<dynamic> route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Logout'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}