class Orders {

  int orderId;
  String stallName;
  int shell;
  int otp;
  bool otpSeen;
  int status;
  int totalPrice;
  int rating;
  

  Orders({
    this.orderId,
    this.otp,
    this.otpSeen,
    this.rating,
    this.shell,
    this.stallName,
    this.status,
    this.totalPrice,

  });

  factory Orders.fromMap(Map<String, dynamic> response) => Orders(
      orderId: int.parse(response["id"].toString()),
      shell: int.parse(response["shell"].toString()),
      stallName: response["vendor"].toString(),
      otp: int.parse(response["otp"].toString()),
      otpSeen: int.parse(response["otp_seen"].toString()) == 0 ? false : true,
      status: int.parse(response["status"].toString()),
      totalPrice: int.parse(response["price"].toString()),
      rating: int.parse(response["rating"].toString()),
     
  );

}
