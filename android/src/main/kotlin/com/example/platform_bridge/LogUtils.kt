package com.example.platform_bridge

import android.util.Log
import java.security.InvalidParameterException

/**
 * 日志工具类，用于统一处理日志输出
 */
public object LogUtils {
    private const val TAG = "PlatformBridgePlugin"
    /**
     * 输出调试日志
     */
    fun d(message: String) {
        try {
            Log.d(TAG, message)
        } catch (e: RuntimeException) {
            // 在测试环境中，Android的Log可能未被模拟，此时跳过日志记录
            // 或者使用标准输出替代
            println("DEBUG: $message")
        }
    }

    /**
     * 输出错误日志
     */
    fun e(message: String) {
        try {
            Log.e(TAG, message)
        } catch (e: RuntimeException) {
            // 在测试环境中，Android的Log可能未被模拟，此时跳过日志记录
            // 或者使用标准输出替代
            println("ERROR: $message")
        }
    }

    /**
     * 输出警告日志
     */
    fun w(message: String) {
        try {
            Log.w(TAG, message)
        } catch (e: RuntimeException) {
            // 在测试环境中，Android的Log可能未被模拟，此时跳过日志记录
            // 或者使用标准输出替代
            println("WARN: $message")
        }
    }

    /**
     * 输出信息日志
     */
    fun i(message: String) {
        try {
            Log.i(TAG, message)
        } catch (e: RuntimeException) {
            // 在测试环境中，Android的Log可能未被模拟，此时跳过日志记录
            // 或者使用标准输出替代
            println("INFO: $message")
        }
    }
    
}