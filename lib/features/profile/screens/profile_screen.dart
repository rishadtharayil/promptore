import 'package:flutter/material.dart';
import 'package:promptore/core/theme/color_extension.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:promptore/core/theme/colors.dart';
import 'package:promptore/core/theme/color_extension.dart';
import 'package:promptore/core/theme/typography.dart';
import 'package:promptore/core/theme/dimensions.dart';
import 'package:promptore/core/data/mock_data.dart';
import 'package:promptore/core/models/models.dart';
import 'package:promptore/core/providers/prompts_provider.dart';
import 'package:promptore/core/providers/collections_provider.dart';
import 'package:promptore/core/providers/theme_provider.dart';
import 'package:promptore/core/widgets/grain_overlay.dart';
import 'package:promptore/core/widgets/atmospheric_divider.dart';

/// Profile — personal archive and creative identity.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = MockData.currentUser;
    
    // Read dynamic states from Providers
    final allPrompts = ref.watch(promptsProvider);
    final allCollections = ref.watch(collectionsProvider);

    final authored = allPrompts
        .where((p) => p.authorId == user.id)
        .toList();
    final echoed = allPrompts
        .where((p) => p.isEchoed)
        .toList();
    final collections = allCollections
        .where((c) => c.ownerId == user.id)
        .toList();

    // Dynamically calculate stats
    final totalEchoesReceived = authored.fold<int>(0, (sum, p) => sum + p.echoCount);

    return GrainOverlay(
      child: Scaffold(
        backgroundColor: PromptoreColorExtension.of(context).background,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),

                 // Theme Toggle button
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: IconButton(
                      icon: Consumer(
                        builder: (context, ref, child) {
                          final themeMode = ref.watch(themeModeProvider);
                          final isLight = themeMode == ThemeMode.light;
                          return Icon(
                            isLight ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                            size: 20,
                            color: PromptoreColorExtension.of(context).dustySepia,
                          );
                        },
                      ),
                      onPressed: () {
                        ref.read(themeModeProvider.notifier).toggleTheme();
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
                    color: PromptoreColorExtension.of(context).surfaceElevated,
                    border: Border.all(
                      color: PromptoreColorExtension.of(context).mutedGold.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      user.displayName[0],
                      style: PromptoreTypography.displayMedium.copyWith(
                        color: PromptoreColorExtension.of(context).mutedGold,
                        fontSize: 36,
                      ),
                    ),
                  ),
                ).animate().fadeIn(duration: 500.ms).scale(
                      begin: const Offset(0.9, 0.9),
                      end: const Offset(1, 1),
                      duration: 500.ms,
                    ),

                const SizedBox(height: 16),

                // Name
                Text(
                  user.displayName,
                  style: PromptoreTypography.displaySmall,
                ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

                const SizedBox(height: 4),

                // Handle
                Text(
                  user.handle,
                  style: PromptoreTypography.metaLarge,
                ).animate().fadeIn(duration: 400.ms, delay: 150.ms),

                const SizedBox(height: 12),

                // Bio
                if (user.bio != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      user.bio!,
                      textAlign: TextAlign.center,
                      style: PromptoreTypography.bodyMedium.copyWith(
                        height: 1.6,
                      ),
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 200.ms),

                const SizedBox(height: 10),

                // Mood
                if (user.mood != null)
                  Text(
                    'Currently: ${user.mood}',
                    style: PromptoreTypography.accent.copyWith(fontSize: 14),
                  ).animate().fadeIn(duration: 400.ms, delay: 250.ms),

                const SizedBox(height: 20),

                // Stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _StatItem(value: authored.length, label: 'prompts'),
                    const _StatDivider(),
                    _StatItem(value: totalEchoesReceived, label: 'echoes'),
                    const _StatDivider(),
                    _StatItem(value: collections.length, label: 'collections'),
                    const _StatDivider(),
                    _StatItem(value: user.tunedInCount, label: 'tuned in'),
                  ],
                ).animate().fadeIn(duration: 400.ms, delay: 300.ms),

                const SizedBox(height: 24),
                const AtmosphericDivider(),
                const SizedBox(height: 16),

                // Tab bar
                _TabBar(
                  currentIndex: _tabIndex,
                  onChanged: (i) => setState(() => _tabIndex = i),
                ).animate().fadeIn(duration: 400.ms, delay: 350.ms),

                const SizedBox(height: 16),

                // Tab content
                if (_tabIndex == 0) ...[
                  if (authored.isNotEmpty)
                    ...authored.asMap().entries.map((entry) =>
                        _CompactPromptTile(prompt: entry.value, index: entry.key))
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: Text(
                        'You have not authored any prompts yet.',
                        style: PromptoreTypography.bodySmall.copyWith(color: PromptoreColorExtension.of(context).charcoal),
                      ),
                    ),
                ] else if (_tabIndex == 1) ...[
                  if (echoed.isNotEmpty)
                    ...echoed.asMap().entries.map((entry) =>
                        _CompactPromptTile(prompt: entry.value, index: entry.key))
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: Text(
                        'You have not echoed any prompts yet.',
                        style: PromptoreTypography.bodySmall.copyWith(color: PromptoreColorExtension.of(context).charcoal),
                      ),
                    ),
                ] else ...[
                  if (collections.isNotEmpty)
                    ...collections.asMap().entries.map((entry) {
                      final col = entry.value;
                      return GestureDetector(
                        onTap: () => context.push('/collections/${col.id}'),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: Dimensions.pagePaddingH,
                            vertical: 4,
                          ),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: PromptoreColorExtension.of(context).surface,
                            borderRadius:
                                BorderRadius.circular(Dimensions.radiusSm),
                            border: Border.all(
                              color: PromptoreColorExtension.of(context).warmGray
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
                                      PromptoreColorExtension.of(context).mutedGold,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 14),
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
                    })
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: Text(
                        'You have no collections yet.',
                        style: PromptoreTypography.bodySmall.copyWith(color: PromptoreColorExtension.of(context).charcoal),
                      ),
                    ),
                ],
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

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Text(
            value >= 1000
                ? '${(value / 1000).toStringAsFixed(1)}k'
                : '$value',
            style: PromptoreTypography.titleMedium.copyWith(
              color: PromptoreColorExtension.of(context).parchment,
            ),
          ),
          const SizedBox(height: 2),
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
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 24,
      color: PromptoreColorExtension.of(context).warmGray.withValues(alpha: 0.3),
    );
  }
}

class _TabBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const _TabBar({required this.currentIndex, required this.onChanged});

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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isActive
                      ? PromptoreColorExtension.of(context).mutedGold
                      : Colors.transparent,
                  width: 1.5,
                ),
              ),
            ),
            child: Text(
              entry.value,
              style: PromptoreTypography.labelMedium.copyWith(
                color: isActive
                    ? PromptoreColorExtension.of(context).mutedGold
                    : PromptoreColorExtension.of(context).charcoal,
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

  const _CompactPromptTile({required this.prompt, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/prompt/${prompt.id}'),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: Dimensions.pagePaddingH,
          vertical: 4,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: PromptoreColorExtension.of(context).surface,
          borderRadius: BorderRadius.circular(Dimensions.radiusSm),
          border: Border.all(
            color: PromptoreColorExtension.of(context).warmGray.withValues(alpha: 0.3),
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
            const SizedBox(width: 12),
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
            const SizedBox(width: 8),
            Icon(
              Icons.graphic_eq_rounded,
              size: 12,
              color: PromptoreColorExtension.of(context).charcoal,
            ),
            const SizedBox(width: 4),
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
