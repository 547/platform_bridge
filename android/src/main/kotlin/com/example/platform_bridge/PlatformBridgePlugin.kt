package com.example.platform_bridge

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.*
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import LogUtils

/** 
 * PlatformBridgePlugin - 用于Flutter与原生Android平台间双向通信的插件
 * 
 * 功能包括：
 * 1. Flutter向原生发送数据（sendToNative）
 * 2. 原生向Flutter发送数据（sendDataToFlutter）
 * 3. 原生监听来自Flutter的数据（listenFromFlutter）
 * 4. 可配置的数据存储功能（shouldStoreReceivedData）
 */
class PlatformBridgePlugin(private val shouldStoreReceivedData: Boolean = false) : FlutterPlugin, MethodCallHandler, StreamHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel : MethodChannel
    
    // 存储EventChannels的map，用于向Flutter发送数据
    private val eventChannels = mutableMapOf<String, EventChannel.EventSink>()
    
    // 存储监听器的map，用于监听来自Flutter的数据
    private val flutterListeners = mutableMapOf<String, (Any?) -> Unit>()
    
    // 存储从Flutter接收的数据
    private val flutterDataStorage = mutableMapOf<String, Any?>()

    companion object {
        /// 通道名称 - 使用完整包名前缀以避免命名冲突
        private const val CHANNEL_NAME = "com.seven.platform_bridge/platform_bridge"
        
        /// 获取平台版本号的方法名
        private const val METHOD_GET_PLATFORM_VERSION = "getPlatformVersion"
        
        /// Flutter向原生发送数据的方法名
        private const val METHOD_SEND_TO_NATIVE = "sendToNative"
        
        /// 原生向Flutter发送数据的方法名
        private const val METHOD_SEND_TO_FLUTTER = "sendToFlutter"
        
        /// 参数名称
        private const val PARAM_NAME = "name"
        
        /// 参数数据
        private const val PARAM_DATA = "data"
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        LogUtils.d("Plugin attached to engine")
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME)
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        LogUtils.d("Received method call: ${call.method}")
        
        when (call.method) {
            METHOD_GET_PLATFORM_VERSION -> {
                LogUtils.d("Getting platform version")
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            METHOD_SEND_TO_NATIVE -> {
                LogUtils.d("Handling sendToNative method call")
                
                val name = call.argument<String>(PARAM_NAME)
                val data = call.argument<Any>(PARAM_DATA)
                
                if (name != null) {
                    LogUtils.d("Received data from Flutter: name=$name, data=$data")
                    
                    // 处理从Flutter发送过来的数据
                    handleDataFromFlutter(name, data)
                    
                    result.success(null)
                } else {
                    LogUtils.e("Name parameter is null")
                    result.error("INVALID_ARGUMENT", "Name cannot be null", null)
                }
            }
            else -> {
                LogUtils.w("Method not implemented: ${call.method}")
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        Log.d(TAG, "Plugin detached from engine")
        channel.setMethodCallHandler(null)
    }
    
    /**
     * 处理由Flutter发送过来的数据
     * 
     * @param name 数据标识符
     * @param data 要处理的数据
     */
    private fun handleDataFromFlutter(name: String, data: Any?) {
        LogUtils.d("Handling data from Flutter: name=$name, data=$data")
        
        // 如果存在对应的监听器，则调用它
        flutterListeners[name]?.let { listener ->
            LogUtils.d("Calling listener for name: $name")
            listener(data)
        }
        
        // 如果需要存储数据，则存储
        if (shouldStoreReceivedData) {
            LogUtils.d("Storing data with name: $name, data: $data")
            flutterDataStorage[name] = data
        } else {
            LogUtils.d("Data storage is disabled, skipping storage for name: $name")
        }
    }
    
    /**
     * 向Flutter发送数据
     * 
     * @param name 数据标识符
     * @param data 要发送的数据
     */
    fun sendDataToFlutter(name: String, data: Any?) {
        LogUtils.d("Sending data to Flutter: name=$name, data=$data")
        
        // 使用MethodChannel向Flutter发送数据
        val args = hashMapOf<String, Any?>(
            PARAM_NAME to name,
            PARAM_DATA to data
        )
        channel.invokeMethod(METHOD_SEND_TO_FLUTTER, args)
    }
    
    /**
     * 监听来自Flutter的数据
     * 
     * @param name 数据标识符
     * @param listener 接收数据的回调函数
     */
    fun listenFromFlutter(name: String, listener: (Any?) -> Unit) {
        LogUtils.d("Setting up listener for name: $name")
        flutterListeners[name] = listener
    }
    
    /**
     * 获取已存储的数据
     * 
     * @param name 数据标识符
     * @return 存储的数据
     */
    fun getStoredData(name: String): Any? {
        LogUtils.d("Retrieving stored data for name: $name")
        return flutterDataStorage[name]
    }
    
    /**
     * 删除已存储的数据
     * 
     * @param name 数据标识符
     */
    fun removeStoredData(name: String) {
        LogUtils.d("Removing stored data for name: $name")
        flutterDataStorage.remove(name)
    }
    
    /**
     * 清空所有已存储的数据
     */
    fun clearStoredData() {
        LogUtils.d("Clearing all stored data")
        flutterDataStorage.clear()
    }
    
    // StreamHandler methods for event channels (not currently used but required by interface)
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        // Not used in this implementation
        LogUtils.d("Event channel listening started")
    }

    override fun onCancel(arguments: Any?) {
        // Not used in this implementation
        LogUtils.d("Event channel listening cancelled")
    }
    
    /**
     * 发送预定义的数据类型示例
     */
    fun sendExampleData() {
        LogUtils.d("Sending example data")
        
        // 示例：发送用户令牌
        sendDataToFlutter("USER_TOKEN", "abc123xyz")
        
        // 示例：发送用户信息JSON
        val userInfo = mapOf(
            "name" to "John Doe",
            "email" to "john@example.com",
            "age" to 30
        )
        sendDataToFlutter("USER_INFO", userInfo)
    }
}