import 'package:flutter/material.dart';
import 'package:promptore/core/theme/color_extension.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:promptore/core/theme/typography.dart';
import 'package:promptore/core/theme/dimensions.dart';
import 'package:promptore/core/models/models.dart';
import 'package:promptore/core/providers/prompts_provider.dart';

/// The core prompt card — designed to feel like a manuscript excerpt,
/// an archival entry, or a collectible artifact. NOT a social media post.
class PromptCard extends ConsumerWidget {
  final Prompt prompt;
  final int index;

  const PromptCard({super.key, required this.prompt, this.index = 0});

  String _timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo ago';
    return '${(diff.inDays / 365).floor()}y ago';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch promptsProvider to get the latest state of this prompt
    final prompts = ref.watch(promptsProvider);
    final p = prompts.firstWhere((element) => element.id == prompt.id, orElse: () => prompt);

    return GestureDetector(
      onTap: () => context.push('/prompt/${p.id}'),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: Dimensions.pagePaddingH,
          vertical: Dimensions.feedItemSpacing,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.cardPaddingH,
          vertical: 18,
        ),
        decoration: BoxDecoration(
          color: PromptoreColorExtension.of(context).surface,
          borderRadius: BorderRadius.circular(Dimensions.cardRadius),
          border: Border.all(
            color: PromptoreColorExtension.of(context).warmGray.withValues(alpha: 0.4),
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category + Size
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      p.category.symbol,
                      style: TextStyle(
                        fontSize: 12,
                        color: p.category.color,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      p.category.label,
                      style: PromptoreTypography.metaSmall.copyWith(
                        color: p.category.color,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
                Text(
                  p.size.label,
                  style: PromptoreTypography.metaSmall.copyWith(
                    color: PromptoreColorExtension.of(context).charcoal,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Title
            Text(
              p.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: PromptoreTypography.titleLarge.copyWith(
                color: PromptoreColorExtension.of(context).parchment,
              ),
            ),

            const SizedBox(height: 8),

            // Excerpt
            Text(
              p.excerpt,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: PromptoreTypography.bodyMedium.copyWith(
                height: 1.55,
                color: PromptoreColorExtension.of(context).dustySepia,
              ),
            ),

            const SizedBox(height: 12),

            // Tags
            if (p.tags.isNotEmpty)
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: p.tags.take(4).map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: PromptoreColorExtension.of(context).warmGray.withValues(alpha: 0.3),
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusFull),
                    ),
                    child: Text(
                      tag,
                      style: PromptoreTypography.metaSmall.copyWith(
                        color: PromptoreColorExtension.of(context).dustySepia,
                        fontSize: 9,
                      ),
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 14),

            // Author row
            Row(
              children: [
                // Avatar
                Container(
                  width: Dimensions.avatarSm,
                  height: Dimensions.avatarSm,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: p.category.color.withValues(alpha: 0.2),
                    border: Border.all(
                      color: p.category.color.withValues(alpha: 0.3),
                      width: 0.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      p.authorName[0].toUpperCase(),
                      style: PromptoreTypography.metaSmall.copyWith(
                        color: p.category.color,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  p.authorName,
                  style: PromptoreTypography.bodySmall.copyWith(
                    color: PromptoreColorExtension.of(context).parchment,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  p.authorHandle,
                  style: PromptoreTypography.metaSmall.copyWith(
                    color: PromptoreColorExtension.of(context).charcoal,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '· ${_timeAgo(p.createdAt)}',
                  style: PromptoreTypography.metaSmall.copyWith(
                    color: PromptoreColorExtension.of(context).charcoal,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Thin divider
            Container(
              height: 0.5,
              color: PromptoreColorExtension.of(context).warmGray.withValues(alpha: 0.3),
            ),

            const SizedBox(height: 10),

            // Action row
            Row(
              children: [
                // Echo
                _ActionButton(
                  icon: Icons.graphic_eq_rounded,
                  count: p.echoCount,
                  isActive: p.isEchoed,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    ref.read(promptsProvider.notifier).toggleEcho(p.id);
                  },
                ),
                const SizedBox(width: 20),
                // Archive
                _ActionButton(
                  icon: Icons.bookmark_outline_rounded,
                  activeIcon: Icons.bookmark_rounded,
                  count: p.archiveCount,
                  isActive: p.isArchived,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    ref.read(promptsProvider.notifier).toggleArchive(p.id);
                  },
                ),
                const SizedBox(width: 20),
                // Remix
                _ActionButton(
                  icon: Icons.call_split_rounded,
                  count: p.remixCount,
                  isActive: false,
                  onTap: () => context.push('/remix/${p.id}'),
                ),
                const Spacer(),
                // Impact indicator
                _ImpactBar(score: p.impactScore),
              ],
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(
            duration: 500.ms,
            curve: Curves.easeOut,
          )
          .slideY(
            begin: 0.04,
            end: 0,
            duration: 500.ms,
            curve: Curves.easeOut,
          ),
    );
  }
}

/// Action button for Echo, Archive, Remix
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final IconData? activeIcon;
  final int count;
  final bool isActive;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    this.activeIcon,
    required this.count,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Icon(
            isActive ? (activeIcon ?? icon) : icon,
            size: 16,
            color: isActive
                ? PromptoreColorExtension.of(context).mutedGold
                : PromptoreColorExtension.of(context).charcoal,
          ),
          const SizedBox(width: 4),
          Text(
            _formatCount(count),
            style: PromptoreTypography.metaSmall.copyWith(
              color: isActive
                  ? PromptoreColorExtension.of(context).mutedGold
                  : PromptoreColorExtension.of(context).charcoal,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}k';
    return count.toString();
  }
}

/// Thin gold bar showing impact score as width percentage
class _ImpactBar extends StatelessWidget {
  final double score;

  const _ImpactBar({required this.score});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'impact',
          style: PromptoreTypography.metaSmall.copyWith(
            fontSize: 7,
            color: PromptoreColorExtension.of(context).charcoal,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          width: Dimensions.impactBarWidth,
          height: Dimensions.impactBarHeight,
          decoration: BoxDecoration(
            color: PromptoreColorExtension.of(context).warmGray.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: score.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      PromptoreColorExtension.of(context).fadedBronze.withValues(alpha: 0.6),
                      PromptoreColorExtension.of(context).mutedGold,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
