import 'package:http/http.dart' as http;

class HttpHelperGet {
  static Future<http.Response> get(String url) async {
    Uri uri = Uri.parse(url);
    return await http.get(uri);
  }
}
