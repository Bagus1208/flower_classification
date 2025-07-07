import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flower_classification/classes/flower.dart';
import 'package:flower_classification/views/info.dart';
import 'package:flower_classification/views/predict_page.dart';
import 'package:flutter/material.dart';
import 'package:flower_classification/views/home_page.dart';
import 'package:flower_classification/classes/colors.dart';
import 'package:flower_classification/views/profile.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<dynamic> _history = [];

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }
  
Future<Flower?> fetchFlowerDetail(String predictedClass) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('flowers')
      .where('nama', isEqualTo: predictedClass)
      .limit(1)
      .get();

  if (snapshot.docs.isNotEmpty) {
    final doc = snapshot.docs.first;
    return Flower.fromFirestore(doc.id, doc.data());
  }
  return null;
}

Future<void> _fetchHistory() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showError('User not logged in');
      return;
    }

    final querySnapshot = await FirebaseFirestore.instance
        .collection('prediction_history')
        .where('user_id', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .get();

    final List<dynamic> fetchedData = querySnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      data['timestamp'] =
          (data['timestamp'] as Timestamp).toDate().toString().split(' ')[0]; // Format: YYYY-MM-DD
      return data;
    }).toList();

    setState(() {
      _history = fetchedData;
    });
  } catch (e) {
    _showError('Gagal mengambil data riwayat: $e');
  }
}

Future<void> _deleteHistoryItem(String id) async {
  try {
    final docRef = FirebaseFirestore.instance.collection('prediction_history').doc(id);
    final doc = await docRef.get();

    if (doc.exists) {
      await docRef.delete();
      _fetchHistory(); // Refresh list
    } else {
      _showError('Data tidak ditemukan');
    }
  } catch (e) {
    _showError('Gagal menghapus data: $e');
  }
}


  void _showError(String message) {
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

  // void _showDetailDialog(dynamic item) {
  //   showDialog(
  //     context: context,
  //     builder:
  //         (_) => AlertDialog(
  //           title: const Text('Detail Riwayat'),
  //           content: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Image.network(
  //                 item['image_url'],
  //                 height: 150,
  //                 errorBuilder:
  //                     (context, error, stackTrace) => const Icon(
  //                       Icons.broken_image,
  //                       size: 50,
  //                       color: Colors.grey,
  //                     ),
  //               ),
  //               const SizedBox(height: 10),
  //               Text(
  //                 'Filename: ${item['filename']}',
  //                 style: TextStyle(fontWeight: FontWeight.bold),
  //               ),
  //               Text('Predicted Class: ${item['predicted_class']}'),
  //               Text(
  //                 'Confidence: ${(item['confidence'] * 100).toStringAsFixed(2)}%',
  //               ),
  //               Text('Timestamp: ${item['timestamp']}'),
  //               // Text(
  //               //   'All Predictions:',
  //               //   style: TextStyle(fontWeight: FontWeight.bold),
  //               // ),
  //               // ...item['all_predictions'].entries.map<Widget>((entry) {
  //               //   return Text(
  //               //     '${entry.key}: ${(entry.value * 100).toStringAsFixed(2)}%',
  //               //     style: TextStyle(fontSize: 14),
  //               //   );
  //               // }).toList(),
  //             ],
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: const Text('Tutup'),
  //             ),
  //             // TextButton(
  //             //   onPressed: () => _generatePDF(item),
  //             //   child: const Text('Download PDF'),
  //             // ),
  //           ],
  //         ),
  //   );
  // }

void _showDetailDialog(dynamic item) async {
  Flower? flowerDetail = await fetchFlowerDetail(item['predicted_class']);

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(item['predicted_class']),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              item['image_url'],
              height: 150,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 50, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              'Filename: ${item['filename']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Confidence: ${(item['confidence'] * 100).toStringAsFixed(2)}%'),
            Text('Timestamp: ${item['timestamp']}'),
            const SizedBox(height: 10),
            if (flowerDetail != null) ...[
              const Divider(),
              const Text(
                'Deskripsi:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(flowerDetail.deskripsi),
              const SizedBox(height: 8),
              const Text(
                'Manfaat:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...flowerDetail.manfaat.map((m) => Text('• $m')).toList(),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Tutup'),
        ),
      ],
    ),
  );
}

  int _currentPage = 0;
  final int itemsPerPage = 4;

  int get totalPages => (_history.length / itemsPerPage).ceil();

  List<Widget> _buildPageIndicators() {
    List<Widget> widgets = [];

    // Tombol ke halaman 1
    widgets.add(_buildPageNumber(0));

    // Titik-titik sebelum currentPage
    if (_currentPage > 2) {
      widgets.add(
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text('..'),
        ),
      );
    }

    // Halaman sebelumnya (jika bukan halaman pertama atau kedua)
    if (_currentPage != 0 && _currentPage < totalPages - 1) {
      widgets.add(_buildPageNumber(_currentPage));
    }

    // Titik-titik setelah currentPage
    if (_currentPage < totalPages - 3) {
      widgets.add(
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text('..'),
        ),
      );
    }

    // Tombol ke halaman terakhir
    if (totalPages > 1) {
      widgets.add(_buildPageNumber(totalPages - 1));
    }

    return widgets;
  }

  Widget _buildPageNumber(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentPage = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Text(
          '${index + 1}',
          style: TextStyle(
            fontWeight:
                _currentPage == index ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
            color: _currentPage == index ? greencolor : Colors.black,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int _currentIndex = 1;

    final int startIndex = _currentPage * itemsPerPage;
    final int endIndex = (_currentPage + 1) * itemsPerPage;
    final List _pagedItems = _history.sublist(
      startIndex,
      endIndex > _history.length ? _history.length : endIndex,
    );
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: greencolor,
        title: Text(
          "Riwayat Klasifikasi Jenis Bunga",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body:
          _history.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _pagedItems.length,
                      itemBuilder: (context, index) {
                        var historyItem = _pagedItems[index];
                        return InkWell(
                          onTap: () {
                            _showDetailDialog(historyItem);
                          },
                          child: Card(
                            margin: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                // Gambar di kiri
                                Container(
                                  width: 100,
                                  height: 100,
                                  margin: const EdgeInsets.all(8),
                                  child: Image.network(
                                    historyItem['image_url'],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.broken_image,
                                        size: 50,
                                        color: Colors.grey,
                                      );
                                    },
                                  ),
                                ),
                                // Teks di kanan
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Filename: ${historyItem['filename']}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Predicted: ${historyItem['predicted_class']}',
                                      ),
                                      Text(
                                        'Confidence: ${(historyItem['confidence'] * 100).toStringAsFixed(2)}%',
                                      ),
                                      Text(
                                        'Timestamp: ${historyItem['timestamp']}',
                                      ),
                                    ],
                                  ),
                                ),
                                // Tombol hapus
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed:
                                      () => _confirmDelete(historyItem['id']),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Tombol pagination
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Tombol panah kiri
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed:
                              _currentPage > 0
                                  ? () {
                                    setState(() {
                                      _currentPage--;
                                    });
                                  }
                                  : null,
                        ),
                        // Nomor halaman (dengan logika singkat)
                        ..._buildPageIndicators(),
                        // Tombol panah kanan
                        IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed:
                              (_currentPage + 1) * itemsPerPage <
                                      _history.length
                                  ? () {
                                    setState(() {
                                      _currentPage++;
                                    });
                                  }
                                  : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: greencolor,
        selectedItemColor: Colors.white, // Warna item aktif
        unselectedItemColor: Colors.white70,
        currentIndex: _currentIndex,
        onTap: (int index) {
          if (index == 0) {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder:
                    (context, animation1, animation2) =>
                        HomePage(),
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

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Confirm Delete'),
            content: Text('Are you sure you want to delete this record?'),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text('Delete'),
                onPressed: () {
                  Navigator.pop(context);
                  _deleteHistoryItem(id);
                },
              ),
            ],
          ),
    );
  }
}
