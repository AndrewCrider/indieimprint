import 'package:cloud_firestore/cloud_firestore.dart';

class Artist {
  String brand;
  String id;
  String bio;
  String name;
  String teaserText;
  String coverPhoto;
  String email;
  String twitter;
  String website;

  Artist({
    required this.brand,
    required this.id,
    required this.bio,
    required this.name,
    required this.teaserText,
    required this.coverPhoto,
    required this.email,
    required this.twitter,
    required this.website,
  });

  factory Artist.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Artist(
      brand: data?['brand'] ?? '',
      id: snapshot.id,
      bio: data?['bio'] ?? '',
      name: data?['name'] ?? '',
      teaserText: data?['teaserText'] ?? '',
      coverPhoto: data?['coverPhoto'] ?? '',
      email: data?['email'] ?? '',
      twitter: data?['twitter'] ?? '',
      website: data?['website'] ?? '',
    );
  }

  static Future<List<Artist>> fetchArtistsByBrandFromFirebase(String brand) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('artists')
        .where('brand', isEqualTo: brand)
        .get();
    return snapshot.docs.map((doc) => Artist.fromFirestore(doc)).toList();
  }

  static Future<List<Artist>> fetchArtistsByIdFromFirebase(String id) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('artists')
        .where(FieldPath.documentId, isEqualTo: id)
        .get();
    return snapshot.docs.map((doc) => Artist.fromFirestore(doc)).toList();
  }
}
