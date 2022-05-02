import 'dart:io';

import 'package:dictionary/src/model.dart';
import 'package:dictionary/src/window_listener.dart';
import 'package:dictionary/ui/frame/frame.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:tray_manager/tray_manager.dart' as tray;
import 'package:window_manager/window_manager.dart';

class WordsApp extends StatefulWidget {
  const WordsApp({Key? key}) : super(key: key);

  @override
  State<WordsApp> createState() => _WordsAppState();
}

class _WordsAppState extends State<WordsApp> with tray.TrayListener {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Settings(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.transparent,
          primarySwatch: Colors.grey,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.transparent,
          primarySwatch: Colors.grey,
        ),
        home: const Frame(),
      ),
    );
  }

  @override
  void initState() {
    tray.trayManager.addListener(this);
    windowManager.addListener(MainWindowListener());
    super.initState();
  }

  @override
  void dispose() {
    tray.trayManager.removeListener(this);
    super.dispose();
  }

  @override
  Future<void> onTrayMenuItemClick(tray.MenuItem menuItem) async {
    if (menuItem.key == 'show_window') {
      await windowManager
          .setPosition(await ScreenRetriever.instance.getCursorScreenPoint());
      await windowManager.show();
    } else if (menuItem.key == 'exit') {
      await windowManager.setPreventClose(false);
      await windowManager.close();
    }
  }
}
