import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // ⚠️ IMPORTANT:
  // Use LAN IP if testing on real phone (not localhost)
  static const String baseUrl = "http://192.168.1.100:8000";

  static Future<Map<String, dynamic>> uploadVideo(File videoFile) async {
    final uri = Uri.parse("$baseUrl/predict");

    var request = http.MultipartRequest("POST", uri);
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        videoFile.path,
      ),
    );

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      return jsonDecode(responseBody);
    } else {
      throw Exception("Failed to get prediction");
    }
  }
}