import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

@immutable
class Loading extends StatefulWidget {

  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with TickerProviderStateMixin {
  late final AnimationController spinController;
  @override
  void initState() {
    spinController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    spinController.repeat();
    super.initState();
  }

  @override
  void dispose() {
    spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: spinController,
      child: const Icon(Ionicons.sync),
    );
  }
}
