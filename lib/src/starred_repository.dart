import 'dart:convert' as convert;
import 'dart:io';

import 'package:path_provider/path_provider.dart' as pathProvider;

import 'model.dart';

final Durations = [
  const Duration(minutes: 5),
  const Duration(minutes: 30),
  const Duration(minutes: 120),
  const Duration(days: 1),
  const Duration(days: 2),
  const Duration(days: 4),
  const Duration(days: 8),
  const Duration(days: 15),
  const Duration(days: 30),
  const Duration(days: 60)
];

class StarredWordRepository {
  StarredWordRepository._();

  final String path = 'Dictionary/stars.json';

  static final StarredWordRepository instance = StarredWordRepository._();

  Future<List<StarredWord>> _loadList() async {
    final root = await pathProvider.getApplicationDocumentsDirectory();
    final file = File('${root.path}/$path');
    if (await file.exists()) {
      final data = await file.readAsString();
      final json = convert.jsonDecode(data) as List<dynamic>;
      return json.map((item) => StarredWord(word: item['word'])).toList();
    } else {
      return [];
    }
  }

  Future<void> _saveList(List<StarredWord> list) async {
    final root = await pathProvider.getApplicationDocumentsDirectory();
    final file = File('${root.path}/$path');

    if (!await file.exists()) {
      await file.create(recursive: true);
    }
    final data =
        convert.jsonEncode(list.map((item) => {'word': item.word}).toList());
    await file.writeAsString(data);
  }

  Future<List<StarredWord>> list() async {
    return await _loadList();
  }

  Future<StarredWord?> get(String word) async {
    if (!(await _loadList())
        .any((item) => item.word.toUpperCase() == word.toUpperCase())) {
      return null;
    }
    return (await _loadList())
        .firstWhere((item) => item.word.toUpperCase() == word.toString());
  }

  Future<void> add(String word) async {
    if (!(await list())
        .any((item) => item.word.toUpperCase() == word.toUpperCase())) {
      var list = await _loadList();
      list.insert(0, StarredWord(word: word));
      await _saveList(list);
    }
  }

  Future<void> remove(String word) async {
    var list = await _loadList();
    list.removeWhere((item) => item.word.toUpperCase() == word.toUpperCase());
    await _saveList(list);
  }

  Future<bool> exists(String word) async {
    return (await _loadList())
        .any((item) => item.word.toUpperCase() == word.toUpperCase());
  }
}
