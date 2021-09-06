import 'dart:async';

import 'package:flutter/foundation.dart';

// TODO 手动调用位置：全局页面跳转、ToastProvider、dio request & response(可重写log interceptor)
class Logger {
  /// release模式下在内存中存储log信息
  static List<String> logs = List();

  static void reportPrint(ZoneDelegate parent, Zone zone, String str) {
    String line = _getFormatTime() + ' | ' + str;
    if (kDebugMode) {
      parent.print(zone, line);
    } else {
      checkList();
      logs.add(line);
    }
  }

  static void reportError(Object error, StackTrace stack) {
    List<String> lines = [
      '----------------------------------------------------------------------',
      _getFormatTime() + ' | ' + error.toString(),
      stack.toString(),
      '----------------------------------------------------------------------'
    ];
    if (kDebugMode) {
      for (String line in lines) print(line);
    } else {
      checkList();
      logs.addAll(lines);
    }
  }

  // TODO 为了防止内存占用，暂时先控制log条数在200条以内
  static void checkList() {
    if (logs.length < 200) return;
    List<String> newList = List()
      ..addAll(logs.getRange(logs.length - 50, logs.length));
    logs = newList;
  }

  // TODO
  static Future<void> uploadLogs() async {}

  static String _getFormatTime() {
    var now = DateTime.now();
    return "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
  }
}
