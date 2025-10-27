# RFID Flutter Core

[![pub package](https://img.shields.io/pub/v/rfid_flutter_core.svg)](https://pub.dev/packages/rfid_flutter_core)

> 中文 | [English](README.md)

`rfid_flutter_core` 是 RFID Flutter 插件架构的核心基础包，提供了 RFID 操作所需的核心接口、数据类、枚举和工具类。  
本插件包本身不实现具体的业务逻辑，而是为其他 RFID 实现包提供统一的接口和数据结构定义。

如不熟悉 RFID 技术背景及相关术语，建议参阅 [RFID 说明文档](https://github.com/RFID-Devs/rfid_flutter_plugin/wiki/RFID-zh)，以便更好地理解插件接口的功能设计与使用方式

**重要提示：本插件仅适用于已完成适配的特定设备环境，非通用 RFID 插件。未经验证的设备可能无法工作，请在集成前谨慎评估**


## ✨ 功能特性

### 📚 核心接口
- **RfidInterface**: 定义了完整的 RFID 操作接口，包括初始化、盘点、读写、锁定、销毁等功能
- **统一的操作接口**: 为不同的硬件实现提供一致的API


## 🚀 快速开始

### 安装

将以下内容添加到你的 `pubspec.yaml` 文件中：

```yaml
dependencies:
  rfid_flutter_core: ^0.1.1
```

然后运行：

```bash
flutter pub get
```

### 导入包

```dart
import 'package:rfid_flutter_core/rfid_flutter_core.dart';
```


## 🔗 相关包

- **rfid_flutter_android**: Android 平台的 RFID 实现包，包含 UART、URA4 相关设备

## 📄 许可证

本项目基于 BSD 许可证开源。详细信息请查看 [LICENSE](LICENSE) 文件。
