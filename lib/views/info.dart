import 'package:flower_classification/classes/colors.dart';
import 'package:flower_classification/views/home_page.dart';
import 'package:flower_classification/views/predict_page.dart';
import 'package:flower_classification/views/profile.dart';
import 'package:flower_classification/views/riwayat.dart';
import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    int _currentIndex = 3; // Set the current index to 2 for InfoPage
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Informasi Aplikasi',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: greencolor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Aplikasi Klasifikasi Bunga',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Aplikasi ini digunakan untuk mengklasifikasikan berbagai jenis bunga menggunakan teknologi machine learning.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Divider(
                color: Colors.grey,
                thickness: 1,
                height: 20, // jarak vertikal
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/sabdha.jpg'),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Developer 1:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.person, color: greencolor),
                          SizedBox(width: 8),
                          const Text('Sabdha Putra Laudri'),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.mail_outline_rounded, color: greencolor),
                          SizedBox(width: 8),
                          Text('sabdhacipaku04@gmail.com'),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.menu_book_sharp, color: greencolor),
                          SizedBox(width: 8),
                          const Text('Npm: 202143501480'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              Divider(
                color: Colors.grey,
                thickness: 1,
                height: 20, // jarak vertikal
              ),

              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/bagus.jpeg'),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Developer 2:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.person, color: greencolor),
                          SizedBox(width: 8),
                          const Text('Bagus Ario Yudanto'),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.mail_outline_rounded, color: greencolor),
                          SizedBox(width: 8),
                          const Text('bagusarioyudanto123@gmail\n.com'),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.menu_book_sharp, color: greencolor),
                          SizedBox(width: 8),
                          const Text('Npm: 202143501465'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Divider(
                color: Colors.grey,
                thickness: 1,
                height: 20, // jarak vertikal
              ),

              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/kelvin.jpeg'),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Developer 3:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.person, color: greencolor),
                          SizedBox(width: 8),
                          const Text('Kelvin Dodi'),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.mail_outline_rounded, color: greencolor),
                          SizedBox(width: 8),
                          const Text('kelvinsap73@gmail.com'),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.menu_book_sharp, color: greencolor),
                          SizedBox(width: 8),
                          const Text('Npm: 202143501460'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
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
          } else if (index == 2) {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder:
                    (context, animation1, animation2) => const PredictPage(),
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
