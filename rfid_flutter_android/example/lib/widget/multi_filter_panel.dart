import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rfid_flutter_android/rfid_flutter_android.dart';

import '../l10n/app_localizations.dart';
import 'expandable_panel/expandable_panel.dart';

/// Controller for [MultiFilterPanel] filter list <br/>
/// [MultiFilterPanel] 过滤列表的控制器 <br/>
///
/// #### English
/// Optional. When provided, it is the source of truth for the filter list.
/// Read [filters]; mutate via [add], [removeAt], [clear]. Listen with [addListener].
/// The owner must [dispose] it.
///
/// #### 中文
/// 可选。传入后由 Controller 作为过滤列表的唯一数据源。
/// 通过 [filters] 读取；用 [add]、[removeAt]、[clear] 修改；用 [addListener] 监听。
/// 创建方需要在适当时机调用 [dispose]。
class MultiFilterPanelController extends ChangeNotifier {
  /// Creates a controller. <br/>
  /// 创建控制器。 <br/>
  ///
  /// #### English
  /// [filters] is the initial filter list (copied).
  ///
  /// #### 中文
  /// [filters] 为初始过滤列表（会拷贝一份）。
  MultiFilterPanelController({List<RfidFilter>? filters}) {
    if (filters != null) {
      _filters.addAll(filters);
    }
  }

  /// Maximum number of filter conditions <br/>
  /// 过滤条件最大数量 <br/>
  static const int maxCount = 8;

  final List<RfidFilter> _filters = [];

  /// Current filter list (unmodifiable view) <br/>
  /// 当前过滤列表（只读视图） <br/>
  List<RfidFilter> get filters => List.unmodifiable(_filters);

  /// Whether the list is empty <br/>
  /// 列表是否为空 <br/>
  bool get isEmpty => _filters.isEmpty;

  /// Number of filters <br/>
  /// 过滤条件数量 <br/>
  int get length => _filters.length;

  /// Add a filter. Returns `false` if already at [maxCount]. <br/>
  /// 添加过滤条件。已达 [maxCount] 时返回 `false`。 <br/>
  bool add(RfidFilter filter) {
    if (_filters.length >= maxCount) {
      return false;
    }
    _filters.add(filter);
    notifyListeners();
    return true;
  }

  /// Remove the filter at [index] <br/>
  /// 删除指定下标的过滤条件 <br/>
  void removeAt(int index) {
    if (index < 0 || index >= _filters.length) {
      return;
    }
    _filters.removeAt(index);
    notifyListeners();
  }

  /// Clear all filters <br/>
  /// 清空全部过滤条件 <br/>
  void clear() {
    if (_filters.isEmpty) {
      return;
    }
    _filters.clear();
    notifyListeners();
  }
}

/// Multi-filter panel based on [ExpandablePanel] <br/>
/// 基于 [ExpandablePanel] 的多过滤条件面板 <br/>
///
/// #### English
/// Manages add/delete/clear and subtitle internally.
/// Expose the list via [MultiFilterPanelController].
///
/// ```dart
/// final controller = MultiFilterPanelController();
///
/// MultiFilterPanel(controller: controller);
///
/// // later
/// final filters = controller.filters;
/// ```
///
/// #### 中文
/// 增删清空与副标题由组件内部处理；通过 [MultiFilterPanelController] 对外暴露列表。
///
/// ```dart
/// final controller = MultiFilterPanelController();
///
/// MultiFilterPanel(controller: controller);
///
/// // 使用时
/// final filters = controller.filters;
/// ```
class MultiFilterPanel extends StatefulWidget {
  const MultiFilterPanel({
    super.key,
    this.controller,
  });

  /// Optional filter-list controller <br/>
  /// 可选的过滤列表控制器 <br/>
  ///
  /// #### English
  /// When non-null, [MultiFilterPanelController] is the source of truth.
  /// The owner must dispose it. When null, an internal controller is used.
  ///
  /// #### 中文
  /// 非空时由 [MultiFilterPanelController] 作为列表唯一数据源，创建方负责 dispose；
  /// 为空时使用内部 Controller。
  final MultiFilterPanelController? controller;

  @override
  State<MultiFilterPanel> createState() => _MultiFilterPanelState();
}

class _MultiFilterPanelState extends State<MultiFilterPanel> {
  late MultiFilterPanelController _controller;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    _bindController(widget.controller);
  }

  @override
  void didUpdateWidget(covariant MultiFilterPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _unbindController();
      _bindController(widget.controller);
    }
  }

  @override
  void dispose() {
    _unbindController();
    super.dispose();
  }

  void _bindController(MultiFilterPanelController? controller) {
    if (controller != null) {
      _controller = controller;
      _ownsController = false;
    } else {
      _controller = MultiFilterPanelController();
      _ownsController = true;
    }
    _controller.addListener(_onFiltersChanged);
  }

  void _unbindController() {
    _controller.removeListener(_onFiltersChanged);
    if (_ownsController) {
      _controller.dispose();
    }
  }

  void _onFiltersChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  String _subtitle(AppLocalizations l10n) {
    if (_controller.isEmpty) {
      return l10n.filterNone;
    }
    return l10n.filterCountFormat(_controller.length);
  }

  void _onAddPressed() {
    final l10n = AppLocalizations.of(context)!;
    if (_controller.length >= MultiFilterPanelController.maxCount) {
      BotToast.showText(text: l10n.filterMaxCount);
      return;
    }
    _showAddFilterDialog();
  }

  Future<void> _showAddFilterDialog() async {
    final l10n = AppLocalizations.of(context)!;
    var selectedBank = RfidBank.epc;
    final offsetController = TextEditingController(text: '32');
    final lengthController = TextEditingController();
    final dataController = TextEditingController();

    final result = await showDialog<RfidFilter>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            void onBankChanged(RfidBank? bank) {
              if (bank == null) return;
              setDialogState(() {
                selectedBank = bank;
                offsetController.text = bank == RfidBank.epc ? '32' : '0';
              });
            }

            return AlertDialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              title: Text(l10n.filterDialogTitle),
              content: SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(l10n.bank),
                          const SizedBox(width: 8),
                          Expanded(
                            child: RadioGroup<RfidBank>(
                              groupValue: selectedBank,
                              onChanged: onBankChanged,
                              child: Wrap(
                                spacing: 4,
                                children: [
                                  _dialogBankRadio(
                                    label: 'EPC',
                                    bank: RfidBank.epc,
                                    onTap: () => onBankChanged(RfidBank.epc),
                                  ),
                                  _dialogBankRadio(
                                    label: 'TID',
                                    bank: RfidBank.tid,
                                    onTap: () => onBankChanged(RfidBank.tid),
                                  ),
                                  _dialogBankRadio(
                                    label: 'USER',
                                    bank: RfidBank.user,
                                    onTap: () => onBankChanged(RfidBank.user),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: offsetController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: '${l10n.offset} (bit)',
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: lengthController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: '${l10n.length} (bit)',
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: dataController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9a-fA-F]')),
                          _UpperCaseTextFormatter(),
                        ],
                        decoration: InputDecoration(
                          labelText: '${l10n.data} (hex)',
                          hintText: l10n.enterHexData,
                          isDense: true,
                        ),
                        onChanged: (value) {
                          lengthController.text = (value.length * 4).toString();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(l10n.cancel),
                ),
                TextButton(
                  onPressed: () {
                    final offset = int.tryParse(offsetController.text);
                    if (offset == null || offset < 0) {
                      BotToast.showText(text: l10n.filterOffsetInvalid);
                      return;
                    }
                    final length = int.tryParse(lengthController.text);
                    if (length == null || length < 0) {
                      BotToast.showText(text: l10n.filterLengthInvalid);
                      return;
                    }
                    final data = dataController.text;
                    if (data.isEmpty) {
                      BotToast.showText(text: l10n.filterDataEmpty);
                      return;
                    }
                    Navigator.of(dialogContext).pop(
                      RfidFilter(
                        enabled: true,
                        bank: selectedBank,
                        offset: offset,
                        length: length,
                        data: data,
                      ),
                    );
                  },
                  child: Text(l10n.ok),
                ),
              ],
            );
          },
        );
      },
    );

    offsetController.dispose();
    lengthController.dispose();
    dataController.dispose();

    if (result != null) {
      if (!_controller.add(result)) {
        BotToast.showText(text: l10n.filterMaxCount);
      }
    }
  }

  Widget _dialogBankRadio({
    required String label,
    required RfidBank bank,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<RfidBank>(
            value: bank,
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          Text(label),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ExpandablePanel(
      title: l10n.filterTitle,
      subtitle: _subtitle(l10n),
      // Body 在 Overlay 中：用 ListenableBuilder 保证展开后增删能刷新列表
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          final filters = _controller.filters;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 仅限制列表区域高度，避免条目过多把底部按钮挤出可视区
              if (filters.isEmpty)
                SizedBox(
                  height: 50,
                  child: Center(
                    child: Text(
                      l10n.filterEmpty,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                )
              else
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 250),
                  child: ListView.separated(
                    shrinkWrap: true,
                    // Overlay 中的列表不应再套用状态栏等 MediaQuery 顶部 padding，否则上方会出现大块空白
                    padding: EdgeInsets.zero,
                    itemCount: filters.length,
                    separatorBuilder: (_, __) => const Divider(height: 0.5, thickness: 0.5),
                    itemBuilder: (context, index) {
                      final filter = filters[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                l10n.filterItemFormat(
                                  filter.bank.description,
                                  filter.offset,
                                  filter.length,
                                  filter.data,
                                ),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                            IconButton(
                              onPressed: () => _controller.removeAt(index),
                              icon: const Icon(Icons.delete, color: Colors.red),
                              iconSize: 20,
                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _onAddPressed,
                        child: Text(l10n.filterAdd),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _controller.clear,
                        child: Text(l10n.filterClear),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// 将输入转为大写（十六进制数据）
class _UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
