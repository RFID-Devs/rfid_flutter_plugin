import 'dart:async';
import 'package:flutter/services.dart';
import 'package:rfid_flutter_core/rfid_flutter_core.dart';

class MethodChannelHelper {
  final MethodChannel _channel;

  MethodChannelHelper(this._channel);

  /// 通用方法：处理返回布尔值的方法 <br>
  /// [methodName] 方法名 <br>
  /// [arguments] 参数 <br>
  /// [validation] 参数校验方法 <br>
  Future<RfidResult<bool>> invokeBoolMethod(
    String methodName, [
    Map<String, dynamic>? arguments,
    Future<void> Function()? validation,
  ]) async {
    try {
      if (validation != null) {
        await validation();
      }
      final result = await _channel.invokeMethod<bool>(methodName, arguments);
      if (result == null) {
        return RfidResult.failure('$methodName failed');
      }
      return RfidResult.success(result);
    } on PlatformException catch (e) {
      return RfidResult.failure(e.message ?? 'Unknown error');
    } catch (e) {
      return RfidResult.failure(e.toString());
    }
  }

  /// 通用方法：处理返回字符串的方法 <br>
  /// [methodName] 方法名 <br>
  /// [arguments] 参数 <br>
  /// [validation] 参数校验方法 <br>
  Future<RfidResult<String>> invokeStringMethod(
    String methodName, [
    Map<String, dynamic>? arguments,
    Future<void> Function()? validation,
  ]) async {
    try {
      if (validation != null) {
        await validation();
      }
      final result = await _channel.invokeMethod<String>(methodName, arguments);
      if (result != null && result.isNotEmpty) {
        return RfidResult.success(result);
      } else {
        return RfidResult.failure('$methodName failed');
      }
    } on PlatformException catch (e) {
      return RfidResult.failure(e.message ?? 'Unknown error');
    } catch (e) {
      return RfidResult.failure(e.toString());
    }
  }

  /// 通用方法：处理返回整数的方法 <br>
  /// [methodName] 方法名 <br>
  /// [arguments] 参数 <br>
  /// [validation] 参数校验方法 <br>
  Future<RfidResult<int>> invokeIntMethod(
    String methodName, [
    Map<String, dynamic>? arguments,
    Future<void> Function()? validation,
  ]) async {
    try {
      if (validation != null) {
        await validation();
      }
      final result = await _channel.invokeMethod<int>(methodName, arguments);
      if (result != null) {
        return RfidResult.success(result);
      } else {
        return RfidResult.failure('$methodName failed');
      }
    } on PlatformException catch (e) {
      return RfidResult.failure(e.message ?? 'Unknown error');
    } catch (e) {
      return RfidResult.failure(e.toString());
    }
  }

  /// 通用方法：处理返回对象的方法（包括枚举） <br>
  /// [methodName] 方法名 <br>
  /// [arguments] 参数 <br>
  /// [validation] 参数校验方法 <br>
  Future<RfidResult<T>> invokeObjectMethod<T>(
    String methodName,
    T? Function(dynamic) fromData, [
    Map<String, dynamic>? arguments,
    Future<void> Function()? validation,
  ]) async {
    try {
      if (validation != null) {
        await validation();
      }
      final result = await _channel.invokeMethod(methodName, arguments);
      // print('result: $result');
      final object = fromData(result);
      if (object != null) {
        return RfidResult.success(object);
      } else {
        return RfidResult.failure('$methodName failed');
      }
    } on PlatformException catch (e) {
      return RfidResult.failure(e.message ?? 'Unknown error');
    } catch (e) {
      return RfidResult.failure(e.toString());
    }
  }

  /// 通用方法：处理返回空的方法 <br>
  /// [methodName] 方法名 <br>
  /// [arguments] 参数 <br>
  /// [validation] 参数校验方法 <br>
  Future<RfidResult<void>> invokeVoidMethod(
    String methodName, [
    Map<String, dynamic>? arguments,
    Future<void> Function()? validation,
  ]) async {
    try {
      if (validation != null) {
        await validation();
      }
      await _channel.invokeMethod<void>(methodName, arguments);
      return const RfidResult.success(null);
    } on PlatformException catch (e) {
      return RfidResult.failure(e.message ?? 'Unknown error');
    } catch (e) {
      return RfidResult.failure(e.toString());
    }
  }
}
