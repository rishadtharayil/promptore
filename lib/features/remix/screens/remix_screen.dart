import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:promptore/core/theme/colors.dart';
import 'package:promptore/core/theme/typography.dart';
import 'package:promptore/core/theme/dimensions.dart';
import 'package:promptore/core/data/mock_data.dart';
import 'package:promptore/core/models/models.dart';
import 'package:promptore/core/widgets/grain_overlay.dart';
import 'package:promptore/core/widgets/atmospheric_divider.dart';

/// Remix screen — fork a prompt and make it your own.
class RemixScreen extends StatefulWidget {
  final String promptId;

  RemixScreen({super.key, required this.promptId});

  @override
  State<RemixScreen> createState() => _RemixScreenState();
}

class _RemixScreenState extends State<RemixScreen> {
  late Prompt _original;
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late PromptCategory _selectedCategory;
  late List<String> _tags;
  bool _originalExpanded = false;

  @override
  void initState() {
    super.initState();
    _original = MockData.prompts.firstWhere((p) => p.id == widget.promptId);
    _titleController =
        TextEditingController(text: 'Remix of: ${_original.title}');
    _contentController = TextEditingController(text: _original.content);
    _selectedCategory = _original.category;
    _tags = List.from(_original.tags);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _publish() {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Remix published to the archive',
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
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return GrainOverlay(
      child: Scaffold(
        backgroundColor: PromptoreColors.background,
        appBar: AppBar(
          backgroundColor: PromptoreColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              size: 20,
              color: PromptoreColors.dustySepia,
            ),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Remix',
            style: PromptoreTypography.titleMedium,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(bottom: 100),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.pagePaddingH,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),

                // Attribution
                Row(
                  children: [
                    Icon(
                      Icons.call_split_rounded,
                      size: 14,
                      color: PromptoreColors.fadedBronze,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Original by ${_original.authorName}',
                      style: PromptoreTypography.metaLarge.copyWith(
                        color: PromptoreColors.fadedBronze,
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms),

                SizedBox(height: 16),

                // Original prompt (collapsible)
                GestureDetector(
                  onTap: () {
                    setState(() => _originalExpanded = !_originalExpanded);
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: PromptoreColors.surface,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radiusSm),
                      border: Border.all(
                        color:
                            PromptoreColors.warmGray.withValues(alpha: 0.3),
                        width: 0.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _original.title,
                                style: PromptoreTypography.titleSmall.copyWith(
                                  color: PromptoreColors.parchment,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Icon(
                              _originalExpanded
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              size: 18,
                              color: PromptoreColors.charcoal,
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          _originalExpanded
                              ? _original.content
                              : _original.content.length > 150
                                  ? '${_original.content.substring(0, 150)}...'
                                  : _original.content,
                          style: PromptoreTypography.bodySmall.copyWith(
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

                SizedBox(height: 20),

                // "Your Remix" label
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 1,
                      color: PromptoreColors.mutedGold.withValues(alpha: 0.3),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'YOUR REMIX',
                      style: PromptoreTypography.metaLarge.copyWith(
                        letterSpacing: 2.0,
                        color: PromptoreColors.mutedGold,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 1,
                        color:
                            PromptoreColors.mutedGold.withValues(alpha: 0.3),
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms, delay: 200.ms),

                SizedBox(height: 20),

                // Title field
                TextField(
                  controller: _titleController,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: PromptoreColors.parchment,
                    height: 1.3,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Remix title...',
                    hintStyle: GoogleFonts.cormorantGaramond(
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                      color: PromptoreColors.charcoal,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  maxLines: 2,
                ).animate().fadeIn(duration: 400.ms, delay: 300.ms),

                SizedBox(height: 12),

                AtmosphericDivider(),

                SizedBox(height: 12),

                // Content field
                TextField(
                  controller: _contentController,
                  style: PromptoreTypography.bodyLarge.copyWith(
                    height: 1.7,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Your remixed content...',
                    hintStyle: PromptoreTypography.bodyMedium.copyWith(
                      color: PromptoreColors.charcoal,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  maxLines: null,
                  minLines: 6,
                ).animate().fadeIn(duration: 400.ms, delay: 350.ms),

                SizedBox(height: 20),

                // Category
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: PromptCategory.values.map((cat) {
                      final isSelected = cat == _selectedCategory;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedCategory = cat),
                        child: Container(
                          margin: EdgeInsets.only(right: 8),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? cat.color.withValues(alpha: 0.15)
                                : PromptoreColors.surface,
                            borderRadius: BorderRadius.circular(
                              Dimensions.radiusFull,
                            ),
                            border: Border.all(
                              color: isSelected
                                  ? cat.color.withValues(alpha: 0.5)
                                  : PromptoreColors.warmGray
                                      .withValues(alpha: 0.4),
                              width: 0.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                cat.symbol,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: cat.color,
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                cat.label.split(' ').first,
                                style: PromptoreTypography.metaSmall.copyWith(
                                  color: isSelected
                                      ? cat.color
                                      : PromptoreColors.dustySepia,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                SizedBox(height: 16),

                // Tags
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _tags.map((tag) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color:
                            PromptoreColors.warmGray.withValues(alpha: 0.3),
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusFull),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            tag,
                            style: PromptoreTypography.metaSmall.copyWith(
                              color: PromptoreColors.dustySepia,
                            ),
                          ),
                          SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              setState(() => _tags.remove(tag));
                            },
                            child: Icon(
                              Icons.close,
                              size: 12,
                              color: PromptoreColors.charcoal,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                SizedBox(height: 32),

                // Publish button
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: _publish,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: PromptoreColors.mutedGold,
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusMd),
                      ),
                      child: Center(
                        child: Text(
                          'Publish Remix',
                          style: PromptoreTypography.labelLarge.copyWith(
                            color: PromptoreColors.background,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 500.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
