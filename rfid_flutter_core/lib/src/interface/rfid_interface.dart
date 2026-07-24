import 'package:rfid_flutter_core/src/entity/index.dart';

/// RFID interface <br/>
/// RFID接口 <br/>
abstract class RfidInterface {
  /// Init RFID Module <br/>
  /// 初始化RFID模块 <br/>
  ///
  /// #### English
  /// Connect and initialize the RFID module, it may take a long time.
  ///
  /// Returns a [RfidResult] where `data` is [bool], `true` if initialization succeeds, `false` otherwise. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 连接并初始化RFID模块，注意耗时时间可能会比较长。
  ///
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示初始化成功，false 表示初始化失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。
  Future<RfidResult<bool>> init();

  /// Release RFID Module <br/>
  /// 释放RFID模块 <br/>
  ///
  /// #### English
  /// Release resources and disconnect from the RFID module. <br/>
  /// When don't need to use the RFID module, please call this method to release resources, to reduce power consumption and improve battery life. <br/>
  ///
  /// Returns a [RfidResult] where `data` is [bool], `true` if the free operation succeeds, `false` otherwise. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 释放资源并断开与RFID模块的连接。 <br/>
  /// 不需要使用RFID模块时，请调用本方法释放资源，以减少电量消耗，提高续航。 <br/>
  ///
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示释放成功，false 表示释放失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。
  Future<RfidResult<bool>> free();

  /// Get RFID tag stream <br/>
  /// 获取RFID标签的信息流 <br/>
  ///
  /// #### English
  /// After calling [startInventory], the RFID tags found will be returned through this stream.
  ///
  /// #### 中文
  /// 调用 [startInventory] 后，盘点到的RFID标签会通过该信息流返回。
  Stream<List<RfidTagInfo>> get rfidTagStream;

  /// Get RFID module firmware version <br/>
  /// 获取RFID模块的固件版本信息 <br/>
  ///
  /// #### English
  /// Returns a [RfidResult] where `data` is [String], the RFID firmware version string.
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 返回 [RfidResult]，成功时 `data` 为 [String]，UHF固件版本字符串。失败时 `error` 包含错误描述信息。
  Future<RfidResult<String>> getUhfFirmwareVersion();

  /// Get RFID module hardware version <br/>
  /// 获取RFID模块的硬件版本信息 <br/>
  ///
  /// #### English
  /// Returns a [RfidResult] where `data` is [String], the RFID hardware version string.
  /// On failure, `error` contains the error description.
  ///
  /// #### 中文
  /// 返回 [RfidResult]，成功时 `data` 为 [String]，UHF硬件版本字符串。失败时 `error` 包含错误描述信息。
  Future<RfidResult<String>> getUhfHardwareVersion();

  /// Reset RFID Module <br/>
  /// 重置RFID模块 <br/>
  ///
  /// #### English
  /// Returns a [RfidResult] where `data` is [bool], `true` if the reset operation succeeds, `false` otherwise.
  /// On failure, `error` contains the error description.
  ///
  /// #### 中文
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示重置成功，false 表示重置失败。
  /// 失败时 `error` 包含错误描述信息。
  Future<RfidResult<bool>> resetUhf();

  /// Get temperature of the RFID module <br/>
  /// 获取RFID模块的温度 <br/>
  ///
  /// #### English
  /// Returns a [RfidResult] where `data` is [int], the temperature of the RFID module, unit: ℃. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 返回 [RfidResult]，成功时 `data` 为 [int]，单位摄氏度℃，失败时 `error` 包含错误描述信息。
  Future<RfidResult<int>> getUhfTemperature();

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
  //                                                                           11    111
  //                                                                           111  1111
  //                                                                           11111111
  //                                                                            111111

  /// Set frequency parameter <br/>
  /// 设置频段参数 <br/>
  ///
  /// #### English
  /// Returns a [RfidResult] where `data` is [bool], `true` if set successfully, `false` if set fails. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示设置成功，false 表示设置失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<bool>> setFrequency(RfidFrequency frequency);

  /// Get frequency parameter <br/>
  /// 获取频段参数 <br/>
  ///
  /// #### English
  /// Returns a [RfidResult] where `data` is [RfidFrequency]. On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 返回 [RfidResult]，成功时 `data` 为 [RfidFrequency]，失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<RfidFrequency>> getFrequency();

  /// Set power parameter <br/>
  /// 设置功率参数 <br/>
  ///
  /// #### English
  /// [power] value range: 1-30. <br/>
  ///
  /// Returns a [RfidResult] where `data` is [bool], `true` if set successfully, `false` if set fails. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// [power]可取值范围为 1-30。
  ///
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示设置成功，false 表示设置失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<bool>> setPower(int power);

  /// Get power parameter <br/>
  /// 获取功率参数 <br/>
  ///
  /// #### English
  /// Returns a [RfidResult] where `data` is [int], the power parameter value. On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 返回 [RfidResult]，成功时 `data` 为 [int]，失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<int>> getPower();

  /// Set RFLink parameter <br/>
  /// 设置RFLink参数 <br/>
  ///
  /// #### English
  /// Returns a [RfidResult] where `data` is [bool], `true` if set successfully, `false` if set fails. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示设置成功，false 表示设置失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<bool>> setRfLink(RfidRfLink rfLink);

  /// Get RFLink parameter <br/>
  /// 获取RFLink参数 <br/>
  ///
  /// #### English
  /// Get the RFID RFLink parameter value. <br/>
  /// Returns a [RfidResult] where `data` is [RfidRfLink], the RFLink parameter value. On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 返回 [RfidResult]，成功时 `data` 为 [RfidRfLink]，失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<RfidRfLink>> getRfLink();

  /// Set inventory mode parameter <br/>
  /// 设置盘点模式参数 <br/>
  ///
  /// #### English
  /// When [inventoryMode.inventoryBank] is [RfidInventoryBank.epcTidUser], set the EPC + TID + USER inventory mode. <br/>
  /// In this case, the [inventoryMode.offset] and [inventoryMode.length] will take effect on the USER area, and other cases will not take effect. <br/>
  ///
  /// Returns a [RfidResult] where `data` is [bool], `true` if set successfully, `false` if set fails. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 当 [inventoryMode.inventoryBank] 为 [RfidInventoryBank.epcTidUser] 时，设置 EPC + TID + USER 盘点模式。 <br/>
  /// 此时 [inventoryMode.offset] 和 [inventoryMode.length] 参数会作用于 USER 区域，其余情况[inventoryMode.offset] 和 [inventoryMode.length] 参数无实际作用。
  ///
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示设置成功，false 表示设置失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<bool>> setInventoryMode(RfidInventoryMode inventoryMode);

  /// Get inventory mode parameter <br/>
  /// 获取盘点模式参数 <br/>
  ///
  /// #### English
  /// Returns a [RfidResult] where `data` is [RfidInventoryMode], the inventory mode parameter value. On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 返回 [RfidResult]，成功时 `data` 为 [RfidInventoryMode]，失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<RfidInventoryMode>> getInventoryMode();

  /// Set Gen2 parameter <br/>
  /// 设置Gen2参数 <br/>
  ///
  /// #### English
  /// Only the properties provided in the input [gen2] will be set; other Gen2 parameters will remain unchanged. <br/>
  /// Returns a [RfidResult] where `data` is [bool], `true` if set successfully, `false` if set fails. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 仅会设置传入的 [gen2] 属性参数，不会影响其他参数。 <br/>
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示设置成功，false 表示设置失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  ///
  /// #### Example
  /// ```dart
  /// final gen2 = RfidGen2(
  ///   querySession: RfidGen2.querySessionS0,
  ///   queryTarget: RfidGen2.queryTargetA
  /// );
  /// final result = await RfidWithUart.instance.setGen2(gen2);
  /// ```
  Future<RfidResult<bool>> setGen2(RfidGen2 gen2);

  /// Get Gen2 parameter <br/>
  /// 获取Gen2参数 <br/>
  ///
  /// #### English
  /// Returns a [RfidResult] where `data` is [RfidGen2], the Gen2 parameter value. On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 返回 [RfidResult]，成功时 `data` 为 [RfidGen2]，失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<RfidGen2>> getGen2();

  /// Set FastInventory parameter <br/>
  /// 设置 FastInventory 参数 <br/>
  ///
  /// #### English
  /// [fastInventory] - true: Open, false: Close
  ///
  /// Returns a [RfidResult] where `data` is [bool], `true` if set successfully, `false` if set fails. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// [fastInventory] - true: 开启，false: 关闭
  ///
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示设置成功，false 表示设置失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<bool>> setFastInventory(RfidFastInventory fastInventory);

  /// Get FastInventory parameter <br/>
  /// 获取 FastInventory 参数 <br/>
  ///
  /// #### English
  /// Returns a [RfidResult] where `data` is [bool], `true` if get successfully, `false` if get fails. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示获取成功，false 表示获取失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<RfidFastInventory>> getFastInventory();

  /// Set TagFocus parameter <br/>
  /// 设置 TagFocus 参数 <br/>
  ///
  /// #### English
  /// [tagFocus] - true: Open, false: Close
  ///
  /// Returns a [RfidResult] where `data` is [bool], `true` if set successfully, `false` if set fails. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// [tagFocus] - true: 开启，false: 关闭
  ///
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示设置成功，false 表示设置失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<bool>> setTagFocus(bool tagFocus);

  /// Get TagFocus parameter <br/>
  /// 获取 TagFocus 参数 <br/>
  ///
  /// #### English
  /// Returns a [RfidResult] where `data` is [bool], `true` if get successfully, `false` if get fails. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示获取成功，false 表示获取失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<bool>> getTagFocus();

  /// Set FastId parameter <br/>
  /// 设置 FastId 参数 <br/>
  ///
  /// #### English
  /// [fastId] - true: Open, false: Close
  ///
  /// Returns a [RfidResult] where `data` is [bool], `true` if set successfully, `false` if set fails. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示设置成功，false 表示设置失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<bool>> setFastId(bool fastId);

  /// Get FastId parameter <br/>
  /// 获取快速ID参数 <br/>
  ///
  /// #### English
  /// Returns a [RfidResult] where `data` is [bool], `true` if get successfully, `false` if get fails. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示获取成功，false 表示获取失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<bool>> getFastId();

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

  /// Set Filter parameter <br/>
  /// 设置盘点过滤参数 <br/>
  ///
  /// #### English
  /// Returns a [RfidResult] where `data` is [bool], `true` if set successfully, `false` if set fails. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示设置成功，false 表示设置失败。 <br/>
  ///
  /// #### Example
  ///
  /// 取消过滤
  ///
  /// ```dart
  /// final filter = RfidFilter(
  ///   enabled: false,
  /// );
  /// final result = await RfidWithUart.instance.setFilter(filter);
  /// ```
  ///
  /// ----
  ///
  /// Filter tags whose EPC data starts with 1111 (EPC: **1111**22223333) <br/>
  /// 过滤EPC数据以 1111开头的标签（EPC: **1111**22223333）
  ///
  /// ```dart
  /// final filter = RfidFilter(
  ///   enabled: true,
  ///   bank: RfidBank.epc,
  ///   enabled: true,
  ///   offset: 32,
  ///   length: 16,
  ///   data: '1111',
  /// );
  /// final result = await RfidWithUart.instance.setFilter(filter);
  /// ```
  ///
  /// ----
  ///
  /// Filter tags whose TID data 16\~48 bit is 22223333 (TID: 1111**22223333**4444) <br/>
  /// 过滤TID数据 第16\~48 bit 为 22223333的标签（TID: 1111**22223333**4444）
  ///
  /// ```dart
  /// final filter = RfidFilter(
  ///   enabled: true,
  ///   bank: RfidBank.tid,
  ///   offset: 16,
  ///   length: 32,
  ///   data: '22223333',
  /// );
  /// final result = await RfidWithUart.instance.setFilter(filter);
  /// ```
  Future<RfidResult<bool>> setFilter(RfidFilter filter);

  /// Set multiple Filter parameters <br/>
  /// 设置多个盘点过滤参数 <br/>
  ///
  /// #### English
  /// [filters] List of filter parameters. <br/>
  /// Returns a [RfidResult] where `data` is [bool], `true` if set successfully, `false` if set fails. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// [filters] 过滤参数列表。 <br/>
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示设置成功，false 表示设置失败。 <br/>
  ///
  /// #### Example
  ///
  /// 取消过滤
  ///
  /// ```dart
  /// final filters = [
  ///   RfidFilter(
  ///     enabled: false,
  ///   ),
  /// ];
  /// final result = await RfidWithUart.instance.setFilters(filters);
  /// ```
  ///
  /// ----
  ///
  /// Filter tags whose EPC data starts with 1111, and TID data 16\~48 bit is 22223333 <br/>
  /// 过滤EPC数据以 1111开头，且TID数据 第16\~48 bit 为 22223333的标签
  ///
  /// ```dart
  /// final filters = [
  ///   RfidFilter(
  ///     enabled: true,
  ///     bank: RfidBank.epc,
  ///     offset: 32,
  ///     length: 16,
  ///     data: '1111',
  ///   ),
  ///   RfidFilter(
  ///     enabled: true,
  ///     bank: RfidBank.tid,
  ///     offset: 16,
  ///     length: 32,
  ///     data: '22223333',
  ///   ),
  /// ];
  /// final result = await RfidWithUart.instance.setFilters(filters);
  /// ```
  Future<RfidResult<bool>> setFilters(List<RfidFilter> filters);

  /// Single Inventory <br/>
  /// 单步盘点 <br/>
  ///
  /// #### English
  /// Single step inventory, only inventory one tag. <br/>
  /// [filters] Optional filter list. See [startInventory] for filter semantics. <br/>
  /// Returns a [RfidResult] where `data` is [RfidTagInfo], the tag information. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 单步盘点，只盘点一张标签。 <br/>
  /// [filters] 可选过滤参数列表，语义同 [startInventory]。 <br/>
  /// 返回 [RfidResult]，成功时 `data` 为 [RfidTagInfo] 标签信息，失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<RfidTagInfo>> singleInventory({List<RfidFilter>? filters});

  /// Start Inventory <br/>
  /// 开始盘点 <br/>
  ///
  /// #### English
  /// [filters] Optional filter list: <br/>
  /// - `null` (or omitted): do not set filter (note: this does **not** cancel existing filters) <br/>
  /// - empty list, or all items with `enabled == false`: cancel/disable filters <br/>
  /// - one enabled filter: equivalent to [setFilter] <br/>
  /// - multiple enabled filters: equivalent to [setFilters] <br/>
  /// [inventoryParam] Optional inventory parameters, if empty, it means not to set the inventory parameters, using the default parameters. <br/>
  /// Returns a [RfidResult] where `data` is [bool], `true` if the inventory starts successfully, `false` if the inventory fails. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// [filters] 可选过滤参数列表： <br/>
  /// - `null`（或不传）：不设置过滤（注意：**不是**取消过滤） <br/>
  /// - 空列表，或全部 `enabled == false`：取消/禁用过滤 <br/>
  /// - 有效过滤（`enabled == true`）数量为 1：等价于 [setFilter] <br/>
  /// - 有效过滤数量大于 1：等价于 [setFilters] <br/>
  /// [inventoryParam] 可选盘点参数，为空时表示不设置盘点参数，采用默认参数。 <br/>
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示开始盘点成功，false 表示开始盘点失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  ///
  /// #### Example
  ///
  /// Pass `null` / omit filters: do not set filter. <br/>
  /// 传入 `null` / 不传 filters：不设置过滤。
  /// ```dart
  /// final result = await RfidWithUart.instance.startInventory();
  /// // 或
  /// final result = await RfidWithUart.instance.startInventory(filters: null);
  /// ```
  ///
  /// ----
  ///
  /// Pass empty list: cancel filters. <br/>
  /// 传入空列表：取消过滤。
  /// ```dart
  /// final result = await RfidWithUart.instance.startInventory(filters: []);
  /// ```
  ///
  /// ----
  ///
  /// Set one filter, no inventoryParam, use default parameters. <br/>
  /// 过滤EPC数据以 1111开头的标签（EPC: **1111**22223333）
  /// ```dart
  /// final filter = RfidFilter(
  ///   enabled: true,
  ///   bank: RfidBank.epc,
  ///   offset: 32,
  ///   length: 16,
  ///   data: '1111',
  /// );
  /// final result = await RfidWithUart.instance.startInventory(filters: [filter]);
  /// ```
  ///
  /// It's equivalent to: <br/>
  /// 等价于:
  /// ```dart
  /// final filter = RfidFilter(
  ///   enabled: true,
  ///   bank: RfidBank.epc,
  ///   offset: 32,
  ///   length: 16,
  ///   data: '1111',
  /// );
  /// await RfidWithUart.instance.setFilter(filter);
  /// final result = await RfidWithUart.instance.startInventory();
  /// ```
  ///
  /// ----
  ///
  /// Set multiple filters (three filters). <br/>
  /// 多条件过滤
  /// ```dart
  /// final filters = [
  ///   RfidFilter(
  ///     enabled: true,
  ///     bank: RfidBank.epc,
  ///     offset: 32,
  ///     length: 16,
  ///     data: '1111',
  ///   ),
  ///   RfidFilter(
  ///     enabled: true,
  ///     bank: RfidBank.tid,
  ///     offset: 16,
  ///     length: 32,
  ///     data: '22223333',
  ///   ),
  ///   RfidFilter(
  ///     enabled: true,
  ///     bank: RfidBank.user,
  ///     offset: 0,
  ///     length: 16,
  ///     data: 'ABCD',
  ///   ),
  /// ];
  /// final result = await RfidWithUart.instance.startInventory(filters: filters);
  /// ```
  ///
  /// ----
  ///
  /// Filters out duplicate tags, ensuring that the tags returned by the current inventory session are unique. <br/>
  /// 过滤重复标签，确保本次盘点返回的标签唯一。 <br/>
  ///
  /// ```dart
  /// final result = await RfidWithUart.instance.startInventory(
  ///     inventoryParam: RfidInventoryParam(unique: true)
  /// );
  /// ```
  ///
  Future<RfidResult<bool>> startInventory({
    List<RfidFilter>? filters,
    RfidInventoryParam? inventoryParam,
  });

  /// Stop Inventory <br/>
  /// 停止盘点 <br/>
  ///
  /// #### English
  /// Returns a [RfidResult] where `data` is [bool], `true` if the inventory stops successfully, `false` if the inventory stops fails. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示停止盘点成功，false 表示停止盘点失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<bool>> stopInventory();

  /// Is Inventorying <br/>
  /// 是否正在盘点 <br/>
  ///
  /// #### English
  /// Returns a [RfidResult] where `data` is [bool], `true` if the inventory is running, `false` if the inventory is not running. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示正在盘点，false 表示正在盘点。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<bool>> isInventorying();

  /// Read Data from Tag <br/>
  /// 读取标签数据 <br/>
  ///
  /// #### English
  ///
  /// [filter]  - Filter parameters, if empty, it means not to specify the tag <br/>
  /// [bank]    - Read data area <br/>
  /// [offset]  - Read start position, unit: word <br/>
  /// [length]  - Read data length, unit: word <br/>
  /// [password] - Read tag password <br/>
  ///
  /// Returns a [RfidResult] where `data` is [String], the tag data. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  ///
  /// [filter]   - 过滤参数，为空时表示不指定标签 <br/>
  /// [bank]     - 读取的数据区域 <br/>
  /// [offset]   - 读取的起始位置，单位：字 <br/>
  /// [length]   - 读取的数据长度，单位：字 <br/>
  /// [password] - 读取的标签密码 <br/>
  ///
  /// 返回 [RfidResult]，成功时 `data` 为 [String] 标签数据，失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<String>> readData({
    RfidFilter? filter = null,
    required RfidBank bank,
    required int offset,
    required int length,
    required String password,
  });

  /// Write Data to Tag <br/>
  /// 写入标签数据 <br/>
  ///
  /// #### English
  ///
  /// [filter]    - Filter parameters, if empty, it means not to specify the tag (note that it is not to cancel the filter) <br/>
  /// [bank]      - Write data area <br/>
  /// [offset]    - Write start position, unit: word <br/>
  /// [length]    - Write data length, unit: word <br/>
  /// [password]  - Write tag password <br/>
  /// [data]      - Write data <br/>
  ///
  /// Returns a [RfidResult] where `data` is [bool], `true` if the write operation succeeds, `false` otherwise. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  ///
  /// [filter]    - 过滤参数，为空时表示不指定标签（注意不是取消过滤） <br/>
  /// [bank]      - 写入的数据区域 <br/>
  /// [offset]    - 写入的起始位置，单位：字 <br/>
  /// [length]    - 写入的数据长度，单位：字 <br/>
  /// [password]  - 写入的标签密码（如果标签有密码） <br/>
  /// [data]      - 写入的数据 <br/>
  ///
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示写入成功，false 表示写入失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<bool>> writeData({
    RfidFilter? filter = null,
    required RfidBank bank,
    required int offset,
    required int length,
    required String password,
    required String data,
  });

  /// Lock Tag <br/>
  /// 锁定标签 <br/>
  ///
  /// #### English
  ///
  /// [filter]    - Filter parameters, if empty, it means not to specify the tag <br/>
  /// [password]  - Tag access password <br/>
  /// [lockBanks] - Lock tag banks <br/>
  /// [lockMode]  - Lock tag operation mode <br/>
  ///
  /// Returns a [RfidResult] where `data` is [bool], `true` if the lock operation succeeds, `false` otherwise. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  ///
  /// [filter]    - 过滤参数，为空时表示不指定标签 <br/>
  /// [password]  - 标签访问密码 <br/>
  /// [lockBanks] - 需要操作的标签区域列表 <br/>
  /// [lockMode]  - 标签操作模式 <br/>
  ///
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示锁定成功，false 表示锁定失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<bool>> lockTag({
    RfidFilter? filter = null,
    required String password,
    required List<RfidLockBank> lockBanks,
    required RfidLockMode lockMode,
  });

  /// Kill Tag <br/>
  /// 销毁标签 <br/>
  ///
  /// #### English
  ///
  /// [filter]    - Filter parameters, if empty, it means not to specify the tag <br/>
  /// [password]  - Kill tag password <br/>
  ///
  /// Returns a [RfidResult] where `data` is [bool], `true` if the kill operation succeeds, `false` otherwise. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  ///
  /// [filter]    - 过滤参数，为空时表示不指定标签 <br/>
  /// [password]  - 标签销毁密码 <br/>
  ///
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示销毁成功，false 表示销毁失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<bool>> killTag({
    RfidFilter? filter = null,
    required String password,
  });
}
