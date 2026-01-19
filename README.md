# Platform Bridge

A Flutter plugin for bidirectional communication between Flutter and native platforms (Android/iOS).

[中文文档](./README_ZH.md)

## Features

- **Bidirectional Communication**: Supports sending data from Flutter to native platforms and receiving data from native platforms in Flutter.
- **Unified API**: Provides consistent interfaces across different platforms.
- **Simple Integration**: Easy to integrate with existing Flutter applications.

## Requirements

- Flutter 3.3.0 or higher
- Android API Level 21 or higher
- iOS 11.0 or higher
- Java 8 or higher (for Android builds)
- Xcode 13.0 or higher (for iOS builds)

## Installation

Add the plugin to your `pubspec.yaml`:

```yaml
dependencies:
  platform_bridge: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Usage

### Import the Package

```dart
import 'package:platform_bridge/platform_bridge.dart';
```

### Send Data from Flutter to Native

```dart
PlatformBridge platformBridge = PlatformBridge();

// Send data to native platform
await platformBridge.sendToNative("USER_INFO", {
  "name": "John Doe",
  "email": "john@example.com"
});
```

### Listen for Data from Native Platforms

```dart
// Set up a listener for data from native platforms
platformBridge.listenFromNative("NOTIFICATION", (data) {
  print("Received notification from native: $data");
});

```

### Sending Data from Native to Flutter

#### Android
```kotlin
// In your Activity or other Android component
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
// In your AppDelegate or other iOS component
if let plugin = PlatformBridgePlugin.getInstance() {
  plugin.sendDataToFlutter(name: "EVENT_NAME", data: [
    "key": "value",
    "another_key": 123
  ])
}
```

### Listening for Data from Flutter in Native

#### Android
```kotlin
// In your Activity or other Android component
val plugin = PlatformBridgePlugin.getInstance()
if (plugin != null) {
  plugin.listenFromFlutter("EVENT_NAME") { data ->
    println("Received data from Flutter: $data")
  }
}
```

#### iOS
```swift
// In your AppDelegate or other iOS component
if let plugin = PlatformBridgePlugin.getInstance() {
  plugin.listenFromFlutter(name: "EVENT_NAME") { data in
    print("Received data from Flutter: \(data ?? "nil")")
  }
}
```

## Important Notes

### Instance Management

1. The plugin instance is created and set by the Flutter framework when `onAttachedToEngine` is called in the native code. Do not attempt to create new instances directly.
2. The `getInstance()` method only returns the currently set instance reference. If the plugin hasn't been initialized yet, it will return null.
3. Do not use blocking mechanisms like `Thread.sleep()` on the main thread to wait for instance initialization, as this can cause UI freezes.
4. Handle asynchronous initialization timing issues by implementing retry mechanisms or callbacks to wait for the instance to be ready.

### Threading Model

1. **MethodChannel Calls**: It's acceptable to initiate `invokeMethod` calls from background threads. The Flutter framework automatically handles thread scheduling.
2. **UI Updates**: Any operations involving UI updates must be performed on the main thread.
3. **Correct Practice**:
   - MethodChannel method calls can be initiated from background threads
   - When updating UI, use `Handler(Looper.getMainLooper()).post()` (Android) or `DispatchQueue.main.async` (iOS) to submit tasks to the main thread
4. Avoid the misconception that all cross-platform communication must occur on the main thread, as this adds unnecessary complexity.

## Example

Check the `example` directory for a complete example showing how to use the plugin in both Flutter and native code.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

MIT