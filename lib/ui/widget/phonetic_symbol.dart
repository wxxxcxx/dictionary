import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kplayer/kplayer.dart';

class PhoneticSymbol extends StatefulWidget {
  final String label;
  final String? voice;
  final String phoneticSymbol;

  const PhoneticSymbol(
      {Key? key, this.voice, required this.phoneticSymbol, required this.label})
      : super(key: key);

  @override
  State<PhoneticSymbol> createState() => _PhoneticSymbolState();
}

class _PhoneticSymbolState extends State<PhoneticSymbol> {
  late final PlayerController player;

  play() {
    if (widget.voice != null && widget.voice!.isEmpty) {
      return;
    }
    player.play();
  }

  @override
  void initState() {
    player =
        Player.network(widget.voice, id: widget.voice.hashCode, once: false);
    player.callback = (event) {log('$event');};
    super.initState();
  }
  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? const Color(0xFFEFEFEF)
                : const Color(0xFF323844),
            borderRadius: BorderRadius.circular(5.0)),
        child: Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF999999),
          ),
        ),
      ),
      if (widget.voice != null)
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          clipBehavior: Clip.antiAlias,
          child: AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            child: IconButton(
                onPressed: () => play(),
                icon: const Icon(Ionicons.volume_high_outline)),
          ),
        ),
      Expanded(
        child: Row(
          children: [
            Expanded(
              child: Text(
                '/${widget.phoneticSymbol}/',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF999999),
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
