import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'platform_bridge_method_channel.dart';

/// 平台桥接插件的抽象接口
///
/// 定义了Flutter与原生平台之间双向通信所需的方法
/// 具体的平台实现（如Android、iOS）应继承此类并实现相应方法
abstract class PlatformBridgePlatform extends PlatformInterface {
  /// 构造函数
  PlatformBridgePlatform() : super(token: _token);

  /// 用于验证平台实现的token
  static final Object _token = Object();

  /// 当前实例
  static PlatformBridgePlatform _instance = MethodChannelPlatformBridge();

  /// 获取默认的 [PlatformBridgePlatform] 实例
  ///
  /// 默认返回 [MethodChannelPlatformBridge] 实例
  static PlatformBridgePlatform get instance => _instance;

  /// 设置平台特定的实现
  ///
  /// 平台特定的实现应在此处设置自己的扩展 [PlatformBridgePlatform] 类的实例
  static set instance(PlatformBridgePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// 获取平台版本
  ///
  /// 返回平台的版本信息
  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  /// 发送数据到原生平台
  ///
  /// [name] - 数据标识符
  /// [data] - 要发送的数据（支持String, int, double, bool, Map, List等类型）
  Future<void> sendToNative(String name, dynamic data) {
    throw UnimplementedError('sendToNative() has not been implemented.');
  }

  /// 监听来自原生平台的数据
  ///
  /// [name] - 数据标识符
  /// [callback] - 接收数据的回调函数
  void listenFromNative(String name, Function(dynamic data) callback) {
    throw UnimplementedError('listenFromNative() has not been implemented.');
  }
}
