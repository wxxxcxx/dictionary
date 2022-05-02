import 'package:dictionary/src/history_repository.dart';
import 'package:flutter/material.dart';
import 'package:screen_text_extractor/screen_text_extractor.dart';
import 'package:dictionary/src/shortcut.dart';
import 'package:dictionary/ui/widget/search_input.dart';
import 'package:dictionary/ui/widget/search_suggestions.dart';
import 'package:dictionary/ui/widget/word_detail.dart';

class SearchPage extends StatefulWidget {
  final String word;

  const SearchPage({Key? key, this.word = ''}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool explicit = false;

  String currentWord = '';

  TextEditingController controller = TextEditingController();

  showSuggestions(String word) {
    setState(() {
      explicit = false;
      currentWord = word;
    });
  }

  showDetail(String word) {
    HistoryRepository.instance.add(word);
    setState(() {
      explicit = true;
      currentWord = word;
    });
  }

  @override
  void initState() {
    ShortcutService.instance.addListener((type) {
      switch (type) {
        case ShortcutEventType.querySelection:
          {
            ScreenTextExtractor.instance
                .extract(mode: ExtractMode.screenSelection)
                .then((value) {
              if (value != null) {
                controller.text = value.text!;
                showDetail(value.text!);
              }
            });
          }
          break;
        case ShortcutEventType.queryClipboard:
          {
            ScreenTextExtractor.instance
                .extract(mode: ExtractMode.clipboard)
                .then((value) {
              if (value != null) {
                controller.text = value.text!;
                showDetail(value.text!);
              }
            });
          }
          break;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (explicit) {
          setState(() {
            explicit = false;
            currentWord = controller.text;
          });
          return false;
        }
        if (controller.text.isNotEmpty) {
          controller.clear();
          setState(() {
            explicit = false;
            currentWord = controller.text;
          });
          return false;
        }
        return true;
      },
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: SearchInput(
            controller: controller,
            onSearchChanged: showSuggestions,
            onSearchComplete: () {
              showDetail(controller.text);
            },
          ),
        ),
        Expanded(
          child: Scrollbar(
            child: Container(
              child: explicit
                  ? SingleChildScrollView(child: WordDetail(word: currentWord))
                  : SearchSuggestions(
                      word: currentWord,
                      onSelect: (word) {
                        if (controller.text.isEmpty) {
                          controller.text = word.word;
                        }
                        showDetail(word.word);
                      },
                    ),
            ),
          ),
        )
      ]),
    );
  }
}
