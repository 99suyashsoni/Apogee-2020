class StallMenuItem {

  int itemId;
  String itemName;
  int stallId;
  String stallName;
  String category;
  int  currentPrice;
  bool isAvailable;
  bool isVeg;
  int discount;
  int basePrice;

  StallMenuItem({
    this.itemId,
    this.itemName,
    this.stallId,
    this.stallName,
    this.category,
    this.currentPrice,
    this.isAvailable,
    this.isVeg,
    this.discount,
    this.basePrice,

  });

  factory StallMenuItem.fromMap(Map<String, dynamic> response) => StallMenuItem(
      itemId: int.parse(response["itemId"].toString()),
      itemName: response["itemName"].toString(),
      stallId: int.parse(response["stallId"].toString()),
      stallName: response["stallName"].toString(),
      category: response["category"].toString(),
      currentPrice: int.parse(response["current_price"].toString()),
      isAvailable: int.parse(response["isAvailable"].toString()) == 0 ? false : true,
      isVeg: int.parse(response["isVeg"].toString()) == 0 ? false : true,
      discount: int.parse(response["discount"].toString()),
      basePrice: int.parse(response["base_price"].toString()),

  );

}
