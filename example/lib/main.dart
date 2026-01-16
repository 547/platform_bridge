import 'package:flutter/material.dart';
import 'dart:async';

import 'package:platform_bridge/platform_bridge.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final PlatformBridge _bridge = PlatformBridge();
  String _platformVersion = 'Unknown';
  String _receivedData = 'No data received yet';
  int _clickCount = 0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _bridge.getPlatformVersion() ?? 'Unknown platform version';
    } catch (e) {
      debugPrint('Failed to get platform version: $e');
      return;
    }

    // 初始化监听来自原生的数据
    _bridge.listenFromNative('USER_TOKEN', (data) {
      setState(() {
        _receivedData = 'Received USER_TOKEN: $data';
      });
    });

    _bridge.listenFromNative('USER_INFO', (data) {
      setState(() {
        _receivedData = 'Received USER_INFO: $data';
      });
    });

    _bridge.listenFromNative('CLICK_COUNT', (data) {
      setState(() {
        _receivedData = 'Received CLICK_COUNT: $data';
      });
    });

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Platform Bridge Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Running on: $_platformVersion\n'),
              Text('$_receivedData\n'),
              ElevatedButton(
                onPressed: () async {
                  _clickCount++;
                  await _bridge.sendToNative('CLICK_COUNT', _clickCount);
                  setState(() {
                    _receivedData = 'Sent CLICK_COUNT: $_clickCount to native';
                  });
                },
                child: const Text('Send Click Count to Native'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final userInfo = {
                    'name': 'Flutter User',
                    'email': 'flutter@example.com',
                    'timestamp': DateTime.now().millisecondsSinceEpoch,
                  };
                  await _bridge.sendToNative('USER_INFO', userInfo);
                  setState(() {
                    _receivedData = 'Sent USER_INFO to native';
                  });
                },
                child: const Text('Send User Info to Native'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
