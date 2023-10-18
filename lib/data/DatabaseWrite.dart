import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:indieimprint/data/Purchase.dart';


class DatabaseWrite{

  static purchaseDatabaseInit() async {
    final database = await openDatabase(
      join(await getDatabasesPath(), 'purchases.db'),

      onCreate: (db, version){
        return db.execute("Create TABLE purchases (issueID TEXT PRIMARY KEY, title TEXT, series TEXT, localDownloadPath TEXT, purchaseDate INT, status TEXT, coverImage TEXT, issueLocation TEXT, lastPageRead INT);" );

      },
      version: 1,


    );
    return database;
  }

  static Future<void> makePurchase(Purchase p) async {

    final Database db = await openDatabase(join(await getDatabasesPath(), 'purchases.db'));
    await db.insert("purchases", p.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    //TODO: Write to Firestore


  }

  static Future<List<Purchase>> listPurchases() async {
    Database db = await openDatabase(join(await getDatabasesPath(), 'purchases.db'));
    List<Purchase> pl = [];

    final List<Map<String, dynamic>> purchases = await db.query('purchases');

    for(int p=0; p < purchases.length; p++){
        Purchase pi = new Purchase(issueID: purchases[p]["issueID"], title: purchases[p]["title"],
                  series: purchases[p]['series'],
                  localDownloadPath: purchases[p]["localDownloadPath"],
                  purchaseDate: purchases[p]["purchaseDate"], status: purchases[p]["status"],
                  coverImage: purchases[p]["coverImage"], issueLocation: purchases[p]["issueLocation"],
                  lastPageRead: purchases[p]["lastPageRead"]);

        pl.add(pi);
    }

    return pl;
  }


}