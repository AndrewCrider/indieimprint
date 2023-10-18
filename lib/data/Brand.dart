import 'package:cloud_firestore/cloud_firestore.dart';

class Brand {
  String id;
  String brand;
  List<String> artistIds;
  String website;
  String contact;
  String facebook;
  String twitter;
  String patreon;
  String discord;
  String coverImage;
  String tagline;
  String description;
  String newsFeedTopic;
  String substack;


  Brand({
    required this.id,
    required this.brand,
    required this.coverImage,
    required this.tagline,
    required this.description,
    required this.newsFeedTopic,
    required this.artistIds,
    required this.website,
    required this.contact,
    required this.facebook,
    required this.twitter,
    required this.patreon,
    required this.discord,
    required this.substack,
  });

  factory Brand.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Brand(
      id: snapshot.id,
      brand: data?['brand'] ?? '',
      coverImage: data?['coverImage'],
      tagline: data?['tagline'],
      description: data?['description'],
      newsFeedTopic: data?['newsFeedTopic'],
      artistIds: List<String>.from(data?['artistIds'] ?? []),
      website: data?['website'] ?? '',
      contact: data?['contact'] ?? '',
      facebook: data?['facebook'] ?? '',
      twitter: data?['twitter'] ?? '',
      patreon: data?['patreon'] ?? '',
      discord: data?['discord'] ?? '',
      substack: data?['substack']?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'brand': brand,
      'coverImage': coverImage,
      'tagline': tagline,
      'description':description,
      'newsFeedTopic': newsFeedTopic,
      'artistIds': artistIds,
      'website': website,
      'contact': contact,
      'facebook': facebook,
      'twitter': twitter,
      'patreon': patreon,
      'discord': discord,
      'substack': substack,
    };
  }

  static Future<List<Brand>> fetchBrandsFromFirebase() async {
    final snapshot = await FirebaseFirestore.instance.collection('brands').get();
    return snapshot.docs.map((doc) => Brand.fromFirestore(doc)).toList();
  }

  static Future<Brand> fetchSingleBrandFromFirebase(String brand) async {
    final snapshot = await FirebaseFirestore.instance.collection('brand')
        .where('brand', isEqualTo: brand)
        .limit(1) // Limit the query to one document
        .get();

    if (snapshot.docs.isNotEmpty) {
      return Brand.fromFirestore(snapshot.docs.first);
    } else {
      return Brand(
        id: '123',
        brand: 'Flatline Comics',
        coverImage: '/brandData/flatline_icon_large.png',
        tagline: 'You want Clowns or Wrestlers?',
        description: 'I got both',
        newsFeedTopic: 'abc',
        artistIds: ['Hyja9E6zgsjksEzEzhx2', 'Hyja9E6zgsjksEzEzhx2'],
        website: 'www.inversepress.com',
        contact: 'inversepress@inversepress.com',
        facebook: 'facebook.com',
        twitter: '@inversspress',
        patreon: 'www.patreon.com',
        discord: 'www.facebook.com',
        substack: '',
      ); // Return null if no matching document is found
    }
  }

  Future<void> saveToFirebase() async {
    await FirebaseFirestore.instance
        .collection('brands')
        .doc(id)
        .set(toMap());
  }

  static fetchfalseBrandData(){
    return Brand(
      id: '123',
      brand: 'Flatline Comics',
      coverImage: '/brandData/flatline_icon_large.png',
      tagline: 'You want Clowns or Wrestlers?',
      description: 'I got both',
      newsFeedTopic: 'abc',
      artistIds: ['Hyja9E6zgsjksEzEzhx2', 'Hyja9E6zgsjksEzEzhx2'],
      website: 'www.inversepress.com',
      contact: 'inversepress@inversepress.com',
      facebook: 'facebook.com',
      twitter: '@inversspress',
      patreon: 'www.patreon.com',
      discord: 'www.facebook.com',
      substack: '',
    );
  }
}
