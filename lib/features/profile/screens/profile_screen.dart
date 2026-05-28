import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:promptore/core/theme/colors.dart';
import 'package:promptore/core/theme/typography.dart';
import 'package:promptore/core/theme/dimensions.dart';
import 'package:promptore/core/data/mock_data.dart';
import 'package:promptore/core/models/models.dart';
import 'package:promptore/core/widgets/grain_overlay.dart';
import 'package:promptore/core/widgets/atmospheric_divider.dart';
import 'package:promptore/core/providers/theme_provider.dart';

/// Profile — personal archive and creative identity.
class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = MockData.currentUser;
    final authored = MockData.prompts
        .where((p) => p.authorId == user.id)
        .toList();
    final echoed = MockData.prompts.take(5).toList(); // Mock echoed
    final collections = MockData.collections
        .where((c) => c.ownerId == user.id)
        .toList();

    return GrainOverlay(
      child: Scaffold(
        backgroundColor: PromptoreColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 16),

                 // Theme Toggle button
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Consumer(
                      builder: (context, ref, child) {
                        final themeMode = ref.watch(themeModeProvider);
                        final isLight = themeMode == ThemeMode.light;
                        return IconButton(
                          icon: Icon(
                            isLight ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                            size: 20,
                            color: PromptoreColors.dustySepia,
                          ),
                          onPressed: () {
                            ref.read(themeModeProvider.notifier).toggleTheme();
                          },
                        );
                      },
                    ),
                  ),
                ),

                // Avatar
                Container(
                  width: Dimensions.avatarProfile,
                  height: Dimensions.avatarProfile,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: PromptoreColors.surfaceElevated,
                    border: Border.all(
                      color: PromptoreColors.mutedGold.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      user.displayName[0],
                      style: PromptoreTypography.displayMedium.copyWith(
                        color: PromptoreColors.mutedGold,
                        fontSize: 36,
                      ),
                    ),
                  ),
                ).animate().fadeIn(duration: 500.ms).scale(
                      begin: Offset(0.9, 0.9),
                      end: Offset(1, 1),
                      duration: 500.ms,
                    ),

                SizedBox(height: 16),

                // Name
                Text(
                  user.displayName,
                  style: PromptoreTypography.displaySmall,
                ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

                SizedBox(height: 4),

                // Handle
                Text(
                  user.handle,
                  style: PromptoreTypography.metaLarge,
                ).animate().fadeIn(duration: 400.ms, delay: 150.ms),

                SizedBox(height: 12),

                // Bio
                if (user.bio != null)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      user.bio!,
                      textAlign: TextAlign.center,
                      style: PromptoreTypography.bodyMedium.copyWith(
                        height: 1.6,
                      ),
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 200.ms),

                SizedBox(height: 10),

                // Mood
                if (user.mood != null)
                  Text(
                    'Currently: ${user.mood}',
                    style: PromptoreTypography.accent.copyWith(fontSize: 14),
                  ).animate().fadeIn(duration: 400.ms, delay: 250.ms),

                SizedBox(height: 20),

                // Stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _StatItem(value: user.promptCount, label: 'prompts'),
                    _StatDivider(),
                    _StatItem(value: user.echoesReceived, label: 'echoes'),
                    _StatDivider(),
                    _StatItem(value: user.collectionsCount, label: 'collections'),
                    _StatDivider(),
                    _StatItem(value: user.tunedInCount, label: 'tuned in'),
                  ],
                ).animate().fadeIn(duration: 400.ms, delay: 300.ms),

                SizedBox(height: 24),
                AtmosphericDivider(),
                SizedBox(height: 16),

                // Tab bar
                _TabBar(
                  currentIndex: _tabIndex,
                  onChanged: (i) => setState(() => _tabIndex = i),
                ).animate().fadeIn(duration: 400.ms, delay: 350.ms),

                SizedBox(height: 16),

                // Tab content
                if (_tabIndex == 0)
                  ...authored.asMap().entries.map((entry) =>
                      _CompactPromptTile(prompt: entry.value, index: entry.key))
                else if (_tabIndex == 1)
                  ...echoed.asMap().entries.map((entry) =>
                      _CompactPromptTile(prompt: entry.value, index: entry.key))
                else
                  ...collections.asMap().entries.map((entry) {
                    final col = entry.value;
                    return GestureDetector(
                      onTap: () => context.push('/collections/${col.id}'),
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: Dimensions.pagePaddingH,
                          vertical: 4,
                        ),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: PromptoreColors.surface,
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusSm),
                          border: Border.all(
                            color: PromptoreColors.warmGray
                                .withValues(alpha: 0.3),
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 4,
                              height: 32,
                              decoration: BoxDecoration(
                                color: col.coverColor ??
                                    PromptoreColors.mutedGold,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    col.name,
                                    style: PromptoreTypography.labelLarge,
                                  ),
                                  if (col.description != null)
                                    Text(
                                      col.description!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: PromptoreTypography.bodySmall,
                                    ),
                                ],
                              ),
                            ),
                            Text(
                              '${col.promptCount}',
                              style: PromptoreTypography.metaMedium,
                            ),
                          ],
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(
                          duration: 400.ms,
                          delay: Duration(milliseconds: entry.key * 80),
                        );
                  }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final int value;
  final String label;

  _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Text(
            value >= 1000
                ? '${(value / 1000).toStringAsFixed(1)}k'
                : '$value',
            style: PromptoreTypography.titleMedium.copyWith(
              color: PromptoreColors.parchment,
            ),
          ),
          SizedBox(height: 2),
          Text(
            label,
            style: PromptoreTypography.metaSmall.copyWith(
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 24,
      color: PromptoreColors.warmGray.withValues(alpha: 0.3),
    );
  }
}

class _TabBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;

  _TabBar({required this.currentIndex, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final tabs = ['Authored', 'Echoed', 'Collections'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: tabs.asMap().entries.map((entry) {
        final isActive = entry.key == currentIndex;
        return GestureDetector(
          onTap: () => onChanged(entry.key),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isActive
                      ? PromptoreColors.mutedGold
                      : Colors.transparent,
                  width: 1.5,
                ),
              ),
            ),
            child: Text(
              entry.value,
              style: PromptoreTypography.labelMedium.copyWith(
                color: isActive
                    ? PromptoreColors.mutedGold
                    : PromptoreColors.charcoal,
                letterSpacing: 0.5,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _CompactPromptTile extends StatelessWidget {
  final Prompt prompt;
  final int index;

  _CompactPromptTile({required this.prompt, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/prompt/${prompt.id}'),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: Dimensions.pagePaddingH,
          vertical: 4,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: PromptoreColors.surface,
          borderRadius: BorderRadius.circular(Dimensions.radiusSm),
          border: Border.all(
            color: PromptoreColors.warmGray.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: prompt.category.color,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                prompt.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: PromptoreTypography.labelLarge.copyWith(
                  fontSize: 13,
                ),
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.graphic_eq_rounded,
              size: 12,
              color: PromptoreColors.charcoal,
            ),
            SizedBox(width: 4),
            Text(
              '${prompt.echoCount}',
              style: PromptoreTypography.metaSmall,
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(
          duration: 400.ms,
          delay: Duration(milliseconds: index * 80),
        );
  }
}
