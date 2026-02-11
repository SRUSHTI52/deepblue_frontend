import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // ⚠️ IMPORTANT:
  // Use LAN IP if testing on real phone (not localhost)
  static const String baseUrl = "https://alethea-cephalalgic-elise.ngrok-free.dev";

  static Future<Map<String, dynamic>> uploadVideo(File videoFile) async {
    final uri = Uri.parse("$baseUrl/predict");

    var request = http.MultipartRequest("POST", uri);
    request.files.add(
      await http.MultipartFile.fromPath(
        'video',
        videoFile.path,
      ),
    );

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      return jsonDecode(responseBody);
    } else {
      // Capture the error body from the stream
      final errorBody = await response.stream.bytesToString();

      // Print the status code and the actual error message from the server
      print("Error Status: ${response.statusCode}");
      print("Error Body: $errorBody");

      throw Exception("Failed to get prediction: $errorBody");
    }

  }
}