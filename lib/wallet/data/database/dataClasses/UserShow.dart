import 'package:flutter/material.dart';

class UserShow {
  int id;
  String name;
  int used;
  int unused;

  UserShow({
    @required this.id,
    @required this.name,
    this.unused = 0,
    this.used = 0
  });

  factory UserShow.fromResponse(Map<String, dynamic> response) => UserShow(
    id: int.parse(response["id"].toString()),
    name: response["show_name"].toString(),
    used: int.parse(response["used_count"].toString()),
    unused: int.parse(response["unused_count"].toString())
  );
}