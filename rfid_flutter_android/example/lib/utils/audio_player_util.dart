import 'package:rfid_flutter_android/rfid_flutter_android.dart';
import 'package:rfid_flutter_android_example/entity/app_global_state.dart';

class AudioPlayerUtil {
  static Future<void> playSuccess() async {
    if (appState.isHandset.value) {
      DeviceManager.instance.playSound(1);
    } else {
      RfidWithUra4.instance.triggerBeep();
    }
  }

  static Future<void> playFailure() async {
    if (appState.isHandset.value) {
      DeviceManager.instance.playSound(2);
    }
  }
}
