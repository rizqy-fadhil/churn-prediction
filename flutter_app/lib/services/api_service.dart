import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000';

  static Future<Map<String, dynamic>> predict(Map<String, dynamic> input) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/churn/predict'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(input),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Prediction failed');
    }
  }

  static Future<List<dynamic>> getHistory() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/churn'),
      headers: {'Content-Type': 'application/json'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['data'];
    } else {
      throw Exception(data['message'] ?? 'Failed to fetch history');
    }
  }

  static Future<Map<String, dynamic>> getPredictionById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/churn/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['data'];
    } else {
      throw Exception(data['message'] ?? 'Failed to fetch prediction');
    }
  }
}