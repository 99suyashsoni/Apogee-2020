class StallDataItem {
  int stallId;
  String stallName;
  bool closed;
  String imageUrl;
  String description;

  StallDataItem ({
    this.stallId,
    this.stallName,
    this.imageUrl,
    this.closed,
    this.description
  });

  factory StallDataItem.fromMap(Map<String, dynamic> response) => StallDataItem(
    stallId: int.parse(response["stallId"].toString()),
    stallName: response["stallName"].toString(),
    imageUrl: response["imageUrl"].toString(),
    closed: int.parse(response["closed"].toString()) == 0 ? false : true,
    description: response["description"].toString(),
  );
}