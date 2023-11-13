import 'dart:convert';
import 'package:http/http.dart' as http;

class BaseApiService {
  final String baseUrl;

  BaseApiService(this.baseUrl);

  Future<Map<String, dynamic>> postRequest(String endpoint, Map<String, dynamic> body) async {
    final String url = '$baseUrl/$endpoint';
    final Map<String, String> headers = {'Content-Type': 'application/json'};

    final response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to perform POST request. Status code: ${response.statusCode}');
    }
  }

  Future<List<Map<String, dynamic>>> getRequest(String endpoint, {Map<String, dynamic>? parameters}) async {
    final String url = '$baseUrl/$endpoint';
    final Uri uri = Uri.parse(url).replace(queryParameters: parameters);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final dynamic responseData = jsonDecode(response.body);
      if (responseData is List) {
        return List<Map<String, dynamic>>.from(responseData);
      } else {
        throw Exception('Failed to parse response data as List.');
      }
    } else {
      throw Exception('Failed to perform GET request. Status code: ${response.statusCode}');
    }
  }
}
