import 'package:flutter/material.dart';
import 'package:promptore/core/theme/color_extension.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';
import '../core/theme/dimensions.dart';
import '../core/widgets/responsive_layout.dart';

/// Main shell with atmospheric bottom navigation.
/// Five tabs: Feed, Explore, Compose, Collections, Profile.
/// Custom styling — no Material default bottom nav appearance.
class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      body: navigationShell,
      bottomNavigationBar: _buildBottomNav(context),
      sideNavigationBar: _buildSideNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;

    return Container(
      decoration: BoxDecoration(
        color: PromptoreColorExtension.of(context).surface,
        border: Border(
          top: BorderSide(
            color: PromptoreColorExtension.of(context).warmGray,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: Dimensions.bottomNavHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.auto_stories_outlined,
                activeIcon: Icons.auto_stories,
                label: 'Feed',
                isActive: currentIndex == 0,
                onTap: () => _onTap(0),
              ),
              _NavItem(
                icon: Icons.explore_outlined,
                activeIcon: Icons.explore,
                label: 'Explore',
                isActive: currentIndex == 1,
                onTap: () => _onTap(1),
              ),
              _ComposeButton(
                isActive: currentIndex == 2,
                onTap: () => _onTap(2),
              ),
              _NavItem(
                icon: Icons.collections_bookmark_outlined,
                activeIcon: Icons.collections_bookmark,
                label: 'Archive',
                isActive: currentIndex == 3,
                onTap: () => _onTap(3),
              ),
              _NavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profile',
                isActive: currentIndex == 4,
                onTap: () => _onTap(4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSideNav(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;

    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: PromptoreColorExtension.of(context).surface,
        border: Border(
          right: BorderSide(
            color: PromptoreColorExtension.of(context).warmGray,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _NavItem(
              icon: Icons.auto_stories_outlined,
              activeIcon: Icons.auto_stories,
              label: 'Feed',
              isActive: currentIndex == 0,
              onTap: () => _onTap(0),
            ),
            const SizedBox(height: 32),
            _NavItem(
              icon: Icons.explore_outlined,
              activeIcon: Icons.explore,
              label: 'Explore',
              isActive: currentIndex == 1,
              onTap: () => _onTap(1),
            ),
            const SizedBox(height: 32),
            _ComposeButton(
              isActive: currentIndex == 2,
              onTap: () => _onTap(2),
            ),
            const SizedBox(height: 32),
            _NavItem(
              icon: Icons.collections_bookmark_outlined,
              activeIcon: Icons.collections_bookmark,
              label: 'Archive',
              isActive: currentIndex == 3,
              onTap: () => _onTap(3),
            ),
            const SizedBox(height: 32),
            _NavItem(
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              label: 'Profile',
              isActive: currentIndex == 4,
              onTap: () => _onTap(4),
            ),
          ],
        ),
      ),
    );
  }

  void _onTap(int index) {
    HapticFeedback.selectionClick();
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

/// Individual navigation item with atmospheric styling
class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: Icon(
                isActive ? activeIcon : icon,
                color: isActive
                    ? PromptoreColorExtension.of(context).mutedGold
                    : PromptoreColorExtension.of(context).charcoal,
                size: 22,
              ),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: PromptoreTypography.metaSmall.copyWith(
                color: isActive
                    ? PromptoreColorExtension.of(context).mutedGold
                    : PromptoreColorExtension.of(context).charcoal,
                fontSize: 9,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Special compose button — golden accent, slightly larger
class _ComposeButton extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;

  const _ComposeButton({
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isActive
              ? PromptoreColorExtension.of(context).mutedGold
              : PromptoreColorExtension.of(context).mutedGold.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: PromptoreColorExtension.of(context).mutedGold.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
        child: Icon(
          Icons.edit_outlined,
          color: isActive
              ? (Theme.of(context).brightness == Brightness.light
                  ? PromptoreColors.inkDark
                  : PromptoreColorExtension.of(context).background)
              : PromptoreColorExtension.of(context).mutedGold,
          size: 20,
        ),
      ),
    );
  }
}
