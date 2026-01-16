# platform_bridge

A Flutter plugin that provides bidirectional communication between Flutter and native platforms (Android/iOS).

## Features

- Send data from Flutter to native platforms (Android/iOS)
- Send data from native platforms (Android/iOS) to Flutter
- Listen for data with custom identifiers
- Support for various data types (String, int, double, bool, Map, List, etc.)
- Configurable data storage on native platforms
- Manual data removal capabilities

## Usage

### Send Data from Flutter to Native

```dart
final bridge = PlatformBridge();

// Send a string
await bridge.sendToNative('USER_TOKEN', 'abc123xyz');

// Send JSON data (Map)
await bridge.sendToNative('USER_INFO', {
  'name': 'John Doe',
  'email': 'john@example.com',
  'age': 30
});

// Send integer
await bridge.sendToNative('CLICK_COUNT', 42);
```

### Listen for Data from Native in Flutter

```dart
final bridge = PlatformBridge();

// Listen for USER_TOKEN
bridge.listenFromNative('USER_TOKEN', (data) {
  print('Received USER_TOKEN: $data');
});

// Listen for USER_INFO
bridge.listenFromNative('USER_INFO', (data) {
  print('Received USER_INFO: $data');
});
```

### Send Data from Native to Flutter

#### Android (Kotlin)
```kotlin
val plugin = PlatformBridgePlugin()
plugin.sendDataToFlutter("USER_TOKEN", "abc123xyz")

val userInfo = mapOf(
    "name" to "John Doe",
    "email" to "john@example.com",
    "age" to 30
)
plugin.sendDataToFlutter("USER_INFO", userInfo)
```

#### iOS (Swift)
```swift
let plugin = PlatformBridgePlugin()
plugin.sendDataToFlutter(name: "USER_TOKEN", data: "abc123xyz")

let userInfo: [String: Any] = [
    "name": "John Doe",
    "email": "john@example.com",
    "age": 30
]
plugin.sendDataToFlutter(name: "USER_INFO", data: userInfo)
```

### Listen for Data from Flutter in Native

#### Android (Kotlin)
```kotlin
val plugin = PlatformBridgePlugin()

// Listen for CLICK_COUNT
plugin.listenFromFlutter("CLICK_COUNT") { data ->
    println("Received CLICK_COUNT: $data")
}

// Listen for USER_INFO
plugin.listenFromFlutter("USER_INFO") { data ->
    println("Received USER_INFO: $data")
}
```

#### iOS (Swift)
```swift
let plugin = PlatformBridgePlugin()

// Listen for CLICK_COUNT
plugin.listenFromFlutter(name: "CLICK_COUNT") { data in
    print("Received CLICK_COUNT: \\(String(describing: data))")
}

// Listen for USER_INFO
plugin.listenFromFlutter(name: "USER_INFO") { data in
    print("Received USER_INFO: \\(String(describing: data))")
}
```

### Configure Data Storage Behavior at Initialization

Control whether to store data received from Flutter at initialization:

#### Android (Kotlin)
```kotlin
// Initialize with data storage enabled
val pluginWithStorage = PlatformBridgePlugin(true)

// Initialize with data storage disabled (default behavior)
val pluginWithoutStorage = PlatformBridgePlugin(false)
val pluginWithoutStorageDefault = PlatformBridgePlugin()  // Same as passing false
```

#### iOS (Swift)
```swift
// Initialize with data storage enabled
let pluginWithStorage = PlatformBridgePlugin(shouldStoreReceivedData: true)

// Initialize with data storage disabled (default behavior)
let pluginWithoutStorage = PlatformBridgePlugin(shouldStoreReceivedData: false)
let pluginWithoutStorageDefault = PlatformBridgePlugin()  // Same as passing false
```

### Manage Stored Data

When data storage is enabled, you can manage the stored data:

#### Android (Kotlin)
```kotlin
val plugin = PlatformBridgePlugin(true)  // Enable storage at initialization

// Get stored data
val token = plugin.getStoredData("USER_TOKEN")

// Remove specific stored data
plugin.removeStoredData("USER_TOKEN")

// Clear all stored data
plugin.clearStoredData()
```

#### iOS (Swift)
```swift
let plugin = PlatformBridgePlugin(shouldStoreReceivedData: true)  // Enable storage at initialization

// Get stored data
let token = plugin.getStoredData(forName: "USER_TOKEN")

// Remove specific stored data
plugin.removeStoredData(forName: "USER_TOKEN")

// Clear all stored data
plugin.clearStoredData()
```

### How It Works

Native platforms automatically receive data sent from Flutter via the `sendToNative` method. When Flutter calls `sendToNative`, the native platform receives the data and triggers any corresponding listeners registered with `listenFromFlutter`.

You can control whether the data should be stored by setting the storage option during initialization (defaults to `false`). When enabled, data is stored and can be accessed later using the storage management methods.