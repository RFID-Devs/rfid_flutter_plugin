import 'package:signals/signals.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:rfid_flutter_android/rfid_flutter_android.dart';
import '../entity/rfid_manager.dart';

class ReadWriteViewModel {
  final filter = signal(RfidFilter(
    enabled: false,
    offset: 32,
    length: 96,
    bank: RfidBank.epc,
    data: '',
  ));
  final offset = signal(2);
  final length = signal(6);
  final bank = signal(RfidBank.epc);
  final password = signal('00000000');
  final data = signal('');

  Future<void> readData() async {
    final res = await RfidManager.instance.readData(
      filter: filter.value,
      bank: bank.value,
      offset: offset.value,
      length: length.value,
      password: password.value,
    );

    if (res.result) {
      final readData = res.data ?? '';
      data.value = readData;
      BotToast.showText(text: '✅ Read data successfully:\n$readData');
    } else {
      BotToast.showText(text: '❌ Read Data Failed: ${res.error}');
    }
  }

  Future<void> writeData() async {
    if (data.value.isEmpty) {
      BotToast.showText(text: '❌ Please enter data to write first');
      return;
    }

    final result = await RfidManager.instance.writeData(
      filter: filter.value,
      bank: bank.value,
      offset: offset.value,
      length: length.value,
      password: password.value,
      data: data.value,
    );

    if (result.isEffective) {
      BotToast.showText(text: '✅ Write data successfully');
    } else {
      BotToast.showText(text: '❌ Write data failed${result.error == null ? '' : ': ${result.error}'}');
    }
  }

  void dispose() {
    // signals will be automatically disposed when no longer watched
  }
}
