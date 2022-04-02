
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:dictionary/src/model.dart';
import 'package:dictionary/src/shortcut.dart';
import 'package:dictionary/ui/page/search_page.dart';
import 'package:dictionary/ui/page/settings_page.dart';
import 'package:dictionary/ui/page/stars_page.dart';
import 'package:dictionary/ui/widget/navigator_container.dart';

class DesktopFrame extends StatefulWidget {
  const DesktopFrame({Key? key}) : super(key: key);

  @override
  State<DesktopFrame> createState() => _DesktopFrameState();
}

class _DesktopFrameState extends State<DesktopFrame> {
  List<Widget> pages = [
    NavigatorContainer(
      builder: (BuildContext context) {
        return const SearchPage();
      },
    ),
    NavigatorContainer(
      builder: (BuildContext context) {
        return const StarsPage();
      },
    ),
    const SettingsPage()
  ];

  int _currentPageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    ShortcutService.instance.addListener((type) {
      if (type == ShortcutEventType.querySelection ||
          type == ShortcutEventType.queryClipboard) {
        windowManager.focus();
        _pageController.jumpToPage(0);
      }
    });

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final settings = Provider.of<Settings>(context, listen: false);
      ShortcutService.instance.start(settings);
    });
  }

  @override
  void dispose() {
    ShortcutService.instance.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? const Color(0xFFF5F5F5)
              : const Color(0xFF282C34),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).shadowColor.withAlpha(0x33),
                blurRadius: 10)
          ],
          // borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            GestureDetector(
              onPanStart: (detail) {
                // detail.
                windowManager.startDragging();
              },
              child: Container(
                color: Colors.transparent,
                margin: const EdgeInsets.only(
                  left: 5,
                  right: 5,
                  bottom: 5,
                  top: 10,
                ),
                child: Row(
                  children: [
                    Material(
                      type: MaterialType.transparency,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: IconButton(
                        onPressed: () {
                          _pageController.animateToPage(
                            0,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.ease,
                          );
                        },
                        icon: _currentPageIndex == 0
                            ? const Icon(Ionicons.home)
                            : const Icon(Ionicons.home_outline),
                      ),
                    ),
                    Material(
                      type: MaterialType.transparency,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: IconButton(
                        onPressed: () {
                          _pageController.animateToPage(
                            1,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.ease,
                          );
                        },
                        icon: _currentPageIndex == 1
                            ? const Icon(Ionicons.star)
                            : const Icon(Ionicons.star_outline),
                      ),
                    ),
                    const Expanded(
                      child: SizedBox.shrink(),
                    ),
                    Material(
                      type: MaterialType.transparency,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: IconButton(
                        onPressed: () {
                          _pageController.animateToPage(
                            2,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.ease,
                          );
                        },
                        icon: _currentPageIndex == 2
                            ? const Icon(Ionicons.settings_sharp)
                            : const Icon(Ionicons.settings_outline),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPageIndex = index;
                      });
                    },
                    children: pages,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
