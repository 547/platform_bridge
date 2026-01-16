import Flutter
import UIKit

/**
 * PlatformBridgePlugin - 用于Flutter与原生iOS平台间双向通信的插件
 *
 * 功能包括：
 * 1. Flutter向原生发送数据（sendToNative）
 * 2. 原生向Flutter发送数据（sendDataToFlutter）
 * 3. 原生监听来自Flutter的数据（listenFromFlutter）
 */
public class PlatformBridgePlugin: NSObject, FlutterPlugin {
    private var channel: FlutterMethodChannel?
    
    // 存储监听器的字典，用于监听来自Flutter的数据
    private var flutterListeners: [String: (Any?) -> Void] = [:]
    
    // MARK: - Constants
    private static let CHANNEL_NAME = "com.seven.platform_bridge/platform_bridge"
    private static let METHOD_GET_PLATFORM_VERSION = "getPlatformVersion"
    private static let METHOD_SEND_TO_NATIVE = "sendToNative"
    private static let METHOD_SEND_TO_FLUTTER = "sendToFlutter"
    private static let PARAM_NAME = "name"
    private static let PARAM_DATA = "data"
    
    // MARK: - Singleton instance
    private static var sharedInstance: PlatformBridgePlugin?
    
    // 私有初始化方法
    private override init() {
        super.init()
        
        LogUtils.info("PlatformBridgePlugin initialized")
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: PlatformBridgePlugin.CHANNEL_NAME, binaryMessenger: registrar.messenger())
        let instance = PlatformBridgePlugin.getInstance()
        instance.channel = channel
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        LogUtils.info("PlatformBridgePlugin registered with registrar")
    }
    
    /**
     * 获取插件单例实例
     */
    public static func getInstance() -> PlatformBridgePlugin {
        if let instance = sharedInstance {
            return instance
        }
        let instance = PlatformBridgePlugin()
        // 保存单例引用
        PlatformBridgePlugin.sharedInstance = instance
        return instance
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        LogUtils.debug("Received method call: \(call.method)")
        
        switch call.method {
        case PlatformBridgePlugin.METHOD_GET_PLATFORM_VERSION:
            LogUtils.info("Getting platform version")
            result("iOS " + UIDevice.current.systemVersion)
        case PlatformBridgePlugin.METHOD_SEND_TO_NATIVE:
            guard let arguments = call.arguments as? [String: Any],
                  let name = arguments[PlatformBridgePlugin.PARAM_NAME] as? String else {
                LogUtils.error("Invalid arguments: Missing name or data")
                
                result(FlutterError(code: "INVALID_ARGUMENT",
                                   message: "Missing name or data",
                                   details: nil))
                return
            }
            
            let data = arguments[PlatformBridgePlugin.PARAM_DATA]
            
            LogUtils.debug("Received data from Flutter: name=\(name), data=\(String(describing: data))")
            
            // 处理由Flutter发送过来的数据
            handleDataFromFlutter(name: name, data: data)
            
            result(nil)
        default:
            LogUtils.warning("Method not implemented: \(call.method)")
            result(FlutterMethodNotImplemented)
        }
    }
    
    /**
     * 处理由Flutter发送过来的数据
     *
     * - Parameters:
     *   - name: 数据标识符
     *   - data: 要处理的数据
     */
    private func handleDataFromFlutter(name: String, data: Any?) {
        LogUtils.debug("Handling data from Flutter: name=\(name), data=\(String(describing: data))")
        
        // 检查实例特定的监听器
        if let listener = flutterListeners[name] {
            LogUtils.debug("Calling instance listener for name: \(name)")
            listener(data)
        }
    }
    
    /**
     * 向Flutter发送数据
     *
     * - Parameters:
     *   - name: 数据标识符
     *   - data: 要发送的数据
     */
    public func sendDataToFlutter(name: String, data: Any?) {
        LogUtils.debug("Sending data to Flutter: name=\(name), data=\(String(describing: data))")
        
        let args: [String: Any?] = [
            PlatformBridgePlugin.PARAM_NAME: name,
            PlatformBridgePlugin.PARAM_DATA: data
        ]
        channel?.invokeMethod(PlatformBridgePlugin.METHOD_SEND_TO_FLUTTER, arguments: args)
    }
    
    /**
     * 监听来自Flutter的数据
     *
     * - Parameters:
     *   - name: 数据标识符
     *   - listener: 接收数据的回调函数
     */
    public func listenFromFlutter(name: String, listener: @escaping (Any?) -> Void) {
        LogUtils.debug("Setting up listener for Flutter data: name=\(name)")
        flutterListeners[name] = listener
    }
}