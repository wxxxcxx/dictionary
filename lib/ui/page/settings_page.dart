import 'dart:io';

import 'package:dictionary/src/history_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:dictionary/src/model.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  Widget _buildDesktopOptionWidgets(BuildContext context) {
    return Consumer<Settings>(
      builder: (context, settings, child) {
        return Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '热键',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Row(
                children: [
                  Text(
                    '查询选中的单词',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const Expanded(child: SizedBox.shrink()),
                  InkWell(
                    onTap: () async {
                      final key = await showDialog(
                          context: context,
                          builder: (context) {
                            return Center(
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text('请输入热键')),
                                    HotKeyRecorder(
                                      initalHotKey:
                                          settings.querySelectionHotKey,
                                      onHotKeyRecorded: (hotKey) {
                                        if (hotKey.modifiers != null &&
                                            hotKey.modifiers!.isNotEmpty) {
                                          Navigator.of(context).pop(hotKey);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                      if (key != null) {
                        settings.querySelectionHotKey = key;
                      }
                    },
                    child: Text('${settings.querySelectionHotKey}'),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '查询已复制的单词',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const Expanded(child: SizedBox.shrink()),
                  InkWell(
                    onTap: () async {
                      final key = await showDialog(
                          context: context,
                          builder: (context) {
                            return Center(
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text('请输入热键')),
                                    HotKeyRecorder(
                                      initalHotKey:
                                          settings.queryClipboardHotKey,
                                      onHotKeyRecorded: (hotKey) {
                                        if (hotKey.modifiers != null &&
                                            hotKey.modifiers!.isNotEmpty) {
                                          Navigator.of(context).pop(hotKey);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                      if (key != null) {
                        settings.queryClipboardHotKey = key;
                      }
                    },
                    child: Text('${settings.queryClipboardHotKey}'),
                  ),
                ],
              ),
              const Divider(
                height: 20,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQueryOptionsWidget(BuildContext context) {
    return Consumer<Settings>(builder: (context, settings, child) {
      return Container(
          margin: const EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              '查询',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            OutlinedButton(
              onPressed: () {
                HistoryRepository.instance.clean();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('清除查询记录'),
                ],
              ),
            ),
            const Divider(
              height: 20,
            ),
          ]));
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = false;
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      isDesktop = true;
    }
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildQueryOptionsWidget(context),
          if (isDesktop) _buildDesktopOptionWidgets(context),
          OutlinedButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('退出'),
                Icon(Ionicons.exit_outline),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
