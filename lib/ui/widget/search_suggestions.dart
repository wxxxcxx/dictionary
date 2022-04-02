import 'package:dictionary/src/history_repository.dart';
import 'package:flutter/material.dart';
import 'package:dictionary/src/api.dart';
import 'package:dictionary/src/model.dart';
import 'package:dictionary/ui/widget/loading.dart';
import 'package:dictionary/ui/widget/word_summary.dart';

class SearchSuggestions extends StatefulWidget {
  final String word;

  Function(WordSuggestion)? onSelect;

  SearchSuggestions({Key? key, required this.word, this.onSelect})
      : super(key: key);

  @override
  State<SearchSuggestions> createState() => _SearchSuggestionsState();
}

class _SearchSuggestionsState extends State<SearchSuggestions> {
  Widget _buildSuggestions(
      BuildContext context, List<WordSuggestion> suggestions) {
    if (suggestions.isEmpty) {
      return Container(
          alignment: Alignment.topCenter,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
          child: const Text('No suggestions'));
    }
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        final word = suggestions[index];
        return Container(
          key: ValueKey(word.word.toLowerCase()),
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onTap: () {
              if (widget.onSelect != null) {
                widget.onSelect!(word);
              }
            },
            child: WordSummary(
              word: word.word,
              explain: word.explain,
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Divider(),
        );
      },
      itemCount: suggestions.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.word.isEmpty
          ? HistoryRepository.instance.list()
          : Client.suggest(widget.word),
      builder:
          (BuildContext context, AsyncSnapshot<List<WordSuggestion>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Container(
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
              child: Text('${snapshot.error}'),
            );
          }
          if (snapshot.hasData) {
            final suggestions = snapshot.data;
            return _buildSuggestions(context, suggestions!);
          }
          return const SizedBox.shrink();
        } else {
          return Container(
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
              child: const Loading());
        }
      },
    );
  }
}
