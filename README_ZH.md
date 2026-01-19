# Platform Bridge

一个Flutter插件，用于Flutter与原生平台(Android/iOS)之间的双向通信。

## 功能

- **双向通信**：支持从Flutter向原生平台发送数据，以及在Flutter中接收来自原生平台的数据。
- **统一API**：提供跨平台的一致接口。
- **简单集成**：易于与现有Flutter应用程序集成。

## 系统要求

- Flutter 3.3.0 或更高版本
- Android API Level 21 或更高版本
- iOS 11.0 或更高版本
- Java 8 或更高版本（用于Android构建）
- Xcode 13.0 或更高版本（用于iOS构建）

## 安装

将插件添加到您的 `pubspec.yaml`:

```yaml
dependencies:
  platform_bridge: ^0.0.1
```

然后运行:

```bash
flutter pub get
```

## 使用方法

### 导入包

```dart
import 'package:platform_bridge/platform_bridge.dart';
```

### 从Flutter向原生发送数据

```dart
PlatformBridge platformBridge = PlatformBridge();

// 向原生平台发送数据
await platformBridge.sendToNative("USER_INFO", {
  "name": "John Doe",
  "email": "john@example.com"
});
```

### 监听来自原生平台的数据

```dart
// 为来自原生平台的数据设置监听器
platformBridge.listenFromNative("NOTIFICATION", (data) {
  print("Received notification from native: $data");
});

// 开始监听
await platformBridge.startListening();
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

1. 插件实例是由Flutter框架在原生代码中的`onAttachedToEngine`被调用时创建和设置的。不要尝试直接创建新实例。
2. `getInstance()`方法只返回当前设置的实例引用。如果插件尚未初始化，它将返回null。
3. 不要在主线程使用像`Thread.sleep()`这样的阻塞机制来等待实例初始化，因为这可能导致UI卡顿。
4. 通过实现重试机制或回调来处理异步初始化时序问题，以等待实例准备就绪。

### 线程模型

1. **MethodChannel调用**：可以从后台线程发起`invokeMethod`调用。Flutter框架会自动处理线程调度。
2. **UI更新**：任何涉及UI更新的操作都必须在主线程上执行。
3. **正确做法**：
   - 可以从后台线程发起MethodChannel方法调用
   - 更新UI时，使用`Handler(Looper.getMainLooper()).post()`（Android）或`DispatchQueue.main.async`（iOS）将任务提交到主线程
4. 不要误解所有的跨平台通信都必须在主线程上发生，因为这会增加不必要的复杂性。

## 示例

请查看 `example` 目录，其中包含一个完整的示例，展示了如何在Flutter和原生代码中使用该插件。

## 贡献

欢迎提交Pull Request。对于重大更改，请先开Issue讨论您想要改变的内容。

## 许可证

MIT