import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flower_classification/classes/flower.dart';
import 'package:flower_classification/widgets/flower_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Flower> flowers = [];
  final db = FirebaseFirestore.instance;

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
                    childAspectRatio: 2 / 2.5,
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
