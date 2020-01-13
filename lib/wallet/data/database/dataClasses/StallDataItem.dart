class StallDataItem {
  int stallId;
  String stallName;
  bool closed;
  String imageUrl;

  StallDataItem ({
    this.stallId,
    this.stallName,
    this.imageUrl,
    this.closed
  });

  factory StallDataItem.fromMap(Map<String, dynamic> response) => StallDataItem(
    stallId: int.parse(response["stallId"].toString()),
    stallName: response["stallName"].toString(),
    imageUrl: response["imageUrl"].toString(),
    closed: int.parse(response["closed"].toString()) == 0 ? false : true
  );
}