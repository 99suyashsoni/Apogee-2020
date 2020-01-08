import 'package:apogee_main/shared/database_helper.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/CartItem.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/StallData.dart';
import 'package:sqflite/sqflite.dart';

class WalletDao {
  // This is a demo insert query to show how we intend to write DAO files. 
  // Please follow this pattern strictly, and donot forget to include error handling in all queries
  Future<Null> insertAllStalls(List<dynamic> stallsJson) async {
    var database = await databaseInstance();
    await database.transaction((transaction) async {
      await transaction.delete("stalls");
      for(var stallJson in stallsJson) {
        await transaction.rawInsert("""INSERT INTO stalls (stallId, stallName, closed, imageUrl) VALUES (?, ?, ?, ?)""", [
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

  Future<Null> clearAllCartItems() async {
    var database = await databaseInstance();
    var result = await database.rawQuery("""DELETE * FROM cart_data""");
    print("Result for deleting cart items = $result");
  }

  Future<Null> deleteCartItem(int itemId) async {
    var database = await databaseInstance();
    if(itemId == null)
      return;
    var result = await database.rawQuery("""DELETE FROM cart_data WHERE itemId = ?""", [itemId]);
    print("Result of deleting object from cart = $result");
  }

  Future<List<CartItem>> getAllCartItems() async {
    var database = await databaseInstance();
    var result = await database.rawQuery("""SELECT cart_data.item_id AS itemId, stall_items.itemName as itemName, stall_items.isVeg as isVeg, cart_data.vendor_id AS vendorId, stalls.stallName AS vendorName, cart_data.quantity AS quantity, stall_items.current_price AS currentPrice, stall_items.discount AS discount, stall_items.base_price AS basePrice FROM cart_data LEFT JOIN stall_items ON cart_data.item_id = stall_items.itemId LEFT JOIN stalls ON cart_data.vendor_id = stalls.stallId ORDER BY vendorId""");
    List<CartItem> cartItems = [];
    if(result == null || result.isEmpty) 
      return cartItems;
    for(var element in result) {
      cartItems.add(CartItem.fromMap(element));
    }
    return cartItems;
  }

  Future<Null> insertCartItems(List<dynamic> cartJson) async {
    var database = await databaseInstance();
    await database.transaction((transaction) async {
      await transaction.delete("cart_data");
      for(var element in cartJson) {
        await transaction.rawInsert("""INSERT INTO cart_data (item_id, quantity, vendor_id) VALUES (?, ?, ?)""", [
          int.parse(element["item_data".toString()]) ?? 0,
          int.parse(element["quantity"].toString()) ?? 1,
          int.parse(element["vendor_id"].toString()) ?? 0
        ]);
      }
    });
  }
}