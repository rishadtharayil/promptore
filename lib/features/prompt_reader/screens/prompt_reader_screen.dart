import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import 'package:promptore/core/theme/colors.dart';
import 'package:promptore/core/theme/typography.dart';
import 'package:promptore/core/theme/dimensions.dart';
import 'package:promptore/core/data/mock_data.dart';
import 'package:promptore/core/models/models.dart';
import 'package:promptore/core/widgets/grain_overlay.dart';
import 'package:promptore/core/widgets/glow_container.dart';
import 'package:promptore/core/widgets/atmospheric_divider.dart';
import '../widgets/typewriter_text.dart';

/// The immersive prompt reading experience — the most atmospheric screen.
/// Feels like reading literature, not viewing a post.
class PromptReaderScreen extends StatefulWidget {
  final String promptId;

  PromptReaderScreen({super.key, required this.promptId});

  @override
  State<PromptReaderScreen> createState() => _PromptReaderScreenState();
}

class _PromptReaderScreenState extends State<PromptReaderScreen> {
  late Prompt _prompt;
  bool _typewriterEnabled = true;
  bool _isEchoed = false;
  bool _isArchived = false;

  @override
  void initState() {
    super.initState();
    _prompt = MockData.prompts.firstWhere((p) => p.id == widget.promptId);
    _isEchoed = _prompt.isEchoed;
    _isArchived = _prompt.isArchived;
  }

  List<Annotation> get _annotations =>
      MockData.annotations.where((a) => a.promptId == widget.promptId).toList();

  String _formatDate(DateTime dt) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  void _copyPrompt() {
    Clipboard.setData(ClipboardData(text: _prompt.content));
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
          style: TextStyle(fontWeight: FontWeight.w600),
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
    return GrainOverlay(
      child: Scaffold(
        backgroundColor: PromptoreColors.background,
        body: Stack(
          children: [
            CustomScrollView(
              physics: BouncingScrollPhysics(),
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
                        _isArchived
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_outline_rounded,
                        size: 20,
                        color: _isArchived
                            ? PromptoreColors.mutedGold
                            : PromptoreColors.dustySepia,
                      ),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        setState(() => _isArchived = !_isArchived);
                      },
                    ),
                    SizedBox(width: 4),
                  ],
                ),

                // Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),

                        // Category
                        Row(
                          children: [
                            Text(
                              _prompt.category.symbol,
                              style: TextStyle(
                                fontSize: 14,
                                color: _prompt.category.color,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              _prompt.category.label,
                              style: PromptoreTypography.metaMedium.copyWith(
                                color: _prompt.category.color,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ).animate().fadeIn(duration: 500.ms),

                        SizedBox(height: 20),

                        // Title with optional typewriter
                        GlowContainer(
                          glowOpacity: 0.04,
                          glowAlignment: Alignment(-0.5, 0),
                          child: _typewriterEnabled
                              ? TypewriterText(
                                  key: ValueKey('tw_${_prompt.id}'),
                                  text: _prompt.title,
                                  style: PromptoreTypography.readerTitle,
                                  animate: true,
                                  charDuration: Duration(milliseconds: 50),
                                )
                              : Text(
                                  _prompt.title,
                                  style: PromptoreTypography.readerTitle,
                                ),
                        ).animate().fadeIn(duration: 600.ms, delay: 100.ms),

                        SizedBox(height: 24),

                        // Author section
                        Row(
                          children: [
                            Container(
                              width: Dimensions.avatarMd,
                              height: Dimensions.avatarMd,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _prompt.category.color
                                    .withValues(alpha: 0.15),
                                border: Border.all(
                                  color: _prompt.category.color
                                      .withValues(alpha: 0.3),
                                  width: 0.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  _prompt.authorName[0],
                                  style: PromptoreTypography.labelLarge.copyWith(
                                    color: _prompt.category.color,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _prompt.authorName,
                                  style: PromptoreTypography.labelLarge,
                                ),
                                Text(
                                  _prompt.authorHandle,
                                  style: PromptoreTypography.metaMedium,
                                ),
                              ],
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: PromptoreColors.mutedGold
                                      .withValues(alpha: 0.4),
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(
                                  Dimensions.radiusFull,
                                ),
                              ),
                              child: Text(
                                'Tune In',
                                style: PromptoreTypography.metaMedium.copyWith(
                                  color: PromptoreColors.mutedGold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ).animate().fadeIn(duration: 500.ms, delay: 200.ms),

                        SizedBox(height: 16),

                        // Metadata row
                        Row(
                          children: [
                            Text(
                              _formatDate(_prompt.createdAt),
                              style: PromptoreTypography.readerMeta,
                            ),
                            SizedBox(width: 16),
                            Text(
                              _prompt.size.label,
                              style: PromptoreTypography.readerMeta,
                            ),
                            SizedBox(width: 16),
                            Text(
                              '${(_prompt.impactScore * 100).toInt()}% impact',
                              style: PromptoreTypography.readerMeta.copyWith(
                                color: PromptoreColors.mutedGold,
                              ),
                            ),
                          ],
                        ).animate().fadeIn(duration: 400.ms, delay: 300.ms),

                        SizedBox(height: 24),

                        AtmosphericDivider(),

                        SizedBox(height: 28),

                        // Remix attribution
                        if (_prompt.remixOfTitle != null) ...[
                          Container(
                            padding: EdgeInsets.all(14),
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
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Remixed from: ${_prompt.remixOfTitle}',
                                    style: PromptoreTypography.metaMedium.copyWith(
                                      color: PromptoreColors.fadedBronze,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24),
                        ],

                        // Prompt content — paragraph by paragraph
                        ..._buildContentParagraphs(),

                        SizedBox(height: 32),

                        AtmosphericDivider(),

                        SizedBox(height: 24),

                        // Tags
                        if (_prompt.tags.isNotEmpty) ...[
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: _prompt.tags.map((tag) {
                              return Container(
                                padding: EdgeInsets.symmetric(
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
                          SizedBox(height: 32),
                        ],

                        // Annotations section
                        if (_annotations.isNotEmpty) ...[
                          Text(
                            'Annotations',
                            style: PromptoreTypography.titleSmall.copyWith(
                              color: PromptoreColors.dustySepia,
                              letterSpacing: 1.0,
                            ),
                          ),
                          SizedBox(height: 16),
                          ..._annotations.asMap().entries.map((entry) {
                            final ann = entry.value;
                            return Container(
                              margin: EdgeInsets.only(bottom: 12),
                              padding: EdgeInsets.all(16),
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
                                      SizedBox(width: 6),
                                      Text(
                                        ann.authorHandle,
                                        style: PromptoreTypography.metaSmall,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
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
                        ],

                        // Bottom padding for action bar
                        SizedBox(height: 100),
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
                    padding: EdgeInsets.symmetric(
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
                          onTap: _copyPrompt,
                        ),
                        _FloatingAction(
                          icon: _isEchoed
                              ? Icons.graphic_eq_rounded
                              : Icons.graphic_eq_rounded,
                          label: 'Echo',
                          isActive: _isEchoed,
                          onTap: () {
                            HapticFeedback.lightImpact();
                            setState(() => _isEchoed = !_isEchoed);
                          },
                        ),
                        _FloatingAction(
                          icon: _isArchived
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_outline_rounded,
                          label: 'Archive',
                          isActive: _isArchived,
                          onTap: () {
                            HapticFeedback.lightImpact();
                            setState(() => _isArchived = !_isArchived);
                          },
                        ),
                        _FloatingAction(
                          icon: Icons.call_split_rounded,
                          label: 'Remix',
                          onTap: () => context.push('/remix/${_prompt.id}'),
                        ),
                        _FloatingAction(
                          icon: Icons.send_rounded,
                          label: 'Transmit',
                          onTap: () {
                            HapticFeedback.selectionClick();
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
  List<Widget> _buildContentParagraphs() {
    final paragraphs = _prompt.content.split('\n\n');
    return paragraphs.asMap().entries.map((entry) {
      final text = entry.value.trim();
      if (text.isEmpty) return SizedBox.shrink();

      return Padding(
        padding: EdgeInsets.only(bottom: 16),
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

  _FloatingAction({
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
          SizedBox(height: 4),
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
