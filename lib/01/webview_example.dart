import 'dart:async';
import 'dart:io';

import 'package:app_bridge/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

///  Name: WebViewExample
///  Created by Fitem on 2022/12/16
class WebViewExample extends StatefulWidget {
  const WebViewExample({Key? key}) : super(key: key);

  @override
  State<WebViewExample> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: const Text('Flutter WebView example'),
        actions: <Widget>[
          PopupMenuButton(
              itemBuilder: (context) {
            return [
              const PopupMenuItem<int>(
                value: 0,
                child: Text("测试H5给App发送消息"),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text("测试App给H5发送消息"),
              )
            ];
          }, onSelected: (value) {
            _onTest(value);
          })
        ],
      ),
      body: WebView(
        initialUrl: 'https://flutter.dev',
        javascriptMode: JavascriptMode.unrestricted,
        javascriptChannels: {
          // 设置JavascriptChannel
          JavascriptChannel(
            name: 'jsBridge',
            onMessageReceived: (JavascriptMessage message) {
              // 在这里处理来自H5的消息
              AppUtil.show(message.message);
            },
          ),
        },
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }

  Future<void> _onTest(int value) async {
    var webViewController = await _controller.future;
    if (value == 0) {
      await webViewController
          .runJavascript("window.jsBridge.postMessage('Hello, world!')");
    } else {
      await webViewController.runJavascript("""  
      // 接收来自App的消息
      window.receiveMessage = function receiveMessage(message) {
        console.log(message);
      };""");
      await webViewController.runJavascript("receiveMessage('App给H5发送消息')");
    }
  }
}
