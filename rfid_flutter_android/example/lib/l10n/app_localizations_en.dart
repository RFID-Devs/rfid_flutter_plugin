// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get deviceInfo => 'Device Info';

  @override
  String get rfidScanner => 'RFID Scanner';

  @override
  String get barcodeScanner => 'Barcode Scanner';

  @override
  String get deviceInfoSubtitle => 'SN, IMEI, ect';

  @override
  String get rfidScannerSubtitle => 'RFID tags scanning, parameter manager';

  @override
  String get barcodeScannerSubtitle => 'Scan barcodes, QR codes, etc';

  @override
  String get language => 'Language';

  @override
  String get inventory => 'Inventory';

  @override
  String get settings => 'Settings';

  @override
  String get readWrite => 'Read-Write';

  @override
  String get lockKill => 'Lock-Kill';

  @override
  String get initSuccess => '✅ Init Success';

  @override
  String get initFailed => '❌ Init Failed';

  @override
  String get freeSuccess => '✅ Free Success';

  @override
  String get freeFailed => '❌ Free Failed';

  @override
  String get filter => 'Filter';

  @override
  String get filterTitle => 'Tag Filter';

  @override
  String get filterNone => 'No filter';

  @override
  String get filterEmpty => 'No filter conditions';

  @override
  String get filterAdd => 'Add Filter';

  @override
  String get filterClear => 'Clear Filters';

  @override
  String filterCountFormat(int count) {
    return '$count tag filter(s)';
  }

  @override
  String get filterDialogTitle => 'Filter Condition';

  @override
  String filterItemFormat(String bank, int offset, int length, String data) {
    return '$bank · Offset $offset · Length $length · $data';
  }

  @override
  String get filterMaxCount => 'Maximum 8 filter conditions';

  @override
  String get filterOffsetInvalid => 'Invalid offset';

  @override
  String get filterLengthInvalid => 'Invalid length';

  @override
  String get filterDataEmpty => 'Filter data cannot be empty';

  @override
  String get offset => 'Offset';

  @override
  String get length => 'Length';

  @override
  String get data => 'Data';

  @override
  String get bank => 'Bank';

  @override
  String get enterHexData => 'Enter hex data';

  @override
  String get password => 'Password';

  @override
  String get enterPassword => 'Enter password';

  @override
  String get ok => 'OK';

  @override
  String get clear => 'Clear';

  @override
  String get single => 'Single';

  @override
  String get start => 'Start';

  @override
  String get stop => 'Stop';

  @override
  String get tagUnique => 'Unique';

  @override
  String get duration => 'Duration';

  @override
  String get inventoryDurationLabel => 'Duration';

  @override
  String inventoryConfigDurationFormat(String duration) {
    return 'Duration ${duration}s';
  }

  @override
  String get inventoryConfigSeparator => ' | ';

  @override
  String get seconds => '(s)';

  @override
  String get time => 'Time';

  @override
  String get tag => 'Tag';

  @override
  String get all => 'All';

  @override
  String get count => 'Count';

  @override
  String get antenna => 'Antenna';

  @override
  String get rssi => 'Rssi';

  @override
  String get singleInventory => 'Single Inventory';

  @override
  String get startInventorySuccess => 'Start Inventory Success';

  @override
  String get inventoryNotRunning => 'Inventory is not running';

  @override
  String get inventoryIsRunning => 'Inventory is running';

  @override
  String get stopInventorySuccess => 'Stop Inventory Success';

  @override
  String get stopInventoryFailed => 'Stop Inventory Failed';

  @override
  String get clearDataAlready => 'Clear Data Already';

  @override
  String get write => 'Write';

  @override
  String get read => 'Read';

  @override
  String get word => 'word';

  @override
  String get readDataSuccess => '✅ Read data successfully';

  @override
  String get readDataFailed => '❌ Read Data Failed';

  @override
  String get writeDataSuccess => '✅ Write data successfully';

  @override
  String get writeDataFailed => '❌ Write data failed';

  @override
  String get pleaseEnterData => '❌ Please enter data to write first';

  @override
  String get lockAndUnlock => 'Lock-Unlock';

  @override
  String get accessPassword => 'Access Password';

  @override
  String get cantUseDefaultPassword => 'Can\'t use default password';

  @override
  String get lockMode => 'Lock Mode:';

  @override
  String get lock => 'Lock';

  @override
  String get permanentLock => 'Permanent Lock';

  @override
  String get unlock => 'Unlock';

  @override
  String get permanentUnlock => 'Permanent Unlock';

  @override
  String get banksToLock => 'Banks to Lock:';

  @override
  String get lockTag => 'Lock Tag';

  @override
  String get killTag => 'Kill Tag';

  @override
  String get killPassword => 'Kill Password';

  @override
  String get warningKillTag =>
      'Warning: This operation permanently destroys the tag and cannot be undone!';

  @override
  String get lockTagSuccess => '✅ Lock tag successfully';

  @override
  String get lockTagFailed => '❌ Lock tag failed';

  @override
  String get lockTagFailedSelectBank =>
      '❌ Lock tag failed: Please select at least one bank to lock';

  @override
  String get lockTagFailedEnterPassword =>
      '❌ Lock tag failed: Please enter access password';

  @override
  String get killTagSuccess => '✅ Kill tag successfully';

  @override
  String get killTagFailed => '❌ Kill tag failed';

  @override
  String get killTagFailedEnterPassword =>
      '❌ Kill tag failed: Please enter kill password';

  @override
  String get set => 'Set';

  @override
  String get get => 'Get';

  @override
  String get cancel => 'Cancel';

  @override
  String get reset => 'Reset';

  @override
  String get failed => 'Failed';

  @override
  String get success => 'Success';

  @override
  String get enable => 'Enable';

  @override
  String get disable => 'Disable';

  @override
  String get basicFunctions => 'Basic Functions';

  @override
  String get firmwareVer => 'Firmware Ver';

  @override
  String get hardwareVer => 'Hardware Ver';

  @override
  String get temperature => 'Temperature';

  @override
  String get resetModule => 'Reset Module';

  @override
  String get resetModuleTitle => 'Reset Module';

  @override
  String get resetModuleContent =>
      'Are you sure you want to reset all settings?';

  @override
  String get frequency => 'Frequency';

  @override
  String get selectFrequency => 'Select Frequency';

  @override
  String get setFrequency => 'Set Frequency';

  @override
  String get getFrequency => 'Get Frequency';

  @override
  String get rfLink => 'RF Link';

  @override
  String get selectRfLink => 'Select RF Link';

  @override
  String get setRfLink => 'Set RF Link';

  @override
  String get getRfLink => 'Get RF Link';

  @override
  String get power => 'Power';

  @override
  String get powerLevel => 'Power Level';

  @override
  String get current => 'Current';

  @override
  String get setPower => 'Set Power';

  @override
  String get getPower => 'Get Power';

  @override
  String get inventoryMode => 'Inventory Mode';

  @override
  String get inventoryBank => 'Inventory Bank';

  @override
  String get offsetWord => 'Offset (word)';

  @override
  String get lengthWord => 'Length (word)';

  @override
  String get gen2Parameters => 'Gen2 Parameters';

  @override
  String get gen2 => 'Gen2';

  @override
  String get querySession => 'Session';

  @override
  String get queryTarget => 'Target';

  @override
  String get antennaState => 'Antenna State';

  @override
  String get powerDbm => 'Power (dBm)';

  @override
  String get setAntennaState => 'Set Antenna State';

  @override
  String get getAntennaState => 'Get Antenna State';

  @override
  String get fastId => 'FastID';

  @override
  String get tagFocus => 'TagFocus';

  @override
  String get fastInventory => 'FastInventory';

  @override
  String get resetUhf => 'Reset UHF';

  @override
  String get barcode => 'Barcode';

  @override
  String get decodeTimeout => 'Decode timeout';

  @override
  String get decodeCancel => 'Decode cancel';

  @override
  String get decodeFailure => 'Decode failure';

  @override
  String get decodeEngineError => 'Decode engine error';

  @override
  String get decodingFormat => 'Decoding Format';

  @override
  String get serialNumber => 'Serial Number';

  @override
  String get imei1 => 'IMEI 1';

  @override
  String get imei2 => 'IMEI 2';

  @override
  String get refresh => 'Refresh';

  @override
  String get retry => 'Retry';
}
