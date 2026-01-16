import Flutter
import UIKit
import platform_bridge
@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // 添加调试信息，确认监听器将在单例可用时设置
    print("Waiting for plugin singleton to be available...")
    
    let pluginInstance = PlatformBridgePlugin.getInstance()
    print("Setting up listeners from iOS native side...")
      
    pluginInstance.listenFromFlutter(name: "CLICK_COUNT") { data in
          print("iOS received from Flutter CLICK_COUNT event: \(data ?? "nil")")
    }
      
    pluginInstance.listenFromFlutter(name: "USER_INFO") { data in
        print("iOS received from Flutter USER_INFO event: \(data ?? "nil")")
    }
      
    // 添加一个监听器，监听所有可能的事件
    pluginInstance.listenFromFlutter(name: "TEST_FROM_FLUTTER") { data in
        print("iOS received from Flutter TEST_FROM_FLUTTER event: \(data ?? "nil")")
    }
        
    sendTestDataToFlutter(pluginInstance)
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    

    private func sendTestDataToFlutter(_ plugin: PlatformBridgePlugin) {
      // 1秒后发送初始测试数据
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
          plugin.sendDataToFlutter(name: "INITIAL_DATA", data: [
              "message": "iOS sent initial data after 1 second",
              "timestamp": Date().timeIntervalSince1970
          ])
      }
      
      // 3秒后发送用户信息
      DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
          plugin.sendDataToFlutter(name: "USER_INFO_DELAYED", data: [
              "name": "iOS User",
              "device": "iPhone 17",
              "platform": "iOS"
          ])
          plugin.sendDataToFlutter(name: "USER_INFO_DELAYED", data: [
              "name": "iOS User",
              "device": "iPhone 16",
              "platform": "iOS"
          ])
      }
      
      // 5秒后发送计数数据
      DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
          plugin.sendDataToFlutter(name: "COUNTER_UPDATE", data: [
              "counter": 42,
              "description": "Counter from iOS native"
          ])
      }
      
      // 7秒后发送复杂数据结构
      DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
          plugin.sendDataToFlutter(name: "COMPLEX_DATA", data: [
              "metadata": [
                  "version": "1.0.0",
                  "source": "iOS Native"
              ],
              "payload": [
                  "items": [
                      ["id": 1, "name": "Item 1"],
                      ["id": 2, "name": "Item 2"],
                      ["id": 3, "name": "Item 3"]
                  ],
                  "total": 3
              ]
          ])
      }
      
      // 10秒后发送心跳信号
      DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
          plugin.sendDataToFlutter(name: "HEARTBEAT", data: [
              "status": "alive",
              "timestamp": Date().timeIntervalSince1970,
              "platform": "iOS"
          ])
      }
      
      // 每5秒重复发送定期更新
      Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
          plugin.sendDataToFlutter(name: "PERIODIC_UPDATE", data: [
              "message": "Periodic update from iOS",
              "timestamp": Date().timeIntervalSince1970
          ])
      }
    }
}
