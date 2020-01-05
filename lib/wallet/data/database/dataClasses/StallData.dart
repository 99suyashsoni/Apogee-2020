class StallData {
  int stallId;
  String stallName;
  bool closed;
  String imageUrl;

  StallData({
    this.stallId,
    this.stallName,
    this.imageUrl,
    this.closed
  });

  factory StallData.fromMap(Map<String, dynamic> response) => StallData(
    stallId: int.parse(response["stallId"].toString()),
    stallName: response["stallName"].toString(),
    imageUrl: response["imageUrl"].toString(),
    closed: int.parse(response["closed"].toString()) == 0 ? false : true
  );
}