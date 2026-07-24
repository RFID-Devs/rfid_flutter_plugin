// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get deviceInfo => '设备信息';

  @override
  String get rfidScanner => 'RFID扫描';

  @override
  String get barcodeScanner => '条码扫描';

  @override
  String get deviceInfoSubtitle => 'SN, IMEI, 等';

  @override
  String get rfidScannerSubtitle => 'RFID标签扫描、参数管理';

  @override
  String get barcodeScannerSubtitle => '扫描条码、二维码等';

  @override
  String get language => '语言';

  @override
  String get inventory => '盘点';

  @override
  String get settings => '设置';

  @override
  String get readWrite => '读-写';

  @override
  String get lockKill => '锁定-销毁';

  @override
  String get initSuccess => '✅ 初始化成功';

  @override
  String get initFailed => '❌ 初始化失败';

  @override
  String get freeSuccess => '✅ 释放成功';

  @override
  String get freeFailed => '❌ 释放失败';

  @override
  String get filter => '过滤';

  @override
  String get filterTitle => '标签过滤';

  @override
  String get filterNone => '无过滤';

  @override
  String get filterEmpty => '无过滤条件';

  @override
  String get filterAdd => '添加过滤';

  @override
  String get filterClear => '清空过滤';

  @override
  String filterCountFormat(int count) {
    return '$count 个过滤条件';
  }

  @override
  String get filterDialogTitle => '过滤条件';

  @override
  String filterItemFormat(String bank, int offset, int length, String data) {
    return '$bank · 地址 $offset · 长度 $length · $data';
  }

  @override
  String get filterMaxCount => '最多支持添加8个过滤条件';

  @override
  String get filterOffsetInvalid => '地址参数无效';

  @override
  String get filterLengthInvalid => '长度参数无效';

  @override
  String get filterDataEmpty => '过滤数据不能为空';

  @override
  String get offset => '地址';

  @override
  String get length => '长度';

  @override
  String get data => '数据';

  @override
  String get bank => '存储区';

  @override
  String get enterHexData => '输入十六进制数据';

  @override
  String get password => '密码';

  @override
  String get enterPassword => '输入密码';

  @override
  String get ok => '确定';

  @override
  String get clear => '清空';

  @override
  String get single => '单次';

  @override
  String get start => '开始';

  @override
  String get stop => '停止';

  @override
  String get tagUnique => '标签去重';

  @override
  String get duration => '时长';

  @override
  String get seconds => '(秒)';

  @override
  String get time => '时间';

  @override
  String get tag => '标签';

  @override
  String get all => '总计';

  @override
  String get count => '计数';

  @override
  String get antenna => '天线';

  @override
  String get rssi => '信号';

  @override
  String get singleInventory => '单次盘点';

  @override
  String get startInventorySuccess => '开启盘点成功';

  @override
  String get inventoryNotRunning => '未盘点';

  @override
  String get inventoryIsRunning => '盘点正在运行';

  @override
  String get stopInventorySuccess => '停止盘点成功';

  @override
  String get stopInventoryFailed => '停止盘点失败';

  @override
  String get clearDataAlready => '数据已清空';

  @override
  String get write => '写入';

  @override
  String get read => '读取';

  @override
  String get word => '字';

  @override
  String get readDataSuccess => '✅ 读取数据成功';

  @override
  String get readDataFailed => '❌ 读取数据失败';

  @override
  String get writeDataSuccess => '✅ 写入数据成功';

  @override
  String get writeDataFailed => '❌ 写入数据失败';

  @override
  String get pleaseEnterData => '❌ 请先输入要写入的数据';

  @override
  String get lockAndUnlock => '锁定-解锁';

  @override
  String get accessPassword => '访问密码';

  @override
  String get cantUseDefaultPassword => '不能使用默认密码';

  @override
  String get lockMode => '锁定模式：';

  @override
  String get lock => '锁定';

  @override
  String get permanentLock => '永久锁定';

  @override
  String get unlock => '解锁';

  @override
  String get permanentUnlock => '永久解锁';

  @override
  String get banksToLock => '存储区：';

  @override
  String get lockTag => '锁定标签';

  @override
  String get killTag => '销毁标签';

  @override
  String get killPassword => '销毁密码';

  @override
  String get warningKillTag => '警告：此操作将永久销毁标签且无法撤销！';

  @override
  String get lockTagSuccess => '✅ 锁定标签成功';

  @override
  String get lockTagFailed => '❌ 锁定标签失败';

  @override
  String get lockTagFailedSelectBank => '❌ 锁定标签失败：请至少选择一个要锁定的存储区';

  @override
  String get lockTagFailedEnterPassword => '❌ 锁定标签失败：请输入访问密码';

  @override
  String get killTagSuccess => '✅ 销毁标签成功';

  @override
  String get killTagFailed => '❌ 销毁标签失败';

  @override
  String get killTagFailedEnterPassword => '❌ 销毁标签失败：请输入销毁密码';

  @override
  String get set => '设置';

  @override
  String get get => '获取';

  @override
  String get cancel => '取消';

  @override
  String get reset => '重置';

  @override
  String get failed => '失败';

  @override
  String get success => '成功';

  @override
  String get enable => '启用';

  @override
  String get disable => '禁用';

  @override
  String get basicFunctions => '基础功能';

  @override
  String get firmwareVer => '固件版本';

  @override
  String get hardwareVer => '硬件版本';

  @override
  String get temperature => '温度';

  @override
  String get resetModule => '重置模块';

  @override
  String get resetModuleTitle => '重置模块';

  @override
  String get resetModuleContent => '确定要重置所有设置吗？';

  @override
  String get frequency => '频率';

  @override
  String get selectFrequency => '选择频率';

  @override
  String get setFrequency => '设置频率';

  @override
  String get getFrequency => '获取频率';

  @override
  String get rfLink => 'RF链路';

  @override
  String get selectRfLink => '选择RF链路';

  @override
  String get setRfLink => '设置RF链路';

  @override
  String get getRfLink => '获取RF链路';

  @override
  String get power => '功率';

  @override
  String get powerLevel => '功率等级：';

  @override
  String get current => '当前';

  @override
  String get setPower => '设置功率';

  @override
  String get getPower => '获取功率';

  @override
  String get inventoryMode => '盘点模式';

  @override
  String get inventoryBank => '盘点存储区';

  @override
  String get offsetWord => '地址 (字)';

  @override
  String get lengthWord => '长度 (字)';

  @override
  String get gen2Parameters => 'Gen2参数';

  @override
  String get gen2 => 'Gen2';

  @override
  String get querySession => 'Session';

  @override
  String get queryTarget => 'Target';

  @override
  String get antennaState => '天线状态';

  @override
  String get powerDbm => '功率 (dBm)';

  @override
  String get setAntennaState => '设置天线状态';

  @override
  String get getAntennaState => '获取天线状态';

  @override
  String get fastId => 'FastID';

  @override
  String get tagFocus => 'TagFocus';

  @override
  String get fastInventory => 'FastInventory';

  @override
  String get resetUhf => '重置UHF';

  @override
  String get barcode => '扫码';

  @override
  String get decodeTimeout => '解码超时';

  @override
  String get decodeCancel => '解码取消';

  @override
  String get decodeFailure => '解码失败';

  @override
  String get decodeEngineError => '解码引擎错误';

  @override
  String get decodingFormat => '解码格式';

  @override
  String get serialNumber => '序列号';

  @override
  String get imei1 => 'IMEI 1';

  @override
  String get imei2 => 'IMEI 2';

  @override
  String get refresh => '刷新';

  @override
  String get retry => '重试';
}
