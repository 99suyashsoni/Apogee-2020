import 'package:apogee_main/shared/database_helper.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/StallData.dart';
import 'package:sqflite/sqflite.dart';

class WalletDao {
  // This is a demo insert query to show how we intend to write DAO files. 
  // Please follow this pattern strictly, and donot forget to include error handling in all queries
  Future<Null> insertAllStalls(List<dynamic> stallsJson) async {
    var database = await databaseInstance();
    await database.transaction((transaction) async {
      transaction.delete("stalls");
      for(var stallJson in stallsJson) {
        transaction.rawInsert("""INSERT INTO stalls (stallId, stallName, closed, imageUrl) VALUES (?, ?, ?, ?)""", [
          int.parse(stallJson["id"].toString()) ?? 0,
          stallJson["name"].toString() ?? "",
          int.parse(stallJson["closed"].toString()) ?? 0,
          stallJson["image_url"].toString() ?? ""
        ]);
      }
    });
  }

  // This is a demo select query to show how we intend to write DAO files. 
  // The model data class for this is present in lib/wallet/data/database/dataClasses/StallData.dart
  // Please follow this pattern strictly, and donot forget to include error handling in all queries
  Future<List<StallData>> getAllStalls() async {
    var database = await databaseInstance();
    List<Map<String, dynamic>> result = await database.rawQuery("""SELECT * FROM stalls""");
    if(result == null || result.isEmpty) 
      return [];
    List<StallData> stallsList = [];
    for(var item in result) {
      stallsList.add(StallData.fromMap(item));
    }
    return stallsList;
  }
}