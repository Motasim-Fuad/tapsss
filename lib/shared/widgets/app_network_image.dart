import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AppNetworkImage extends StatefulWidget {
  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  State<AppNetworkImage> createState() => _AppNetworkImageState();
}

class _AppNetworkImageState extends State<AppNetworkImage> {
  bool _ready = false;
  bool _failed = false;

  @override
  void didUpdateWidget(AppNetworkImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _ready = false;
      _failed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? BorderRadius.circular(12);
    final url = widget.url;

    if (url == null || url.isEmpty) {
      return _frame(
        radius,
        Container(
          color: AppColors.surface,
          alignment: Alignment.center,
          child: const Icon(Icons.image_outlined, color: AppColors.textHint),
        ),
      );
    }

    final dpr = MediaQuery.devicePixelRatioOf(context);
    final width = widget.width;
    final cacheWidth = width != null && width.isFinite ? (width * dpr).round().clamp(1, 1200) : null;

    return _frame(
      radius,
      Stack(
        fit: StackFit.expand,
        children: [
          if (!_ready) const _ImageShimmer(),
          if (_failed)
            const ColoredBox(
              color: AppColors.surface,
              child: Icon(Icons.broken_image_outlined, color: AppColors.textHint),
            )
          else
            Image(
              image: CachedNetworkImageProvider(url, maxWidth: cacheWidth),
              fit: widget.fit,
              width: widget.width,
              height: widget.height,
              gaplessPlayback: true,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                final loaded = wasSynchronouslyLoaded || frame != null;
                if (loaded && !_ready) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted && !_ready) setState(() => _ready = true);
                  });
                }
                return AnimatedOpacity(
                  opacity: loaded ? 1 : 0,
                  duration: wasSynchronouslyLoaded ? Duration.zero : const Duration(milliseconds: 280),
                  curve: Curves.easeOut,
                  child: child,
                );
              },
              errorBuilder: (_, __, ___) {
                if (!_failed) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted && !_failed) setState(() => _failed = true);
                  });
                }
                return const SizedBox.shrink();
              },
            ),
        ],
      ),
    );
  }

  Widget _frame(BorderRadius radius, Widget child) {
    return ClipRRect(
      borderRadius: radius,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: child,
      ),
    );
  }
}

class _ImageShimmer extends StatefulWidget {
  const _ImageShimmer();

  @override
  State<_ImageShimmer> createState() => _ImageShimmerState();
}

class _ImageShimmerState extends State<_ImageShimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1.6 + (t * 3.2), -0.4),
              end: Alignment(-0.2 + (t * 3.2), 0.4),
              colors: const [
                Color(0xFFD5DCE6),
                Color(0xFFEEF2F7),
                Color(0xFFFFFFFF),
                Color(0xFFEEF2F7),
                Color(0xFFD5DCE6),
              ],
              stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
            ),
          ),
        );
      },
    );
  }
}
