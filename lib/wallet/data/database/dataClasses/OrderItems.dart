//  id INTEGER PRIMARY KEY AUTOINCREMENT,
//     name TEXT NON NULL,
//     item_id INTEGER NON NULL,
//     quantity INTEGER NON NULL,
//     unit_price INTEGER NON NULL,
//     order_id INTEGER NON NULL

    class OrderItems {

  int itemId;
  String itemName;
  int  unitPrice;
  int quantity;
  int orderId;

  OrderItems({
    this.itemId,
    this.itemName,
    this.orderId,
    this.unitPrice,
    this.quantity,
  });

  factory OrderItems.fromMap(Map<String, dynamic> response) => OrderItems(
    itemId: int.parse(response["item_id"].toString()),
    itemName: response["name"].toString(),
    quantity: int.parse(response["quantity"].toString()),
    orderId: int.parse(response["order_id"].toString()),
    unitPrice: int.parse(response["unit_price"].toString()),
  );

}
