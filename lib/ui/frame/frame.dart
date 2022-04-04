import 'dart:io';

import 'package:dictionary/ui/widget/toast.dart';
import 'package:flutter/material.dart';
import 'package:dictionary/ui/frame/desktop_frame.dart';
import 'package:dictionary/ui/frame/mobile_frame.dart';

class Frame extends StatefulWidget {
  const Frame({Key? key}) : super(key: key);

  @override
  State<Frame> createState() => _FrameState();
}

class _FrameState extends State<Frame> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      return const DesktopFrame();
    } else {
      return const MobileFrame();
    }
  }
}
