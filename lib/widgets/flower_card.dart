import 'package:flower_classification/classes/colors.dart';
import 'package:flower_classification/classes/flower.dart';
import 'package:flutter/material.dart';

class FlowerCard extends StatelessWidget {
  const FlowerCard({super.key, required this.flower});

  final Flower flower;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final width = size.height > size.width ? size.width : size.height;
    final height = size.height > size.width ? size.height : size.width;

    return Container(
      width: width / 2.25,
      child: Card(
        color: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  flower.imageUrl,
                  height: height / 6.9,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5, left: 5, top: 5),
                child: Column(
                  children: [
                    Text(
                      flower.nama,
                      style: TextStyle(
                        fontFamily: 'InterBold',
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: height / 76),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(width / 2.4, height / 25.3),
                        backgroundColor: greencolor,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              title: Text(flower.nama),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        flower.imageUrl,
                                        height: 150,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      'Deskripsi:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(flower.deskripsi),
                                    SizedBox(height: 10),
                                    Text(
                                      'Manfaat:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    ...flower.manfaat
                                        .map((m) => Text('• $m'))
                                        .toList(),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: Text('Tutup'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        'Lihat Detail',
                        style: TextStyle(
                          fontFamily: 'InterRegular',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
