import 'dart:convert';
import 'package:http/http.dart' as http;

class WaApi {
  const WaApi();

  static const String _wa_url = String.fromEnvironment('WA_URL');
  static const String _wa_user = String.fromEnvironment('WA_USER');
  static const String _wa_password = String.fromEnvironment('WA_PASSWORD');

  static final _headers = {
    "Authorization":
        "Basic ${base64.encode('$_wa_user:$_wa_password'.codeUnits)}"
  };

  Future<String> login() async {
    final _url = Uri.parse('$_wa_url/app/login');
    try {
      final _response = await http.get(
        _url,
        headers: _headers,
      );

      final _result = jsonDecode(_response.body) as Map<String, dynamic>;

      return _result['results']['qr_link'] as String;
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }

  Future<List<dynamic>> fetchDevices() async {
    final _url = Uri.parse('$_wa_url/app/devices');
    try {
      final _response = await http.get(
        _url,
        headers: _headers,
      );

      final _result = jsonDecode(_response.body) as Map<String, dynamic>;

      return _result['results'];
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }

  Future<void> reconnect() async {
    final _url = Uri.parse('$_wa_url/app/reconnect');
    try {
      await http.get(
        _url,
        headers: _headers,
      );
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }
}
