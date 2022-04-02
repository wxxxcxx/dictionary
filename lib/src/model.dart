import 'package:flutter/cupertino.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:dictionary/src/shortcut.dart';

class Word {
  final String word;

  final String? phoneticSymbolUS;
  final String? phoneticSymbolUK;
  final String? speechUS;
  final String? speechUK;
  final String? prototype;

  final List<String> definitions;

  final List<WordForm> forms;

  Word({
    required this.word,
    this.phoneticSymbolUS,
    this.phoneticSymbolUK,
    this.speechUS,
    this.speechUK,
    this.prototype,
    this.definitions = const [],
    this.forms = const [],
  });

  @override
  String toString() {
    return 'Word{word: $word}';
  }
}

class WordForm {
  String word;
  String value;

  WordForm({required this.word, required this.value});
}

class WordSuggestion {
  String word;
  String explain;

  WordSuggestion({required this.word, required this.explain});

  @override
  String toString() {
    return 'WordSuggestion{word: $word, explain: $explain}';
  }
}

class StarredWord {
  String get identity {
    return word.toLowerCase();
  }

  final String word;
  final String summary;

  StarredWord({required this.word, this.summary = ''});
}

class Settings extends ChangeNotifier {
  HotKey _querySelectionHotKey = HotKey(KeyCode.keyS,
      modifiers: [KeyModifier.alt], scope: HotKeyScope.system);
  HotKey _queryClipboardHotKey = HotKey(KeyCode.keyC,
      modifiers: [KeyModifier.alt], scope: HotKeyScope.system);

  HotKey get querySelectionHotKey {
    return _querySelectionHotKey;
  }

  set querySelectionHotKey(value) {
    _querySelectionHotKey = value;
    ShortcutService.instance.restart(this);
    notifyListeners();
  }

  HotKey get queryClipboardHotKey {
    return _queryClipboardHotKey;
  }

  set queryClipboardHotKey(value) {
    _queryClipboardHotKey = value;
    ShortcutService.instance.restart(this);
    notifyListeners();
  }
}
