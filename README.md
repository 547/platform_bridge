# Platform Bridge Plugin

A Flutter plugin that enables bidirectional communication between Flutter and native platforms (Android/iOS).

[中文文档](./README_ZH.md)

## Features

- Send data from Flutter to native platforms
- Send data from native platforms to Flutter
- Listen for data from both sides
- Support for various data types (strings, numbers, JSON objects, etc.)

## Requirements

- Flutter 3.0 or higher
- Android API Level 21 or higher
- iOS 11.0 or higher
- Java 8 or higher (for Android builds)
- Xcode 13.0 or higher (for iOS builds)

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  platform_bridge: ^0.0.1
```

Then run `flutter pub get`.

## Usage

### Sending Data from Flutter to Native

```dart
import 'package:platform_bridge/platform_bridge.dart';

// Send data to native
await PlatformBridge.sendToNative('EVENT_NAME', {
  'key': 'value',
  'another_key': 123,
});
```

### Listening for Data from Native in Flutter

```dart
import 'package:platform_bridge/platform_bridge.dart';

// Listen for data from native
PlatformBridge.listenFromNative('EVENT_NAME', (data) {
  print('Received data from native: $data');
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
  plugin.listenFromFlutter(name: "EVENT_NAME", callback: { data in
    print("Received data from Flutter: $data")
  })
}
```

## Important Notes

### Instance Management
- The plugin instance is managed by the Flutter framework during initialization
- On Android, the `getInstance()` method may return null if the plugin hasn't been initialized yet
- For Android, you may need to implement a retry mechanism to wait for the plugin instance to be ready
- On iOS, the instance is created when Flutter initializes the plugin

### Thread Safety
- MethodChannel calls can be initiated from background threads; Flutter framework handles thread scheduling
- However, UI updates triggered by the communication must happen on the main thread
- On Android, when performing UI updates in response to received data, use `runOnUiThread` or `Handler(Looper.getMainLooper())`
- On iOS, when performing UI updates in response to received data, dispatch to the main queue using `DispatchQueue.main.async`

## Example

Check the `example` directory for a complete example showing how to use the plugin in both Flutter and native code.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

MIT