import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class SearchInput extends StatefulWidget {
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSearchComplete;
  final TextEditingController controller;

  const SearchInput({
    this.onSearchChanged,
    Key? key,
    required this.controller,
    this.onSearchComplete,
  }) : super(key: key);

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? const Color(0xFFFFFFFF)
              : const Color(0xFF323844),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withAlpha(0x44),
              blurRadius: 0.1,
            )
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          // alignment: Alignment.center,
          children: [
            Expanded(
              child: TextField(
                // autofocus: true,
                controller: widget.controller,
                style: const TextStyle(fontSize: 24),
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'hello',
                ),
                onChanged: (text) {
                  if (_debounce?.isActive ?? false) {
                    _debounce?.cancel();
                  }
                  _debounce = Timer(const Duration(milliseconds: 500), () {
                    if (widget.onSearchChanged != null) {
                      widget.onSearchChanged!(text);
                    }
                  });
                },
                onEditingComplete: widget.onSearchComplete,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Visibility(
                visible: widget.controller.text.isNotEmpty,
                child: IconButton(
                  onPressed: () {
                    // 由于当前Widget的可见性由 widget.controller.text.isNotEmpty 控制，所以需要使用setState强制刷新。
                    setState(() {
                      widget.controller.clear();
                      widget.onSearchChanged!('');
                    });
                  },
                  icon: const Icon(Ionicons.backspace_outline),
                ),
              ),
            )
          ],
        ));
  }
}
