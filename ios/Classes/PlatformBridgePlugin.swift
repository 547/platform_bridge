import Flutter
import UIKit

/**
 * PlatformBridgePlugin - 用于Flutter与原生iOS平台间双向通信的插件
 *
 * 功能包括：
 * 1. Flutter向原生发送数据（sendToNative）
 * 2. 原生向Flutter发送数据（sendDataToFlutter）
 * 3. 原生监听来自Flutter的数据（listenFromFlutter）
 * 4. 可配置的数据存储功能（shouldStoreReceivedData）
 */
public class PlatformBridgePlugin: NSObject, FlutterPlugin {
    private var channel: FlutterMethodChannel?
    
    // 是否存储从Flutter接收的数据，默认为false
    private let shouldStoreReceivedData: Bool
    
    // 存储监听器的字典，用于监听来自Flutter的数据
    private var flutterListeners: [String: (Any?) -> Void] = [:]
    
    // 存储从Flutter接收的数据
    private var flutterDataStorage: [String: Any?] = [:]
    
    // MARK: - Constants
    private static let channelName = "com.seven.platform_bridge/platform_bridge"
    private static let methodGetPlatformVersion = "getPlatformVersion"
    private static let methodSendToNative = "sendToNative"
    private static let methodSendToFlutter = "sendToFlutter"
    private static let paramName = "name"
    private static let paramData = "data"
    
    // 初始化方法，可以设置是否存储接收的数据
    public init(shouldStoreReceivedData: Bool = false) {
        self.shouldStoreReceivedData = shouldStoreReceivedData
        super.init()
        
        LogUtils.info("PlatformBridgePlugin initialized with shouldStoreReceivedData: "
                      + (shouldStoreReceivedData ? "true" : "false"))
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: PlatformBridgePlugin.channelName, binaryMessenger: registrar.messenger())
        let instance = PlatformBridgePlugin()
        instance.channel = channel
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        LogUtils.info("PlatformBridgePlugin registered with registrar")
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        LogUtils.debug("Received method call: \(call.method)")
        
        switch call.method {
        case PlatformBridgePlugin.methodGetPlatformVersion:
            LogUtils.info("Getting platform version")
            result("iOS " + UIDevice.current.systemVersion)
        case PlatformBridgePlugin.methodSendToNative:
            LogUtils.info("Handling sendToNative method call")
            
            guard let arguments = call.arguments as? [String: Any],
                  let name = arguments[PlatformBridgePlugin.paramName] as? String else {
                LogUtils.error("Invalid arguments: Missing name or data")
                
                result(FlutterError(code: "INVALID_ARGUMENT",
                                   message: "Missing name or data",
                                   details: nil))
                return
            }
            
            let data = arguments[PlatformBridgePlugin.paramData]
            
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
        
        // 如果存在对应的监听器，则调用它
        if let listener = flutterListeners[name] {
            LogUtils.debug("Calling listener for name: \(name)")
            listener(data)
        }
        
        // 如果需要存储数据，则存储
        if shouldStoreReceivedData {
            LogUtils.debug("Storing data with name: \(name), data=\(String(describing: data))")
            flutterDataStorage[name] = data
        } else {
            LogUtils.debug("Data storage is disabled, skipping storage for name: \(name)")
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
            PlatformBridgePlugin.paramName: name,
            PlatformBridgePlugin.paramData: data
        ]
        channel?.invokeMethod(PlatformBridgePlugin.methodSendToFlutter, arguments: args)
    }
    
    /**
     * 监听来自Flutter的数据
     *
     * - Parameters:
     *   - name: 数据标识符
     *   - listener: 接收数据的回调函数
     */
    public func listenFromFlutter(name: String, listener: @escaping (Any?) -> Void) {
        LogUtils.debug("Setting up listener for name: \(name)")
        flutterListeners[name] = listener
    }
    
    /**
     * 获取已存储的数据
     *
     * - Parameter name: 数据标识符
     * - Returns: 存储的数据
     */
    public func getStoredData(forName name: String) -> Any? {
        LogUtils.debug("Retrieving stored data for name: \(name)")
        return flutterDataStorage[name]
    }
    
    /**
     * 删除已存储的数据
     *
     * - Parameter name: 数据标识符
     */
    public func removeStoredData(forName name: String) {
        LogUtils.debug("Removing stored data for name: \(name)")
        flutterDataStorage.removeValue(forKey: name)
    }
    
    /**
     * 清空所有已存储的数据
     */
    public func clearStoredData() {
        LogUtils.debug("Clearing all stored data")
        flutterDataStorage.removeAll()
    }
    
    /**
     * 发送预定义的数据类型示例
     */
    public func sendExampleData() {
        LogUtils.info("Sending example data")
        
        // 示例：发送用户令牌
        sendDataToFlutter(name: "USER_TOKEN", data: "abc123xyz")
        
        // 示例：发送用户信息字典
        let userInfo: [String: Any] = [
            "name": "John Doe",
            "email": "john@example.com",
            "age": 30
        ]
        sendDataToFlutter(name: "USER_INFO", data: userInfo)
    }
}