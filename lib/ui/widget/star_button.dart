import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:dictionary/src/starred_repository.dart';
import 'package:dictionary/ui/widget/toast.dart';

class StarButton extends StatefulWidget {
  final String word;

  const StarButton({Key? key, required this.word}) : super(key: key);

  @override
  State<StarButton> createState() => _StarButtonState();
}

class _StarButtonState extends State<StarButton> {
  bool starred = false;

  loadStarStatus() async {
    final exists = await StarredWordRepository.instance.exists(widget.word);
    setState(() {
      starred = exists;
    });
  }

  toggleStar() async {
    if (await StarredWordRepository.instance.exists(widget.word)) {
      await StarredWordRepository.instance.remove(widget.word);
    } else {
      await StarredWordRepository.instance.add(widget.word);
      ToastNotification('Starred').dispatch(context);
    }
    await loadStarStatus();
  }

  @override
  void initState() {
    loadStarStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(5),
      clipBehavior: Clip.antiAlias,
      child: IconButton(
        icon: Builder(
          builder: (BuildContext context) {
            if (starred) {
              return const Icon(Ionicons.star);
            } else {
              return const Icon(Ionicons.star_outline);
            }
          },
        ),
        onPressed: toggleStar,
      ),
    );
  }
}
