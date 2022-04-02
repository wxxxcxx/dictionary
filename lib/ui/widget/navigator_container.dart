import 'package:flutter/material.dart';

class NavigatorContainer extends StatefulWidget {
  final Widget Function(BuildContext context) builder;

  NavigatorContainer({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  State<NavigatorContainer> createState() => _NavigatorContainerState();
}

class _NavigatorContainerState extends State<NavigatorContainer> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? result = await navigatorKey.currentState?.maybePop(null);
        return !result!;
      },
      child: Navigator(
        key: navigatorKey,
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(builder: (context) {
            return Builder(builder: widget.builder);
          });
        },
      ),
    );
  }
}
