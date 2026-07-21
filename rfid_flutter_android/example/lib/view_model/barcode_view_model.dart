import 'dart:async';
import 'dart:typed_data';
import 'package:charset_converter/charset_converter.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:rfid_flutter_android/rfid_flutter_android.dart';
import 'package:rfid_flutter_android_example/entity/app_global_state.dart';
import 'package:rfid_flutter_android_example/utils/audio_player_util.dart';

class BarcodeViewModel {
  final decodingFormat = signal('UTF-8');
  final barcodeList = signal<List<RfidBarcodeInfo>>([]);

  StreamSubscription<RfidBarcodeInfo>? _barcodeSubscription;
  VoidCallback? _scrollToBottomCallback;

  BarcodeViewModel() {
    _barcodeSubscription = BarcodeDecoder.instance.barcodeStream.listen((barcodeInfo) async {
      // print('BarcodeViewModel barcode: ${barcode.toString()}');

      // *** Decode Success ***
      if (barcodeInfo.resultCode == RfidBarcodeInfo.DECODE_SUCCESS) {
        // Decode barcode data
        String decodingFormatData = barcodeInfo.barcode;
        if (decodingFormat.value == 'UTF-8') {
          decodingFormatData = barcodeInfo.barcode;
        } else if (decodingFormat.value == 'GB18030') {
          decodingFormatData = await CharsetConverter.decode("GB18030", Uint8List.fromList(barcodeInfo.barcodeData));
        } else if (decodingFormat.value == 'ISO-8859-1') {
          decodingFormatData = await CharsetConverter.decode("ISO-8859-1", Uint8List.fromList(barcodeInfo.barcodeData));
        } else if (decodingFormat.value == 'SHIFT_JIS') {
          decodingFormatData = await CharsetConverter.decode("Shift_JIS", Uint8List.fromList(barcodeInfo.barcodeData));
        }
        // print('decodingFormatData: $decodingFormatData');
        barcodeInfo.extensions['decodingFormatData'] = decodingFormatData;
        // Add barcode info to list
        barcodeList.value = [...barcodeList.value, barcodeInfo];
        DeviceManager.instance.playSound(1);
        // Trigger scroll to bottom
        _scrollToBottomCallback?.call();
        return;
      }

      // *** Decode Failed ***
      if (barcodeInfo.resultCode == RfidBarcodeInfo.DECODE_TIMEOUT) {
        BotToast.showText(text: appState.localizations.decodeTimeout);
      } else if (barcodeInfo.resultCode == RfidBarcodeInfo.DECODE_CANCEL) {
        BotToast.showText(text: appState.localizations.decodeCancel);
      } else if (barcodeInfo.resultCode == RfidBarcodeInfo.DECODE_FAILURE) {
        BotToast.showText(text: appState.localizations.decodeFailure);
      } else if (barcodeInfo.resultCode == RfidBarcodeInfo.DECODE_ENGINE_ERROR) {
        BotToast.showText(text: appState.localizations.decodeEngineError);
      }
      DeviceManager.instance.playSound(2);
    });
  }

  void setScrollToBottomCallback(VoidCallback callback) {
    _scrollToBottomCallback = callback;
  }

  void init() async {
    final cancel = BotToast.showLoading(
      clickClose: false,
      allowClick: false,
      crossPage: false,
      backButtonBehavior: BackButtonBehavior.none,
    );

    final result = await BarcodeDecoder.instance.init();
    cancel();
    if (result.isEffective) {
      BotToast.showText(text: appState.localizations.initSuccess);
    } else {
      BotToast.showText(text: '${appState.localizations.initFailed}:\n${result.error}');
    }
  }

  void free() async {
    final result = await BarcodeDecoder.instance.free();
    if (result.isIneffective) {
      BotToast.showText(text: '${appState.localizations.freeFailed}:\n${result.error}');
    }

    _barcodeSubscription?.cancel();
  }

  void startScan() {
    BarcodeDecoder.instance.startScan().then((value) {
      if (value.isEffective) {
        BotToast.showText(text: appState.localizations.success);
      } else {
        BotToast.showText(text: '${value.error}');
      }
    });
  }

  void stopScan() {
    BarcodeDecoder.instance.stopScan().then((value) {
      if (value.isEffective) {
        BotToast.showText(text: appState.localizations.success);
      } else {
        BotToast.showText(text: '${value.error}');
      }
    });
  }

  void clear() {
    barcodeList.value = [];
  }
}
