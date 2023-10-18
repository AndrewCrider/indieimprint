import 'package:cloud_firestore/cloud_firestore.dart';

class bannerAds {
  String brand;
  String id;
  DateTime startDate;
  DateTime endDate;
  String image;
  String tagline;
  String type;
  String link;


  bannerAds({
    required this.brand,
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.image,
    required this.tagline,
    required this.type,
    required this.link,

  });

  factory bannerAds.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return bannerAds(
      brand: data?['brand'] ?? '',
      id: snapshot.id,
      startDate: (data?['startDate'] as Timestamp)?.toDate() ?? DateTime.now(),
      endDate: (data?['endDate'] as Timestamp)?.toDate() ?? DateTime.now(),
      image: data?['image'] ?? '',
      tagline: data?['tagline'] ?? '',
      type: data?['type'] ?? '',
      link: data?['link'] ?? '',

    );
  }

  static Future<List<bannerAds>> fetchBannerAdsByBrandFromFirebase(String brand) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('bannerAds')
        .where('brand', whereIn: ['Indie Imprints', brand])
        .get();
    return snapshot.docs.map((doc) => bannerAds.fromFirestore(doc)).toList();
  }


}