import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNav({super.key, required this.currentIndex, required this.onTap});

  static const _items = [
    _NavItemData(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
    _NavItemData(icon: Icons.description_outlined, activeIcon: Icons.description, label: 'Tests'),
    _NavItemData(icon: Icons.menu_book_outlined, activeIcon: Icons.menu_book, label: 'Study'),
    _NavItemData(icon: Icons.bar_chart_outlined, activeIcon: Icons.bar_chart, label: 'Progress'),
    _NavItemData(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final isActive = index == currentIndex;
              return Expanded(
                child: InkWell(
                  onTap: () => onTap(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isActive ? item.activeIcon : item.icon,
                        color: isActive ? AppColors.primary : AppColors.textHint,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: AppTextStyles.caption.copyWith(
                          color: isActive ? AppColors.primary : AppColors.textHint,
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItemData({required this.icon, required this.activeIcon, required this.label});
}
