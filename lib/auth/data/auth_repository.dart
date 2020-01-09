import 'package:apogee_main/shared/network/CustomHttpNetworkClient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite/sqflite.dart';

class AuthRepository {
  AuthRepository({
    @required Database database,
    @required CustomHttpNetworkClient client,
    @required FlutterSecureStorage secureStorage
  }): this._database = database,
      this._client = client,
      this._storage = secureStorage;

  Database _database;
  CustomHttpNetworkClient _client;
  FlutterSecureStorage _storage;

  Future<Null> loginBitsian() async {

  }

  Future<Null> loginOutstee() async{

  }

  Future<Null> logout() async {

  }

  Future<Null> getUser() async{

  }

  Future<Null> setUser() async{

  }
}