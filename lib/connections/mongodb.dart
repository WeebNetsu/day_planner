import 'package:mongo_dart/mongo_dart.dart';

/// MongoDB connection
class MongoDB {
  static Db? db;

  /// Connect to the database
  static Future<void> connect() async {
    db = await Db.create("haha you wish");

    await db?.open();
  }
}
