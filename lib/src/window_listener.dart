import 'package:window_manager/window_manager.dart';

class MainWindowListener extends WindowListener {
  @override
  void onWindowClose() {
    windowManager.hide();
  }
}
