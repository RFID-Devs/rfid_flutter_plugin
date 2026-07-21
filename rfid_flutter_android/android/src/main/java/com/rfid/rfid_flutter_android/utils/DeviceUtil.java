package com.rfid.rfid_flutter_android.utils;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.SharedPreferences;
import android.provider.Settings;
import android.telephony.TelephonyManager;
import android.text.TextUtils;

import com.rscja.CWDeviceInfo;
import com.rscja.team.qcom.DeviceConfiguration_qcom;
import com.rscja.team.qcom.utility.LogUtility_qcom;

import java.lang.reflect.Method;
import java.net.NetworkInterface;
import java.util.Collections;
import java.util.List;


public class DeviceUtil {
    private static final String TAG = "DeviceUtil";

    @SuppressLint("HardwareIds")
    public static String getImei(Context context, String[] imei2) {
        LogUtility_qcom.myLogV(TAG, "getImei " + CWDeviceInfo.getDeviceInfo().getModel() + " " + DeviceConfiguration_qcom.getModel());
        if (DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.C60_QCM2150_100)) {
            return getImeiC60(imei2);
        } else if (CWDeviceInfo.getDeviceInfo().getTeam() == CWDeviceInfo.TEAM_QCOM) {
            String imei1 = getImeiC60_smd450(context, imei2);
            if (!TextUtils.isEmpty(imei1) || !TextUtils.isEmpty(imei2[0])) {
                return imei1;
            }
        } else if (CWDeviceInfo.getDeviceInfo().getTeam() == CWDeviceInfo.TEAM_MTK) {
            String imei1 = getImei_mtk(context, imei2);
            if (!TextUtils.isEmpty(imei1) || !TextUtils.isEmpty(imei2[0])) {
                return imei1;
            }
        }

        LogUtility_qcom.myLogV(TAG, "getImei by other way");

        try {
            TelephonyManager manager = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
            Class<?> clazz = manager.getClass();
            Method getImei = clazz.getDeclaredMethod("getImei", int.class);//(int slotId)
            //获得IMEI 1的信息：
            Object imei_1 = getImei.invoke(manager, 0);
            //获得IMEI 2的信息：
            Object imei_2 = getImei.invoke(manager, 1);

            if (imei_1 != null && imei_2 != null) {
                if (imei2 != null && imei2.length > 0) {
                    imei2[0] = imei_2.toString();
                }
                return imei_1.toString();
            } else if (imei_1 != null) {
                return imei_1.toString();
            } else if (imei_2 != null) {
                return imei_2.toString();
            } else {
                return null;
            }
        } catch (Exception ignored) {
        }
        return null;
    }

    private static String getImei_mtk(Context context, String[] imei2) {
        String imei1 = Settings.Global.getString(context.getContentResolver(), "Imei1");
        String imei_2 = Settings.Global.getString(context.getContentResolver(), "Imei2");
        if (!TextUtils.isEmpty(imei1)) {
            if (!TextUtils.isEmpty(imei_2)) {
                imei2[0] = imei_2;
            }
        }
        return imei1;
    }

    private static String getImeiC60_smd450(Context context, String[] imei2) {
        String imei1 = Settings.System.getString(context.getContentResolver(), "cw_imei_one");
        String strIMEI2 = Settings.System.getString(context.getContentResolver(), "cw_imei_two");
        if (strIMEI2 != null && imei2 != null && imei2.length > 0) {
            imei2[0] = strIMEI2;
        }
        LogUtility_qcom.myLogV(TAG, "getImeiC60_smd450 imei1=" + imei1 + " imei2=" + (imei2 == null ? "null" : imei2[0]));
        return imei1;
    }

    private static String getImeiC60(String[] imei2) {
        String imei1 = getSystemProperties("persist.quectel.imei1");
        String strIMEI2 = getSystemProperties("persist.quectel.imei2");
        if (strIMEI2 != null && imei2 != null && imei2.length > 0) {
            imei2[0] = strIMEI2;
        }
        return imei1;
    }

    @SuppressLint("PrivateApi")
    public static String getSystemProperties(String properties) {
        String strState = "";
        try {
            Class<?> systemProperties = Class.forName("android.os.SystemProperties");
            Method get = systemProperties.getDeclaredMethod("get", String.class);
            strState = (String) get.invoke(null, properties);
        } catch (Exception e) {
            e.printStackTrace();
        }
        LogUtility_qcom.myLogV(TAG, "getSystemProperties " + properties + " = " + strState);
        return strState;
    }


    /**
     * 获取设备序列号
     */
    @SuppressLint("HardwareIds")
    public static String getSerialNum(Context context) {
        String sn = "";
        try {
            if (DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.P80_8953_90)
                    || CWDeviceInfo.getDeviceInfo().getModelAndCpu().equals(CWDeviceInfo.CW125_6225_160)
            ) {
                sn = getSystemProperties("persist.radio.sn");
            } else if (CWDeviceInfo.getDeviceInfo().getModelAndCpu().equals(CWDeviceInfo.MC51_4350_140)
                    || CWDeviceInfo.getDeviceInfo().getModelAndCpu().equals(CWDeviceInfo.URA4_SM6115_130)
            ) {
                sn = getSystemProperties("persist.sys.quectel.sn");
            } else if (DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.C60_SMD450_100)) {
                sn = Settings.System.getString(context.getContentResolver(), "cw_sn_num");
            } else if (DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.C60_MTK_6765_110)
                    || DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.P80_8786_130)
            ) {
                sn = getSystemProperties("vendor.gsm.serial");
                int spaceIndex = sn.indexOf(" ");
                if (spaceIndex > 0) {
                    sn = sn.substring(0, spaceIndex);
                }
            } else if (CWDeviceInfo.getDeviceInfo().getTeam() == CWDeviceInfo.TEAM_QCOM) {
                sn = getSystemProperties("persist.quectel.sn");
            } else if (CWDeviceInfo.getDeviceInfo().getTeam() == CWDeviceInfo.TEAM_MTK) {
                sn = Settings.Global.getString(context.getContentResolver(), "Serial");
            }

            if (!TextUtils.isEmpty(sn)) {
                return sn;
            }
            return android.os.Build.SERIAL;
        } catch (Exception e) {
            LogUtility_qcom.myLogV(TAG, "getSerialNum error:" + e);
        }
        return "";
    }


    public static String getBluetoothAddress(Context context) {
        if (CWDeviceInfo.getDeviceInfo().getTeam() == CWDeviceInfo.TEAM_MTK) {
            String btMac = Settings.Global.getString(context.getContentResolver(), "BtMac");
            if (!TextUtils.isEmpty(btMac)) {
                LogUtility_qcom.myLogV(TAG, "MTK btMac=" + btMac);
                return btMac;
            }
        } else {
            String data = Settings.System.getString(context.getContentResolver(), "cw_bt_address");
            LogUtility_qcom.myLogV(TAG, "getBluetoothAddress cw_bt_address=" + data);
            if (!TextUtils.isEmpty(data)) {
                return data;
            }
        }

        return "";
    }


    @SuppressLint("MissingPermission")
    public static String getWifiMac(Context context) {
        if (CWDeviceInfo.getDeviceInfo().getTeam() == CWDeviceInfo.TEAM_QCOM) {
            String mac = Settings.System.getString(context.getContentResolver(), "cw_wifi_mac");
            String mac2 = getSharedPreferences(context, "cw_wifi_mac");
            LogUtility_qcom.myLogV(TAG, "getWifiMac mac=" + mac + "  mac2=" + mac2);

            if (TextUtils.isEmpty(mac)) {
                if (DeviceConfiguration_qcom.getModel().equals(DeviceConfiguration_qcom.P80_8953_90)) {
                    mac = getLocalMacAddress6Above();
                }
            }
            LogUtility_qcom.myLogV(TAG, "Wifi mac=" + mac);
            //校验是否是我们自己写的地址
            if (!TextUtils.isEmpty(mac)) {
                if (mac.toLowerCase().startsWith("cc") || mac.toLowerCase().startsWith("6c:15:24")) {
                    //系统每次开机都会清除   AppConfig.getAppConfig(getApplicationContext()).setSharedPreferences("cw_wifi_mac",mac); 所以，appcenter把这个值记录一下
                    setSharedPreferences(context, "cw_wifi_mac", mac);
                    return mac;
                }
                return mac;
            }
            if (!TextUtils.isEmpty(mac2)) {
                return mac2;
            }
        } else if (CWDeviceInfo.getDeviceInfo().getTeam() == CWDeviceInfo.TEAM_MTK) {
            String wifiMac = Settings.Global.getString(context.getContentResolver(), "WiFiMac");
            if (!TextUtils.isEmpty(wifiMac)) {
                return wifiMac;
            }
        }

        return getLocalMacAddress6Above();
    }

    private static String getLocalMacAddress6Above() {
        try {
            List<NetworkInterface> all = Collections.list(NetworkInterface.getNetworkInterfaces());
            for (NetworkInterface nif : all) {
                if (!nif.getName().equalsIgnoreCase("wlan0")) continue;

                byte[] macBytes = nif.getHardwareAddress();
                if (macBytes == null) {
                    return "";
                }
                StringBuilder res1 = new StringBuilder();
                for (byte b : macBytes) {
                    res1.append(String.format("%02X:", b));
                }

                if (res1.length() > 0) {
                    res1.deleteCharAt(res1.length() - 1);
                }
                return res1.toString();
            }
        } catch (Exception ignored) {
        }
        return "";
    }


    private static String getSharedPreferences(Context context, String key) {
        return getSP(context).getString(key, "");
    }

    private static SharedPreferences getSP(Context context) {
        return context.getSharedPreferences("config", Context.MODE_PRIVATE);
    }

    private static void setSharedPreferences(Context context, String key, String value) {
        SharedPreferences.Editor editor = getSP(context).edit();
        editor.putString(key, value);
        editor.apply();
    }
}
