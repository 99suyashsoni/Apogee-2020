import 'package:apogee_main/shared/database_helper.dart';
import 'package:apogee_main/shared/database_helper.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/OrderItems.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/StallDataItem.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/StallModifiedMenuItem.dart';

import 'dataClasses/Orders.dart';

class WalletDao {
  // This is a demo insert query to show how we intend to write DAO files. 
  // Please follow this pattern strictly, and donot forget to include error handling in all queries
 Future<Null> insertAllStalls(List<dynamic> stallsJson) async {
    var database = await databaseInstance();
    await database.transaction((transaction) async {
      await transaction.delete("stalls");
      await transaction.delete("stall_items");
      for(var stallJson in stallsJson) {
        await transaction.rawInsert("""INSERT INTO stalls (stallId, stallName, closed, imageUrl, description) VALUES (?, ?, ?, ?, ?)""", [
          int.parse(stallJson["id"].toString()) ?? 0,
          stallJson["name"].toString() ?? "",
          stallJson["closed"] as bool ? 1:0 ?? 0,
          stallJson["image_url"].toString() ?? "",
          stallJson["description"].toString() ??""
        ]);
        print(stallJson["menu"]);

        for(var response in stallJson["menu"]) {
          await transaction.rawInsert("""INSERT INTO stall_items (itemId,itemName,stallId,stallName,category,current_price,
                                                                isAvailable,isVeg,discount,base_price) 
                                                                VALUES ( ?, ?, ?, ? , ?, ?, ?, ?, ?, ?)""",
              [
                int.parse(response["id"].toString()),
                response["name"].toString(),
                int.parse(stallJson["id"].toString()) ?? 0,
                stallJson["name"].toString() ?? "",
                response["description"].toString(),
                int.parse(response["price"].toString()),
                response["is_available"] as bool ? 1 : 0 ?? 0,
                response["is_veg"] as bool ? 1 : 0 ?? 0,
                int.parse(response["current_discount"].toString()),
                int.parse(response["base_price"].toString()),
              ]);
        }
      }
    });
  }
  // This is a demo select query to show how we intend to write DAO files. 
  // The model data class for this is present in lib/wallet/data/database/dataClasses/StallData.dart
  // Please follow this pattern strictly, and donot forget to include error handling in all queries
  Future<List<StallDataItem>> getAllStalls() async {
    var database = await databaseInstance();
    List<Map<String, dynamic>> result = await database.rawQuery("""SELECT * FROM stalls""");
    if(result == null || result.isEmpty) 
      return [];
    List<StallDataItem> stallsList = [];
    for(var item in result) {
      stallsList.add(StallDataItem.fromMap(item));
    }
    return stallsList;
  }

  Future<Null> clearAllCartItems() async {
    var database = await databaseInstance();
    var result = await database.rawQuery("""DELETE  FROM cart_data""");
    print("Result for deleting cart items = $result");
  }

  Future<Null> deleteCartItem(int itemId) async {
    var database = await databaseInstance();
    if(itemId == null)
      return;
    var result = await database.rawQuery("""DELETE FROM cart_data WHERE item_id = ?""", [itemId]);
    print("Result of deleting object from cart = $result");
  }

  Future<List<StallModifiedMenuItem>> getAllCartItems() async {
    var database = await databaseInstance();
    var result = await database.rawQuery("""SELECT cart_data.item_id AS itemId, stall_items.itemName AS itemName, stall_items.stallId AS stallId, stall_items.stallName AS stallName, stall_items.category AS category, stall_items.isVeg as isVeg, cart_data.quantity AS quantity, stall_items.current_price AS current_price, stall_items.discount AS discount, stall_items.base_price AS base_price, stall_items.isAvailable AS isAvailable FROM cart_data LEFT JOIN stall_items ON cart_data.item_id = stall_items.itemId LEFT JOIN stalls ON cart_data.vendor_id = stalls.stallId ORDER BY stallId""");
    List<StallModifiedMenuItem> cartItems = [];
    if(result == null || result.isEmpty) 
      return cartItems;
    for(var element in result) {
      cartItems.add(StallModifiedMenuItem.fromMap(element));
    }
    return cartItems;
  }

  Future<Null> insertCartItems(List<StallModifiedMenuItem> cartJson) async {
   print("insert cart items called");
    var database = await databaseInstance();
    await database.transaction((transaction) async {
      await transaction.delete("cart_data");
      for(var element in cartJson) {    
        await transaction.rawInsert("""INSERT INTO cart_data (item_id, quantity, vendor_id) VALUES (?, ?, ?)""", [
          element.itemId ?? 0,
          element.quantity ?? 1,
          element.stallId ?? 0
        ]);
      }
    });
  }

  Future<Null> insertCartItemfromMenuScreen(int itemId,int quantity,int stallid) async {
    var database = await databaseInstance();
        await database.rawInsert("""INSERT INTO cart_data (item_id, quantity, vendor_id) VALUES (?, ?, ?)""", [
          itemId ,
          quantity,
          stallid
        ]);


  }


  Future<Null> updateCartItemQuantity(int id, int quantity) async {
    var database = await databaseInstance();
    var result = await database.rawQuery("""UPDATE cart_data SET quantity = ? WHERE item_id = ?""", [quantity, id]);
    print("Result for update query on database = $result");
  }

    Future<List<StallModifiedMenuItem>> getModifiedMenuItems(int stallId,int available) async {
    var database = await databaseInstance();
    List<Map<String, dynamic>> result = await database.rawQuery(""" SELECT itemId, itemName, stallId, category, current_price AS current_price, isVeg, COALESCE(cart_data.quantity, 0) AS quantity, discount, base_price AS base_price FROM stall_items LEFT JOIN cart_data ON itemId = item_id WHERE stallId = $stallId AND isAvailable = $available ORDER BY category""");
    if(result == null || result.isEmpty)
      return [];
    List<StallModifiedMenuItem> menuList = [];
    for(var item in result) {
      menuList.add(StallModifiedMenuItem.fromMap(item));
    }

    print(menuList);
    return menuList;
  }

  Future<List<Orders>> getOrderData() async {
    var database = await databaseInstance();
    List<Map<String, dynamic>> result = await database.rawQuery("""SELECT * FROM orders ORDER BY id DESC""");
    if(result == null || result.isEmpty) 
      return [];
    List<Orders> orderData = [];
    for(var item in result) {
      orderData.add(Orders.fromMap(item));
    }
    return orderData;
  }

 Future<List<OrderItems>> getAllOrderDetails() async {
    var database = await databaseInstance();
    List<Map<String, dynamic>> result = await database.rawQuery("""SELECT * FROM order_items""");
    if(result == null || result.isEmpty) 
      return [];
    List<OrderItems> orderDetails = [];
    for(var item in result) {
      orderDetails.add(OrderItems.fromMap(item));
    }
    print("Order Details from database = $orderDetails");
    return orderDetails;
  }
//TODO:  inset complete order dtaa after api call
//TODO: jinko bhi retrive kara h unko order by karna h    
   
   Future<Null> insertAllOrders(List<dynamic> ordersJson) async {
    var database = await databaseInstance();
    await database.transaction((transaction) async {
      await transaction.delete("orders");
      await transaction.delete("order_items");
      for(var orders in ordersJson) {
        for(var order in orders["orders"]) {
          await transaction.rawInsert("""INSERT INTO orders (id, shell, otp, otp_seen,status,price,vendor,rating) VALUES (?, ?, ?, ?,?,?,?,?)""", [
          int.parse(order["order-id"].toString()),
          int.parse(order["shell"].toString()) ,
          int.parse(order["otp"].toString()),
          order["otp_seen"] as bool ? 1 : 0 ?? 0,
          int.parse(order["status"].toString()),
          int.parse(order["price"].toString()),
          order["vendor"]["name"].toString() ?? "unknown",
          int.parse(order["rating"].toString()),
        ]);
          //print(orderJs["orders"]);
          for(var item in order["items"] ){
            await transaction.rawInsert("""INSERT INTO order_items (item_id,name,quantity,unit_price,order_id) 
                                                                VALUES ( ?, ?, ?, ? , ?)""",[
            int.parse(item["id"].toString()),
            item["name"].toString(),
            int.parse(item["quantity"].toString()),
            int.parse(item["unit_price"].toString()),
            int.parse(order["order-id"].toString())
            ]);
          }
        }
       //TODO: try inserting list in sqflite in one query.

      }
    });
  }


}