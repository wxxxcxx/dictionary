import 'package:flutter_test/flutter_test.dart';
import 'package:dictionary/src/api.dart';

void main() {
  test('Query', () async {
    var word = await Client.query('high');
    assert(word.word.isNotEmpty);
  });

  test('Query', () async {
    var word = await Client.query('hierarchies general subject headings');
    assert(word.word.isNotEmpty);
  });
  test('Suggest', () async {
    var list = await Client.suggest('sh');
    assert(list.isNotEmpty);
  });
}
