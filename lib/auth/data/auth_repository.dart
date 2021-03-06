import 'dart:convert';
import 'package:apogee_main/Constants.dart';
import 'package:apogee_main/shared/network/CustomHttpNetworkClient.dart';
import 'package:apogee_main/shared/network/errorState.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

class AuthRepository {
  AuthRepository({
    @required CustomHttpNetworkClient client,
    @required FlutterSecureStorage secureStorage,
    @required FirebaseMessaging messaging,
  })  : this._client = client,
        this._storage = secureStorage,
        this._messaging = messaging;

  final CustomHttpNetworkClient _client;
  final FlutterSecureStorage _storage;
  final FirebaseMessaging _messaging;
  final _signIn = GoogleSignIn(
    scopes: ['email'],
    hostedDomain: 'pilani.bits-pilani.ac.in',
  );
  bool isBitsian;

  Future<String> signInWithGoogle() async {
    await _signIn.signOut();
    final account = await _signIn.signIn();
    return (await account.authentication).idToken;
  }

  Future<ErrorState> loginBitsian(String id, String code) async {

    await _messaging.subscribeToTopic('User');
    await _messaging.subscribeToTopic('Bitsian');
    //final String regToken = await _storage.read(key: 'REGTOKEN') ?? "";
    final regToken = await _messaging.getToken();
    print(regToken);
    Map<String, dynamic> body = {'id_token': id, 'reg_token': regToken};

    //if (regToken != '') body.addAll({'reg_token': regToken});

    if (code != '') body.addAll({'referral_code': code});

    isBitsian = true;
    return await _client.post('wallet/auth', jsonEncode(body), setUser);
  }

  Future<ErrorState> loginOutstee(
      String username, String password, String code) async {

    await _messaging.subscribeToTopic('User');
    await _messaging.subscribeToTopic('Outstee');
    //final String regToken = await _storage.read(key: 'REGTOKEN') ?? "";
    final regToken = await _messaging.getToken();
    print(regToken);
    Map<String, String> body = {'username': username, 'password': password, 'reg_token': regToken};

    //if (regToken != '') body.addAll({'reg_token': regToken});

    if (code != '') body.addAll({'referral_code': code});

    isBitsian = false;
    print(body);
    return await _client.post(
        'wallet/auth', json.encode(body), setUser /*, false*/);
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

  Future<bool> get isLoggedIn async {
    final userJwt = await _storage.read(key: 'JWT');
    final userName = await _storage.read(key: 'NAME');
    final userQr = await _storage.read(key: 'QR');
    List<String> userData = List(3);
    userData[0] = userJwt;
    userData[1] = userName;
    userData[2] = userQr;

    if (userData.contains(null))
      return false;
    else
      return true;
  }

  Future<void> setUser(String json) async {

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

    Constants.userId = user['user_id'].toString();
  }
}
