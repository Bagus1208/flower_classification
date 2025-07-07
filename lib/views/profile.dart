import 'dart:io';
import 'dart:convert';
import 'package:flower_classification/views/info.dart';
import 'package:flower_classification/views/predict_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flower_classification/views/home_page.dart';
import 'package:flower_classification/views/riwayat.dart';
import 'package:flower_classification/classes/colors.dart';
import 'package:flower_classification/views/login.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _loading = false;
  String? _username;
  User? user = FirebaseAuth.instance.currentUser;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _pickImageAndUploadToCloudinary() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      setState(() => _loading = true);
      
      File imageFile = File(pickedFile.path);
      String cloudinaryUploadUrl = "https://api.cloudinary.com/v1_1/dfgvq2ydg/image/upload";
      String uploadPreset = "flutter_upload";

      var request = http.MultipartRequest('POST', Uri.parse(cloudinaryUploadUrl));
      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));
      request.fields['upload_preset'] = uploadPreset;

      var response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final data = json.decode(responseData.body);
        final imageUrl = data['secure_url'];

        // Update ke Firebase Auth dan Firestore dalam satu batch
        await Future.wait([
          user!.updatePhotoURL(imageUrl),
          FirebaseFirestore.instance.collection('users').doc(user!.uid).set(
            {'photoUrl': imageUrl},
            SetOptions(merge: true)
          ),
        ]);
        
        await user!.reload();
        user = FirebaseAuth.instance.currentUser;

        setState(() => _imageFile = imageFile);
      } else {
        throw Exception('Failed to upload image: ${responseData.body}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadUserData() async {
    if (user == null) return;

    try {
      setState(() => _loading = true);
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      if (mounted) {
        setState(() {
          _username = doc.data()?['username'] ?? 
                     user!.displayName ?? 
                     user!.email?.split('@').first ?? 
                     'Pengguna';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _editUsername() async {
    final controller = TextEditingController(text: _username ?? '');

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Username'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Masukkan username baru',
            border: OutlineInputBorder(),
          ),
          maxLength: 20,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final newUsername = controller.text.trim();
              if (newUsername.isEmpty || newUsername.length < 3) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Username minimal 3 karakter')),
                );
                return;
              }
              Navigator.pop(context, newUsername);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );

    if (result != null) {
      try {
        setState(() => _loading = true);
        
        await Future.wait([
          user!.updateDisplayName(result),
          FirebaseFirestore.instance.collection('users').doc(user!.uid).set(
            {'username': result},
            SetOptions(merge: true)
          ),
        ]);
        
        await user!.reload();
        
        if (mounted) {
          setState(() => _username = result);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal update username: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) setState(() => _loading = false);
      }
    }
  }

  ImageProvider _getProfileImage() {
    if (user?.photoURL != null) {
      return NetworkImage(user!.photoURL!);
    }
    return const AssetImage('assets/images/profile.jpg');
  }

  @override
  Widget build(BuildContext context) {
    int _currentIndex = 4;
    
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: greencolor,
        title: const Text(
          'Profil', 
          style: TextStyle(fontSize: 20, color: Colors.white)
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Konfirmasi Logout'),
                  content: const Text('Anda yakin ingin keluar?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Keluar'),
                    ),
                  ],
                ),
              );
              
              if (confirm == true) {
                await FirebaseAuth.instance.signOut();
                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginView()),
                    (route) => false,
                  );
                }
              }
            },
          ),
        ],
      ),

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: _getProfileImage(),
                      ),
                      FloatingActionButton.small(
                        backgroundColor: Colors.white,
                        onPressed: _pickImageAndUploadToCloudinary,
                        child: Icon(Icons.camera_alt, color: greencolor),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(_username ?? 'Memuat...'),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: _editUsername,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.email),
                      title: Text(user?.email ?? 'Tidak ada email'),
                    ),
                  ),
                ],
              ),
            ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: greencolor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _currentIndex,
        onTap: (int index) {
          if (index == 0) {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => HomePage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          } else if (index == 1) {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => const HistoryPage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          } else if (index == 2) {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder:
                    (context, animation1, animation2) => const PredictPage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }else if (index == 3) {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder:
                    (context, animation1, animation2) => const InfoPage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Riwayat'),
            BottomNavigationBarItem(
            icon: Icon(Icons.center_focus_strong_rounded),
            label: 'Klasifikasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement_rounded),
            label: 'Info',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}