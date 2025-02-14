import 'package:http/http.dart' as http;
import 'dart:convert';

class MangaService {
  static const String bucketName = "manekomi";

  static Future<List<String>> loadMangaPages(String folder) async {
    final url =
        "https://storage.googleapis.com/storage/v1/b/$bucketName/o?prefix=mangas/$folder/&alt=json";

    print("Fetching images from: $url");

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data['items'] == null) {
        print("No images found in bucket.");
        return [];
      }

      // Extract only image URLs
      List<String> pages = data['items']
          .where((item) => item.containsKey('name') && item['name'].toString().endsWith('.jpg')) // Ensure 'name' exists and ends with .jpg
          .map<String>((item) => item['mediaLink'] as String) // Ensure valid String URLs
          .toList();

      print("Loaded Images: $pages"); // Debugging output
      return pages;
    } else {
      throw Exception("Failed to fetch images");
    }
  }
}
