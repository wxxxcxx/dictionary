
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:dictionary/ui/page/search_page.dart';
import 'package:dictionary/ui/page/settings_page.dart';
import 'package:dictionary/ui/page/stars_page.dart';
import 'package:dictionary/ui/widget/navigator_container.dart';

class MobileFrame extends StatefulWidget {
  const MobileFrame({Key? key}) : super(key: key);

  @override
  State<MobileFrame> createState() => _MobileFrameState();
}

class _MobileFrameState extends State<MobileFrame> {
  List<Widget> pages = [
    const SearchPage(),
    const StarsPage(),
    const SettingsPage()
  ];

  int _currentPageIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final style = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Theme.of(context).brightness == Brightness.light
          ? Brightness.dark
          : Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(style);
    return NavigatorContainer(
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? const Color(0xFFEFEFEF)
              : const Color(0xFF21252B),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    physics: const BouncingScrollPhysics(),
                    pageSnapping: true,
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPageIndex = index;
                      });
                    },
                    children: pages,
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? const Color(0xFFFFFFFF)
                  : const Color(0xFF282C34),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withAlpha(0x44),
                  blurRadius: 0.1,
                )
              ],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Material(
                      type: MaterialType.transparency,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      clipBehavior: Clip.antiAlias,
                      elevation: 5,
                      child: IconButton(
                        onPressed: () {
                          _pageController.animateToPage(0,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease);
                        },
                        icon: _currentPageIndex == 0
                            ? const Icon(Ionicons.home)
                            : const Icon(Ionicons.home_outline),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Material(
                      type: MaterialType.transparency,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: IconButton(
                        onPressed: () {
                          _pageController.animateToPage(1,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease);
                        },
                        icon: _currentPageIndex == 1
                            ? const Icon(Ionicons.star)
                            : const Icon(Ionicons.star_outline),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Material(
                      type: MaterialType.transparency,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: IconButton(
                        onPressed: () {
                          _pageController.animateToPage(2,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease);
                        },
                        icon: _currentPageIndex == 2
                            ? const Icon(Ionicons.settings_sharp)
                            : const Icon(Ionicons.settings_outline),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
