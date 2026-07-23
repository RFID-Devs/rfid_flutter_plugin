package com.rfid.rfid_flutter_android.channel;

import android.content.Context;

import androidx.annotation.NonNull;

import com.rfid.rfid_flutter_android.utils.TagUtil;
import com.rscja.deviceapi.RFIDWithUHFUART;
import com.rscja.deviceapi.entity.FastInventoryEntity;
import com.rscja.deviceapi.entity.FilterEntity;
import com.rscja.deviceapi.entity.Gen2Entity;
import com.rscja.deviceapi.entity.InventoryModeEntity;
import com.rscja.deviceapi.entity.UHFTAGInfo;
import com.rscja.deviceapi.interfaces.IUHF;
import com.rscja.team.qcom.utility.LogUtility_qcom;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutorService;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class UARTChannelHandler implements MethodChannel.MethodCallHandler {
    private static final String TAG = "UART";

    private final Context context;
    private final ExecutorService executor;

    private RFIDWithUHFUART mReader;

    public UARTChannelHandler(Context context, ExecutorService executor) {
        this.context = context;
        this.executor = executor;
    }

    // 方法处理器映射表
    private final Map<String, MethodHandler> methodHandlers = new HashMap<String, MethodHandler>() {{
        // 基础操作
        put("init", UARTChannelHandler.this::init);
        put("free", UARTChannelHandler.this::free);

        // 盘点相关
        put("setFilter", UARTChannelHandler.this::setFilter);
        put("setFilters", UARTChannelHandler.this::setFilters);
        put("singleInventory", UARTChannelHandler.this::singleInventory);
        put("startInventory", UARTChannelHandler.this::startInventory);
        put("stopInventory", UARTChannelHandler.this::stopInventory);
        put("isInventorying", UARTChannelHandler.this::isInventorying);

        // 标签操作
        put("readData", UARTChannelHandler.this::readData);
        put("writeData", UARTChannelHandler.this::writeData);
        put("lockTag", UARTChannelHandler.this::lockTag);
        put("killTag", UARTChannelHandler.this::killTag);

        // 设置
        put("setFrequency", UARTChannelHandler.this::setFrequency);
        put("getFrequency", UARTChannelHandler.this::getFrequency);
        put("setPower", UARTChannelHandler.this::setPower);
        put("getPower", UARTChannelHandler.this::getPower);
        put("setRfLink", UARTChannelHandler.this::setRfLink);
        put("getRfLink", UARTChannelHandler.this::getRfLink);
        put("setInventoryMode", UARTChannelHandler.this::setInventoryMode);
        put("getInventoryMode", UARTChannelHandler.this::getInventoryMode);
        put("setGen2", UARTChannelHandler.this::setGen2);
        put("getGen2", UARTChannelHandler.this::getGen2);
        put("setFastInventory", UARTChannelHandler.this::setFastInventory);
        put("getFastInventory", UARTChannelHandler.this::getFastInventory);
        put("setTagFocus", UARTChannelHandler.this::setTagFocus);
        put("getTagFocus", UARTChannelHandler.this::getTagFocus);
        put("setFastId", UARTChannelHandler.this::setFastId);
        put("getFastId", UARTChannelHandler.this::getFastId);

        // 版本、温度、重置
        put("getUhfFirmwareVersion", UARTChannelHandler.this::getUhfFirmwareVersion);
        put("getUhfHardwareVersion", UARTChannelHandler.this::getUhfHardwareVersion);
        put("getUhfTemperature", UARTChannelHandler.this::getUhfTemperature);
        put("resetUhf", UARTChannelHandler.this::resetUhf);
    }};

    @Override
    public void onMethodCall(@NonNull MethodCall methodCall, @NonNull MethodChannel.Result result) {
        executor.execute(() -> {
            try {
                if (!methodCall.method.equals("init") && !methodCall.method.equals("free") && mReader == null) {
                    result.error(TAG, "Not initialized", "");
                    return;
                }
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


    // 基础操作方法
    private void init(MethodCall methodCall, MethodChannel.Result result) {
        try {
            mReader = RFIDWithUHFUART.getInstance();
        } catch (Exception e) {
            result.error(TAG, "init error: " + e.getMessage(), null);
            return;
        }
        result.success(mReader.init(context));
    }

    private void free(MethodCall methodCall, MethodChannel.Result result) {
        result.success(mReader.free());
        mReader = null;
    }


    /**
     * @noinspection DataFlowIssue
     */
    private void setFilter(MethodCall methodCall, MethodChannel.Result result) {
        Map<String, Object> map = methodCall.arguments();
        if (map == null) {
            result.error(TAG, "Invalid arguments", null);
            return;
        }
        int bank = (int) map.get("bank");
        if (bank < IUHF.Bank_EPC || bank > IUHF.Bank_USER) {
            result.error(TAG, "Invalid bank", null);
            return;
        }
        int offset = (int) map.get("offset");
        int length = (int) map.get("length");
        String data = (String) map.get("data");
        boolean success = mReader.setFilter(bank, offset, length, data);
        result.success(success);

        LogUtility_qcom.myLogV(TAG, "setFilter: " + bank + " " + offset + " " + length + " " + data + " success=" + success);
    }

    private void setFilters(MethodCall methodCall, MethodChannel.Result result) {
        Map<String, Object> map = methodCall.arguments();
        if (map == null) {
            result.error(TAG, "Invalid arguments", null);
            return;
        }

        Object filtersObj = map.get("filters");
        if (!(filtersObj instanceof List)) {
            result.error(TAG, "Invalid filters", null);
            return;
        }
        try {
            List<Map<String, Object>> filters = (List<Map<String, Object>>) filtersObj;
            List<FilterEntity> list = new ArrayList<>();
            for (Map<String, Object> filter : filters) {
                int bank = (int) filter.get("bank");
                int offset = (int) filter.get("offset");
                int length = (int) filter.get("length");
                String data = (String) filter.get("data");
                list.add(new FilterEntity(bank, offset, length, data));
            }
            boolean res = mReader.setFilter(list);
            result.success(res);
            LogUtility_qcom.myLogV(TAG, "setFilters: " + list + " res=" + res);
        } catch (Exception e) {
            result.error(TAG, "setFilters error: " + e.getMessage(), null);
        }
    }

    private void singleInventory(MethodCall methodCall, MethodChannel.Result result) {
        UHFTAGInfo uhftagInfo = mReader.inventorySingleTag();
        if (uhftagInfo != null) {
            result.success(TagUtil.getTagMap(uhftagInfo));
        } else {
            result.error(TAG, "No tag found", null);
        }
    }

    private void startInventory(MethodCall methodCall, MethodChannel.Result result) {
        result.success(mReader.startInventoryTag());
    }

    private void stopInventory(MethodCall methodCall, MethodChannel.Result result) {
        result.success(mReader.stopInventory());
    }

    private void isInventorying(MethodCall methodCall, MethodChannel.Result result) {
        result.success(mReader.isInventorying());
    }

    /**
     * @noinspection DataFlowIssue
     */
    private void readData(MethodCall methodCall, MethodChannel.Result result) {
        Map<String, Object> map = methodCall.arguments();
        if (map == null) {
            result.error(TAG, "Invalid arguments", null);
            return;
        }
        int bank = (int) map.get("bank");
        int offset = (int) map.get("offset");
        int length = (int) map.get("length");
        String password = (String) map.get("password");
        LogUtility_qcom.myLogV(TAG, "readData bank=" + bank + " offset=" + offset + " length=" + length);

        Object filterObj = map.get("filter");
        boolean useFilter = false;
        Map filter = null;
        if (filterObj instanceof Map) {
            filter = (Map) filterObj;
            Object enabledObj = filter.get("enabled");
            if (enabledObj instanceof Boolean && (Boolean) enabledObj) {
                useFilter = true;
            }
        }

        if (!useFilter) {
            String data = mReader.readData(password, bank, offset, length);
            if (data == null || data.isEmpty()) {
                result.error(TAG, "No tag found", null);
            } else {
                result.success(data);
            }
        } else {
            int filterBank = (int) filter.get("bank");
            int filterOffset = (int) filter.get("offset");
            int filterLength = (int) filter.get("length");
            String filterData = (String) filter.get("data");
            LogUtility_qcom.myLogV(TAG, "readData filter: " + filter);
            String data = mReader.readData(
                    password,
                    filterBank,
                    filterOffset,
                    filterLength,
                    filterData,
                    bank,
                    offset,
                    length
            );
            if (data == null || data.isEmpty()) {
                result.error(TAG, "No tag found", null);
            } else {
                result.success(data);
            }
        }
    }

    /**
     * @noinspection DataFlowIssue
     */
    private void writeData(MethodCall methodCall, MethodChannel.Result result) {
        Map<String, Object> map = methodCall.arguments();
        if (map == null) {
            result.error(TAG, "Invalid arguments", null);
            return;
        }
        int bank = (int) map.get("bank");
        int offset = (int) map.get("offset");
        int length = (int) map.get("length");
        String password = (String) map.get("password");
        String data = (String) map.get("data");
        LogUtility_qcom.myLogV(TAG, "writeData bank=" + bank + " offset=" + offset + " length=" + length + " data=" + data);

        Object filterObj = map.get("filter");
        boolean useFilter = false;
        Map filter = null;
        if (filterObj instanceof Map) {
            filter = (Map) filterObj;
            Object enabledObj = filter.get("enabled");
            if (enabledObj instanceof Boolean && (Boolean) enabledObj) {
                useFilter = true;
            }
        }

        if (!useFilter) {
            result.success(mReader.writeData(password, bank, offset, length, data));
        } else {
            int filterBank = (int) filter.get("bank");
            int filterOffset = (int) filter.get("offset");
            int filterLength = (int) filter.get("length");
            String filterData = (String) filter.get("data");
            LogUtility_qcom.myLogV(TAG, "writeData filter: " + filter);
            result.success(mReader.writeData(
                    password,
                    filterBank,
                    filterOffset,
                    filterLength,
                    filterData,
                    bank,
                    offset,
                    length,
                    data
            ));
        }
    }

    /**
     * @noinspection DataFlowIssue
     */
    private void lockTag(MethodCall methodCall, MethodChannel.Result result) {
        Map<String, Object> map = methodCall.arguments();
        if (map == null) {
            result.error(TAG, "Invalid arguments", null);
            return;
        }
        String password = (String) map.get("password");
        String lockCode = (String) map.get("lockCode");
        LogUtility_qcom.myLogV(TAG, "lockTag: " + password + " " + lockCode);

        Object filterObj = map.get("filter");
        boolean useFilter = false;
        Map filter = null;
        if (filterObj instanceof Map) {
            filter = (Map) filterObj;
            Object enabledObj = filter.get("enabled");
            if (enabledObj instanceof Boolean && (Boolean) enabledObj) {
                useFilter = true;
            }
        }

        if (!useFilter) {
            result.success(mReader.lockMem(password, lockCode));
        } else {
            int filterBank = (int) filter.get("bank");
            int filterOffset = (int) filter.get("offset");
            int filterLength = (int) filter.get("length");
            String filterData = (String) filter.get("data");
            LogUtility_qcom.myLogV(TAG, "lockTag filter: " + filter);
            result.success(mReader.lockMem(
                    password,
                    filterBank,
                    filterOffset,
                    filterLength,
                    filterData,
                    lockCode
            ));
        }
    }

    /**
     * @noinspection DataFlowIssue
     */
    private void killTag(MethodCall methodCall, MethodChannel.Result result) {
        Map<String, Object> map = methodCall.arguments();
        if (map == null) {
            result.error(TAG, "Invalid arguments", null);
            return;
        }
        String password = (String) map.get("password");

        Object filterObj = map.get("filter");
        boolean useFilter = false;
        Map filter = null;
        if (filterObj instanceof Map) {
            filter = (Map) filterObj;
            Object enabledObj = filter.get("enabled");
            if (enabledObj instanceof Boolean && (Boolean) enabledObj) {
                useFilter = true;
            }
        }

        if (!useFilter) {
            result.success(mReader.killTag(password));
        } else {
            int filterBank = (int) filter.get("bank");
            int filterOffset = (int) filter.get("offset");
            int filterLength = (int) filter.get("length");
            String filterData = (String) filter.get("data");
            boolean success = mReader.killTag(
                    password,
                    filterBank,
                    filterOffset,
                    filterLength,
                    filterData
            );
            result.success(success);
            LogUtility_qcom.myLogV(TAG, "killTag filter: " + filter + ", password=" + password + ", success=" + success);
        }
    }


    private void setFrequency(MethodCall methodCall, MethodChannel.Result result) {
        result.success(mReader.setFrequencyMode(methodCall.argument("value")));
    }

    private void getFrequency(MethodCall methodCall, MethodChannel.Result result) {
        result.success(mReader.getFrequencyMode());
    }

    private void setPower(MethodCall methodCall, MethodChannel.Result result) {
        result.success(mReader.setPower(methodCall.argument("value")));
    }

    private void getPower(MethodCall methodCall, MethodChannel.Result result) {
        int power = mReader.getPower();
        if (power <= 0) {
            result.error(TAG, "getPower fail", null);
        } else {
            result.success(power);
        }
    }

    // RF Link相关方法
    private void setRfLink(MethodCall methodCall, MethodChannel.Result result) {
        result.success(mReader.setRFLink(methodCall.argument("value")));
    }

    private void getRfLink(MethodCall methodCall, MethodChannel.Result result) {
        result.success(mReader.getRFLink());
    }

    // 盘点模式相关方法
    private void setInventoryMode(MethodCall methodCall, MethodChannel.Result result) {
        Map<String, Object> map = methodCall.arguments();
        if (map == null) {
            result.error(TAG, "Invalid arguments", null);
            return;
        }

        Object inventoryBankObj = map.get("inventoryBank");
        int bank = inventoryBankObj instanceof Integer ? (int) inventoryBankObj : -1;
        if (bank != InventoryModeEntity.MODE_EPC
                && bank != InventoryModeEntity.MODE_EPC_TID
                && bank != InventoryModeEntity.MODE_EPC_TID_USER
                && bank != InventoryModeEntity.MODE_EPC_TID_RESERVED
                && bank != InventoryModeEntity.MODE_EPC_RESERVED
                && bank != InventoryModeEntity.MODE_TEMPERATURE_TAG
                && bank != InventoryModeEntity.MODE_LED_TAG
        ) {
            result.error(TAG, "Invalid inventoryBank", null);
            return;
        }
        Object offsetObj = map.get("offset");
        int offset = offsetObj instanceof Integer ? (int) offsetObj : 0;
        Object lengthObj = map.get("length");
        int length = lengthObj instanceof Integer ? (int) lengthObj : 0;

        InventoryModeEntity.Builder builder = new InventoryModeEntity.Builder();
        builder.setMode(bank);
        if (bank == InventoryModeEntity.MODE_EPC_TID_USER) {
            builder.setUserOffset(offset)
                    .setUserLength(length);
        } else if (bank == InventoryModeEntity.MODE_EPC_TID_RESERVED || bank == InventoryModeEntity.MODE_EPC_RESERVED) {
            builder.setReservedOffset(offset)
                    .setReservedLength(length);
        }

        result.success(mReader.setEPCAndTIDUserMode(builder.build()));
    }

    private void getInventoryMode(MethodCall methodCall, MethodChannel.Result result) {
        InventoryModeEntity inventoryMode = mReader.getEPCAndTIDUserMode();
        Map<String, Object> map = new HashMap<>();
        map.put("inventoryBank", inventoryMode.getMode());
        if (inventoryMode.getMode() == InventoryModeEntity.MODE_EPC_TID_USER) {
            map.put("offset", inventoryMode.getUserOffset());
            map.put("length", inventoryMode.getUserLength());
        } else if (inventoryMode.getMode() == InventoryModeEntity.MODE_EPC_TID_RESERVED || inventoryMode.getMode() == InventoryModeEntity.MODE_EPC_RESERVED) {
            map.put("offset", inventoryMode.getReservedOffset());
            map.put("length", inventoryMode.getReservedLength());
        }
        result.success(map);
    }

    /**
     * @noinspection DataFlowIssue
     */
    private void setGen2(MethodCall methodCall, MethodChannel.Result result) {
        Map<String, Object> map = methodCall.arguments();
        if (map == null) {
            result.error(TAG, "Invalid arguments", null);
            return;
        }

        Gen2Entity gen2 = mReader.getGen2();
        if (map.containsKey("selectTarget")) {
            gen2.setSelectTarget((int) map.get("selectTarget"));
        }
        if (map.containsKey("selectAction")) {
            gen2.setSelectAction((int) map.get("selectAction"));
        }
        if (map.containsKey("selectTruncate")) {
            gen2.setSelectTruncate((int) map.get("selectTruncate"));
        }
        if (map.containsKey("q")) {
            gen2.setQ((int) map.get("q"));
        }
        if (map.containsKey("startQ")) {
            gen2.setStartQ((int) map.get("startQ"));
        }
        if (map.containsKey("minQ")) {
            gen2.setMinQ((int) map.get("minQ"));
        }
        if (map.containsKey("maxQ")) {
            gen2.setMaxQ((int) map.get("maxQ"));
        }
        if (map.containsKey("queryDR")) {
            gen2.setQueryDR((int) map.get("queryDR"));
        }
        if (map.containsKey("queryM")) {
            gen2.setQueryM((int) map.get("queryM"));
        }
        if (map.containsKey("queryTRext")) {
            gen2.setQueryTRext((int) map.get("queryTRext"));
        }
        if (map.containsKey("querySel")) {
            gen2.setQuerySel((int) map.get("querySel"));
        }
        if (map.containsKey("querySession")) {
            gen2.setQuerySession((int) map.get("querySession"));
        }
        if (map.containsKey("queryTarget")) {
            gen2.setQueryTarget((int) map.get("queryTarget"));
        }
        if (map.containsKey("linkFrequency")) {
            gen2.setLinkFrequency((int) map.get("linkFrequency"));
        }
        result.success(mReader.setGen2(gen2));
    }

    private void getGen2(MethodCall methodCall, MethodChannel.Result result) {
        Gen2Entity gen2 = mReader.getGen2();
        Map<String, Object> map = new HashMap<>();
        map.put("selectTarget", gen2.getSelectTarget());
        map.put("selectAction", gen2.getSelectAction());
        map.put("selectTruncate", gen2.getSelectTruncate());
        map.put("q", gen2.getQ());
        map.put("startQ", gen2.getStartQ());
        map.put("minQ", gen2.getMinQ());
        map.put("maxQ", gen2.getMaxQ());
        map.put("queryDR", gen2.getQueryDR());
        map.put("queryM", gen2.getQueryM());
        map.put("queryTRext", gen2.getQueryTRext());
        map.put("querySel", gen2.getQuerySel());
        map.put("querySession", gen2.getQuerySession());
        map.put("queryTarget", gen2.getQueryTarget());
        map.put("linkFrequency", gen2.getLinkFrequency());
        result.success(map);
    }

    private void setFastInventory(MethodCall methodCall, MethodChannel.Result result) {
        Map<String, Object> map = methodCall.arguments();
        if (map == null) {
            result.error(TAG, "Invalid arguments", null);
            return;
        }
        Object crObj = map.get("cr");
        int cr = crObj instanceof Integer ? (int) crObj : -1;
        FastInventoryEntity fastInventory = new FastInventoryEntity(cr);
        result.success(mReader.setFastInventoryMode(fastInventory));
    }

    private void getFastInventory(MethodCall methodCall, MethodChannel.Result result) {
        FastInventoryEntity fastInventoryMode = mReader.getFastInventoryMode();
        Map<String, Object> map = new HashMap<>();
        map.put("cr", fastInventoryMode == null ? 0x00 : fastInventoryMode.getCr());
        result.success(map);
    }

    private void setTagFocus(MethodCall methodCall, MethodChannel.Result result) {
        boolean value = Boolean.TRUE.equals(methodCall.argument("value"));
        result.success(mReader.setTagFocus(value));
    }

    private void getTagFocus(MethodCall methodCall, MethodChannel.Result result) {
        result.success(mReader.getTagFocus() == 1);
    }

    private void setFastId(MethodCall methodCall, MethodChannel.Result result) {
        boolean value = Boolean.TRUE.equals(methodCall.argument("value"));
        result.success(mReader.setFastID(value));
    }

    private void getFastId(MethodCall methodCall, MethodChannel.Result result) {
        result.success(mReader.getFastId() == 1);
    }


    // 硬件信息相关方法
    private void getUhfFirmwareVersion(MethodCall methodCall, MethodChannel.Result result) {
        result.success(mReader.getVersion());
    }

    private void getUhfHardwareVersion(MethodCall methodCall, MethodChannel.Result result) {
        result.success(mReader.getHardwareVersion());
    }

    private void getUhfTemperature(MethodCall methodCall, MethodChannel.Result result) {
        result.success(mReader.getTemperature());
    }

    private void resetUhf(MethodCall methodCall, MethodChannel.Result result) {
        result.success(mReader.factoryReset());
    }
}
