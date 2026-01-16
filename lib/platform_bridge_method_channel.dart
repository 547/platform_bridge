import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'platform_bridge_platform_interface.dart';
import 'log_utils.dart';

/// 一个使用方法通道（MethodChannel）实现 [PlatformBridgePlatform] 的实现类
///
/// 提供了Flutter与原生平台之间的双向通信功能
class MethodChannelPlatformBridge extends PlatformBridgePlatform {
  /// 与原生平台交互所使用的方法通道
  @visibleForTesting
  late final MethodChannel methodChannel;

  /// 存储监听器的Map，用于接收来自原生平台的数据
  static final Map<String, Function(dynamic data)> _listeners = {};

  /// 常量定义
  static const String _channelName =
      'com.seven.platform_bridge/platform_bridge';
  static const String _methodGetPlatformVersion = 'getPlatformVersion';
  static const String _methodSendToNative = 'sendToNative';
  static const String _methodSendToFlutter = 'sendToFlutter';
  static const String _paramName = 'name';
  static const String _paramData = 'data';

  /// 构造函数，初始化方法通道并设置监听器
  MethodChannelPlatformBridge() {
    methodChannel = const MethodChannel(_channelName);

    // 设置MethodChannel监听器来处理来自原生的数据
    methodChannel.setMethodCallHandler((call) async {
      if (call.method == _methodSendToFlutter) {
        final String receivedName = call.arguments[_paramName] as String;
        final data = call.arguments[_paramData];

        LogUtils.debug(
            'Received data from native: name=$receivedName, data=$data');

        if (_listeners.containsKey(receivedName)) {
          LogUtils.debug('Calling listener for name: $receivedName');
          _listeners[receivedName]!(data);
        } else {
          LogUtils.warning('No listener found for name: $receivedName');
        }
      }
      return null;
    });

    LogUtils.info(
        'MethodChannelPlatformBridge initialized with channel: $_channelName');
  }

  /// 获取平台版本信息
  @override
  Future<String?> getPlatformVersion() async {
    LogUtils.debug('Calling $_methodGetPlatformVersion method');
    final version =
        await methodChannel.invokeMethod<String>(_methodGetPlatformVersion);
    LogUtils.debug('Received platform version: $version');
    return version;
  }

  /// 发送数据到原生平台
  ///
  /// [name] - 数据标识符
  /// [data] - 要发送的数据
  @override
  Future<void> sendToNative(String name, dynamic data) async {
    LogUtils.debug('Sending data to native: name=$name, data=$data');
    await methodChannel.invokeMethod(
        _methodSendToNative, {_paramName: name, _paramData: data});
    LogUtils.debug('Successfully sent data to native: name=$name');
  }

  /// 监听来自原生平台的数据
  ///
  /// [name] - 数据标识符
  /// [callback] - 接收数据的回调函数
  @override
  void listenFromNative(String name, Function(dynamic data) callback) {
    LogUtils.debug('Setting up listener for native data: name=$name');
    _listeners[name] = callback;
  }

  /// 销毁资源，取消订阅
  void dispose() {
    LogUtils.info('Disposing PlatformBridge resources');
    _listeners.clear();
  }
}
