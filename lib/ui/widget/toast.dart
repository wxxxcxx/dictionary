import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ToastNotification extends Notification {
  final String message;
  ToastNotification(this.message);
}

class ToastWrapper extends StatefulWidget {
  final Widget child;

  ToastWrapper({Key? key, required this.child}) : super(key: key);

  @override
  State<ToastWrapper> createState() => _ToastWrapperState();
}

class _ToastWrapperState extends State<ToastWrapper>
    with SingleTickerProviderStateMixin {
  String message = 'Hello';

  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ToastNotification>(
      onNotification: (notification) {
        setState(() {
          message = notification.message;
        });
        _controller.forward();
        Future.delayed(const Duration(seconds: 2)).then((value) {
          _controller.reverse();
        });
        return true;
      },
      child: Stack(
        children: [
          widget.child,
          IgnorePointer(
            child: Container(
              color: const Color(0x00ff88ff),
              child: Builder(
                builder: (BuildContext context) {
                  return FadeTransition(
                    opacity: _controller,
                    child: Align(
                      alignment: const Alignment(0, 0.8),
                      child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                          .backgroundColor
                                          .computeLuminance() <
                                      0.5
                                  ? Colors.white
                                  : Colors.black,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            message,
                            style: TextStyle(
                                color: Theme.of(context)
                                            .backgroundColor
                                            .computeLuminance() <
                                        0.5
                                    ? Colors.black
                                    : Colors.white),
                          )),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
    ;
  }
}
