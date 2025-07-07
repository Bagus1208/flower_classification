import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flower_classification/classes/flower.dart';
import 'package:flower_classification/views/predict_page.dart';
import 'package:flower_classification/widgets/flower_card.dart';
import 'package:flutter/material.dart';
import 'package:flower_classification/views/profile.dart';
import 'package:flower_classification/views/riwayat.dart';
import 'package:flower_classification/classes/colors.dart';
import 'package:flower_classification/views/info.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Flower> flowers = [];
  final db = FirebaseFirestore.instance;
  int _currentIndex = 0;

  void getFlowers() async {
    final result =
        await db.collection('flowers').orderBy('nama', descending: false).get();
    print('data length : ${result.docs.length}');
    setState(() {
      flowers =
          result.docs.map((doc) {
            return Flower.fromFirestore(doc.id, doc.data());
          }).toList();
    });
  }

  @override
  void initState() {
    getFlowers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final width = size.height > size.width ? size.width : size.height;
    final height = size.height > size.width ? size.height : size.width;
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: greencolor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });

          if (index == 1) {
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Image.asset(
                      'assets/images/home.png',
                      height: height / 3.3,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 50,
                      right: 50,
                      left: 15,
                      child: Text(
                        "Selamat Datang",
                        style: TextStyle(fontFamily: 'InterBold', fontSize: 24),
                      ),
                    ),
                    Positioned(
                      top: 80,
                      right: 50,
                      left: 15,
                      child: Text(
                        "Di Klasifikasi\nJenis Bunga",
                        style: TextStyle(fontFamily: 'InterBold', fontSize: 20),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height / 38),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Text(
                        'Daftar Bunga',
                        style: TextStyle(fontFamily: 'InterBold', fontSize: 20),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height / 38),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: flowers.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
                    mainAxisSpacing: 10,
                    childAspectRatio: 2 / 2.6,
                  ),
                  itemBuilder: (context, index) {
                    final flower = flowers[index];
                    return FlowerCard(flower: flower);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
