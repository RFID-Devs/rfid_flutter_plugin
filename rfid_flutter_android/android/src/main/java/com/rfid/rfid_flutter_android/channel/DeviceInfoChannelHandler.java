package com.rfid.rfid_flutter_android.channel;

import android.Manifest;
import android.annotation.SuppressLint;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;

import com.rfid.rfid_flutter_android.utils.DeviceUtil;
import com.rscja.CWDeviceInfo;
import com.rscja.team.qcom.utility.LogUtility_qcom;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ExecutorService;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class DeviceInfoChannelHandler implements MethodChannel.MethodCallHandler {
    private static final String TAG = "DeviceInfo";

    private final Context context;
    private final ExecutorService executor;

    public DeviceInfoChannelHandler(Context context, ExecutorService executor) {
        this.context = context;
        this.executor = executor;
    }

    // 方法处理器映射表
    private final Map<String, MethodHandler> methodHandlers = new HashMap<String, MethodHandler>() {
        {
            put("getSerialNumber", DeviceInfoChannelHandler.this::getSerialNumber);
            put("getImei", DeviceInfoChannelHandler.this::getImei);
            put("isHandset", DeviceInfoChannelHandler.this::isHandset);
            put("setDebug", DeviceInfoChannelHandler.this::setDebug);
            put("setWriteLog", DeviceInfoChannelHandler.this::setWriteLog);

        }
    };

    @Override
    public void onMethodCall(@NonNull MethodCall methodCall, @NonNull MethodChannel.Result result) {
        executor.execute(() -> {
            try {
                LogUtility_qcom.myLogInfo(TAG, "Method: " + methodCall.method + " with args: " + methodCall.arguments);

                MethodHandler handler = methodHandlers.get(methodCall.method);
                if (handler != null) {
                    handler.handle(methodCall, result);
                } else {
                    result.notImplemented();
                }
            } catch (Exception e) {
                // handler.post(() -> result.error(TAG, "Error: " + e.getMessage(), null));
                result.error(TAG, "Error: " + e.getMessage(), null);
                e.printStackTrace();
            }
        });
    }

    private void getSerialNumber(MethodCall methodCall, MethodChannel.Result result) {
        result.success(DeviceUtil.getSerialNum(context));
    }

    private void getImei(MethodCall methodCall, MethodChannel.Result result) {
        String[] imei2 = new String[1];
        String imei1 = DeviceUtil.getImei(context, imei2);
        Map<String, String> map = new HashMap<>();
        map.put("imei1", imei1);
        map.put("imei2", imei2[0]);
        result.success(map);
    }

    // 判断是否是手持机
    // 不是A4就是手持机
    private void isHandset(MethodCall methodCall, MethodChannel.Result result) {
        result.success(!CWDeviceInfo.getDeviceInfo().getModelAndCpu().contains("A4") && !CWDeviceInfo.getDeviceInfo().getModelAndCpu().contains("A8"));
    }

    private void setDebug(MethodCall methodCall, MethodChannel.Result result) {
        boolean value = Boolean.TRUE.equals(methodCall.argument("value"));
        LogUtility_qcom.setDebug(value);
        result.success(true);
    }

    private void setWriteLog(MethodCall methodCall, MethodChannel.Result result) {
        boolean value = Boolean.TRUE.equals(methodCall.argument("value"));

        // 开启日志写入，需要检查权限
        if (value && !hasWriteExternalStoragePermission()) {
            result.error("PERMISSION_DENIED", "Storage permission required", null);
            return;
        }

        LogUtility_qcom.setWriteLog(value);
        result.success(true);
    }

    /**
     * 检查是否有外部存储写入权限
     * LogUtility_qcom会将日志保存在根目录/DeviceAPI_Log.txt，需要存储权限
     */
    @SuppressLint("ObsoleteSdkInt")
    private boolean hasWriteExternalStoragePermission() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            return true;
        }
        return ContextCompat.checkSelfPermission(context, Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED;
    }

}
