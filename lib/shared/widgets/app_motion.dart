import 'package:flutter/material.dart';

/// Fades and slides a widget in once. Rebuilding the parent does not replay it.
class AppEntrance extends StatefulWidget {
  final Widget child;
  final int index;

  const AppEntrance({super.key, required this.child, this.index = 0});

  @override
  State<AppEntrance> createState() => _AppEntranceState();
}

class _AppEntranceState extends State<AppEntrance> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    final delay = Duration(milliseconds: 45 * widget.index);
    Future<void>.delayed(delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(curved),
        child: widget.child,
      ),
    );
  }
}

List<Widget> stagger(List<Widget> children) {
  return [
    for (var i = 0; i < children.length; i++) AppEntrance(index: i, child: children[i]),
  ];
}

/// Plays a short fade when [play] flips to true. Used for bottom-tab switches.
class TabSwitchFade extends StatefulWidget {
  final bool play;
  final Widget child;

  const TabSwitchFade({super.key, required this.play, required this.child});

  @override
  State<TabSwitchFade> createState() => _TabSwitchFadeState();
}

class _TabSwitchFadeState extends State<TabSwitchFade> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
      value: widget.play ? 1 : 0,
    );
  }

  @override
  void didUpdateWidget(TabSwitchFade oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.play && !oldWidget.play) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.play) return widget.child;
    final curved = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    return FadeTransition(
      opacity: Tween<double>(begin: 0.35, end: 1).animate(curved),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.02), end: Offset.zero).animate(curved),
        child: widget.child,
      ),
    );
  }
}
