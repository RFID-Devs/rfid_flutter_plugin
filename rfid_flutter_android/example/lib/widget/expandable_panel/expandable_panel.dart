import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'expandable_panel_coordinator.dart';

/// Controller for [ExpandablePanel] expand/collapse state <br/>
/// [ExpandablePanel] 展开/收起状态的控制器 <br/>
///
/// #### English
/// Optional. When provided, it is the source of truth for open/close.
/// Call [expand], [collapse], or [toggle]; listen via [addListener] or read [isExpanded].
/// The owner must [dispose] it.
///
/// #### 中文
/// 可选。传入后由 Controller 作为展开/收起的唯一数据源。
/// 通过 [expand]、[collapse]、[toggle] 控制；用 [addListener] 监听或读取 [isExpanded]。
/// 创建方需要在适当时机调用 [dispose]。
class ExpandablePanelController extends ChangeNotifier {
  /// Creates a controller. <br/>
  /// 创建控制器。 <br/>
  ///
  /// #### English
  /// [expanded] is the initial expanded state.
  ///
  /// #### 中文
  /// [expanded] 为初始展开状态。
  ExpandablePanelController({bool expanded = false}) : _expanded = expanded;

  bool _expanded;
  _ExpandablePanelState? _state;

  /// Whether the panel is expanded <br/>
  /// 面板是否处于展开状态 <br/>
  bool get isExpanded => _expanded;

  /// Expand the panel <br/>
  /// 展开面板 <br/>
  void expand() {
    if (_expanded) {
      return;
    }
    _setExpanded(true, notify: true);
    _state?._applyExpandedFromController(true);
  }

  /// Collapse the panel <br/>
  /// 收起面板 <br/>
  void collapse() {
    if (!_expanded) {
      return;
    }
    _setExpanded(false, notify: true);
    _state?._applyExpandedFromController(false);
  }

  /// Toggle expand/collapse <br/>
  /// 切换展开/收起 <br/>
  void toggle() {
    if (_expanded) {
      collapse();
    } else {
      expand();
    }
  }

  void _attach(_ExpandablePanelState state) {
    _state = state;
  }

  void _detach(_ExpandablePanelState state) {
    if (_state == state) {
      _state = null;
    }
  }

  /// 由 Panel 同步状态（互斥收起、可见性收起等）；[notify] 为 false 时不触发监听。
  void _setExpanded(bool expanded, {required bool notify}) {
    if (_expanded == expanded) {
      return;
    }
    _expanded = expanded;
    if (notify) {
      notifyListeners();
    }
  }
}

/// Expandable overlay panel <br/>
/// 可展开浮层面板 <br/>
///
/// #### English
/// Displays a header in the normal widget tree. Tapping the header opens a
/// floating body below it with a dimmed scrim. Overlay, animation, and
/// mutually exclusive expansion (opening one panel closes another) are handled
/// internally.
///
/// Basic usage:
/// ```dart
/// ExpandablePanel(
///   title: 'Title',
///   subtitle: 'Subtitle', // optional
///   child: YourPanelContent(),
/// )
/// ```
///
/// With a [controller] (parent must dispose it):
/// ```dart
/// final controller = ExpandablePanelController();
///
/// ExpandablePanel(
///   title: 'Title',
///   controller: controller,
///   child: YourPanelContent(),
/// )
///
/// controller.expand();
/// controller.collapse();
/// ```
///
/// - Omit [controller]: the panel manages expand/collapse by itself.
/// - Pass [controller]: control and observe state via the controller.
///
/// -----
///
/// #### 中文
/// Header 留在正常布局中；点击后在其下方弹出浮层 Body（带半透明蒙版）。
/// 浮层、动画、以及同页多面板互斥展开（打开一个会收起另一个）均由组件内部处理。
///
/// 基本用法：
/// ```dart
/// ExpandablePanel(
///   title: '主标题',
///   subtitle: '副标题', // 可选
///   child: YourPanelContent(),
/// )
/// ```
///
/// 使用 [controller]（由创建方负责 dispose）：
/// ```dart
/// final controller = ExpandablePanelController();
///
/// ExpandablePanel(
///   title: '主标题',
///   controller: controller,
///   child: YourPanelContent(),
/// )
///
/// controller.expand();
/// controller.collapse();
/// ```
///
/// - 不传 [controller]：由组件自行管理展开/收起。
/// - 传入 [controller]：通过 Controller 控制并观察展开状态。
class ExpandablePanel extends StatefulWidget {
  const ExpandablePanel({
    super.key,
    required this.title,
    this.subtitle,
    this.controller,
    required this.child,
  });

  /// Panel title <br/>
  /// 面板标题 <br/>
  final String title;

  /// Panel subtitle; hidden when null or empty <br/>
  /// 面板副标题；为空或空字符串时不显示 <br/>
  final String? subtitle;

  /// Optional expand/collapse controller <br/>
  /// 可选的展开/收起控制器 <br/>
  ///
  /// #### English
  /// When non-null, [ExpandablePanelController] is the source of truth.
  /// The owner must dispose it.
  ///
  /// #### 中文
  /// 非空时由 [ExpandablePanelController] 作为展开状态的唯一数据源。
  /// 创建方需要负责 dispose。
  final ExpandablePanelController? controller;

  /// Content shown in the overlay body when expanded <br/>
  /// 展开后浮层中显示的内容 <br/>
  final Widget child;

  @override
  State<ExpandablePanel> createState() => _ExpandablePanelState();
}

class _ExpandablePanelState extends State<ExpandablePanel> with SingleTickerProviderStateMixin implements ExpandablePanelStateAccessor {
  final GlobalKey _headerKey = GlobalKey();
  final OverlayPortalController _portalController = OverlayPortalController();

  late final AnimationController _animController;

  ExpandablePanelCoordinator? _coordinator;

  /// 无 Controller 时的内部展开状态
  bool _internalExpanded = false;

  /// 是否正在通过逐帧回调监测页面可见性
  bool _watchingVisibility = false;

  /// IndexedStack 可见性缓存：子下标固定，展开期间每帧只读取当前 [IndexedStack.index]
  Element? _indexedStackElement;
  int? _indexedStackChildIndex;

  /// 是否已尝试解析过祖先 IndexedStack（含「不在 Stack 内」的结论）
  bool _indexedStackResolved = false;

  /// 收起动画完成回调世代，避免过期回调误执行
  int _collapseGen = 0;

  /// 当前逻辑展开态：有 Controller 时读 Controller，否则读 [_internalExpanded]
  bool get _isExpanded => widget.controller?.isExpanded ?? _internalExpanded;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this);
    widget.controller?._attach(this);
    // 初始即为展开时，等首帧布局完成后再同步到 Coordinator（此时才能量到 Header 位置）
    if (_isExpanded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _syncExpandedState(true);
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 按当前 Overlay 注册到对应 Coordinator；Overlay 变化时先注销旧实例
    final coordinator = ExpandablePanelCoordinator.of(context);
    if (_coordinator != coordinator) {
      _coordinator?.unregister(this);
      _coordinator = coordinator;
      _coordinator!.register(this);
    }
    // 依赖变化时祖先树可能变了，下次可见性检测时重新解析
    _clearIndexedStackCache();
  }

  @override
  void didUpdateWidget(covariant ExpandablePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach(this);
      widget.controller?._attach(this);
      // 换绑后按新 Controller 状态同步浮层
      _syncExpandedState(_isExpanded);
    }
  }

  @override
  void dispose() {
    _stopVisibilityWatch();
    widget.controller?._detach(this);
    _coordinator?.unregister(this);
    _animController.dispose();
    super.dispose();
  }

  double get _anchorTop {
    final context = _headerKey.currentContext;
    if (context == null) {
      return 0;
    }
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) {
      return 0;
    }
    // 浮层贴在 Header 底边下方
    final offset = renderBox.localToGlobal(Offset.zero);
    return offset.dy + renderBox.size.height;
  }

  @override
  void applyCollapse({required bool notifyParent, required bool fromCoordinator}) {
    if (!mounted) {
      return;
    }
    _stopVisibilityWatch();
    _updateExpanded(false, notify: notifyParent);
    // Coordinator 已负责收起动画时，不再重复 requestCollapse
    if (!fromCoordinator) {
      _coordinator?.requestCollapse(this);
    }
  }

  @override
  void ensureExpandedUi() {
    if (!mounted) {
      return;
    }
    // 展开通知已由 Controller / _toggle 完成，此处只同步本地 UI 与可见性监测
    _updateExpanded(true, notify: false);
    _startVisibilityWatch();
  }

  @override
  void playExpand({required bool fromZero, required Duration duration}) {
    if (!mounted) {
      return;
    }
    _collapseGen++;
    if (!_portalController.isShowing) {
      _portalController.show();
    }
    if (fromZero && _animController.value != 0) {
      _animController.value = 0;
    }
    _animController.animateTo(1, duration: duration, curve: Curves.decelerate);
    setState(() {});
  }

  @override
  void playCollapse({required Duration duration, required VoidCallback onDone}) {
    if (!mounted) {
      onDone();
      return;
    }
    final gen = ++_collapseGen;

    void finish() {
      if (gen != _collapseGen || !mounted) {
        return;
      }
      if (_animController.value > 0.001) {
        return;
      }
      _portalController.hide();
      setState(() {});
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (gen == _collapseGen) {
          onDone();
        }
      });
    }

    if (!_portalController.isShowing) {
      _animController.value = 0;
      finish();
      return;
    }
    if (_animController.value <= 0 && !_animController.isAnimating) {
      finish();
      return;
    }

    _animController.animateTo(0, duration: duration, curve: Curves.decelerate).whenComplete(finish);
    setState(() {});
  }

  @override
  void hideOverlayImmediate() {
    _collapseGen++;
    _animController.stop();
    _animController.value = 0;
    if (_portalController.isShowing) {
      _portalController.hide();
    }
  }

  /// 由 [ExpandablePanelController] 调用：状态已在 Controller 中更新，这里只驱动浮层。
  void _applyExpandedFromController(bool expanded) {
    if (!mounted) {
      return;
    }
    setState(() {});
    _syncExpandedState(expanded);
  }

  /// 更新展开状态：有 Controller 时写回 Controller，否则更新 [_internalExpanded]。
  void _updateExpanded(bool expanded, {required bool notify}) {
    final controller = widget.controller;
    if (controller != null) {
      controller._setExpanded(expanded, notify: notify);
      if (mounted) {
        setState(() {});
      }
      return;
    }
    if (_internalExpanded != expanded) {
      setState(() => _internalExpanded = expanded);
    }
  }

  /// 将逻辑展开态同步到 Coordinator（真正驱动浮层动画）。
  void _syncExpandedState(bool expanded) {
    if (expanded) {
      _coordinator?.requestExpand(this);
      _startVisibilityWatch();
    } else {
      _stopVisibilityWatch();
      _coordinator?.requestCollapse(this);
    }
  }

  void _toggle() {
    final controller = widget.controller;
    if (controller != null) {
      // 有 Controller：只改 Controller，由其回调再同步 Coordinator，避免双路径
      controller.toggle();
      return;
    }
    final next = !_internalExpanded;
    _updateExpanded(next, notify: true);
    _syncExpandedState(next);
  }

  /// 开始逐帧监测页面可见性（切页 / Route 被覆盖时自动收起）。
  void _startVisibilityWatch() {
    if (_watchingVisibility) {
      return;
    }
    _watchingVisibility = true;
    _resolveIndexedStackCache(context);
    SchedulerBinding.instance.addPostFrameCallback(_onVisibilityTick);
  }

  void _stopVisibilityWatch() {
    _watchingVisibility = false;
    _clearIndexedStackCache();
  }

  void _clearIndexedStackCache() {
    _indexedStackElement = null;
    _indexedStackChildIndex = null;
    _indexedStackResolved = false;
  }

  void _onVisibilityTick(Duration _) {
    if (!_watchingVisibility || !mounted) {
      return;
    }
    if (!_isExpanded) {
      _stopVisibilityWatch();
      return;
    }
    if (!_isPageVisible(context)) {
      _stopVisibilityWatch();
      _updateExpanded(false, notify: true);
      _coordinator?.requestCollapse(this);
      return;
    }
    SchedulerBinding.instance.addPostFrameCallback(_onVisibilityTick);
  }

  /// 检测是否仍在可见页面中（兼容 IndexedStack 切页、Route 被覆盖等情况）。
  ///
  /// Dialog / BottomSheet 等 [PopupRoute] 覆盖时不视为离开页面；
  /// 浮层经 [OverlayPortal] 挂在当前 Route 下，Dialog 会正确盖在面板之上。
  bool _isPageVisible(BuildContext context) {
    final route = ModalRoute.of(context);
    if (route != null && !route.isCurrent) {
      // 栈顶若是 PopupRoute（如 showDialog），页面仍可见；仅被其它页面 Route 盖住时才收起
      if (!_isCoveredOnlyByPopup(route)) {
        return false;
      }
    }

    if (!_indexedStackResolved) {
      _resolveIndexedStackCache(context);
    }

    final stackElement = _indexedStackElement;
    final childIndex = _indexedStackChildIndex;
    if (stackElement == null || childIndex == null) {
      // 不在 IndexedStack 内，仅依赖 Route 可见性
      return true;
    }

    final stackWidget = stackElement.widget;
    if (stackWidget is! IndexedStack) {
      // Element 上的 widget 类型已变，重新解析一次
      _clearIndexedStackCache();
      _resolveIndexedStackCache(context);
      final retryElement = _indexedStackElement;
      final retryIndex = _indexedStackChildIndex;
      if (retryElement == null || retryIndex == null) {
        return true;
      }
      final retryStack = retryElement.widget;
      if (retryStack is! IndexedStack) {
        return true;
      }
      return retryIndex == retryStack.index;
    }

    return childIndex == stackWidget.index;
  }

  /// 当前 [route] 是否仅被 [PopupRoute]（Dialog / BottomSheet 等）盖住。
  ///
  /// 利用 [NavigatorState.popUntil]：谓词对栈顶立刻返回 true 时不会真正 pop，仅用于读取栈顶 Route。
  bool _isCoveredOnlyByPopup(ModalRoute<dynamic> route) {
    final navigator = route.navigator;
    if (navigator == null) {
      return false;
    }
    Route<dynamic>? topRoute;
    navigator.popUntil((top) {
      topRoute = top;
      return true;
    });
    return topRoute is PopupRoute;
  }

  /// 解析并缓存自身在祖先 [IndexedStack] 中的子下标（下标固定，切页只变 index）。
  void _resolveIndexedStackCache(BuildContext context) {
    Element? childOfStack;
    Element? stackElement;

    context.visitAncestorElements((element) {
      if (element.widget is IndexedStack) {
        stackElement = element;
        return false;
      }
      childOfStack = element;
      return true;
    });

    _indexedStackResolved = true;

    if (stackElement == null || childOfStack == null) {
      _indexedStackElement = null;
      _indexedStackChildIndex = null;
      return;
    }

    var index = 0;
    int? childIndex;
    stackElement!.visitChildren((child) {
      if (identical(child, childOfStack)) {
        childIndex = index;
      }
      index++;
    });

    _indexedStackElement = stackElement;
    _indexedStackChildIndex = childIndex;
  }

  Widget _buildOverlay(BuildContext context) {
    final anchorTop = _anchorTop;
    final mediaQuery = MediaQuery.of(context);
    final maxBodyHeight = (mediaQuery.size.height - anchorTop - mediaQuery.padding.bottom).clamp(0.0, double.infinity);

    return AnimatedBuilder(
      animation: _animController,
      builder: (context, _) {
        final t = _animController.value;
        // Overlay 的子节点需占满，内部再用 Positioned 布局，否则仅含 Positioned 的 Stack 尺寸为 0
        return Positioned.fill(
          child: Stack(
            children: [
              // 半透明蒙版：点击收起；进度接近 0 时忽略命中，避免挡住下层
              Positioned(
                top: anchorTop,
                left: 0,
                right: 0,
                bottom: 0,
                child: IgnorePointer(
                  ignoring: t < 0.01,
                  child: GestureDetector(
                    onTap: () => _coordinator?.collapseAll(),
                    behavior: HitTestBehavior.opaque,
                    child: Opacity(
                      opacity: t,
                      child: ColoredBox(
                        color: Colors.black.withValues(alpha: 0.32),
                      ),
                    ),
                  ),
                ),
              ),
              // Body：自 Header 底边向下展开
              Positioned(
                top: anchorTop,
                left: 0,
                right: 0,
                child: Material(
                  color: Colors.blue.shade50,
                  elevation: 0,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: maxBodyHeight),
                    child: ClipRect(
                      child: Align(
                        alignment: Alignment.topCenter,
                        heightFactor: t,
                        child: SingleChildScrollView(
                          child: widget.child,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasSubtitle = widget.subtitle != null && widget.subtitle!.isNotEmpty;

    // Header 在文档流中；Body / 蒙版由 OverlayPortal 挂到当前 Route 的 Overlay（低于 Dialog）
    return OverlayPortal(
      controller: _portalController,
      overlayChildBuilder: _buildOverlay,
      child: Material(
        color: Colors.blue.shade50,
        child: InkWell(
          key: _headerKey,
          onTap: _toggle,
          child: SizedBox(
            height: 48,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (hasSubtitle)
                          Text(
                            widget.subtitle!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.25 : 0,
                    duration: ExpandablePanelCoordinator.animDuration,
                    curve: Curves.decelerate,
                    child: Icon(Icons.chevron_right, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
