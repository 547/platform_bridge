package com.example.platform_bridge

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.*
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** 
 * PlatformBridgePlugin - 用于Flutter与原生Android平台间双向通信的插件
 * 
 * 功能包括：
 * 1. Flutter向原生发送数据（sendToNative）
 * 2. 原生向Flutter发送数据（sendDataToFlutter）
 * 3. 原生监听来自Flutter的数据（listenFromFlutter）
 */
class PlatformBridgePlugin : FlutterPlugin, MethodCallHandler {
    /// 用于与Flutter通信的方法通道
    private lateinit var channel : MethodChannel
    
    /// 存储监听器的map，用于监听来自Flutter的数据
    private val flutterListeners = mutableMapOf<String, (Any?) -> Unit>()
    
    companion object {
        /// 通道名称
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
        
        /// 单例实例
        @Volatile
        private var INSTANCE: PlatformBridgePlugin? = null

        /**
         * 获取插件单例实例
         */
        @JvmStatic
        fun getInstance(): PlatformBridgePlugin {
            return INSTANCE ?: synchronized(this) {
                INSTANCE ?: PlatformBridgePlugin().also { INSTANCE = it }
            }
        }
    }

    /// 默认构造函数，供Flutter框架使用
    constructor()

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        LogUtils.d("Plugin attached to engine")
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME)
        channel.setMethodCallHandler(this)
        
        // 保存单例引用
        INSTANCE = this
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
        LogUtils.d("Plugin detached from engine")
        channel.setMethodCallHandler(null)
        
        // 清除单例引用
        INSTANCE = null
    }
    
    /**
     * 处理由Flutter发送过来的数据
     * 
     * @param name 数据标识符
     * @param data 要处理的数据
     */
    private fun handleDataFromFlutter(name: String, data: Any?) {
        LogUtils.d("Handling data from Flutter: name=$name, data=$data")
        
        // 检查实例特定的监听器
        flutterListeners[name]?.let { listener ->
            LogUtils.d("Calling instance listener for name: $name")
            listener(data)
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
}