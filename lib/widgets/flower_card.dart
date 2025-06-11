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
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () {},
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
