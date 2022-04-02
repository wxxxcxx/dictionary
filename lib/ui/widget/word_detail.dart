import 'package:flutter/material.dart';
import 'package:dictionary/src/api.dart';
import 'package:dictionary/src/model.dart';
import 'package:dictionary/ui/widget/loading.dart';
import 'package:dictionary/ui/widget/phonetic_symbol.dart';
import 'package:dictionary/ui/widget/star_button.dart';

class WordDetail extends StatefulWidget {
  final String word;

  const WordDetail({Key? key, required this.word}) : super(key: key);

  @override
  State<WordDetail> createState() => _WordDetailState();
}

class _WordDetailState extends State<WordDetail> {
  @override
  void initState() {
    super.initState();
  }

  Widget _buildHearderWidget(context, Word word) {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.word,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        StarButton(word: word.word),
      ],
    );
  }

  Widget _buildPhoneticSymbolWidget(context, Word word) {
    if ((word.phoneticSymbolUS == null || word.phoneticSymbolUS == '') &&
        (word.phoneticSymbolUK == null || word.phoneticSymbolUK == '')) {
      return const SizedBox.shrink();
    } else {
      return Container(
        margin: const EdgeInsets.only(top: 15),
        child: Row(
          children: [
            if (word.phoneticSymbolUS != null &&
                word.phoneticSymbolUS!.isNotEmpty)
              Expanded(
                child: PhoneticSymbol(
                  label: 'US',
                  phoneticSymbol: word.phoneticSymbolUS!,
                  voice: word.speechUS!,
                ),
              ),
            if (word.phoneticSymbolUK != null &&
                word.phoneticSymbolUK!.isNotEmpty)
              Expanded(
                child: PhoneticSymbol(
                  phoneticSymbol: word.phoneticSymbolUK!,
                  voice: word.speechUK!,
                  label: 'UK',
                ),
              ),
          ],
        ),
      );
    }
  }

  Widget _buildDefinitionsWidget(context, Word word) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(10),
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? const Color(0xFFF5F5F5)
            : const Color(0xFF323844),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: word.definitions
              .map((item) => Row(
                    children: [
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: SelectableText(item)),
                      ),
                    ],
                  ))
              .toList()),
    );
  }

  Widget _buildFormsWidget(context, Word word) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(5),
      alignment: Alignment.topLeft,
      child: Column(
        children: [
          Builder(builder: (context) {
            if (word.prototype == null) {
              return const SizedBox.shrink();
            }
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  const Expanded(
                    child: SelectableText('原型'),
                  ),
                  Expanded(
                    child: InkWell(child: SelectableText(word.prototype!)),
                  ),
                ],
              ),
            );
          }),
          ...word.forms
              .map((item) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: SelectableText(item.word),
                        ),
                        Expanded(
                          child: SelectableText(item.value),
                        ),
                      ],
                    ),
                  ))
              .toList()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Client.query(widget.word),
        builder: (BuildContext context, AsyncSnapshot<Word> snapshot) {
          var content = [];
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              content = [
                Text(
                  snapshot.error.toString(),
                )
              ];
            }
            if (snapshot.hasData) {
              content = [
                _buildHearderWidget(context, snapshot.data!),
                _buildPhoneticSymbolWidget(context, snapshot.data!),
                _buildDefinitionsWidget(context, snapshot.data!),
                _buildFormsWidget(context, snapshot.data!),
              ];
            }
          } else {
            content = [const Loading()];
          }

          return Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [...content],
            ),
          );
        });
  }
}
