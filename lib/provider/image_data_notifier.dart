import 'dart:typed_data';

import 'package:cropyourimage_gallery/image_urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageDataNotifier extends ChangeNotifier {
  /// [List] which keeps original data load from internet
  /// and converted into [Uint8List]
  final loadData = <Uint8List>[];
  bool get hasData => loadData.isNotEmpty;

  Future<void> loadAllImages() async {
    for (final url in imageUrls) {
      final response = await http.get(Uri.parse(url));
      loadData.add(response.bodyBytes);
      notifyListeners();
    }
  }
}
