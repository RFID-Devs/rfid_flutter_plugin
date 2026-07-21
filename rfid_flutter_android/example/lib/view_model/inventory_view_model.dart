import 'dart:async';
import 'package:rfid_flutter_android_example/utils/device_util.dart';
import 'package:rfid_flutter_android_example/view_model/rfid_main_view_model.dart';
import 'package:signals/signals.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:rfid_flutter_android/rfid_flutter_android.dart';
import 'package:rfid_flutter_android_example/entity/app_global_state.dart';
import '../entity/rfid_manager.dart';

class InventoryViewModel {
  final filter = signal(RfidFilter(
    enabled: false,
    offset: 32,
    length: 96,
    bank: RfidBank.epc,
    data: '',
  ));
  final isInventoryRunning = signal(false);
  final tagCount = signal(0);
  final allCount = signal(0);
  final tagList = List<RfidTagInfo>.empty(growable: true);

  // RFID Tag Listener
  StreamSubscription<List<RfidTagInfo>>? _tagSubscription;
  StreamSubscription<RfidKeyEvent>? _keyDownSubscription;

  // Timestamp for updating the inventory data UI, used to control UI refresh rate.
  // It is not recommended to listen to tagList for UI updates, as tagList changes too frequently during inventory.
  // 更新盘点数据UI的时间戳，用于控制UI更新频率，不建议用监听tagList来更新UI，因为盘点时tagList更新频率太高
  final lastUpdateTimestamp = signal(0);
  Timer? _delayedUpdateTimer;

  final unique = signal(false);
  final duration = signal('');
  final inventoryTime = signal(0.0);
  Timer? _inventoryTimer;
  DateTime? _inventoryStartTime;
  Timer? _durationTimer;

  late EffectCleanup _pageIndexEffectCleanup;

  InventoryViewModel() {
    _tagSubscription = RfidManager.instance.rfidTagStream.listen(
      (tagInfos) {
        for (var tagInfo in tagInfos) {
          addTag(tagInfo);
        }
      },
      onError: (error) {
        BotToast.showText(text: 'Error: $error');
      },
    );

    _keyDownSubscription = DeviceManager.instance.keyDownEventStream.listen((event) {
      if (DeviceUtil.isScanKey(event) && RfidMainViewModel.instance.currentPageIndex.value == 0) {
        inventoryToggle();
      }
    });

    _pageIndexEffectCleanup = effect(() async {
      final currentPageIndex = RfidMainViewModel.instance.currentPageIndex.value;
      if (currentPageIndex != 0 && isInventoryRunning.value) {
        stopInventory();
      }
    });
  }

  void dispose() {
    _keyDownSubscription?.cancel();
    _tagSubscription?.cancel();
    _delayedUpdateTimer?.cancel();
    _inventoryTimer?.cancel();
    _durationTimer?.cancel();
    _pageIndexEffectCleanup();
  }

  void addTag(RfidTagInfo tagInfo) {
    final result = RfidTagUtil.getTagIndex(tagList, tagInfo);
    final index = result['index'];

    if (result['exist'] == true) {
      tagList[index].count += tagInfo.count;
      tagList[index].rssi = tagInfo.rssi;
      tagList[index].antenna = tagInfo.antenna; // Means only for URA4
    } else {
      tagList.insert(index, tagInfo);
      tagCount.value += tagInfo.count;
    }
    allCount.value += tagInfo.count;

    DeviceManager.instance.playSound(1);

    updateTagListUI();
  }

  // 单步盘点
  Future<void> singleInventory() async {
    final res = await RfidManager.instance.singleInventory(
      filter: filter.value,
    );

    if (res.result) {
      final tagInfo = res.data;
      if (tagInfo != null) {
        BotToast.showText(text: appState.localizations.success);
        addTag(tagInfo);
      }
    } else {
      BotToast.showText(text: res.error ?? appState.localizations.failed);
    }
  }

  Future<void> inventoryToggle() async {
    if (isInventoryRunning.value) {
      await stopInventory();
    } else {
      await startInventory();
    }
  }

  // 开启连续盘点
  Future<void> startInventory() async {
    if (isInventoryRunning.value) {
      BotToast.showText(text: appState.localizations.inventoryIsRunning);
      return;
    }

    final res = await RfidManager.instance.startInventory(
      filter: filter.value,
      inventoryParam: RfidInventoryParam(unique: unique.value),
    );

    if (res.isEffective) {
      isInventoryRunning.value = true;
      _startInventoryTimer();
      BotToast.showText(text: appState.localizations.startInventorySuccess);
    } else {
      BotToast.showText(text: res.error ?? appState.localizations.failed);
    }
  }

  // 停止连续盘点
  Future<void> stopInventory() async {
    if (!isInventoryRunning.value) {
      BotToast.showText(text: appState.localizations.inventoryNotRunning);
      return;
    }

    final res = await RfidManager.instance.stopInventory();

    if (res.isEffective) {
      isInventoryRunning.value = false;
      _stopInventoryTimer();
      BotToast.showText(text: appState.localizations.stopInventorySuccess);
    } else {
      BotToast.showText(text: res.error ?? appState.localizations.failed);
    }
  }

  // 清空计数和标签信息
  void clearData() {
    tagList.clear();
    tagCount.value = 0;
    allCount.value = 0;
    inventoryTime.value = 0.0;
    lastUpdateTimestamp.value = DateTime.now().millisecondsSinceEpoch;
    BotToast.showText(text: appState.localizations.clearDataAlready);
  }

  void _startInventoryTimer() {
    inventoryTime.value = 0.0;
    _inventoryStartTime = DateTime.now();

    _inventoryTimer?.cancel();
    _inventoryTimer = Timer.periodic(const Duration(milliseconds: 90), (timer) {
      if (_inventoryStartTime != null) {
        final elapsed = DateTime.now().difference(_inventoryStartTime!);
        inventoryTime.value = elapsed.inMilliseconds / 1000.0;
      }
    });

    // Start duration timer for auto-stop
    _startDurationTimer();
  }

  void _stopInventoryTimer() {
    _inventoryTimer?.cancel();
    _inventoryTimer = null;
    _inventoryStartTime = null;
    _durationTimer?.cancel();
    _durationTimer = null;
  }

  void _startDurationTimer() {
    _durationTimer?.cancel();
    int durationTime = int.tryParse(duration.value) ?? 999999;
    _durationTimer = Timer(Duration(seconds: durationTime), () {
      if (isInventoryRunning.value) {
        _inventoryTimer?.cancel();
        _durationTimer?.cancel();
        stopInventory();
      }
    });
  }

  void updateTagListUI() {
    final now = DateTime.now().millisecondsSinceEpoch;
    // 200 millisecond interval limit
    if (now - lastUpdateTimestamp.value > 200) {
      lastUpdateTimestamp.value = now;
    } else {
      // Cancel the previous delayed update
      _delayedUpdateTimer?.cancel();
      // Set a 400ms delayed update to ensure the last data is displayed
      _delayedUpdateTimer = Timer(const Duration(milliseconds: 400), () {
        lastUpdateTimestamp.value = DateTime.now().millisecondsSinceEpoch;
      });
    }
  }
}
