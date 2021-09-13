import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:we_pei_yang_flutter/generated/l10n.dart';
import 'package:we_pei_yang_flutter/commons/util/font_manager.dart';

// ignore: must_be_immutable
class WikiPage extends StatelessWidget {
  static const URL = "https://wiki.tjubot.cn/";
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var flag = await _controller.canGoBack();
        if (flag) _controller.goBack();
        return !flag;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Text(S.current.wiki,
                style: FontManager.YaHeiRegular.copyWith(
                    fontSize: 16,
                    color: Color.fromRGBO(36, 43, 69, 1),
                    fontWeight: FontWeight.bold)),
            elevation: 0,
            brightness: Brightness.light,
            centerTitle: true,
            backgroundColor: Colors.white,
            leading: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: GestureDetector(
                  child: Icon(Icons.arrow_back,
                      color: Color.fromRGBO(53, 59, 84, 1.0), size: 32),
                  onTap: () => Navigator.pop(context)),
            )),
        body: WebView(
            initialUrl: URL,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController controller) {
              this._controller = controller;
            }),
      ),
    );
  }
}
