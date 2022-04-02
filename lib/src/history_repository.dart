import 'dart:convert' as convert;
import 'dart:io';

import 'package:path_provider/path_provider.dart' as pathProvider;

import 'model.dart';

class HistoryRepository {
  HistoryRepository._();

  final String path = 'Dictionary/history.json';

  static final HistoryRepository instance = HistoryRepository._();


  Future<void> clean() async {
    final root = await pathProvider.getApplicationDocumentsDirectory();
    final file = File('${root.path}/$path');

    if (await file.exists()) {
      await file.delete(recursive: true);
    }
  }

  Future<List<WordSuggestion>> _loadList() async {
    final root = await pathProvider.getApplicationDocumentsDirectory();
    final file = File('${root.path}/$path');
    if (await file.exists()) {
      final data = await file.readAsString();
      final json = convert.jsonDecode(data) as List<dynamic>;
      return json
          .map((item) => WordSuggestion(word: item['word'], explain: ''))
          .toList();
    } else {
      return [];
    }
  }

  Future<void> _saveList(List<WordSuggestion> list) async {
    final root = await pathProvider.getApplicationDocumentsDirectory();
    final file = File('${root.path}/$path');

    if (!await file.exists()) {
      await file.create(recursive: true);
    }
    final data =
        convert.jsonEncode(list.map((item) => {'word': item.word}).toList());
    await file.writeAsString(data);
  }

  Future<List<WordSuggestion>> list() async {
    return await _loadList();
  }

  Future<WordSuggestion?> get(String word) async {
    if (!(await _loadList())
        .any((item) => item.word.toUpperCase() == word.toUpperCase())) {
      return null;
    }
    return (await _loadList())
        .firstWhere((item) => item.word.toUpperCase() == word.toString());
  }

  Future<void> add(String word) async {
    var list = await _loadList();
    list.removeWhere((item) => item.word.toUpperCase() == word.toUpperCase());
    list.insert(0, WordSuggestion(word: word, explain: ''));
    await _saveList(list);
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
