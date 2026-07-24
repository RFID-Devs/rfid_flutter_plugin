import 'package:flutter/material.dart';

/// 管理同一 [Overlay] 内多个 [ExpandablePanel] 的浮层展开、蒙版、动画与互斥。
///
/// 每个 [OverlayState] 对应一个 Coordinator 实例（见 [of]）。
/// 浮层本身由各面板的 [OverlayPortal] 绘制，本类不再插入 [OverlayEntry]，
/// 从而保证浮层低于 Dialog 等 [PopupRoute]。
class ExpandablePanelCoordinator {
  ExpandablePanelCoordinator(this._overlayState);

  /// 正常展开/收起动画时长（Header 箭头动画与此保持一致）
  static const Duration animDuration = Duration(milliseconds: 220);

  /// 面板互斥切换时的收起/展开时长（比正常动画更快）
  static const Duration _switchAnimDuration = Duration(milliseconds: 120);

  final OverlayState _overlayState;
  final List<ExpandablePanelStateAccessor> _panels = [];

  /// 逻辑上当前展开的面板（收起一开始即可置空，箭头立刻复位）
  ExpandablePanelStateAccessor? _expandedPanel;

  /// 浮层仍在展示（含收起动画中）的面板
  ExpandablePanelStateAccessor? _bodyPanel;

  /// 动画世代号：递增后作废过期的异步收起回调，避免切换过程中旧回调误执行
  int _animGen = 0;

  /// 按 Overlay 缓存 Coordinator，同一 Overlay 内面板共享一份
  static final Map<OverlayState, ExpandablePanelCoordinator> _coordinators = {};

  /// 获取与当前 context 所在 Overlay 绑定的 Coordinator（不存在则创建）。
  static ExpandablePanelCoordinator of(BuildContext context) {
    final overlay = Overlay.of(context);
    return _coordinators.putIfAbsent(overlay, () => ExpandablePanelCoordinator(overlay));
  }

  /// 注册面板；面板在 [State.didChangeDependencies] 中调用。
  void register(ExpandablePanelStateAccessor panel) {
    if (!_panels.contains(panel)) {
      _panels.add(panel);
    }
  }

  /// 注销面板；若该面板正展开或仍在播收起动画，则立即关闭其浮层。
  void unregister(ExpandablePanelStateAccessor panel) {
    _panels.remove(panel);
    if (_expandedPanel == panel || _bodyPanel == panel) {
      _animGen++;
      _expandedPanel = null;
      _bodyPanel = null;
      panel.hideOverlayImmediate();
    }
    if (_panels.isEmpty) {
      _coordinators.remove(_overlayState);
    }
  }

  /// 请求展开 [panel]：支持打断收起、以及与其他面板的互斥切换。
  void requestExpand(ExpandablePanelStateAccessor panel) {
    // 同一面板：从当前进度反向展开（打断收起）
    if (_bodyPanel == panel) {
      _animGen++;
      _expandedPanel = panel;
      panel.ensureExpandedUi();
      panel.playExpand(fromZero: false, duration: animDuration);
      return;
    }

    // 其他面板正在展示：先收起，再展开目标（对齐 Android collapse → expand）
    if (_bodyPanel != null) {
      final previous = _bodyPanel!;
      final toExpand = panel;
      final gen = ++_animGen;
      if (_expandedPanel != null) {
        _expandedPanel = null;
        previous.applyCollapse(notifyParent: true, fromCoordinator: true);
      }
      previous.playCollapse(
        duration: _switchAnimDuration,
        onDone: () {
          if (gen != _animGen) {
            return;
          }
          _bodyPanel = null;
          _openPanel(toExpand, fromZero: true, duration: _switchAnimDuration);
        },
      );
      return;
    }

    _openPanel(panel, fromZero: true, duration: animDuration);
  }

  /// 请求收起 [panel]；若当前浮层并非该面板则忽略。
  void requestCollapse(ExpandablePanelStateAccessor panel) {
    if (_bodyPanel != panel) {
      return;
    }
    final gen = ++_animGen;
    _expandedPanel = null;
    panel.playCollapse(
      duration: animDuration,
      onDone: () {
        if (gen != _animGen) {
          return;
        }
        if (_bodyPanel == panel) {
          _bodyPanel = null;
        }
      },
    );
  }

  /// 收起当前浮层（蒙版点击等入口）；会同步通知面板更新状态。
  void collapseAll() {
    if (_bodyPanel == null) {
      return;
    }
    final panel = _expandedPanel ?? _bodyPanel!;
    final bodyPanel = _bodyPanel!;
    final gen = ++_animGen;
    if (_expandedPanel != null) {
      _expandedPanel = null;
      panel.applyCollapse(notifyParent: true, fromCoordinator: true);
    }
    bodyPanel.playCollapse(
      duration: animDuration,
      onDone: () {
        if (gen != _animGen) {
          return;
        }
        if (_bodyPanel == bodyPanel) {
          _bodyPanel = null;
        }
      },
    );
  }

  void _openPanel(
    ExpandablePanelStateAccessor panel, {
    required bool fromZero,
    required Duration duration,
  }) {
    _expandedPanel = panel;
    _bodyPanel = panel;
    panel.ensureExpandedUi();
    panel.playExpand(fromZero: fromZero, duration: duration);
  }
}

/// [ExpandablePanel] 与 [ExpandablePanelCoordinator] 之间的内部桥接。
abstract class ExpandablePanelStateAccessor {
  /// 由 Coordinator 请求收起（仅处理收起；展开走 [ensureExpandedUi] / [ExpandablePanelCoordinator.requestExpand]）。
  ///
  /// [notifyParent] 为 true 时同步更新 [ExpandablePanelController]（或内部状态）并通知监听者。
  /// [fromCoordinator] 为 true 时表示收起动画已由 Coordinator 负责，Panel 勿再 [ExpandablePanelCoordinator.requestCollapse]。
  void applyCollapse({required bool notifyParent, required bool fromCoordinator});

  /// 互斥切换展开时，确保 Header 箭头等 UI 处于展开态（不重复通知 Controller 监听者）。
  void ensureExpandedUi();

  /// 显示 [OverlayPortal] 并播放展开动画。
  void playExpand({required bool fromZero, required Duration duration});

  /// 播放收起动画，结束后隐藏 [OverlayPortal] 并调用 [onDone]。
  void playCollapse({required Duration duration, required VoidCallback onDone});

  /// 立即隐藏浮层（注销时用，无动画）。
  void hideOverlayImmediate();
}
