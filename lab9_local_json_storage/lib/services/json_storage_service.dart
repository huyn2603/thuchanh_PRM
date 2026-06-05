import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/local_item.dart';

class JsonStorageService {
  static const String fileName = 'local_items.json';

  Future<File> _getStorageFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$fileName');
  }

  Future<List<LocalItem>> loadItems() async {
    final file = await _getStorageFile();
    if (!await file.exists()) {
      final seedItems = [
        const LocalItem(
          id: 1,
          title: 'Watch Interstellar',
          category: 'Movie',
          note: 'Saved from seed data.',
        ),
        const LocalItem(
          id: 2,
          title: 'Read Flutter docs',
          category: 'Study',
          note: 'Practice JSON persistence.',
        ),
      ];
      await saveItems(seedItems);
      return seedItems;
    }

    final rawJson = await file.readAsString();
    final decoded = jsonDecode(rawJson) as List<dynamic>;
    return decoded
        .map((item) => LocalItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveItems(List<LocalItem> items) async {
    final file = await _getStorageFile();
    final encoded = const JsonEncoder.withIndent(
      '  ',
    ).convert(items.map((item) => item.toJson()).toList());
    await file.writeAsString(encoded);
  }
}
