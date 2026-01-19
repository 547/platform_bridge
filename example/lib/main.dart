import 'dart:async';

import 'package:flutter/material.dart';
import 'package:platform_bridge/platform_bridge.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final PlatformBridge _bridge = PlatformBridge();
  static const List<String> eventsToMonitor = [
    'INITIAL_DATA',
    'USER_INFO_DELAYED',
    'COUNTER_UPDATE',
    'COMPLEX_DATA',
    'HEARTBEAT',
    'PERIODIC_UPDATE',
    'CLICK_COUNT',
    'USER_INFO',
    'TEST_FROM_FLUTTER'
  ];
  int clickCount = 0;
  @override
  void initState() {
    super.initState();
    _initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _initPlatformState() async {
    // 为每个事件设置监听器
    for (final eventName in eventsToMonitor) {
      _bridge.listenFromNative(eventName, (data) {
        debugPrint('Flutter received from Native ($eventName): $data');
      });
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          title: const Text('Platform Bridge Example'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 发送数据到原生的按钮
                const SizedBox(height: 20),
                const Text(
                  'Send Data to Native',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: _sendClickCount,
                  child: const Text('Send Click Count to Native'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _sendUserInfo,
                  child: const Text('Send User Info to Native'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _sendTestData,
                  child: const Text('Send Test Data to Native'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 发送点击次数到原生
  void _sendClickCount() async {
    clickCount++;

    await _bridge.sendToNative('CLICK_COUNT', {
      'click_count': clickCount,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    debugPrint('Sent CLICK_COUNT to native: $clickCount');
  }

  // 发送用户信息到原生
  void _sendUserInfo() async {
    await _bridge.sendToNative('USER_INFO', {
      'name': 'Flutter User',
      'platform': 'Flutter',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    debugPrint('Sent USER_INFO to native');
  }

  // 发送测试数据到原生
  void _sendTestData() async {
    await _bridge.sendToNative('TEST_FROM_FLUTTER', {
      'message': 'Hello from Flutter!',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    debugPrint('Sent TEST_FROM_FLUTTER to native');
  }

  @override
  void dispose() {
    super.dispose();
  }
}
