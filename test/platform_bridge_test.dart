import 'package:flutter_test/flutter_test.dart';
import 'package:platform_bridge/platform_bridge.dart';
import 'package:platform_bridge/platform_bridge_platform_interface.dart';
import 'package:platform_bridge/platform_bridge_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPlatformBridgePlatform
    with MockPlatformInterfaceMixin
    implements PlatformBridgePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> sendToNative(String name, dynamic data) async {}

  @override
  void listenFromNative(String name, Function(dynamic data) callback) {}
}

void main() {
  final PlatformBridgePlatform initialPlatform = PlatformBridgePlatform.instance;

  test('$MethodChannelPlatformBridge is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPlatformBridge>());
  });

  test('getPlatformVersion', () async {
    PlatformBridge platformBridgePlugin = PlatformBridge();
    MockPlatformBridgePlatform fakePlatform = MockPlatformBridgePlatform();
    PlatformBridgePlatform.instance = fakePlatform;

    expect(await platformBridgePlugin.getPlatformVersion(), '42');
  });
}