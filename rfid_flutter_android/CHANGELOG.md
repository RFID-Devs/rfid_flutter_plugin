## 0.2.0
* feat: add `setFilters` API for multi-filter support
* feat: improve compatibility with more device models
* feat: add `DeviceManager.playSound` API
* fix: prevent duplicate key event callbacks caused by Flutter KeyboardManager redispatch
* refactor!: change `singleInventory` / `startInventory` filter parameter from `RfidFilter?` to `List<RfidFilter>? filters`
* refactor!: remove `RfidFrequency.china1`; rename `china2` to `china`

## 0.1.1

* fix: Fix EventSink null pointer problem

## 0.1.0

* fix: Improve the BarcodeDecoder-related interface

## 0.1.0-dev.4

* refactor!: Rename RfidWithDeviceInfo to DeviceManager
* feat!: refactor fastInventory interface
* feat: Add scan barcode related interface
* feat: Add key event callback
* fix: A4 gets the antenna interface to return up to 8

## 0.1.0-dev.3

* refactor!: rename beep method to triggerBeep

## 0.1.0-dev.2

* Add log interface to unify log printing;
* relax Flutter SDK constraint to >=2.10.0

## 0.1.0-dev.1

* First version. Support UART, URA4.
