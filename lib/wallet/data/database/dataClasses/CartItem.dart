class CartItem {
  int itemId;
  String itemName;
  String vendorName;
  int currentPrice;
  bool isVeg;
  int discount;
  int basePrice;
  int quantity;
  int vendorId;

  CartItem({
    this.itemId,
    this.quantity,
    this.vendorId,
    this.basePrice,
    this.currentPrice,
    this.discount,
    this.isVeg,
    this.itemName,
    this.vendorName
  });

  factory CartItem.fromMap(Map<String, dynamic> map) => CartItem(
    itemId: int.parse(map["itemId"].toString()) ?? 0,
    basePrice: int.parse(map["basePrice"].toString()) ?? 0,
    currentPrice: int.parse(map["currentPrice"].toString()) ?? int.parse(map["basePrice"].toString()) ?? 0,
    discount: int.parse(map["discount"].toString()) ?? 0,
    isVeg: (int.parse(map["isVeg"].toString()) ?? 0) == 1 ? true : false,
    itemName: map["itemName"].toString() ?? "",
    quantity: int.parse(map["quantity"].toString()) ?? 1,
    vendorId: int.parse(map["vendorId"].toString()) ?? 0,
    vendorName: map["vendorName"].toString() ?? ""
  );

  Map<String, int> toMapForOrder() => {
    itemId.toString(): quantity
  };
}