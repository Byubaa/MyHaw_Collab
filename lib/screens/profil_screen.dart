// lib/screens/profil_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // Import kIsWeb

// Import dart:io HANYA jika bukan web
import 'dart:io' show File;

import '../services/user_profile_service.dart';
import '../models/user_profile.dart';
import 'login_screen.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  final String _staticPhoneNumber = '083845103335';

  String _formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy').format(date); // Format tanggal
  }

  Future<void> _pickImage(BuildContext context, UserProfileService service, ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      service.updateProfilePicture(image.path);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Foto profil berhasil diubah dari ${source == ImageSource.gallery ? "galeri" : "kamera"}!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada foto yang dipilih.')),
      );
    }
    // Tidak perlu Navigator.pop(context) di sini karena _showChangePhotoOptions akan menutup bottom sheet
  }

  void _showEditNameDialog(BuildContext context, UserProfileService service, String currentValue) {
    final TextEditingController controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                service.updateProfile(name: controller.text);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nama tidak boleh kosong!')),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showChangePhotoOptions(BuildContext context, UserProfileService service) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pilih dari Galeri'),
                onTap: () => _pickImage(context, service, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Ambil Foto Baru'),
                onTap: () => _pickImage(context, service, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Hapus Foto Profil'),
                onTap: () {
                  Navigator.pop(context); // Tutup bottom sheet
                  service.updateProfilePicture(null);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Foto profil dihapus!')));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileService>(
      builder: (context, userProfileService, child) {
        final UserProfile user = userProfileService.userProfile;

        ImageProvider<Object>? profileImageProvider;
        if (user.profilePictureUrl != null && user.profilePictureUrl!.isNotEmpty) {
          if (user.profilePictureUrl!.startsWith('http://') || user.profilePictureUrl!.startsWith('https://') || kIsWeb) {
            // Ini adalah URL jaringan atau di web (termasuk blob: URL dari image_picker di web)
            profileImageProvider = NetworkImage(user.profilePictureUrl!);
          } else {
            // Jika bukan web dan bukan URL jaringan, asumsikan ini adalah path file lokal
            try {
              final File imageFile = File(user.profilePictureUrl!);
              if (imageFile.existsSync()) {
                profileImageProvider = FileImage(imageFile);
              } else {
                profileImageProvider = null; // Fallback jika file tidak ditemukan
              }
            } catch (e) {
              profileImageProvider = null;
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
                    _showChangePhotoOptions(context, userProfileService);
                  },
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.blueGrey,
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
                  elevation: 4,
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
                            _showEditNameDialog(context, userProfileService, user.name);
                          },
                        ),
                        const Divider(indent: 16, endIndent: 16),
                        ListTile(
                          leading: const Icon(Icons.email_outlined, color: Colors.blue),
                          title: const Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(user.email),
                        ),
                        const Divider(indent: 16, endIndent: 16),
                        ListTile(
                          leading: const Icon(Icons.phone, color: Colors.blue),
                          title: const Text('Nomor Telepon', style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(_staticPhoneNumber),
                        ),
                        const Divider(indent: 16, endIndent: 16),
                        ListTile(
                          leading: const Icon(Icons.date_range, color: Colors.blue),
                          title: const Text('Tanggal Bergabung', style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(_formatDate(user.joinDate)),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
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