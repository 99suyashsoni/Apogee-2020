abstract class NetworkClient {
  Future<Null> get(String url, Function(String) onSucess);
  // The body parameter here is assumed to be the body encoded in JSON format
  Future<Null> post(String url, String body, Function(String) onSucess);
}