import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Loading placeholders shaped like each screen, not a generic list.
class PageShimmer {
  PageShimmer._();

  static Widget home() {
    return _shell(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _line(width: 90, height: 12),
                    const SizedBox(height: 8),
                    _line(width: 160, height: 22),
                  ],
                ),
              ),
              _box(width: 36, height: 36, radius: 18),
            ],
          ),
          const SizedBox(height: 20),
          _box(height: 190, radius: 18),
          const SizedBox(height: 24),
          _line(width: 120, height: 16),
          const SizedBox(height: 12),
          SizedBox(
            height: 170,
            child: Row(
              children: [
                Expanded(child: _box(height: 170, radius: 14)),
                const SizedBox(width: 12),
                Expanded(child: _box(height: 170, radius: 14)),
                const SizedBox(width: 12),
                Expanded(child: _box(height: 170, radius: 14)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _line(width: 140, height: 16),
          const SizedBox(height: 12),
          _activityRow(),
          const SizedBox(height: 10),
          _activityRow(),
          const SizedBox(height: 24),
          _box(height: 96, radius: 14),
        ],
      ),
    );
  }

  static Widget study() {
    return _shell(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _box(
            height: 92,
            radius: 16,
            child: Row(
              children: [
                _box(width: 60, height: 60, radius: 30),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _line(width: 140, height: 16),
                      const SizedBox(height: 8),
                      _line(width: 180, height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _line(width: 100, height: 16),
          const SizedBox(height: 12),
          for (var i = 0; i < 5; i++) ...[
            _chapterRow(),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  static Widget tests() {
    return _shell(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _box(
            height: 88,
            radius: 16,
            child: Row(
              children: [
                for (var i = 0; i < 3; i++)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _line(width: 48, height: 18),
                        const SizedBox(height: 8),
                        _line(width: 64, height: 10),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          for (var i = 0; i < 4; i++) ...[
            _testCard(),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  static Widget progress() {
    return _shell(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _line(width: 240, height: 12),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _box(height: 130, radius: 14)),
              const SizedBox(width: 12),
              _box(width: 120, height: 130, radius: 14),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _box(height: 78, radius: 14)),
              const SizedBox(width: 10),
              Expanded(child: _box(height: 78, radius: 14)),
              const SizedBox(width: 10),
              Expanded(child: _box(height: 78, radius: 14)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _line(width: 120, height: 16),
              _box(width: 120, height: 32, radius: 20),
            ],
          ),
          const SizedBox(height: 12),
          _box(height: 180, radius: 14),
        ],
      ),
    );
  }

  static Widget profile() {
    return _shell(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _box(
            height: 250,
            radius: 0,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _line(width: 80, height: 18),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _box(width: 56, height: 56, radius: 28),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _line(width: 140, height: 16),
                        const SizedBox(height: 8),
                        _line(width: 180, height: 12),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(child: _box(height: 58, radius: 12)),
                    const SizedBox(width: 8),
                    Expanded(child: _box(height: 58, radius: 12)),
                    const SizedBox(width: 8),
                    Expanded(child: _box(height: 58, radius: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _line(width: 80, height: 12),
                const SizedBox(height: 10),
                _menuCard(3),
                const SizedBox(height: 16),
                _line(width: 110, height: 12),
                const SizedBox(height: 10),
                _menuCard(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget faq() {
    return _shell(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        children: [
          for (var i = 0; i < 7; i++) ...[
            _box(
              height: 56,
              radius: 12,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(child: _line(height: 14)),
                  const SizedBox(width: 12),
                  _box(width: 16, height: 16, radius: 4),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  static Widget notifications() {
    return _shell(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        children: [
          for (var i = 0; i < 6; i++) ...[
            _box(
              height: 88,
              radius: 16,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  _box(width: 42, height: 42, radius: 12),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _line(width: 150, height: 14),
                        const SizedBox(height: 8),
                        _line(height: 12),
                        const SizedBox(height: 8),
                        _line(width: 48, height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }

  static Widget exam() {
    return _shell(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _box(width: 38, height: 38, radius: 19),
              const Spacer(),
              _box(width: 96, height: 32, radius: 20),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _line(width: 120, height: 12),
              _line(width: 36, height: 12),
            ],
          ),
          const SizedBox(height: 8),
          _box(height: 5, radius: 4),
          const SizedBox(height: 20),
          _box(height: 120, radius: 14),
          const SizedBox(height: 16),
          for (var i = 0; i < 4; i++) ...[
            _box(height: 52, radius: 12),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _box(height: 52, radius: 14)),
              const SizedBox(width: 12),
              Expanded(child: _box(height: 52, radius: 14)),
            ],
          ),
        ],
      ),
    );
  }

  static Widget testDetail() {
    return _shell(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _box(
            height: 150,
            radius: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _line(width: 80, height: 12),
                const SizedBox(height: 10),
                _line(width: 180, height: 22),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _box(height: 52, radius: 10)),
                    const SizedBox(width: 10),
                    Expanded(child: _box(height: 52, radius: 10)),
                    const SizedBox(width: 10),
                    Expanded(child: _box(height: 52, radius: 10)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _box(
            radius: 16,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _line(width: 110, height: 16),
                const SizedBox(height: 14),
                for (var i = 0; i < 6; i++) ...[
                  Row(
                    children: [
                      _box(width: 20, height: 20, radius: 10),
                      const SizedBox(width: 10),
                      Expanded(child: _line(height: 12)),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          _box(height: 52, radius: 14),
        ],
      ),
    );
  }

  static Widget chapter() {
    return _shell(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _line(width: 110, height: 12),
          const SizedBox(height: 8),
          _box(height: 5, radius: 4),
          const SizedBox(height: 16),
          _box(height: 180, radius: 12),
          const SizedBox(height: 16),
          _line(width: 90, height: 12),
          const SizedBox(height: 8),
          _line(width: 220, height: 22),
          const SizedBox(height: 16),
          _line(height: 12),
          const SizedBox(height: 8),
          _line(height: 12),
          const SizedBox(height: 8),
          _line(width: 260, height: 12),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(child: _box(height: 52, radius: 14)),
              const SizedBox(width: 12),
              Expanded(child: _box(height: 52, radius: 14)),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _activityRow() {
    return _box(
      height: 64,
      radius: 14,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          _box(width: 36, height: 36, radius: 10),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _line(width: 140, height: 12),
                const SizedBox(height: 6),
                _line(width: 90, height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _chapterRow() {
    return _box(
      height: 68,
      radius: 14,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          _box(width: 22, height: 22, radius: 11),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _line(width: 160, height: 14),
                const SizedBox(height: 6),
                _line(width: 80, height: 10),
              ],
            ),
          ),
          _box(width: 14, height: 14, radius: 4),
        ],
      ),
    );
  }

  static Widget _testCard() {
    return _box(
      radius: 14,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _box(width: 32, height: 32, radius: 8),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _line(width: 140, height: 14),
                    const SizedBox(height: 6),
                    _line(width: 180, height: 10),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _box(height: 5, radius: 4),
          const SizedBox(height: 12),
          _box(height: 44, radius: 14),
        ],
      ),
    );
  }

  static Widget _menuCard(int rows) {
    return _box(
      radius: 12,
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          for (var i = 0; i < rows; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  _box(width: 22, height: 22, radius: 6),
                  const SizedBox(width: 12),
                  Expanded(child: _line(height: 14)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  static Widget _shell({required Widget child, required EdgeInsets padding}) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE6EAF0),
      highlightColor: const Color(0xFFF7F9FC),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            padding: padding,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight - padding.vertical),
              child: child,
            ),
          );
        },
      ),
    );
  }

  static Widget _line({double? width, double height = 12}) {
    return _box(width: width, height: height, radius: 6);
  }

  static Widget _box({
    double? width,
    double? height,
    double radius = 12,
    EdgeInsets? padding,
    Widget? child,
  }) {
    final isBone = child == null;
    return Container(
      width: width ?? double.infinity,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: isBone ? Colors.white : null,
        borderRadius: BorderRadius.circular(radius),
        border: isBone ? null : Border.all(color: Colors.white),
      ),
      child: child,
    );
  }
}
