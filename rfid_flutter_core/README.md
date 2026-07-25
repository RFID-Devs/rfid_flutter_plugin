# RFID Flutter Core

[![pub package](https://img.shields.io/pub/v/rfid_flutter_core.svg)](https://pub.dev/packages/rfid_flutter_core)

> English | [中文文档](https://github.com/RFID-Devs/rfid_flutter_plugin/blob/main/rfid_flutter_core/README-zh.md)

`rfid_flutter_core` is the foundational core package for the RFID Flutter plugin architecture, providing essential interfaces, data classes, enums, and utilities required for RFID operations.   
This package does not implement specific business logic but provides unified interfaces and data structure definitions for other RFID implementation packages.

Refer to the [RFID Documentation](https://github.com/RFID-Devs/rfid_flutter_plugin/wiki/RFID-en) for details on the plugin’s interface design and usage if you are unfamiliar with RFID technology and related terminology.

**Important Note: This plugin is designed exclusively for specific pre-adapted hardware environments and is not a universal RFID solution. Unverified devices may not be compatible. Please evaluate carefully before integration.**

## ✨ Features

### 📚 Core Interfaces
- **RfidInterface**: Defines complete RFID operation interfaces, including initialization, inventory, read/write, lock, kill and other functions
- **Unified operation interface**: Provides consistent API for different hardware implementations


## 🚀 Getting Started

### Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  rfid_flutter_core: ^0.2.0
```

Then run:

```bash
flutter pub get
```

### Import Package

```dart
import 'package:rfid_flutter_core/rfid_flutter_core.dart';
```


## 🔗 Related Packages

- **rfid_flutter_android**: RFID implementation package for the Android platform, supporting UART and URA4 related devices

## 📄 License

This project is licensed under the BSD License. See the [LICENSE](LICENSE) file for details.
