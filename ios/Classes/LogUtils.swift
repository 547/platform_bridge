import Foundation
import os.log

/**
 * 日志工具类，用于统一处理日志输出
 */
class LogUtils {
    private static let subsystem = Bundle.main.bundleIdentifier!
    private static let log = OSLog(subsystem: subsystem, category: "PlatformBridge")
    private static let pluginTag = "PlatformBridgePlugin"
    private static let levelError = "ERROR"
    private static let levelWarning = "WARNING"
    
    /**
     * 格式化日志消息
     */
    private static func formatMessage(_ message: String, level: String? = nil) -> String {
        if let level = level {
            return "[\(pluginTag)] \(level): \(message)"
        }
        return "[\(pluginTag)] \(message)"
    }
    
    /**
     * 输出调试日志
     */
    static func debug(_ message: String) {
        let fullMessage = formatMessage(message)
        if #available(iOS 10.0, *) {
            os_log("%{public}@", log: log, type: .debug, fullMessage)
        } else {
            NSLog("%@", fullMessage)
        }
    }
    
    /**
     * 输出信息日志
     */
    static func info(_ message: String) {
        let fullMessage = formatMessage(message)
        if #available(iOS 10.0, *) {
            os_log("%{public}@", log: log, type: .info, fullMessage)
        } else {
            NSLog("%@", fullMessage)
        }
    }
    
    /**
     * 输出错误日志
     */
    static func error(_ message: String) {
        let fullMessage = formatMessage(message, level: levelError)
        if #available(iOS 10.0, *) {
            os_log("%{public}@", log: log, type: .error, fullMessage)
        } else {
            NSLog("%@", fullMessage)
        }
    }
    
    /**
     * 输出警告日志
     */
    static func warning(_ message: String) {
        let fullMessage = formatMessage(message, level: levelWarning)
        if #available(iOS 10.0, *) {
            os_log("%{public}@", log: log, type: .info, fullMessage)  // os_log doesn't have warning level
        } else {
            NSLog("%@", fullMessage)
        }
    }
}