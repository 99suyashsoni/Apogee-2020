import 'package:apogee_main/shared/network/errorState.dart';

abstract class NetworkClient {
  Future<ErrorState> get(String url, Function(String) onSucess);
  // The body parameter here is assumed to be the body encoded in JSON format
  Future<ErrorState> post(String url, String body, Function(String) onSucess);
}