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
