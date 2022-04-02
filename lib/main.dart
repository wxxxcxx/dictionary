import 'dart:io';
import 'package:dictionary/src/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:kplayer/kplayer.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'app.dart';

void main() async {
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    WidgetsFlutterBinding.ensureInitialized();

    await windowManager.ensureInitialized();
    // Use it only after calling `hiddenWindowAtLaunch`
    windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setTitleBarStyle(TitleBarStyle.normal);
      // await windowManager.setAsFrameless();
      // await windowManager.setAlwaysOnTop(true);
      await windowManager.setBackgroundColor(Colors.transparent);
      await windowManager.center();
      await windowManager.setSize(const Size(500, 600));
      await windowManager.setSkipTaskbar(false);
      await windowManager.show();
      await windowManager.focus();
    });
  }
  Player.boot();
  runApp(ChangeNotifierProvider(
    create: (context) => Settings(),
    child: WordsApp(),
  ));
}
