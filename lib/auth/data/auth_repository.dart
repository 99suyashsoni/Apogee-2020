import 'dart:convert';
import 'package:apogee_main/shared/network/CustomHttpNetworkClient.dart';
import 'package:apogee_main/shared/network/errorState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  AuthRepository({
    @required CustomHttpNetworkClient client,
    @required FlutterSecureStorage secureStorage
  }): this._client = client,
      this._storage = secureStorage;

  CustomHttpNetworkClient _client;
  FlutterSecureStorage _storage;
  bool isBitsian;

  Future<ErrorState> loginBitsian(String id, String code) async {
    final String regToken = await _storage.read(key: "REGTOKEN") ?? "" ;
    Map<String, dynamic> body = {
      'id_token':id
    };

    if(regToken != "")
      body.addAll({'reg_token': regToken});

    if(code != "")
      body.addAll({'referral_code': code});

    isBitsian = true;
    return await _client.post('wallet/auth', jsonEncode(body), setUser);

  }

  Future<ErrorState> loginOutstee(String username, String password, String code) async{
    final String regToken = await _storage.read(key: "REGTOKEN") ?? "" ;
    Map<String, String> body = {
      'username': username,
      'password': password
    };

    if(regToken != "")
      body.addAll({'reg_token': regToken});

    if(code != "")
      body.addAll({'referral_code': code});

    isBitsian = false;
    print(body);
    return await _client.post('wallet/auth', json.encode(body), setUser/*, false*/);
  }

  Future<void> logout() async {
    await _storage.delete(key: 'NAME');
    await _storage.delete(key: 'JWT');
    await _storage.delete(key: 'EMAIL');
    await _storage.delete(key: 'CONTACT');
    await _storage.delete(key: 'ID');
    await _storage.delete(key: 'QR');
    await _storage.delete(key: 'IS_BITSIAN');
    await _storage.delete(key: 'REFERRAL_CODE');
  }

  Future<bool> get isLoggedIn async{

    final userJwt = await _storage.read(key: 'JWT');
    final userName = await _storage.read(key: 'NAME');
    final userQr = await _storage.read(key: 'QR');
    List<String> userData = List(3);
    userData[0] = userJwt;
    userData[1] = userName;
    userData[2] = userQr;

    if(userData.contains(null))
      return false;
    else
      return true;

  }

  Future<void> setUser(String json) async{
    final user = jsonDecode(json) as Map<String, dynamic>;

    await _storage.delete(key: 'NAME');
    await _storage.delete(key: 'JWT');
    await _storage.delete(key: 'EMAIL');
    await _storage.delete(key: 'CONTACT');
    await _storage.delete(key: 'ID');
    await _storage.delete(key: 'QR');
    await _storage.delete(key: 'IS_BITSIAN');
    await _storage.delete(key: 'REFERRAL_CODE');

    await _storage.write(key: 'NAME', value: user['name']);
    await _storage.write(key: 'JWT', value: 'JWT ${user['JWT']}');
    await _storage.write(key: 'EMAIL', value: user['email']);
    await _storage.write(key: 'CONTACT', value: user['phone']);
    await _storage.write(key: 'ID', value: user['user_id'].toString());
    await _storage.write(key: 'QR', value: user['qr_code']);
    await _storage.write(key: 'REFERRAL_CODE', value: user['referral_code']);
    await _storage.write(key: 'IS_BITSIAN', value: isBitsian.toString());
    
  }
}