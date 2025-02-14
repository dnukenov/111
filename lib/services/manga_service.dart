import 'dart:convert';
import 'package:flutter/services.dart';

class MangaService {
  static Future<List<String>> loadMangaPages(String folder) async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    return manifestMap.keys
        .where((path) => path.startsWith('assets/manga/$folder/') &&
        (path.toLowerCase().endsWith('.jpg')))
        .toList();
  }
}
