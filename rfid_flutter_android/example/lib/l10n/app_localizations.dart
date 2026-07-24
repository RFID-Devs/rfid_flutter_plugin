import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// No description provided for @deviceInfo.
  ///
  /// In en, this message translates to:
  /// **'Device Info'**
  String get deviceInfo;

  /// No description provided for @rfidScanner.
  ///
  /// In en, this message translates to:
  /// **'RFID Scanner'**
  String get rfidScanner;

  /// No description provided for @barcodeScanner.
  ///
  /// In en, this message translates to:
  /// **'Barcode Scanner'**
  String get barcodeScanner;

  /// No description provided for @deviceInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'SN, IMEI, ect'**
  String get deviceInfoSubtitle;

  /// No description provided for @rfidScannerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'RFID tags scanning, parameter manager'**
  String get rfidScannerSubtitle;

  /// No description provided for @barcodeScannerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scan barcodes, QR codes, etc'**
  String get barcodeScannerSubtitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @inventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventory;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @readWrite.
  ///
  /// In en, this message translates to:
  /// **'Read-Write'**
  String get readWrite;

  /// No description provided for @lockKill.
  ///
  /// In en, this message translates to:
  /// **'Lock-Kill'**
  String get lockKill;

  /// No description provided for @initSuccess.
  ///
  /// In en, this message translates to:
  /// **'✅ Init Success'**
  String get initSuccess;

  /// No description provided for @initFailed.
  ///
  /// In en, this message translates to:
  /// **'❌ Init Failed'**
  String get initFailed;

  /// No description provided for @freeSuccess.
  ///
  /// In en, this message translates to:
  /// **'✅ Free Success'**
  String get freeSuccess;

  /// No description provided for @freeFailed.
  ///
  /// In en, this message translates to:
  /// **'❌ Free Failed'**
  String get freeFailed;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @filterTitle.
  ///
  /// In en, this message translates to:
  /// **'Tag Filter'**
  String get filterTitle;

  /// No description provided for @filterNone.
  ///
  /// In en, this message translates to:
  /// **'No filter'**
  String get filterNone;

  /// No description provided for @filterEmpty.
  ///
  /// In en, this message translates to:
  /// **'No filter conditions'**
  String get filterEmpty;

  /// No description provided for @filterAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Filter'**
  String get filterAdd;

  /// No description provided for @filterClear.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get filterClear;

  /// No description provided for @filterCountFormat.
  ///
  /// In en, this message translates to:
  /// **'{count} tag filter(s)'**
  String filterCountFormat(int count);

  /// No description provided for @filterDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter Condition'**
  String get filterDialogTitle;

  /// No description provided for @filterItemFormat.
  ///
  /// In en, this message translates to:
  /// **'{bank} · Offset {offset} · Length {length} · {data}'**
  String filterItemFormat(String bank, int offset, int length, String data);

  /// No description provided for @filterMaxCount.
  ///
  /// In en, this message translates to:
  /// **'Maximum 8 filter conditions'**
  String get filterMaxCount;

  /// No description provided for @filterOffsetInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid offset'**
  String get filterOffsetInvalid;

  /// No description provided for @filterLengthInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid length'**
  String get filterLengthInvalid;

  /// No description provided for @filterDataEmpty.
  ///
  /// In en, this message translates to:
  /// **'Filter data cannot be empty'**
  String get filterDataEmpty;

  /// No description provided for @offset.
  ///
  /// In en, this message translates to:
  /// **'Offset'**
  String get offset;

  /// No description provided for @length.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get length;

  /// No description provided for @data.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get data;

  /// No description provided for @bank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get bank;

  /// No description provided for @enterHexData.
  ///
  /// In en, this message translates to:
  /// **'Enter hex data'**
  String get enterHexData;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get enterPassword;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @single.
  ///
  /// In en, this message translates to:
  /// **'Single'**
  String get single;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @tagUnique.
  ///
  /// In en, this message translates to:
  /// **'Unique'**
  String get tagUnique;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'(s)'**
  String get seconds;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @tag.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get tag;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @count.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get count;

  /// No description provided for @antenna.
  ///
  /// In en, this message translates to:
  /// **'Antenna'**
  String get antenna;

  /// No description provided for @rssi.
  ///
  /// In en, this message translates to:
  /// **'Rssi'**
  String get rssi;

  /// No description provided for @singleInventory.
  ///
  /// In en, this message translates to:
  /// **'Single Inventory'**
  String get singleInventory;

  /// No description provided for @startInventorySuccess.
  ///
  /// In en, this message translates to:
  /// **'Start Inventory Success'**
  String get startInventorySuccess;

  /// No description provided for @inventoryNotRunning.
  ///
  /// In en, this message translates to:
  /// **'Inventory is not running'**
  String get inventoryNotRunning;

  /// No description provided for @inventoryIsRunning.
  ///
  /// In en, this message translates to:
  /// **'Inventory is running'**
  String get inventoryIsRunning;

  /// No description provided for @stopInventorySuccess.
  ///
  /// In en, this message translates to:
  /// **'Stop Inventory Success'**
  String get stopInventorySuccess;

  /// No description provided for @stopInventoryFailed.
  ///
  /// In en, this message translates to:
  /// **'Stop Inventory Failed'**
  String get stopInventoryFailed;

  /// No description provided for @clearDataAlready.
  ///
  /// In en, this message translates to:
  /// **'Clear Data Already'**
  String get clearDataAlready;

  /// No description provided for @write.
  ///
  /// In en, this message translates to:
  /// **'Write'**
  String get write;

  /// No description provided for @read.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get read;

  /// No description provided for @word.
  ///
  /// In en, this message translates to:
  /// **'word'**
  String get word;

  /// No description provided for @readDataSuccess.
  ///
  /// In en, this message translates to:
  /// **'✅ Read data successfully'**
  String get readDataSuccess;

  /// No description provided for @readDataFailed.
  ///
  /// In en, this message translates to:
  /// **'❌ Read Data Failed'**
  String get readDataFailed;

  /// No description provided for @writeDataSuccess.
  ///
  /// In en, this message translates to:
  /// **'✅ Write data successfully'**
  String get writeDataSuccess;

  /// No description provided for @writeDataFailed.
  ///
  /// In en, this message translates to:
  /// **'❌ Write data failed'**
  String get writeDataFailed;

  /// No description provided for @pleaseEnterData.
  ///
  /// In en, this message translates to:
  /// **'❌ Please enter data to write first'**
  String get pleaseEnterData;

  /// No description provided for @lockAndUnlock.
  ///
  /// In en, this message translates to:
  /// **'Lock-Unlock'**
  String get lockAndUnlock;

  /// No description provided for @accessPassword.
  ///
  /// In en, this message translates to:
  /// **'Access Password'**
  String get accessPassword;

  /// No description provided for @cantUseDefaultPassword.
  ///
  /// In en, this message translates to:
  /// **'Can\'t use default password'**
  String get cantUseDefaultPassword;

  /// No description provided for @lockMode.
  ///
  /// In en, this message translates to:
  /// **'Lock Mode:'**
  String get lockMode;

  /// No description provided for @lock.
  ///
  /// In en, this message translates to:
  /// **'Lock'**
  String get lock;

  /// No description provided for @permanentLock.
  ///
  /// In en, this message translates to:
  /// **'Permanent Lock'**
  String get permanentLock;

  /// No description provided for @unlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// No description provided for @permanentUnlock.
  ///
  /// In en, this message translates to:
  /// **'Permanent Unlock'**
  String get permanentUnlock;

  /// No description provided for @banksToLock.
  ///
  /// In en, this message translates to:
  /// **'Banks to Lock:'**
  String get banksToLock;

  /// No description provided for @lockTag.
  ///
  /// In en, this message translates to:
  /// **'Lock Tag'**
  String get lockTag;

  /// No description provided for @killTag.
  ///
  /// In en, this message translates to:
  /// **'Kill Tag'**
  String get killTag;

  /// No description provided for @killPassword.
  ///
  /// In en, this message translates to:
  /// **'Kill Password'**
  String get killPassword;

  /// No description provided for @warningKillTag.
  ///
  /// In en, this message translates to:
  /// **'Warning: This operation permanently destroys the tag and cannot be undone!'**
  String get warningKillTag;

  /// No description provided for @lockTagSuccess.
  ///
  /// In en, this message translates to:
  /// **'✅ Lock tag successfully'**
  String get lockTagSuccess;

  /// No description provided for @lockTagFailed.
  ///
  /// In en, this message translates to:
  /// **'❌ Lock tag failed'**
  String get lockTagFailed;

  /// No description provided for @lockTagFailedSelectBank.
  ///
  /// In en, this message translates to:
  /// **'❌ Lock tag failed: Please select at least one bank to lock'**
  String get lockTagFailedSelectBank;

  /// No description provided for @lockTagFailedEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'❌ Lock tag failed: Please enter access password'**
  String get lockTagFailedEnterPassword;

  /// No description provided for @killTagSuccess.
  ///
  /// In en, this message translates to:
  /// **'✅ Kill tag successfully'**
  String get killTagSuccess;

  /// No description provided for @killTagFailed.
  ///
  /// In en, this message translates to:
  /// **'❌ Kill tag failed'**
  String get killTagFailed;

  /// No description provided for @killTagFailedEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'❌ Kill tag failed: Please enter kill password'**
  String get killTagFailedEnterPassword;

  /// No description provided for @set.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get set;

  /// No description provided for @get.
  ///
  /// In en, this message translates to:
  /// **'Get'**
  String get get;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @enable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// No description provided for @disable.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get disable;

  /// No description provided for @basicFunctions.
  ///
  /// In en, this message translates to:
  /// **'Basic Functions'**
  String get basicFunctions;

  /// No description provided for @firmwareVer.
  ///
  /// In en, this message translates to:
  /// **'Firmware Ver'**
  String get firmwareVer;

  /// No description provided for @hardwareVer.
  ///
  /// In en, this message translates to:
  /// **'Hardware Ver'**
  String get hardwareVer;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @resetModule.
  ///
  /// In en, this message translates to:
  /// **'Reset Module'**
  String get resetModule;

  /// No description provided for @resetModuleTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Module'**
  String get resetModuleTitle;

  /// No description provided for @resetModuleContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset all settings?'**
  String get resetModuleContent;

  /// No description provided for @frequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequency;

  /// No description provided for @selectFrequency.
  ///
  /// In en, this message translates to:
  /// **'Select Frequency'**
  String get selectFrequency;

  /// No description provided for @setFrequency.
  ///
  /// In en, this message translates to:
  /// **'Set Frequency'**
  String get setFrequency;

  /// No description provided for @getFrequency.
  ///
  /// In en, this message translates to:
  /// **'Get Frequency'**
  String get getFrequency;

  /// No description provided for @rfLink.
  ///
  /// In en, this message translates to:
  /// **'RF Link'**
  String get rfLink;

  /// No description provided for @selectRfLink.
  ///
  /// In en, this message translates to:
  /// **'Select RF Link'**
  String get selectRfLink;

  /// No description provided for @setRfLink.
  ///
  /// In en, this message translates to:
  /// **'Set RF Link'**
  String get setRfLink;

  /// No description provided for @getRfLink.
  ///
  /// In en, this message translates to:
  /// **'Get RF Link'**
  String get getRfLink;

  /// No description provided for @power.
  ///
  /// In en, this message translates to:
  /// **'Power'**
  String get power;

  /// No description provided for @powerLevel.
  ///
  /// In en, this message translates to:
  /// **'Power Level'**
  String get powerLevel;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// No description provided for @setPower.
  ///
  /// In en, this message translates to:
  /// **'Set Power'**
  String get setPower;

  /// No description provided for @getPower.
  ///
  /// In en, this message translates to:
  /// **'Get Power'**
  String get getPower;

  /// No description provided for @inventoryMode.
  ///
  /// In en, this message translates to:
  /// **'Inventory Mode'**
  String get inventoryMode;

  /// No description provided for @inventoryBank.
  ///
  /// In en, this message translates to:
  /// **'Inventory Bank'**
  String get inventoryBank;

  /// No description provided for @offsetWord.
  ///
  /// In en, this message translates to:
  /// **'Offset (word)'**
  String get offsetWord;

  /// No description provided for @lengthWord.
  ///
  /// In en, this message translates to:
  /// **'Length (word)'**
  String get lengthWord;

  /// No description provided for @gen2Parameters.
  ///
  /// In en, this message translates to:
  /// **'Gen2 Parameters'**
  String get gen2Parameters;

  /// No description provided for @gen2.
  ///
  /// In en, this message translates to:
  /// **'Gen2'**
  String get gen2;

  /// No description provided for @querySession.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get querySession;

  /// No description provided for @queryTarget.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get queryTarget;

  /// No description provided for @antennaState.
  ///
  /// In en, this message translates to:
  /// **'Antenna State'**
  String get antennaState;

  /// No description provided for @powerDbm.
  ///
  /// In en, this message translates to:
  /// **'Power (dBm)'**
  String get powerDbm;

  /// No description provided for @setAntennaState.
  ///
  /// In en, this message translates to:
  /// **'Set Antenna State'**
  String get setAntennaState;

  /// No description provided for @getAntennaState.
  ///
  /// In en, this message translates to:
  /// **'Get Antenna State'**
  String get getAntennaState;

  /// No description provided for @fastId.
  ///
  /// In en, this message translates to:
  /// **'FastID'**
  String get fastId;

  /// No description provided for @tagFocus.
  ///
  /// In en, this message translates to:
  /// **'TagFocus'**
  String get tagFocus;

  /// No description provided for @fastInventory.
  ///
  /// In en, this message translates to:
  /// **'FastInventory'**
  String get fastInventory;

  /// No description provided for @resetUhf.
  ///
  /// In en, this message translates to:
  /// **'Reset UHF'**
  String get resetUhf;

  /// No description provided for @barcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get barcode;

  /// No description provided for @decodeTimeout.
  ///
  /// In en, this message translates to:
  /// **'Decode timeout'**
  String get decodeTimeout;

  /// No description provided for @decodeCancel.
  ///
  /// In en, this message translates to:
  /// **'Decode cancel'**
  String get decodeCancel;

  /// No description provided for @decodeFailure.
  ///
  /// In en, this message translates to:
  /// **'Decode failure'**
  String get decodeFailure;

  /// No description provided for @decodeEngineError.
  ///
  /// In en, this message translates to:
  /// **'Decode engine error'**
  String get decodeEngineError;

  /// No description provided for @decodingFormat.
  ///
  /// In en, this message translates to:
  /// **'Decoding Format'**
  String get decodingFormat;

  /// No description provided for @serialNumber.
  ///
  /// In en, this message translates to:
  /// **'Serial Number'**
  String get serialNumber;

  /// No description provided for @imei1.
  ///
  /// In en, this message translates to:
  /// **'IMEI 1'**
  String get imei1;

  /// No description provided for @imei2.
  ///
  /// In en, this message translates to:
  /// **'IMEI 2'**
  String get imei2;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
