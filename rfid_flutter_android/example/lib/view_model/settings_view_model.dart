import 'package:rfid_flutter_android_example/view_model/rfid_main_view_model.dart';
import 'package:signals/signals.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:rfid_flutter_android/rfid_flutter_android.dart';
import '../entity/rfid_manager.dart';
import '../entity/app_global_state.dart';

class SettingsViewModel {
  final selectedFrequency = signal(RfidFrequency.usa);
  final selectedPower = signal(1);
  final selectedRfLink = signal(RfidRfLink.prAskMiller8_160KHz);

  final selectedInventoryBank = signal(RfidInventoryBank.epc);
  final selectedOffset = signal(0);
  final selectedLength = signal(6);

  final selectedQuerySession = signal(RfidGen2.querySessionS0);
  final selectedQueryTarget = signal(RfidGen2.queryTargetA);

  final selectedFastInventory = signal(RfidFastInventory.crClose);
  final selectedFastId = signal(false);
  final selectedTagFocus = signal(false);

  final antennaNumber = signal<int>(4);
  final antennaState1 = signal(RfidAntennaState(antenna: 1, enable: false, power: 1));
  final antennaState2 = signal(RfidAntennaState(antenna: 2, enable: false, power: 1));
  final antennaState3 = signal(RfidAntennaState(antenna: 3, enable: false, power: 1));
  final antennaState4 = signal(RfidAntennaState(antenna: 4, enable: false, power: 1));
  final antennaState5 = signal(RfidAntennaState(antenna: 5, enable: false, power: 1));
  final antennaState6 = signal(RfidAntennaState(antenna: 6, enable: false, power: 1));
  final antennaState7 = signal(RfidAntennaState(antenna: 7, enable: false, power: 1));
  final antennaState8 = signal(RfidAntennaState(antenna: 8, enable: false, power: 1));

  late EffectCleanup _pageIndexEffectCleanup;

  SettingsViewModel() {
    _pageIndexEffectCleanup = effect(() async {
      final currentPageIndex = RfidMainViewModel.instance.currentPageIndex.value;
      if (currentPageIndex == 1) {
        await getFrequency(showToast: false);
        if (appState.isHandset.value) {
          await getPower(showToast: false);
        } else {
          await getAntennaState(showToast: false);
        }
        await getRfLink(showToast: false);
        await getInventoryMode(showToast: false);
        await getGen2(showToast: false);
        await getFastInventory(showToast: false);
        await getFastId(showToast: false);
        await getTagFocus(showToast: false);
      }
    });
  }

  void dispose() {
    _pageIndexEffectCleanup();
  }

  void showResult(RfidResult<dynamic> res, {showData = false}) {
    if (res.result) {
      BotToast.showText(text: '✅ ${showData ? res.data : appState.localizations.success}');
    } else {
      BotToast.showText(text: '❌ ${appState.localizations.failed}:\n${res.error}');
    }
  }

  Future<void> getUhfFirmwareVersion() async {
    final result = await RfidManager.instance.getUhfFirmwareVersion();
    showResult(result, showData: true);
  }

  Future<void> getUhfHardwareVersion() async {
    final result = await RfidManager.instance.getUhfHardwareVersion();
    showResult(result, showData: true);
  }

  Future<void> getTemperature() async {
    final res = await RfidManager.instance.getUhfTemperature();
    if (res.result) {
      BotToast.showText(text: '✅ ${res.data} ℃');
    } else {
      BotToast.showText(text: '❌ ${appState.localizations.failed}:\n${res.error}');
    }
  }

  Future<void> resetModule() async {
    final result = await RfidManager.instance.resetUhf();
    showResult(result);
  }

  Future<void> getFrequency({bool showToast = true}) async {
    final res = await RfidManager.instance.getFrequency();
    if (res.result) {
      selectedFrequency.value = res.data ?? RfidFrequency.usa;
    }
    if (showToast) {
      showResult(res);
    }
  }

  Future<void> setFrequency() async {
    final result = await RfidManager.instance.setFrequency(selectedFrequency.value);
    showResult(result);
  }

  Future<void> getPower({bool showToast = true}) async {
    final res = await RfidWithUart.instance.getPower();
    if (res.result) {
      selectedPower.value = res.data ?? 1;
    }
    if (showToast) {
      showResult(res);
    }
  }

  Future<void> setPower() async {
    final result = await RfidWithUart.instance.setPower(selectedPower.value.round());
    showResult(result);
  }

  Future<void> getRfLink({bool showToast = true}) async {
    final res = await RfidManager.instance.getRfLink();
    if (res.result) {
      selectedRfLink.value = res.data!;
    }
    if (showToast) {
      showResult(res);
    }
  }

  Future<void> setRfLink() async {
    final result = await RfidManager.instance.setRfLink(selectedRfLink.value);
    showResult(result);
  }

  Future<void> setInventoryMode() async {
    final inventoryMode = RfidInventoryMode(
      inventoryBank: selectedInventoryBank.value,
      offset: selectedOffset.value,
      length: selectedLength.value,
    );
    final result = await RfidManager.instance.setInventoryMode(inventoryMode);
    showResult(result);
  }

  Future<void> getInventoryMode({bool showToast = true}) async {
    final res = await RfidManager.instance.getInventoryMode();
    if (res.result) {
      selectedInventoryBank.value = res.data!.inventoryBank;
      selectedOffset.value = res.data!.offset;
      selectedLength.value = res.data!.length;
    }
    if (showToast) {
      showResult(res);
    }
  }

  Future<void> setGen2() async {
    final gen2 = RfidGen2(
      querySession: selectedQuerySession.value,
      queryTarget: selectedQueryTarget.value,
    );
    final result = await RfidManager.instance.setGen2(gen2);
    showResult(result);
  }

  Future<void> getGen2({bool showToast = true}) async {
    final res = await RfidManager.instance.getGen2();
    if (res.result) {
      selectedQuerySession.value = res.data!.querySession ?? RfidGen2.querySessionS0;
      selectedQueryTarget.value = res.data!.queryTarget ?? RfidGen2.queryTargetA;
    }
    if (showToast) {
      showResult(res);
    }
  }

  Future<void> resetUhf() async {
    final result = await RfidManager.instance.resetUhf();
    showResult(result);
  }

  Future<void> setFastInventory() async {
    final result = await RfidManager.instance.setFastInventory(RfidFastInventory(cr: selectedFastInventory.value));
    showResult(result);
  }

  Future<void> getFastInventory({bool showToast = true}) async {
    final res = await RfidManager.instance.getFastInventory();
    if (res.result) {
      selectedFastInventory.value = res.data?.cr ?? RfidFastInventory.crClose;
    }
    if (showToast) {
      showResult(res);
    }
  }

  Future<void> setFastId() async {
    final result = await RfidManager.instance.setFastId(selectedFastId.value);
    showResult(result);
  }

  Future<void> getFastId({bool showToast = true}) async {
    final res = await RfidManager.instance.getFastId();
    if (res.result) {
      selectedFastId.value = res.data ?? false;
    }
    if (showToast) {
      showResult(res);
    }
  }

  Future<void> setTagFocus() async {
    final result = await RfidManager.instance.setTagFocus(selectedTagFocus.value);
    showResult(result);
  }

  Future<void> getTagFocus({bool showToast = true}) async {
    final res = await RfidManager.instance.getTagFocus();
    if (res.result) {
      selectedTagFocus.value = res.data ?? false;
    }
    if (showToast) {
      showResult(res);
    }
  }

  Future<void> getAntennaState({bool showToast = true}) async {
    final res = await RfidWithUra4.instance.getAntennaState(0); // 0表示获取所有天线状态
    if (res.result && res.data != null) {
      final antennaStates = res.data!;
      antennaNumber.value = antennaStates.length;
      for (var state in antennaStates) {
        switch (state.antenna) {
          case 1:
            antennaState1.value = RfidAntennaState(antenna: 1, enable: state.enable ?? false, power: state.power ?? 20);
            break;
          case 2:
            antennaState2.value = RfidAntennaState(antenna: 2, enable: state.enable ?? false, power: state.power ?? 20);
            break;
          case 3:
            antennaState3.value = RfidAntennaState(antenna: 3, enable: state.enable ?? false, power: state.power ?? 20);
            break;
          case 4:
            antennaState4.value = RfidAntennaState(antenna: 4, enable: state.enable ?? false, power: state.power ?? 20);
            break;
          case 5:
            antennaState5.value = RfidAntennaState(antenna: 5, enable: state.enable ?? false, power: state.power ?? 20);
            break;
          case 6:
            antennaState6.value = RfidAntennaState(antenna: 6, enable: state.enable ?? false, power: state.power ?? 20);
            break;
          case 7:
            antennaState7.value = RfidAntennaState(antenna: 7, enable: state.enable ?? false, power: state.power ?? 20);
            break;
          case 8:
            antennaState8.value = RfidAntennaState(antenna: 8, enable: state.enable ?? false, power: state.power ?? 20);
            break;
        }
      }
    }
    if (showToast) {
      showResult(res);
    }
  }

  Future<void> setAntennaState() async {
    final antennaStates = [
      antennaState1.value,
      antennaState2.value,
      antennaState3.value,
      antennaState4.value,
      antennaState5.value,
      antennaState6.value,
      antennaState7.value,
      antennaState8.value,
    ];
    final result = await RfidWithUra4.instance.setAntennaState(antennaStates);
    showResult(result);
  }
}
