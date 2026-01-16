/// 日志工具类，用于统一处理日志输出
class LogUtils {
  static const String _pluginTag = 'PlatformBridgePlugin';
  static const String _levelError = 'ERROR';
  static const String _levelWarning = 'WARNING';

  /// 格式化日志消息
  static String _formatMessage(String message, [String? level]) {
    if (level != null) {
      return '[$_pluginTag] $level: $message';
    }
    return '[$_pluginTag] $message';
  }

  /// 输出调试日志
  static void debug(String message) {
    _printLog(_formatMessage(message));
  }

  /// 输出信息日志
  static void info(String message) {
    _printLog(_formatMessage(message));
  }

  /// 输出错误日志
  static void error(String message) {
    _printLog(_formatMessage(message, _levelError));
  }

  /// 输出警告日志
  static void warning(String message) {
    _printLog(_formatMessage(message, _levelWarning));
  }

  /// 格式化日志消息并输出
  static void _printLog(String message) {
    // 在调试模式下打印日志
    assert(() {
      // ignore: avoid_print
      print(message);
      return true;
    }());
  }
}
