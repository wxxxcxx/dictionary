import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

import 'model.dart';

class Client {
  static Future<List<WordSuggestion>> suggest(String q) async {
    if (q.isEmpty) {
      return [];
    }
    var url = Uri.https('dict.youdao.com', '/suggest',
        {'q': q, 'le': 'eng', 'num': '20', 'doctype': 'json'});
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = convert.jsonDecode(response.body) as Map<String, dynamic>;

      List<WordSuggestion> suggestions = [];
      var list = data['data']['entries'];
      for (var item in list ?? []) {
        suggestions
            .add(WordSuggestion(word: item['entry'], explain: item['explain']));
      }
      return suggestions;
    } else {
      throw Exception('请求失败');
    }
  }

  static Future<Word> query(String q) async {
    if (q.isEmpty) {
      throw Exception('Please provide a non-empty text');
    }
    var url = Uri.https('dict.youdao.com', '/jsonapi', {
      'jsonversion': '2',
      'q': q,
      'dicts':
          '%7B%22count%22%3A99%2C%22dicts%22%3A%5B%5B%22ec%22%2C%22ce%22%5D%5D%7D',
    });
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = convert.jsonDecode(response.body);
      if (data['ec'] == null) {
        throw Exception('未找到释义');
      }
      Map ec = data['ec']!;
      Map w = ec['word']![0];
      String name = w['return-phrase']['l']['i'];
      String? phoneticSymbolUS = w['usphone'];
      String? phoneticSymbolUK = w['ukphone'];
      String? speechUS = w['usspeech'] != null
          ? 'https://dict.youdao.com/dictvoice?audio=' + w['usspeech']
          : null;
      String? speechUK = w['ukspeech'] != null
          ? 'https://dict.youdao.com/dictvoice?audio=' + w['ukspeech']
          : null;
      String? prototype = w['prototype'];

      List<String> definitions = [];
      for (var item in w['trs'] ?? []) {
        definitions.add(item['tr'][0]['l']['i'][0]);
      }
      List<WordForm> forms = [];
      for (var item in w['wfs'] ?? []) {
        forms.add(
            WordForm(word: item['wf']['name']!, value: item['wf']['value']!));
      }
      return Word(
          word: name,
          prototype: prototype,
          phoneticSymbolUS: phoneticSymbolUS,
          phoneticSymbolUK: phoneticSymbolUK,
          speechUS: speechUS,
          speechUK: speechUK,
          definitions: definitions,
          forms: forms);
    } else {
      throw Exception('查询失败');
    }
  }
}
