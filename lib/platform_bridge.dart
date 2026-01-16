import 'platform_bridge_platform_interface.dart';

class PlatformBridge {
  /// 获取平台版本
  Future<String?> getPlatformVersion() {
    return PlatformBridgePlatform.instance.getPlatformVersion();
  }

  /// 发送数据到原生平台
  /// name: 数据标识符
  /// data: 要发送的数据（String, int, double, bool, Map, List等类型）
  Future<void> sendToNative(String name, dynamic data) async {
    return PlatformBridgePlatform.instance.sendToNative(name, data);
  }

  /// 监听来自原生平台的数据
  /// name: 数据标识符
  /// onDataReceived: 接收数据的回调函数
  void listenFromNative(String name, Function(dynamic data) onDataReceived) {
    PlatformBridgePlatform.instance.listenFromNative(name, onDataReceived);
  }
}
