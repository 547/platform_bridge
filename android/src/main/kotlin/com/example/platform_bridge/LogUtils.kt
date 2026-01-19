package com.example.platform_bridge

import android.util.Log

/**
 * 日志工具类，用于统一处理日志输出
 */
public object LogUtils {
    private const val TAG = "PlatformBridgePlugin"
    /**
     * 输出调试日志
     */
    fun d(message: String) {
        Log.d(TAG, message)
    }

    /**
     * 输出错误日志
     */
    fun e(message: String) {
        Log.e(TAG, message)
    }

    /**
     * 输出警告日志
     */
    fun w(message: String) {
        Log.w(TAG, message)
    }

    /**
     * 输出信息日志
     */
    fun i(message: String) {
        Log.i(TAG, message)
    }
    
}