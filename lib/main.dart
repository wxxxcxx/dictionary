import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kplayer/kplayer.dart';
import 'package:logging/logging.dart';
import 'package:tray_manager/tray_manager.dart' as tray;
import 'package:window_manager/window_manager.dart';

import 'app.dart';

final logger = Logger('DictionaryLogger');
final loggerFile = File('/home/meetcw/dictionary.log');

void main(List<String> args) async {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
    loggerFile.writeAsStringSync(
        '${record.level.name}: ${record.time}: ${record.message}');
  });
  if (!loggerFile.existsSync()) {
    loggerFile.createSync(recursive: true);
  }
  logger.info('$args');

  if (args.isNotEmpty) {
    final uri = Uri.parse(args[0]);
    final String? code = uri.queryParameters['code'];
    logger.info('code: $code');
  }

  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    WidgetsFlutterBinding.ensureInitialized();

    await windowManager.ensureInitialized();
    // Use it only after calling `hiddenWindowAtLaunch`
    windowManager.waitUntilReadyToShow().then((_) async {
      // await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
      // await windowManager.setAsFrameless();
      // await windowManager.setAlwaysOnTop(true);
      await windowManager.center();
      await windowManager.setPreventClose(true);
      await windowManager.setResizable(true);
      await windowManager.setBackgroundColor(Colors.transparent);
      await windowManager.center();
      await windowManager.setSize(const Size(500, 600));
      await windowManager.setSkipTaskbar(false);
      await windowManager.show();
      await windowManager.focus();

      await tray.trayManager.setIcon(
        'assets/images/icon.svg',
      );
      List<tray.MenuItem> items = [
        tray.MenuItem(
          key: 'show_window',
          title: 'Show Window',
        ),
        tray.MenuItem.separator,
        tray.MenuItem(
          key: 'exit',
          title: 'Exit',
        ),
      ];
      await tray.trayManager.setContextMenu(items);
    });
  }
  Player.boot();
  runApp(const WordsApp());
}
