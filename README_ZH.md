# Platform Bridge 插件

一个Flutter插件，用于实现Flutter与原生平台（Android/iOS）之间的双向通信。

## 功能特点

- 从Flutter向原生平台发送数据
- 从原生平台向Flutter发送数据
- 监听来自双方的数据
- 支持多种数据类型（字符串、数字、JSON对象等）

## 系统要求

- Flutter 3.0 或更高版本
- Android API Level 21 或更高版本
- iOS 11.0 或更高版本
- Java 8 或更高版本（用于Android构建）
- Xcode 13.0 或更高版本（用于iOS构建）

## 安装

将以下内容添加到您的 `pubspec.yaml` 文件中：

```yaml
dependencies:
  platform_bridge: ^0.0.1
```

然后运行 `flutter pub get`。

## 使用方法

### 从Flutter向原生平台发送数据

```dart
import 'package:platform_bridge/platform_bridge.dart';

// 向原生平台发送数据
await PlatformBridge.sendToNative('EVENT_NAME', {
  'key': 'value',
  'another_key': 123,
});
```

### 在Flutter中监听来自原生平台的数据

```dart
import 'package:platform_bridge/platform_bridge.dart';

// 监听来自原生平台的数据
PlatformBridge.listenFromNative('EVENT_NAME', (data) {
  print('收到原生平台数据: $data');
});
```

### 从原生平台向Flutter发送数据

#### Android
```kotlin
// 在Activity或其他Android组件中
val plugin = PlatformBridgePlugin.getInstance()
if (plugin != null) {
  plugin.sendDataToFlutter("EVENT_NAME", mapOf(
    "key" to "value",
    "another_key" to 123
  ))
}
```

#### iOS
```swift
// 在AppDelegate或其他iOS组件中
if let plugin = PlatformBridgePlugin.getInstance() {
  plugin.sendDataToFlutter(name: "EVENT_NAME", data: [
    "key": "value",
    "another_key": 123
  ])
}
```

### 在原生平台监听来自Flutter的数据

#### Android
```kotlin
// 在Activity或其他Android组件中
val plugin = PlatformBridgePlugin.getInstance()
if (plugin != null) {
  plugin.listenFromFlutter("EVENT_NAME") { data ->
    println("收到Flutter数据: $data")
  }
}
```

#### iOS
```swift
// 在AppDelegate或其他iOS组件中
if let plugin = PlatformBridgePlugin.getInstance() {
  plugin.listenFromFlutter(name: "EVENT_NAME", callback: { data in
    print("收到Flutter数据: $data")
  })
}
```

## 重要说明

### 实例管理
- 插件实例由Flutter框架在初始化期间管理
- 在Android上，如果插件尚未初始化，`getInstance()` 方法可能返回null
- 对于Android，您可能需要实现重试机制以等待插件实例准备就绪
- 在iOS上，实例在Flutter初始化插件时创建

### 线程安全性
- MethodChannel调用可以从后台线程发起；Flutter框架会处理线程调度
- 但是，由通信触发的UI更新必须在主线程上发生
- 在Android上，当响应接收到的数据执行UI更新时，请使用 `runOnUiThread` 或 `Handler(Looper.getMainLooper())`
- 在iOS上，当响应接收到的数据执行UI更新时，请使用 `DispatchQueue.main.async` 分派到主队列

## 示例

请查看 `example` 目录，其中包含一个完整的示例，展示了如何在Flutter和原生代码中使用该插件。

## 贡献

欢迎提交Pull Request。对于重大更改，请先开Issue讨论您想要改变的内容。

## 许可证

MIT