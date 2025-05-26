class Flower {
  final String id;
  final String nama;
  final String deskripsi;
  final List<String> manfaat;
  final String imageUrl;

  const Flower({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.manfaat,
    required this.imageUrl,
  });

  factory Flower.fromFirestore(String id, Map<String, dynamic> data) {
    return Flower(
      id: id,
      nama: data['nama'],
      deskripsi: data['deskripsi'],
      manfaat: List<String>.from(data['manfaat'] as List),
      imageUrl: data['image_url'],
    );
  }
}
