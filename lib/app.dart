import 'dart:io';

import 'package:dictionary/ui/frame/frame.dart';
import 'package:flutter/material.dart';

class WordsApp extends StatelessWidget {
  WordsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
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
    );
  }
}
