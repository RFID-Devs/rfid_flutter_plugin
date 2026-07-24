import 'package:rfid_flutter_core/rfid_flutter_core.dart';

/// Utility class for checking RFID interface parameters. <br/>
/// RFID接口参数校验工具类
class RfidInterfaceParamCheck {
  static bool isHexString(String str) {
    return RegExp(r'^[0-9A-Fa-f]+$').hasMatch(str);
  }

  static Future<void> checkFilter(RfidFilter? filter) async {
    if (filter == null || !filter.enabled) return;
    if (filter.bank.value < RfidBank.epc.value || filter.bank.value > RfidBank.user.value) {
      throw ArgumentError('Filter bank param must be between ${RfidBank.epc.value} and ${RfidBank.user.value}, got: ${filter.bank.value}');
    }
    if (filter.offset < 0) {
      throw ArgumentError('Filter offset param invalid, got: ${filter.offset}');
    }
    if (filter.length < 0) {
      throw ArgumentError('Filter length param invalid, got: ${filter.length}');
    } else if (filter.length > 0) {
      if (filter.data.isEmpty) {
        throw ArgumentError('Filter data param can\'t be empty');
      }
      // 检查data是否为16进制字符串
      if (!isHexString(filter.data)) {
        throw ArgumentError('Filter data param must be a hexadecimal string, got: ${filter.data}');
      }
      if (filter.data.length * 4 < filter.length) {
        throw ArgumentError('Filter data param not match length param');
      }
    }
  }

  static Future<void> checkFilters(List<RfidFilter> filters) async {
    for (var i = 0; i < filters.length; i++) {
      try {
        await checkFilter(filters[i]);
      } on ArgumentError catch (e) {
        throw ArgumentError('filters[$i]: ${e.message}');
      }
    }
  }

  static Future<void> checkPassword(String password) async {
    if (password.length != 8) {
      throw ArgumentError('Password must be 8 characters long, got: $password');
    }
    if (!isHexString(password)) {
      throw ArgumentError('Password must be a hexadecimal string, got: $password');
    }
  }

  static Future<void> checkPower(int power) async {
    if (power < 1) {
      throw ArgumentError('Power param must be greater than 0, got: $power');
    }
  }

  static Future<void> checkAntennaState(List<RfidAntennaState> antennaStateList) async {
    if (antennaStateList.isEmpty) {
      throw ArgumentError('Antenna state list is empty');
    }
    for (var antennaState in antennaStateList) {
      if (antennaState.antenna < 0) {
        throw ArgumentError('Antenna number invalid, got: ${antennaState.antenna}');
      }
      if (antennaState.power != null && (antennaState.power! < 1)) {
        throw ArgumentError('Power param must be greater than 0, got: ${antennaState.power}');
      }
    }
  }

  static Future<void> checkInventoryMode(RfidInventoryMode inventoryMode) async {
    if (inventoryMode.inventoryBank.value <= RfidInventoryBank.epcTid.value) {
      return;
    }
    if (inventoryMode.offset < 0) {
      throw ArgumentError('Offset param must be greater than 0, got: ${inventoryMode.offset}');
    }
    if (inventoryMode.length < 0) {
      throw ArgumentError('Length param must be greater than 0, got: ${inventoryMode.length}');
    }
  }

  static Future<void> checkGen2(RfidGen2 gen2) async {
    // selectTarget 校验: S0(0) ~ SL(4)
    if (gen2.selectTarget != null && (gen2.selectTarget! < RfidGen2.selectTargetS0 || gen2.selectTarget! > RfidGen2.selectTargetSL)) {
      throw ArgumentError(
          'Gen2 SelectTarget must be between ${RfidGen2.selectTargetS0} and ${RfidGen2.selectTargetSL}, got: ${gen2.selectTarget}');
    }

    // selectAction 校验: 0 ~ 7
    if (gen2.selectAction != null && (gen2.selectAction! < 0 || gen2.selectAction! > 7)) {
      throw ArgumentError('Gen2 SelectAction must be between 0 and 7, got: ${gen2.selectAction}');
    }

    // selectTruncate 校验: Disable(0) ~ Enable(1)
    if (gen2.selectTruncate != null &&
        (gen2.selectTruncate! < RfidGen2.selectTruncateDisable || gen2.selectTruncate! > RfidGen2.selectTruncateEnable)) {
      throw ArgumentError(
          'Gen2 SelectTruncate must be between ${RfidGen2.selectTruncateDisable} and ${RfidGen2.selectTruncateEnable}, got: ${gen2.selectTruncate}');
    }

    // q 校验: Static(0) ~ Dynamic(1)
    if (gen2.q != null && (gen2.q! < RfidGen2.qStatic || gen2.q! > RfidGen2.qDynamic)) {
      throw ArgumentError('Gen2 Q algorithm must be between ${RfidGen2.qStatic} and ${RfidGen2.qDynamic}, got: ${gen2.q}');
    }

    // startQ 校验: 0 ~ 15
    if (gen2.startQ != null && (gen2.startQ! < 0 || gen2.startQ! > 15)) {
      throw ArgumentError('Gen2 StartQ must be between 0 and 15, got: ${gen2.startQ}');
    }

    // minQ 校验: 0 ~ 15
    if (gen2.minQ != null && (gen2.minQ! < 0 || gen2.minQ! > 15)) {
      throw ArgumentError('Gen2 MinQ must be between 0 and 15, got: ${gen2.minQ}');
    }

    // maxQ 校验: 0 ~ 15
    if (gen2.maxQ != null && (gen2.maxQ! < 0 || gen2.maxQ! > 15)) {
      throw ArgumentError('Gen2 MaxQ must be between 0 and 15, got: ${gen2.maxQ}');
    }

    // queryDR 校验: DR_8(0) ~ DR_64_3(1)
    if (gen2.queryDR != null && (gen2.queryDR! < RfidGen2.queryDR_8 || gen2.queryDR! > RfidGen2.queryDR_64_3)) {
      throw ArgumentError('Gen2 QueryDR must be between ${RfidGen2.queryDR_8} and ${RfidGen2.queryDR_64_3}, got: ${gen2.queryDR}');
    }

    // queryM 校验: FM0(0) ~ Miller8(3)
    if (gen2.queryM != null && (gen2.queryM! < RfidGen2.queryM_FM0 || gen2.queryM! > RfidGen2.queryM_Miller8)) {
      throw ArgumentError('Gen2 QueryM must be between ${RfidGen2.queryM_FM0} and ${RfidGen2.queryM_Miller8}, got: ${gen2.queryM}');
    }

    // queryTRext 校验: NoPilot(0) ~ UsePilot(1)
    if (gen2.queryTRext != null && (gen2.queryTRext! < RfidGen2.queryTRextNoPilot || gen2.queryTRext! > RfidGen2.queryTRextUsePilot)) {
      throw ArgumentError(
          'Gen2 QueryTRext must be between ${RfidGen2.queryTRextNoPilot} and ${RfidGen2.queryTRextUsePilot}, got: ${gen2.queryTRext}');
    }

    // querySel 校验: All(0) ~ SL(3)
    if (gen2.querySel != null && (gen2.querySel! < RfidGen2.querySelAll || gen2.querySel! > RfidGen2.querySelSL)) {
      throw ArgumentError('Gen2 QuerySel must be between ${RfidGen2.querySelAll} and ${RfidGen2.querySelSL}, got: ${gen2.querySel}');
    }

    // querySession 校验: S0(0) ~ S3(3)
    if (gen2.querySession != null && (gen2.querySession! < RfidGen2.querySessionS0 || gen2.querySession! > RfidGen2.querySessionS3)) {
      throw ArgumentError(
          'Gen2 QuerySession must be between ${RfidGen2.querySessionS0} and ${RfidGen2.querySessionS3}, got: ${gen2.querySession}');
    }

    // queryTarget 校验: A(0) ~ B(1)
    if (gen2.queryTarget != null && (gen2.queryTarget! < RfidGen2.queryTargetA || gen2.queryTarget! > RfidGen2.queryTargetB)) {
      throw ArgumentError(
          'Gen2 QueryTarget must be between ${RfidGen2.queryTargetA} and ${RfidGen2.queryTargetB}, got: ${gen2.queryTarget}');
    }

    // linkFrequency 校验: 0 ~ 7
    if (gen2.linkFrequency != null && (gen2.linkFrequency! < 0 || gen2.linkFrequency! > 7)) {
      throw ArgumentError('Gen2 LinkFrequency must be between 0 and 7, got: ${gen2.linkFrequency}');
    }
  }
}
