import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:promptore/core/theme/colors.dart';
import 'package:promptore/core/theme/typography.dart';
import 'package:promptore/core/theme/dimensions.dart';
import 'package:promptore/core/models/models.dart';
import 'package:promptore/core/providers/prompts_provider.dart';
import 'package:promptore/core/providers/annotations_provider.dart';
import 'package:promptore/core/providers/users_provider.dart';
import 'package:promptore/core/widgets/grain_overlay.dart';
import 'package:promptore/core/widgets/glow_container.dart';
import 'package:promptore/core/widgets/atmospheric_divider.dart';
import '../widgets/typewriter_text.dart';

/// The immersive prompt reading experience — the most atmospheric screen.
/// Feels like reading literature, not viewing a post.
class PromptReaderScreen extends ConsumerStatefulWidget {
  final String promptId;

  const PromptReaderScreen({super.key, required this.promptId});

  @override
  ConsumerState<PromptReaderScreen> createState() => _PromptReaderScreenState();
}

class _PromptReaderScreenState extends ConsumerState<PromptReaderScreen> {
  bool _typewriterEnabled = true;
  final _annotationController = TextEditingController();

  @override
  void dispose() {
    _annotationController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime dt) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  void _copyPrompt(Prompt prompt) {
    Clipboard.setData(ClipboardData(text: prompt.content));
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Prompt copied to archive',
          style: PromptoreTypography.bodySmall.copyWith(
            color: PromptoreColors.parchment,
          ),
        ),
        backgroundColor: PromptoreColors.surfaceElevated,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusMd),
        ),
      ),
    );
  }

  void _submitAnnotation() {
    final text = _annotationController.text.trim();
    if (text.isNotEmpty) {
      ref.read(annotationsProvider.notifier).addAnnotation(widget.promptId, text);
      ref.read(promptsProvider.notifier).incrementAnnotationCount(widget.promptId);
      _annotationController.clear();
      HapticFeedback.mediumImpact();
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Annotation published to margin',
            style: PromptoreTypography.bodySmall.copyWith(
              color: PromptoreColors.parchment,
            ),
          ),
          backgroundColor: PromptoreColors.surfaceElevated,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radiusMd),
          ),
        ),
      );
    }
  }

  /// Parse simple markdown-like formatting: **bold** and *italic*
  List<TextSpan> _parseContent(String text) {
    final spans = <TextSpan>[];
    final regex = RegExp(r'\*\*(.+?)\*\*|\*(.+?)\*');
    int lastEnd = 0;

    for (final match in regex.allMatches(text)) {
      // Add text before the match
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: text.substring(lastEnd, match.start)));
      }
      if (match.group(1) != null) {
        // **bold**
        spans.add(TextSpan(
          text: match.group(1),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ));
      } else if (match.group(2) != null) {
        // *italic*
        spans.add(TextSpan(
          text: match.group(2),
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: PromptoreColors.mutedGold.withValues(alpha: 0.9),
          ),
        ));
      }
      lastEnd = match.end;
    }

    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd)));
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final prompts = ref.watch(promptsProvider);
    final prompt = prompts.firstWhere((p) => p.id == widget.promptId);

    final annotationsList = ref.watch(annotationsProvider);
    final annotations = annotationsList.where((a) => a.promptId == widget.promptId).toList();

    final users = ref.watch(usersProvider);
    final author = users.firstWhere(
      (u) => u.id == prompt.authorId,
      orElse: () => UserProfile(
        id: prompt.authorId,
        displayName: prompt.authorName,
        handle: prompt.authorHandle,
        joinedAt: DateTime.now(),
      ),
    );
    final isTunedIn = author.isTunedIn;

    return GrainOverlay(
      child: Scaffold(
        backgroundColor: PromptoreColors.background,
        body: Stack(
          children: [
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // App bar
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  pinned: true,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 20,
                      color: PromptoreColors.dustySepia,
                    ),
                    onPressed: () => context.pop(),
                  ),
                  actions: [
                    // Typewriter toggle
                    IconButton(
                      icon: Icon(
                        _typewriterEnabled
                            ? Icons.text_fields_rounded
                            : Icons.text_format_rounded,
                        size: 20,
                        color: _typewriterEnabled
                            ? PromptoreColors.mutedGold
                            : PromptoreColors.charcoal,
                      ),
                      onPressed: () {
                        setState(() => _typewriterEnabled = !_typewriterEnabled);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        prompt.isArchived
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_outline_rounded,
                        size: 20,
                        color: prompt.isArchived
                            ? PromptoreColors.mutedGold
                            : PromptoreColors.dustySepia,
                      ),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        ref.read(promptsProvider.notifier).toggleArchive(prompt.id);
                      },
                    ),
                    const SizedBox(width: 4),
                  ],
                ),

                // Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),

                        // Category
                        Row(
                          children: [
                            Text(
                              prompt.category.symbol,
                              style: TextStyle(
                                fontSize: 14,
                                color: prompt.category.color,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              prompt.category.label,
                              style: PromptoreTypography.metaMedium.copyWith(
                                color: prompt.category.color,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ).animate().fadeIn(duration: 500.ms),

                        const SizedBox(height: 20),

                        // Title with optional typewriter
                        GlowContainer(
                          glowOpacity: 0.04,
                          glowAlignment: const Alignment(-0.5, 0),
                          child: _typewriterEnabled
                              ? TypewriterText(
                                  key: ValueKey('tw_${prompt.id}'),
                                  text: prompt.title,
                                  style: PromptoreTypography.readerTitle,
                                  animate: true,
                                  charDuration: const Duration(milliseconds: 50),
                                )
                              : Text(
                                  prompt.title,
                                  style: PromptoreTypography.readerTitle,
                                ),
                        ).animate().fadeIn(duration: 600.ms, delay: 100.ms),

                        const SizedBox(height: 24),

                        // Author section
                        Row(
                          children: [
                            Container(
                              width: Dimensions.avatarMd,
                              height: Dimensions.avatarMd,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: prompt.category.color
                                    .withValues(alpha: 0.15),
                                border: Border.all(
                                  color: prompt.category.color
                                      .withValues(alpha: 0.3),
                                  width: 0.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  prompt.authorName[0],
                                  style: PromptoreTypography.labelLarge.copyWith(
                                    color: prompt.category.color,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  prompt.authorName,
                                  style: PromptoreTypography.labelLarge,
                                ),
                                Text(
                                  prompt.authorHandle,
                                  style: PromptoreTypography.metaMedium,
                                ),
                              ],
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                ref.read(usersProvider.notifier).toggleTuneIn(author.id);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isTunedIn
                                      ? PromptoreColors.mutedGold.withValues(alpha: 0.15)
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: PromptoreColors.mutedGold
                                        .withValues(alpha: isTunedIn ? 0.6 : 0.4),
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.radiusFull,
                                  ),
                                ),
                                child: Text(
                                  isTunedIn ? 'Tuned In' : 'Tune In',
                                  style: PromptoreTypography.metaMedium.copyWith(
                                    color: PromptoreColors.mutedGold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ).animate().fadeIn(duration: 500.ms, delay: 200.ms),

                        const SizedBox(height: 16),

                        // Metadata row
                        Row(
                          children: [
                            Text(
                              _formatDate(prompt.createdAt),
                              style: PromptoreTypography.readerMeta,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              prompt.size.label,
                              style: PromptoreTypography.readerMeta,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              '${(prompt.impactScore * 100).toInt()}% impact',
                              style: PromptoreTypography.readerMeta.copyWith(
                                color: PromptoreColors.mutedGold,
                              ),
                            ),
                          ],
                        ).animate().fadeIn(duration: 400.ms, delay: 300.ms),

                        const SizedBox(height: 24),

                        const AtmosphericDivider(),

                        const SizedBox(height: 28),

                        // Remix attribution
                        if (prompt.remixOfTitle != null) ...[
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: PromptoreColors.surfaceElevated,
                              borderRadius: BorderRadius.circular(
                                Dimensions.radiusSm,
                              ),
                              border: Border.all(
                                color:
                                    PromptoreColors.warmGray.withValues(alpha: 0.3),
                                width: 0.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.call_split_rounded,
                                  size: 14,
                                  color: PromptoreColors.fadedBronze,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Remixed from: ${prompt.remixOfTitle}',
                                    style: PromptoreTypography.metaMedium.copyWith(
                                      color: PromptoreColors.fadedBronze,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Prompt content — paragraph by paragraph
                        ..._buildContentParagraphs(prompt),

                        const SizedBox(height: 32),

                        const AtmosphericDivider(),

                        const SizedBox(height: 24),

                        // Tags
                        if (prompt.tags.isNotEmpty) ...[
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: prompt.tags.map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: PromptoreColors.warmGray
                                      .withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.radiusFull,
                                  ),
                                ),
                                child: Text(
                                  '#$tag',
                                  style: PromptoreTypography.metaMedium.copyWith(
                                    color: PromptoreColors.dustySepia,
                                  ),
                                ),
                              );
                            }).toList(),
                          ).animate().fadeIn(duration: 400.ms),
                          const SizedBox(height: 32),
                        ],

                        // Annotations section
                        Text(
                          'Annotations',
                          style: PromptoreTypography.titleSmall.copyWith(
                            color: PromptoreColors.dustySepia,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        if (annotations.isNotEmpty) ...[
                          ...annotations.asMap().entries.map((entry) {
                            final ann = entry.value;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: PromptoreColors.surfaceElevated,
                                borderRadius: BorderRadius.circular(
                                  Dimensions.radiusSm,
                                ),
                                border: Border(
                                  left: BorderSide(
                                    color: PromptoreColors.mutedGold
                                        .withValues(alpha: 0.3),
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        ann.authorName,
                                        style: PromptoreTypography.labelMedium
                                            .copyWith(
                                          color: PromptoreColors.parchment,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        ann.authorHandle,
                                        style: PromptoreTypography.metaSmall,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    ann.content,
                                    style: PromptoreTypography.bodySmall.copyWith(
                                      height: 1.6,
                                      color: PromptoreColors.dustySepia,
                                    ),
                                  ),
                                ],
                              ),
                            ).animate().fadeIn(
                                  duration: 400.ms,
                                  delay: Duration(
                                    milliseconds: 100 * entry.key,
                                  ),
                                );
                          }),
                        ] else ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'No margin notes on this manuscript yet.',
                              style: PromptoreTypography.bodySmall.copyWith(
                                color: PromptoreColors.charcoal,
                              ),
                            ),
                          ),
                        ],

                        // Add Margin Note input
                        const SizedBox(height: 24),
                        Text(
                          'Add Margin Note',
                          style: PromptoreTypography.titleSmall.copyWith(
                            color: PromptoreColors.dustySepia,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _annotationController,
                          style: PromptoreTypography.bodySmall.copyWith(
                            color: PromptoreColors.parchment,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Write a thought or annotation...',
                            hintStyle: PromptoreTypography.bodySmall.copyWith(
                              color: PromptoreColors.charcoal,
                            ),
                            filled: true,
                            fillColor: PromptoreColors.surfaceElevated,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSm),
                              borderSide: BorderSide(
                                color: PromptoreColors.warmGray.withValues(alpha: 0.3),
                                width: 0.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSm),
                              borderSide: BorderSide(
                                color: PromptoreColors.warmGray.withValues(alpha: 0.3),
                                width: 0.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSm),
                              borderSide: BorderSide(
                                color: PromptoreColors.mutedGold.withValues(alpha: 0.5),
                                width: 0.5,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.add_comment_rounded,
                                color: PromptoreColors.mutedGold,
                                size: 18,
                              ),
                              onPressed: _submitAnnotation,
                            ),
                          ),
                          maxLines: 2,
                          onSubmitted: (_) => _submitAnnotation(),
                        ),

                        // Bottom padding for action bar
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Floating action bar
            Positioned(
              left: 24,
              right: 24,
              bottom: MediaQuery.of(context).padding.bottom + 16,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusLg),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: PromptoreColors.surfaceElevated
                          .withValues(alpha: 0.92),
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusLg),
                      border: Border.all(
                        color: PromptoreColors.warmGray.withValues(alpha: 0.3),
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _FloatingAction(
                          icon: Icons.copy_rounded,
                          label: 'Copy',
                          onTap: () => _copyPrompt(prompt),
                        ),
                        _FloatingAction(
                          icon: Icons.graphic_eq_rounded,
                          label: 'Echo',
                          isActive: prompt.isEchoed,
                          onTap: () {
                            HapticFeedback.lightImpact();
                            ref.read(promptsProvider.notifier).toggleEcho(prompt.id);
                          },
                        ),
                        _FloatingAction(
                          icon: prompt.isArchived
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_outline_rounded,
                          label: 'Archive',
                          isActive: prompt.isArchived,
                          onTap: () {
                            HapticFeedback.lightImpact();
                            ref.read(promptsProvider.notifier).toggleArchive(prompt.id);
                          },
                        ),
                        _FloatingAction(
                          icon: Icons.call_split_rounded,
                          label: 'Remix',
                          onTap: () => context.push('/remix/${prompt.id}'),
                        ),
                        _FloatingAction(
                          icon: Icons.send_rounded,
                          label: 'Transmit',
                          onTap: () {
                            HapticFeedback.selectionClick();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Prompt transmitted successfully',
                                  style: PromptoreTypography.bodySmall.copyWith(
                                    color: PromptoreColors.parchment,
                                  ),
                                ),
                                backgroundColor: PromptoreColors.surfaceElevated,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 600.ms, delay: 500.ms).slideY(
                    begin: 0.3,
                    end: 0,
                    duration: 600.ms,
                    delay: 500.ms,
                    curve: Curves.easeOut,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build content paragraphs with simple markdown parsing
  List<Widget> _buildContentParagraphs(Prompt prompt) {
    final paragraphs = prompt.content.split('\n\n');
    return paragraphs.asMap().entries.map((entry) {
      final text = entry.value.trim();
      if (text.isEmpty) return const SizedBox.shrink();

      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: RichText(
          text: TextSpan(
            style: PromptoreTypography.readerBody,
            children: _parseContent(text),
          ),
        ),
      ).animate().fadeIn(
            duration: 500.ms,
            delay: Duration(milliseconds: 400 + (entry.key * 100)),
          );
    }).toList();
  }
}

/// Floating action button in the bottom bar
class _FloatingAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FloatingAction({
    required this.icon,
    required this.label,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
            color: isActive
                ? PromptoreColors.mutedGold
                : PromptoreColors.dustySepia,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: PromptoreTypography.metaSmall.copyWith(
              color: isActive
                  ? PromptoreColors.mutedGold
                  : PromptoreColors.dustySepia,
              fontSize: 8,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
