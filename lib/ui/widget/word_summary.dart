import 'package:flutter/material.dart';

class WordSummary extends StatefulWidget {
  final String word;

  final String explain;

  const WordSummary({
    required this.word,
    required this.explain,
    Key? key,
  }) : super(key: key);

  @override
  State<WordSummary> createState() => _WordSummaryState();
}

class _WordSummaryState extends State<WordSummary> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              widget.word,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 24),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              widget.explain,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xff999999), fontSize: 14),
            ),
          )
        ],
      ),
    );
  }
}
