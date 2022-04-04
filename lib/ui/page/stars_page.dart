import 'package:flutter/material.dart';
import 'package:dictionary/src/model.dart';
import 'package:dictionary/src/starred_repository.dart';
import 'package:dictionary/ui/widget/loading.dart';
import 'package:dictionary/ui/widget/word_detail.dart';
import 'package:dictionary/ui/widget/word_summary.dart';

class StarsPage extends StatefulWidget {
  const StarsPage({Key? key}) : super(key: key);

  @override
  State<StarsPage> createState() => _StarsPageState();
}

class _StarsPageState extends State<StarsPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: StarredWordRepository.instance.list(),
      builder:
          (BuildContext context, AsyncSnapshot<List<StarredWord>> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text('空'),
            );
          }

          return Container(
            margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              separatorBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Divider(),
                );
              },
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                return Container(
                  key: ValueKey(item.word.toLowerCase()),
                  child: InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onTap: () {
                      showModalBottomSheet(
                          // useRootNavigator: true,
                          backgroundColor:
                              Theme.of(context).brightness == Brightness.light
                                  ? const Color(0xFFF5F5F5)
                                  : const Color(0xFF282C34),
                          isDismissible: true,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          context: context,
                          builder: (context) {
                            return FractionallySizedBox(
                              heightFactor: 0.9,
                              child: WordDetail(
                                word: item.word,
                              ),
                            );
                          });
                      // Navigator.of(context)
                      //     .push(MaterialPageRoute(builder: (context) {
                      //   return DetailPage(word: e['word']);
                      // }));
                    },
                    child: WordSummary(
                      word: item.word,
                      explain: '',
                    ),
                  ),
                );
              },
              itemCount: snapshot.data!.length,
            ),
          );
        } else {
          return const Center(child: Loading());
        }
      },
    );
  }
}
