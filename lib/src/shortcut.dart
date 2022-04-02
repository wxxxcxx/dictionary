import 'dart:io';

import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:dictionary/src/model.dart';

enum ShortcutEventType { querySelection, queryClipboard }

class ShortcutService {
  ShortcutService._();

  static final ShortcutService instance = ShortcutService._();

  final List<void Function(ShortcutEventType)> _listeners = [];

  addListener(void Function(ShortcutEventType) listener) {
    if (!_listeners.any((element) => element == listener)) {
      _listeners.add(listener);
    }
  }

  start(Settings settings) async {
    if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
      await hotKeyManager.unregisterAll();

      await hotKeyManager.register(
        settings.querySelectionHotKey,
        keyDownHandler: (hotKey) {
          for (var listener in _listeners) {
            listener(ShortcutEventType.querySelection);
          }
        },
      );

      await hotKeyManager.register(
        settings.queryClipboardHotKey,
        keyDownHandler: (hotKey) {
          for (var listener in _listeners) {
            listener(ShortcutEventType.queryClipboard);
          }
        },
      );
    }
  }

  stop() async {
    if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
      await hotKeyManager.unregisterAll();
    }
  }

  restart(Settings settings) async {
    await stop();
    await start(settings);
  }
}
