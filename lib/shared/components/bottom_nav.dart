import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';

class MarginBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onCaptureTap;

  const MarginBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    required this.onCaptureTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: MarginColors.surface,
        border: Border(
          top: BorderSide(color: MarginColors.border, width: 1.0),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.home_rounded,
                outlinedIcon: Icons.home_outlined,
                label: "Home",
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.book_rounded,
                outlinedIcon: Icons.book_outlined,
                label: "Journal",
              ),
              // Elevated Center Capture Button
              _buildCenterCaptureButton(),
              _buildNavItem(
                index: 2,
                icon: Icons.folder_rounded,
                outlinedIcon: Icons.folder_outlined,
                label: "Projects",
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.group_rounded,
                outlinedIcon: Icons.group_outlined,
                label: "Teams",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData outlinedIcon,
    required String label,
  }) {
    final isSelected = currentIndex == index;

    return InkWell(
      onTap: () => onTabSelected(index),
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? icon : outlinedIcon,
              color: isSelected ? MarginColors.lavender : MarginColors.textMuted,
              size: 22,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: MarginTypography.navLabel.copyWith(
                color: isSelected ? MarginColors.lavender : MarginColors.textMuted,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterCaptureButton() {
    return GestureDetector(
      onTap: onCaptureTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: MarginColors.lavender,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: MarginColors.lavender.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.add_rounded,
          color: MarginColors.background,
          size: 28,
        ),
      ),
    );
  }
}
