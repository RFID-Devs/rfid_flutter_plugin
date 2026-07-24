import 'dart:async';

import 'package:flutter/services.dart';
import 'package:rfid_flutter_core/rfid_flutter_core.dart';
import 'package:rfid_flutter_android/src/method_channel_helper.dart';

/// Hands-on RFID interface implementation <br/>
/// 手持机的RFID接口实现 <br/>
///
/// ### English
///
/// Basic usage flow: [init] -> ... -> [free]
///
/// #### Note:
/// 1. RfidWithUart uses singleton pattern, please do not create instances, use RfidWithUart.instance to get the instance and call the various interfaces.
/// 2. Before calling other commands, please call the [init] method to initialize the UHF module, and call the [free] method to release resources when not in use.
/// 3. After initialization, you can set and get various parameters according to your needs, or start inventory by calling the [startInventory] method. The tag data will be returned through the [rfidTagStream] stream. <br/>
/// 4. During the inventory process, the module no longer responds to other commands. You can call the [stopInventory] method to stop the inventory.
/// 5. The module can only execute one command at a time, please control the calling time, otherwise it may fail.
/// 6. RfidWithUart has processed error cases, so that each method will not throw exceptions, and the error information can be viewed in [RfidResult].
///
/// ### 中文
///
/// 基本使用流程：[init] -> ... -> [free]
///
/// #### 注意事项：
/// 1. RfidWithUart 使用了单例模式，请不要创建实例，使用 RfidWithUart.instance 获取实例调用各个接口即可
/// 2. 调用其他命令前，请先调用 [init] 方法初始化超高频模块，不再使用时调用 [free] 方法释放资源
/// 3. 完成初始化后，可根据需求设置和获取各个参数，也可通过 [startInventory] 方法开启盘点标签，标签数据将通过 [rfidTagStream] 流式返回。<br/>
/// 4. 盘点过程中，模块不再响应其他命令。可以使用 [stopInventory] 方法停止盘点标签
/// 5. 模块一次只能执行一条命令，请控制调用时机，否则可能会应答失败
/// 6. RfidWithUart 已经对错误情况进行处理，可以保证各个方法不会抛出异常，失败时可在 [RfidResult] 中查看错误信息
///
class RfidWithUart implements RfidInterface {
  static RfidWithUart? _instance;

  static RfidWithUart get instance {
    _instance ??= RfidWithUart._();
    return _instance!;
  }

  late final MethodChannel _channel;
  late final MethodChannelHelper _methodChannelHelper;

  late final StreamController<List<RfidTagInfo>> _tagStreamController;
  RfidInventoryParam? _inventoryParam;
  final List<RfidTagInfo> _tagList = [];

  // Private constructor for singleton
  RfidWithUart._() {
    _channel = const MethodChannel('rfid_flutter_android/uart');
    _methodChannelHelper = MethodChannelHelper(_channel);

    // 使用广播流控制器以支持多个监听器
    _tagStreamController = StreamController<List<RfidTagInfo>>.broadcast();

    const eventChannel = EventChannel('rfid_flutter_android/uartEvent');
    eventChannel.receiveBroadcastStream().listen((event) {
      if (event['type'] == 'RFID_TAG') {
        final tagInfo = RfidTagInfo.fromMap(event);
        //print('tagInfo: $tagInfo');
        if (tagInfo == null) return;

        if (_inventoryParam?.unique ?? false) {
          // filter duplicate tags
          final result = RfidTagUtil.getTagIndex(_tagList, tagInfo);
          if (result['exist'] != true) {
            _tagList.insert(result['index'], tagInfo);
            _tagStreamController.add([tagInfo]);
          }
        } else {
          // return all tags
          _tagStreamController.add([tagInfo]);
        }
      }
    });
  }

  @override
  Stream<List<RfidTagInfo>> get rfidTagStream => _tagStreamController.stream;

  @override
  Future<RfidResult<bool>> init() async {
    return _methodChannelHelper.invokeBoolMethod('init');
  }

  @override
  Future<RfidResult<bool>> free() async {
    return _methodChannelHelper.invokeBoolMethod('free');
  }

  @override
  Future<RfidResult<String>> getUhfFirmwareVersion() async {
    return _methodChannelHelper.invokeStringMethod('getUhfFirmwareVersion');
  }

  @override
  Future<RfidResult<String>> getUhfHardwareVersion() async {
    return _methodChannelHelper.invokeStringMethod('getUhfHardwareVersion');
  }

  @override
  Future<RfidResult<int>> getUhfTemperature() async {
    return _methodChannelHelper.invokeIntMethod('getUhfTemperature');
  }

  @override
  Future<RfidResult<bool>> resetUhf() async {
    return _methodChannelHelper.invokeBoolMethod('resetUhf');
  }

  //                                                  111
  //     1111                                         111
  //   11111111                    11        11       111
  //  1111111111                   111       111
  //  111     11                   111       111
  //  111              11111     1111111   1111111    111     111  111          111111
  //  11111           1111111    1111111   1111111    111     111 11111       111111111
  //   111111        111   111   1111111   1111111    111     1111111111      1111111111
  //    1111111     111    111     111       111      111     1111  1111     1111    111
  //       1111     1111111111     111       111      111     111    111     111     111
  //         111    1111111111     111       111      111     111    111     111     111
  //  1      111    111            111       111      111     111    111     111     111
  //  11    1111    111    11      111       111      111     111    111     1111   1111
  //  1111111111     111  111      11111     11111    111     111    111      1111111111
  //  111111111      1111111       11111     11111    111     111    111      111111 111
  //   111111         11111         1111      1111    111     111    111       1111  111
  //                                                                                 111
  //                                                                           11   1111
  //                                                                           111  1111
  //                                                                           11111111
  //                                                                            111111

  @override
  Future<RfidResult<RfidFrequency>> getFrequency() async {
    return _methodChannelHelper.invokeObjectMethod<RfidFrequency>(
      'getFrequency',
      (result) => RfidFrequency.fromValue(result ?? -1),
    );
  }

  @override
  Future<RfidResult<bool>> setFrequency(RfidFrequency frequency) async {
    return _methodChannelHelper.invokeBoolMethod(
      'setFrequency',
      {'value': frequency.value},
    );
  }

  @override
  Future<RfidResult<int>> getPower() async {
    return _methodChannelHelper.invokeIntMethod('getPower');
  }

  @override
  Future<RfidResult<bool>> setPower(int power) async {
    return _methodChannelHelper.invokeBoolMethod(
      'setPower',
      {'value': power},
    );
  }

  @override
  Future<RfidResult<bool>> setRfLink(RfidRfLink rfLink) async {
    return _methodChannelHelper.invokeBoolMethod(
      'setRfLink',
      {'value': rfLink.value},
    );
  }

  @override
  Future<RfidResult<RfidRfLink>> getRfLink() async {
    return _methodChannelHelper.invokeObjectMethod<RfidRfLink>(
      'getRfLink',
      (result) => RfidRfLink.fromValue(result ?? 0),
    );
  }

  @override
  Future<RfidResult<bool>> setInventoryMode(RfidInventoryMode inventoryMode) async {
    return _methodChannelHelper.invokeBoolMethod(
      'setInventoryMode',
      inventoryMode.toMap(),
      () => RfidInterfaceParamCheck.checkInventoryMode(inventoryMode),
    );
  }

  @override
  Future<RfidResult<RfidInventoryMode>> getInventoryMode() async {
    return _methodChannelHelper.invokeObjectMethod<RfidInventoryMode>(
      'getInventoryMode',
      (result) => RfidInventoryMode.fromMap(result),
    );
  }

  @override
  Future<RfidResult<bool>> setGen2(RfidGen2 gen2) async {
    return _methodChannelHelper.invokeBoolMethod(
      'setGen2',
      gen2.toMap(),
      () => RfidInterfaceParamCheck.checkGen2(gen2),
    );
  }

  @override
  Future<RfidResult<RfidGen2>> getGen2() async {
    return _methodChannelHelper.invokeObjectMethod<RfidGen2>(
      'getGen2',
      (result) => RfidGen2.fromMap(result),
    );
  }

  @override
  Future<RfidResult<bool>> setFastId(bool fastId) async {
    return _methodChannelHelper.invokeBoolMethod(
      'setFastId',
      {'value': fastId},
    );
  }

  @override
  Future<RfidResult<bool>> getFastId() async {
    return _methodChannelHelper.invokeBoolMethod(
      'getFastId',
    );
  }

  @override
  Future<RfidResult<bool>> setTagFocus(bool tagFocus) async {
    return _methodChannelHelper.invokeBoolMethod(
      'setTagFocus',
      {'value': tagFocus},
    );
  }

  @override
  Future<RfidResult<bool>> getTagFocus() async {
    return _methodChannelHelper.invokeBoolMethod(
      'getTagFocus',
    );
  }

  @override
  Future<RfidResult<bool>> setFastInventory(RfidFastInventory fastInventory) async {
    return _methodChannelHelper.invokeBoolMethod(
      'setFastInventory',
      fastInventory.toMap(),
    );
  }

  @override
  Future<RfidResult<RfidFastInventory>> getFastInventory() async {
    return _methodChannelHelper.invokeObjectMethod<RfidFastInventory>(
      'getFastInventory',
      (result) => RfidFastInventory.fromMap(result),
    );
  }

  //  11    111    11    111    111111111
  //  11    111    11    111    111111111
  //  11    111    11    111    111
  //  11    111    11    111    111
  //  11    111    11    111    111
  //  11    111    11    111    111
  //  11    111    111111111    111111111
  //  11    111    111111111    111111111
  //  11    111    11    111    111
  //  11    111    11    111    111
  //  11    111    11    111    111
  //  111   111    11    111    111
  //  11111111     11    111    111
  //   1111111     11    111    111
  //    1111       11    111    111

  @override
  Future<RfidResult<bool>> setFilter(RfidFilter filter) async {
    return _methodChannelHelper.invokeBoolMethod(
      'setFilter',
      filter.toMap(),
      () => RfidInterfaceParamCheck.checkFilter(filter),
    );
  }

  @override
  Future<RfidResult<bool>> setFilters(List<RfidFilter> filters) async {
    return _methodChannelHelper.invokeBoolMethod(
      'setFilters',
      {'filters': filters.map((filter) => filter.toMap()).toList()},
      () => RfidInterfaceParamCheck.checkFilters(filters),
    );
  }

  Future<RfidResult<bool>> _setupFilters(List<RfidFilter>? filters) async {
    if (filters == null) {
      return const RfidResult.success(true); // 不设置过滤
    }

    // 仅统计 enabled == true 的过滤器
    final enabledFilters = filters.where((f) => f.enabled).toList();

    if (enabledFilters.isEmpty) {
      // 空列表或全部 enabled == false：禁用过滤
      final emptyFilter = RfidFilter(enabled: true, bank: RfidBank.epc, offset: 0, length: 0, data: '');
      final res = await setFilter(emptyFilter);
      if (res.isIneffective) {
        return RfidResult.failure(res.error);
      }
    } else if (enabledFilters.length == 1) {
      // 单个过滤：setFilter 适配度更高
      final res = await setFilter(enabledFilters.first);
      if (res.isIneffective) {
        return RfidResult.failure(res.error);
      }
    } else {
      // 多个过滤
      final res = await setFilters(enabledFilters);
      if (res.isIneffective) {
        return RfidResult.failure(res.error);
      }
    }

    return const RfidResult.success(true);
  }

  @override
  Future<RfidResult<RfidTagInfo>> singleInventory({List<RfidFilter>? filters}) async {
    final filterResult = await _setupFilters(filters);
    if (filterResult.isIneffective) {
      return RfidResult.failure(filterResult.error);
    }
    return _methodChannelHelper.invokeObjectMethod<RfidTagInfo>(
      'singleInventory',
      (result) => RfidTagInfo.fromMap(result),
    );
  }

  @override
  Future<RfidResult<bool>> startInventory({
    List<RfidFilter>? filters,
    RfidInventoryParam? inventoryParam,
  }) async {
    final filterResult = await _setupFilters(filters);
    if (filterResult.isIneffective) {
      return RfidResult.failure(filterResult.error);
    }

    _inventoryParam = inventoryParam;
    _tagList.clear();

    return _methodChannelHelper.invokeBoolMethod(
      'startInventory',
      inventoryParam?.toMap(),
    );
  }

  @override
  Future<RfidResult<bool>> stopInventory() async {
    return _methodChannelHelper.invokeBoolMethod('stopInventory');
  }

  @override
  Future<RfidResult<bool>> isInventorying() async {
    return _methodChannelHelper.invokeBoolMethod('isInventorying');
  }

  @override
  Future<RfidResult<String>> readData({
    RfidFilter? filter,
    required RfidBank bank,
    required int offset,
    required int length,
    required String password,
  }) async {
    return _methodChannelHelper.invokeStringMethod(
      'readData',
      {
        'filter': filter?.toMap(),
        'bank': bank.value,
        'offset': offset,
        'length': length,
        'password': password,
      },
      () async {
        await RfidInterfaceParamCheck.checkFilter(filter);
        await RfidInterfaceParamCheck.checkPassword(password);
      },
    );
  }

  @override
  Future<RfidResult<bool>> writeData({
    RfidFilter? filter,
    required RfidBank bank,
    required int offset,
    required int length,
    required String password,
    required String data,
  }) async {
    return _methodChannelHelper.invokeBoolMethod(
      'writeData',
      {
        'filter': filter?.toMap(),
        'bank': bank.value,
        'offset': offset,
        'length': length,
        'password': password,
        'data': data,
      },
      () async {
        await RfidInterfaceParamCheck.checkFilter(filter);
        await RfidInterfaceParamCheck.checkPassword(password);
      },
    );
  }

  @override
  Future<RfidResult<bool>> lockTag({
    RfidFilter? filter,
    required String password,
    required List<RfidLockBank> lockBanks,
    required RfidLockMode lockMode,
  }) async {
    return _methodChannelHelper.invokeBoolMethod(
      'lockTag',
      {
        'filter': filter?.toMap(),
        'password': password,
        'lockCode': RfidTagUtil.getLockCode(lockBanks, lockMode),
      },
      () async {
        await RfidInterfaceParamCheck.checkFilter(filter);
        await RfidInterfaceParamCheck.checkPassword(password);
      },
    );
  }

  @override
  Future<RfidResult<bool>> killTag({
    RfidFilter? filter,
    required String password,
  }) async {
    return _methodChannelHelper.invokeBoolMethod(
      'killTag',
      {
        'filter': filter?.toMap(),
        'password': password,
      },
      () async {
        await RfidInterfaceParamCheck.checkFilter(filter);
        await RfidInterfaceParamCheck.checkPassword(password);
      },
    );
  }
}
