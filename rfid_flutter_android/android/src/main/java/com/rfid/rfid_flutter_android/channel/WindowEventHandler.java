package com.rfid.rfid_flutter_android.channel;

import android.os.Handler;
import android.os.Looper;
import android.view.KeyEvent;

import com.rfid.rfid_flutter_android.utils.WindowCallback;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.EventChannel;

public class WindowEventHandler extends WindowCallback implements EventChannel.StreamHandler {
    private static final String TAG = "WindowEventHandler";

    private EventChannel.EventSink eventSink;
    private final Handler handler = new Handler(Looper.getMainLooper());

    // Flutter KeyboardManager 在未处理按键时会 redispatch，同一 KeyEvent 可能再次进入 Window.Callback；
    // 用 eventTime + keyCode + action 去重，避免向 Flutter 重复上报。
    private long lastNotifiedEventTime = -1;
    private int lastNotifiedKeyCode = -1;
    private int lastNotifiedAction = -1;

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        this.eventSink = eventSink;

    }

    @Override
    public void onCancel(Object o) {
        this.eventSink = null;
        handler.removeCallbacksAndMessages(null);
    }


    @Override
    public boolean dispatchKeyEvent(KeyEvent event) {
//        Log.i(TAG, " ----------- dispatchKeyEvent: " + event);
        if (event.getKeyCode() != KeyEvent.KEYCODE_UNKNOWN) {
//            Log.i(TAG, " +++++++++++ dispatchKeyEvent: " + event);
            boolean isDuplicate = event.getEventTime() == lastNotifiedEventTime
                    && event.getKeyCode() == lastNotifiedKeyCode
                    && event.getAction() == lastNotifiedAction;
            if (!isDuplicate) {
                lastNotifiedEventTime = event.getEventTime();
                lastNotifiedKeyCode = event.getKeyCode();
                lastNotifiedAction = event.getAction();

                Map<String, Object> map = new HashMap<>();
                map.put("type", "KEY_EVENT");
                map.put("keyCode", event.getKeyCode());
                map.put("keyCodeName", KeyEvent.keyCodeToString(event.getKeyCode()));
                map.put("action", event.getAction());
                handler.post(() -> {
                    if (eventSink != null) {
                        eventSink.success(map);
                    }
                });
            }
        }
        return super.dispatchKeyEvent(event);
    }

}
