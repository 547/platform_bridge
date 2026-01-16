package com.example.platform_bridge

import android.util.Log

/**
 * 日志工具类，用于统一处理日志输出
 */
object LogUtils {
    private const val TAG = "PlatformBridgePlugin"
    private const val LEVEL_ERROR = "ERROR"
    private const val LEVEL_WARNING = "WARNING"
    
    /**
     * 格式化日志消息
     */
    private fun formatMessage(message: String, level: String? = null): String {
        return if (level != null) {
            "[$TAG] $level: $message"
        } else {
            "[$TAG] $message"
        }
    }
    
    /**
     * 输出调试日志
     */
    fun d(message: String) {
        Log.d(TAG, formatMessage(message))
    }
    
    /**
     * 输出错误日志
     */
    fun e(message: String) {
        Log.e(TAG, formatMessage(message, LEVEL_ERROR))
    }
    
    /**
     * 输出警告日志
     */
    fun w(message: String) {
        Log.w(TAG, formatMessage(message, LEVEL_WARNING))
    }
    
    /**
     * 输出信息日志
     */
    fun i(message: String) {
        Log.i(TAG, formatMessage(message))
    }
}