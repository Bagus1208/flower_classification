import 'package:firebase_auth/firebase_auth.dart';
import 'package:flower_classification/views/home_page.dart';
import 'package:flower_classification/views/info.dart';
import 'package:flower_classification/views/profile.dart';
import 'package:flutter/material.dart';
import 'package:flower_classification/classes/colors.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'riwayat.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

// import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PredictPage extends StatefulWidget {
  const PredictPage({super.key});

  @override
  State<PredictPage> createState() => _PredictPageState();
}

class _PredictPageState extends State<PredictPage> {
  File? _image;
  String? _prediction;
  double? _confidence;
  // Map<String, dynamic>? _allPredictions;
  bool _loading = false;

  final List<String> classLabels = [
    'astilbe',
    'bellflower',
    'black eyed susan',
    'calendula',
    'california poppy',
    'carnation',
    'common daisy',
    'coreopsis',
    'daffodil',
    'dandelion',
    'iris',
    'magnolia',
    'rose',
    'sunflower',
    'tulip',
    'water lily',
  ];

  late Interpreter _interpreter;
  bool _modelLoaded = false;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<String?> uploadToCloudinary(File imageFile) async {
    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/dfgvq2ydg/image/upload',
    );

    final request =
        http.MultipartRequest('POST', url)
          ..fields['upload_preset'] = 'flutter_upload'
          ..files.add(
            await http.MultipartFile.fromPath('file', imageFile.path),
          );

    final response = await request.send();
    final resBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final result = jsonDecode(resBody);
      return result['secure_url'];
    } else {
      print("Upload gagal: $resBody");
      return null;
    }
  }

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/model/classification_flowers.tflite',
      );
      setState(() {
        _modelLoaded = true;
      });
      print("Model loaded successfully");
    } catch (e) {
      print("Failed to load model: $e");
      showError("Gagal load model: $e");
    }
  }

  final picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      await predictImage(File(pickedFile.path));
    }
  }

  Future<void> predictImage(File imageFile) async {
    String? imageUrl = await uploadToCloudinary(imageFile);

    if (imageUrl == null) {
      showError("Gagal upload gambar");
      return;
    }

    if (!_modelLoaded || _interpreter == null) {
      showError("Model belum dimuat");
      return;
    }

    setState(() {
      _loading = true;
      _prediction = null;
      _confidence = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        showError('User not logged in');
        return;
      }

      // Decode image menggunakan package 'image'
      final rawBytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(rawBytes);
      if (image == null) {
        showError("Gagal decode gambar");
        return;
      }

      // Resize ke 150x150 (sesuai input model)
      final resizedImage = img.copyResize(image, width: 150, height: 150);

      // Normalisasi dan ubah ke format [1, 150, 150, 3]
      final input = List.generate(150, (y) {
        return List.generate(150, (x) {
          final pixel = resizedImage.getPixel(x, y);
          return [
            img.getRed(pixel) / 255.0,
            img.getGreen(pixel) / 255.0,
            img.getBlue(pixel) / 255.0,
          ];
        });
      });

      final inputTensor = [input]; // [1, 150, 150, 3]

      // Siapkan output buffer
      final output = List.filled(
        16,
        0.0,
      ).reshape([1, 16]); // Sesuaikan jumlah kelas

      // Jalankan model
      _interpreter!.run(inputTensor, output);

      // Ambil hasil dan analisis
      List<double> probabilities = List<double>.from(output[0]);
      final maxIdx = probabilities.indexWhere(
        (e) => e == probabilities.reduce((a, b) => a > b ? a : b),
      );
      final label = classLabels[maxIdx];
      final confidence = probabilities[maxIdx];

      // Simpan ke Firestore
      await FirebaseFirestore.instance.collection('prediction_history').add({
        'user_id': user.uid,
        'filename': imageFile.path.split('/').last,
        'predicted_class': label,
        'confidence': confidence,
        'timestamp': Timestamp.now(),
        'image_url': imageUrl,
        // 'all_predictions': {
        //   for (int i = 0; i < classLabels.length; i++)
        //     classLabels[i]: probabilities[i],
        // },
      });

      setState(() {
        _prediction = label;
        _confidence = confidence;
      });
    } catch (e) {
      showError("Error prediksi: $e");
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void showError(String message) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int _currentIndex = 2;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        // automaticallyImplyLeading: false,
        title: Text("Klasifikasi Jenis Bunga"),
        backgroundColor: greencolor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _image != null
                  ? Image.file(_image!)
                  : Image.asset(
                    'assets/images/Group 31.png',
                    width: 200,
                    height: 200,
                  ),
              //Text("No image selected."),
              SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: greencolor,
                  foregroundColor:
                      Colors.white, // Ganti warna latar belakang tombol
                ),
                icon: Icon(Icons.camera_alt),
                label: Text("Ambil Foto"),
                onPressed: () => pickImage(ImageSource.camera),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor:
                      greencolor, // Ganti warna latar belakang tombol
                ),
                icon: Icon(Icons.image),
                label: Text("Pilih dari Gallery"),
                onPressed: () => pickImage(ImageSource.gallery),
              ),
              SizedBox(height: 20),
              _loading
                  ? CircularProgressIndicator()
                  : _prediction != null
                  ? Column(
                    children: [
                      Text(
                        "Prediction: $_prediction",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        "Confidence: ${(_confidence! * 100).toStringAsFixed(2)}%",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 20),
                      //   if (_allPredictions != null) ...[
                      //     Text(
                      //       "All Predictions:",
                      //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      //         ),
                      // ..._allPredictions!.entries.map((entry) => Text(
                      //   "${entry.key}: ${(entry.value * 100).toStringAsFixed(2)}%",
                      // style: TextStyle(fontSize: 16),
                      //)),
                      // SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: greencolor,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HistoryPage(),
                            ),
                          );
                        },
                        child: Text("Lihat Riwayat"),
                      ),
                    ],
                  )
                  : Container(),
            ],
          ),
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
                pageBuilder:
                    (context, animation1, animation2) => const HistoryPage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          } else if (index == 3) {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder:
                    (context, animation1, animation2) => const InfoPage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          } else if (index == 4) {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder:
                    (context, animation1, animation2) => const ProfileView(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            label: 'Riwayat',
          ),
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
