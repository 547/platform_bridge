package com.example.platform_bridge_example

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import com.example.platform_bridge.PlatformBridgePlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import java.util.Timer
import kotlin.concurrent.fixedRateTimer
import kotlin.concurrent.schedule

class MainActivity: FlutterActivity() {
    private val mainHandler = Handler(Looper.getMainLooper())

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // 设置监听器，监听来自Flutter的数据
        PlatformBridgePlugin.getInstance().listenFromFlutter("CLICK_COUNT") { data ->
            println("Android received from Flutter CLICK_COUNT event: $data")
        }
        
        PlatformBridgePlugin.getInstance().listenFromFlutter("USER_INFO") { data ->
            println("Android received from Flutter USER_INFO event: $data")
        }
        
        // 添加一个监听器，监听所有可能的事件
        PlatformBridgePlugin.getInstance().listenFromFlutter("TEST_FROM_FLUTTER") { data ->
            println("Android received from Flutter TEST_FROM_FLUTTER event: $data")
        }
        
        // 添加几个延迟发送数据到Flutter的测试方法
        setupDelayedTestData()
    }
    
    private fun setupDelayedTestData() {
        val plugin = PlatformBridgePlugin.getInstance()
        
        // 1秒后发送初始测试数据
        Timer().schedule(1000) {
            mainHandler.post {
                plugin.sendDataToFlutter("INITIAL_DATA", mapOf(
                    "message" to "Android sent initial data after 1 second",
                    "timestamp" to System.currentTimeMillis()
                ))
            }
        }
        
        // 3秒后发送用户信息
        Timer().schedule(3000) {
            mainHandler.post {
                plugin.sendDataToFlutter("USER_INFO_DELAYED", mapOf(
                    "name" to "Android User 1",
                    "device" to "Pixel",
                    "platform" to "Android"
                ))
            }
            mainHandler.post {
                plugin.sendDataToFlutter("USER_INFO_DELAYED", mapOf(
                    "name" to "Android User 2",
                    "device" to "Pixel",
                    "platform" to "Android"
                ))
            }
        }
        
        // 5秒后发送计数数据
        Timer().schedule(5000) {
            mainHandler.post {
                plugin.sendDataToFlutter("COUNTER_UPDATE", mapOf(
                    "counter" to 42,
                    "description" to "Counter from Android native"
                ))
            }
        }
        
        // 7秒后发送复杂数据结构
        Timer().schedule(7000) {
            mainHandler.post {
                plugin.sendDataToFlutter("COMPLEX_DATA", mapOf(
                    "metadata" to mapOf(
                        "version" to "1.0.0",
                        "source" to "Android Native"
                    ),
                    "payload" to mapOf(
                        "items" to listOf(
                            mapOf("id" to 1, "name" to "Item 1"),
                            mapOf("id" to 2, "name" to "Item 2"),
                            mapOf("id" to 3, "name" to "Item 3")
                        ),
                        "total" to 3
                    )
                ))
            }
        }
        
        // 10秒后发送心跳信号
        Timer().schedule(10000) {
            mainHandler.post {
                plugin.sendDataToFlutter("HEARTBEAT", mapOf(
                    "status" to "alive",
                    "timestamp" to System.currentTimeMillis(),
                    "platform" to "Android"
                ))
            }
        }
        
        // 每5秒重复发送定期更新
        fixedRateTimer("periodicUpdate", initialDelay = 0, period = 5000) {
            mainHandler.post {
                plugin.sendDataToFlutter("PERIODIC_UPDATE", mapOf(
                    "message" to "Periodic update from Android",
                    "timestamp" to System.currentTimeMillis()
                ))
            }
        }
    }
}